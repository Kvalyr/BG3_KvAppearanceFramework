-- Preconfigure KvShared
KVS = {}
KVS.modTableKey = "KvAppearanceFramework"
KVS.modPrefix = "KvAF"
KVS.modVersion = {major=0.1, minor=0.0}

-- KvShared
Ext.Require("KvShared/_Main.lua")

-- KvAppearanceFramework
Main = {}
State = {}
VisualLibrary = {}
Addons = {}

Ext.Require("KvAF_Main.lua")
Ext.Require("KvAF_Config.lua")
Ext.Require("KvAF_State.lua")
Ext.Require("KvAF_Library.lua")
Ext.Require("KvAF_Addons.lua")

-- Temporary version implementation until KVS version logic fleshed out
Main.version_temp = {}
Main.version_temp["major"] = 0.1
Main.version_temp["minor"] = 0.0


local kvaf_initDone = false

local function LevelGameplayStarted()
    if kvaf_initDone then return end

    State.Init()
    -- Fangs.Init()
    -- Horns.Init()

    kvaf_initDone = true
    KVS.Output.Info("Log Level at:", KVS.Output.GetLogLevel(), "("..KVS.Output.GetLogLevelAsStr()..")")
end

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", LevelGameplayStarted)
