static StringMap g_names;

void NameList_Create() {
    g_names = new StringMap();
}

void NameList_Set(int userId, const char[] name) {
    char key[USER_ID_SIZE];

    NameList_UserIdToKey(userId, key);

    g_names.SetString(key, name);
}

void NameList_Get(int userId, char[] name) {
    char key[USER_ID_SIZE];

    NameList_UserIdToKey(userId, key);

    g_names.GetString(key, name, MAX_NAME_LENGTH);
}

void NameList_Remove(int userId) {
    char key[USER_ID_SIZE];

    NameList_UserIdToKey(userId, key);

    g_names.Remove(key);
}

static void NameList_UserIdToKey(int userId, char[] key) {
    IntToString(userId, key, USER_ID_SIZE);
}
