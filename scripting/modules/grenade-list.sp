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
    int entityField = (entity & 0xFFFF) << 16;
    int userIdField = (userId & 0x7FFF) << 1;
    int teamField = team - TEAM_ALLIES;

    return entityField | userIdField | teamField;
}

static int GrenadeList_GetEntity(int index) {
    int item = g_items.Get(index);

    return (item >> 16) & 0xFFFF;
}

int GrenadeList_GetUserId(int index) {
    int item = g_items.Get(index);

    return (item >> 1) & 0x7FFF;
}

int GrenadeList_GetTeam(int index) {
    int item = g_items.Get(index);

    return (item & 1) + TEAM_ALLIES;
}
