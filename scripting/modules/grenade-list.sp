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
    return (entity << 16) | (userId << 1) | (team - TEAM_ALLIES);
}

static int GrenadeList_GetEntity(int index) {
    int item = g_items.Get(index);

    return (item >> 16) & BIT_MASK_16;
}

int GrenadeList_GetUserId(int index) {
    int item = g_items.Get(index);

    return (item >> 1) & BIT_MASK_15;
}

int GrenadeList_GetTeam(int index) {
    int item = g_items.Get(index);

    return (item & BIT_MASK_1) + TEAM_ALLIES;
}
