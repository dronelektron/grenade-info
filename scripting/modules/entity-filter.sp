static StringMap g_physicsGrenades;
static StringMap g_liveGrenades;

void EntityFilter_Create() {
    g_physicsGrenades = new StringMap();
    g_liveGrenades = new StringMap();

    g_physicsGrenades.SetValue("grenade_frag_ger", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_frag_us", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_riflegren_ger", NO_VALUE);
    g_physicsGrenades.SetValue("grenade_riflegren_us", NO_VALUE);

    g_liveGrenades.SetValue("weapon_frag_ger_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_frag_us_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_riflegren_ger_live", NO_VALUE);
    g_liveGrenades.SetValue("weapon_riflegren_us_live", NO_VALUE);
}

bool EntityFilter_IsPhysicsGrenade(const char[] className) {
    return g_physicsGrenades.ContainsKey(className);
}

bool EntityFilter_IsLiveGrenade(const char[] className) {
    return g_liveGrenades.ContainsKey(className);
}
