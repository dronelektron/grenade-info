static ArrayList g_grenades;
static ArrayList g_owners;
static ArrayList g_teams;
static ArrayList g_names;

void GrenadeList_Create() {
    int nameBlockSize = ByteCountToCells(MAX_NAME_LENGTH);

    g_grenades = new ArrayList();
    g_owners = new ArrayList();
    g_teams = new ArrayList();
    g_names = new ArrayList(nameBlockSize);
}

void GrenadeList_Add(int entity, int owner, int team, const char[] ownerName) {
    g_grenades.Push(entity);
    g_owners.Push(owner);
    g_teams.Push(team);
    g_names.PushString(ownerName);
}

void GrenadeList_Remove(int index) {
    g_grenades.Erase(index);
    g_owners.Erase(index);
    g_teams.Erase(index);
    g_names.Erase(index);
}

int GrenadeList_FindByEntity(int entity) {
    return g_grenades.FindValue(entity);
}

int GrenadeList_GetOwner(int index) {
    return g_owners.Get(index);
}

int GrenadeList_GetTeam(int index) {
    return g_teams.Get(index);
}

void GrenadeList_GetOwnerName(int index, char[] ownerName) {
    g_names.GetString(index, ownerName, MAX_NAME_LENGTH);
}
