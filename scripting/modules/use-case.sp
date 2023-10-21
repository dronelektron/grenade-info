static int g_lastPickUpClient = CLIENT_NOT_FOUND;

void UseCase_AddPlayerName(int client) {
    int userId = GetClientUserId(client);
    char name[MAX_NAME_LENGTH];

    GetClientName(client, name, sizeof(name));
    NameList_Set(userId, name);
}

void UseCase_RemovePlayerName(int client) {
    int userId = GetClientUserId(client);

    NameList_Remove(userId);
}

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
    int ownerId = GetClientUserId(owner);
    int team = GetClientTeam(owner);

    GrenadeList_Add(entity, ownerId, team);
}

void UseCase_OnEntityDestroyed(int entity) {
    if (!IsValidEntity(entity)) {
        return;
    }

    char className[CLASS_NAME_SIZE];

    GetEntityClassname(entity, className, sizeof(className));

    if (!EntityFilter_IsPhysicsGrenade(className)) {
        return;
    }

    int grenadeIndex = GrenadeList_FindByEntity(entity);

    if (grenadeIndex == INDEX_NOT_FOUND) {
        return;
    }

    int ownerId = GrenadeList_GetUserId(grenadeIndex);
    int ownerTeam = GrenadeList_GetTeam(grenadeIndex);

    GrenadeList_Remove(grenadeIndex);

    if (g_lastPickUpClient == CLIENT_NOT_FOUND) {
        return;
    }

    int lastPickUpClient = g_lastPickUpClient;
    int owner = GetClientOfUserId(ownerId);

    g_lastPickUpClient = CLIENT_NOT_FOUND;

    if (lastPickUpClient == owner) {
        return;
    }

    int clientTeam = GetClientTeam(lastPickUpClient);

    if (clientTeam != ownerTeam) {
        return;
    }

    char ownerName[MAX_NAME_LENGTH];

    NameList_Get(ownerId, ownerName);
    Message_YouPickedUpGrenade(lastPickUpClient, ownerName);
}
