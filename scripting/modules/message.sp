void Message_YouPickedUpGrenade(int client, const char[] ownerName) {
    CPrintToChat(client, "%t", "You picked up grenade", ownerName);
}
