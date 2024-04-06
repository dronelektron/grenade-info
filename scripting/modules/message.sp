void Message_YouPickedUpGrenade(int client, const char[] ownerName) {
    PrintToChat(client, COLOR_DEFAULT ... "%t", "You picked up grenade", ownerName);
}
