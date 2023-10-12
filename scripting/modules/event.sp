void Event_Create() {
    HookEvent("player_changename", Event_PlayerChangeName);
}

public void Event_PlayerChangeName(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    char playerName[MAX_NAME_LENGTH];

    event.GetString("newname", playerName, sizeof(playerName));

    NameList_Set(userId, playerName);
}
