static int g_lastPickUpClient = CLIENT_NOT_FOUND;

void UseCase_OnWeaponEquipPost(int client, int weapon) {
    char className[CLASS_NAME_SIZE];

    GetEntityClassname(weapon, className, sizeof(className));

    if (EntityFilter_IsLiveGrenade(className)) {
        g_lastPickUpClient = client;
    }
}

void UseCase_OnEntityCreated(int entity, const char[] className) {
    if (EntityFilter_IsPhysicsGrenade(className)) {
        SDKHook(entity, SDKHook_SpawnPost, Hook_OnEntitySpawnPost);
    }
}

public void Hook_OnEntitySpawnPost(int entity) {
    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    int team = GetClientTeam(owner);
    char ownerName[MAX_NAME_LENGTH];

    GetClientName(owner, ownerName, sizeof(ownerName));
    GrenadeList_Add(entity, owner, team, ownerName);
}

void UseCase_OnEntityDestroyed(int entity) {
    char className[CLASS_NAME_SIZE];

    GetEntityClassname(entity, className, sizeof(className));

    if (!EntityFilter_IsPhysicsGrenade(className)) {
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
