static ArrayList g_items;

void GrenadeList_Create() {
    g_items = new ArrayList();
}

void GrenadeList_Add(int entity, int userId, int team) {
    int item = GrenadeList_Encode(entity, userId, team);

    g_items.Push(item);
}

void GrenadeList_Remove(int index) {
    g_items.Erase(index);
}

int GrenadeList_FindByEntity(int entity) {
    for (int i = 0; i < g_items.Length; i++) {
        int tempEntity = GrenadeList_GetEntity(i);

        if (tempEntity == entity) {
            return i;
        }
    }

    return INDEX_NOT_FOUND;
}

static int GrenadeList_Encode(int entity, int userId, int team) {
    return (entity << BIT_OFFSET_ENTITY) | (userId << BIT_OFFSET_USER_ID) | team;
}

static int GrenadeList_GetEntity(int index) {
    int item = g_items.Get(index);

    return (item >> BIT_OFFSET_ENTITY) & BIT_MASK_ENTITY;
}

int GrenadeList_GetUserId(int index) {
    int item = g_items.Get(index);

    return (item >> BIT_OFFSET_USER_ID) & BIT_MASK_USER_ID;
}

int GrenadeList_GetTeam(int index) {
    int item = g_items.Get(index);

    return item & BIT_MASK_TEAM;
}
