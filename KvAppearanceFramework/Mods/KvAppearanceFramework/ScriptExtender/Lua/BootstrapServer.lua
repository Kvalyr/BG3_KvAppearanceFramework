-- Preconfigure KvShared
KVS = {}
KVS.modTableKey = "KvAppearanceFramework"
KVS.modPrefix = "KvAF"
KVS.modVersion = {major=0, minor=1, revision=0, build=0}

-- KvShared
Ext.Require("KvShared/_Main.lua")

-- KvAppearanceFramework
Main = {}
State = {}
VisualLibrary = {}
Library = VisualLibrary -- Alias
Addons = {}

Ext.Require("KvAF_Main.lua")
Ext.Require("KvAF_Config.lua")
Ext.Require("KvAF_State.lua")
Ext.Require("KvAF_Library.lua")
Ext.Require("KvAF_Addons.lua")
Ext.Require("BaseGame_Pack/BG3-DAF_CCAV.lua")
Ext.Require("BaseGame_Pack/BG3-DAF_CCSV.lua")


local kvaf_initDone = false

local function LevelGameplayStarted()
    if kvaf_initDone then return end

    State.Init()

    kvaf_initDone = true
    KVS.Output.Info("Log Level at:", KVS.Output.GetLogLevel(), "("..KVS.Output.GetLogLevelAsStr()..")")
    Addons.List()
end

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", LevelGameplayStarted)
