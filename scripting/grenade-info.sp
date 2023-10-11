#include <sourcemod>
#include <sdkhooks>

#include "morecolors"

#include "gi/entity-filter"
#include "gi/use-case"

#include "modules/entity-filter.sp"
#include "modules/grenade-list.sp"
#include "modules/message.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Grenade info",
    author = "Dron-elektron",
    description = "Shows information about a picked up grenade",
    version = "0.1.0",
    url = "https://github.com/dronelektron/grenade-info"
};

public void OnPluginStart() {
    EntityFilter_Create();
    GrenadeList_Create();
    LoadTranslations("grenade-info.phrases");
}

public void OnClientPutInServer(int client) {
    SDKHook(client, SDKHook_WeaponEquipPost, Hook_OnWeaponEquipPost);
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
