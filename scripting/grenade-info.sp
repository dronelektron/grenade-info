#include <sourcemod>
#include <sdkhooks>

#include "grenade-info/entity-filter"
#include "grenade-info/grenade-list"
#include "grenade-info/message"
#include "grenade-info/name-list"
#include "grenade-info/use-case"

#include "modules/entity-filter.sp"
#include "modules/event.sp"
#include "modules/grenade-list.sp"
#include "modules/message.sp"
#include "modules/name-list.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Grenade info",
    author = "Dron-elektron",
    description = "Shows information about a picked up grenade",
    version = "1.0.4",
    url = "https://github.com/dronelektron/grenade-info"
};

public void OnPluginStart() {
    EntityFilter_Create();
    Event_Create();
    GrenadeList_Create();
    NameList_Create();
    LoadTranslations("grenade-info.phrases");
}

public void OnClientPutInServer(int client) {
    SDKHook(client, SDKHook_WeaponEquipPost, Hook_OnWeaponEquipPost);
}

public void OnClientConnected(int client) {
    UseCase_AddPlayerName(client);
}

public void OnClientDisconnect(int client) {
    UseCase_RemovePlayerName(client);
}

public void Hook_OnWeaponEquipPost(int client, int weapon) {
    UseCase_OnWeaponEquipPost(client, weapon);
}

public void OnEntityCreated(int entity, const char[] className) {
    UseCase_OnEntityCreated(entity, className);
}

public void OnEntityDestroyed(int entity) {
    UseCase_OnEntityDestroyed(entity);
}
