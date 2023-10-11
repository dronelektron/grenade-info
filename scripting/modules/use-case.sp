static StringMap g_physicsGrenades;
static StringMap g_liveGrenades;
static int g_lastPickUpClient = CLIENT_NOT_FOUND;

void UseCase_CreateGrenadesFilter() {
    g_physicsGrenades = new StringMap();
    g_liveGrenades = new StringMap();

    g_physicsGrenades.SetValue("grenade_frag_ger", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_frag_us", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_riflegren_ger", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_riflegren_us", NO_VALUE);

    g_liveGrenades.SetValue("weapon_frag_ger_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_frag_us_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_riflegren_ger_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_riflegren_us_live", NO_VALUE);
}

void UseCase_OnWeaponEquipPost(int client, int weapon) {
    char className[CLASS_NAME_SIZE];

    GetEntityClassname(weapon, className, sizeof(className));

    if (UseCase_IsLiveGrenade(className)) {
        g_lastPickUpClient = client;
    }
}

void UseCase_OnEntityCreated(int entity, const char[] className) {
    if (UseCase_IsPhysicsGrenade(className)) {
        SDKHook(entity, SDKHook_SpawnPost, Hook_OnEntitySpawnPost);
    }
}

public void Hook_OnEntitySpawnPost(int entity) {
    int owner = UseCase_GetEntityOwner(entity);
    int team = GetClientTeam(owner);
    char ownerName[MAX_NAME_LENGTH];

    GetClientName(owner, ownerName, sizeof(ownerName));
    GrenadeList_Add(entity, owner, team, ownerName);
}

void UseCase_OnEntityDestroyed(int entity) {
    char className[CLASS_NAME_SIZE];

    GetEntityClassname(entity, className, sizeof(className));

    if (!UseCase_IsPhysicsGrenade(className)) {
        return;
    }

    int grenadeIndex = GrenadeList_FindByEntity(entity);

    if (grenadeIndex == INDEX_NOT_FOUND) {
        return;
    }

    int owner = GrenadeList_GetOwner(grenadeIndex);
    int ownerTeam = GrenadeList_GetTeam(grenadeIndex);
    char ownerName[MAX_NAME_LENGTH];

    GrenadeList_GetOwnerName(grenadeIndex, ownerName);
    GrenadeList_Remove(grenadeIndex);

    if (g_lastPickUpClient == CLIENT_NOT_FOUND) {
        return;
    }

    int lastPickUpClient = g_lastPickUpClient;

    g_lastPickUpClient = CLIENT_NOT_FOUND;

    if (lastPickUpClient == owner) {
        return;
    }

    int clientTeam = GetClientTeam(lastPickUpClient);

    if (clientTeam != ownerTeam) {
        return;
    }

    Message_YouPickedUpGrenade(lastPickUpClient, ownerName);
}

static bool UseCase_IsPhysicsGrenade(const char[] className) {
    return g_physicsGrenades.ContainsKey(className);
}

static bool UseCase_IsLiveGrenade(const char[] className) {
    return g_liveGrenades.ContainsKey(className);
}

static int UseCase_GetEntityOwner(int entity) {
    return GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
}
