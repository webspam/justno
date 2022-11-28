ScriptName JustNo:Quest extends Quest
{Registers event listeners for sitting on nearby stuff}

; --------------------- Properties ---------------------

Actor property PlayerRef auto
{Autofill}
Keyword property FurnitureClassRelaxation auto
{Autofill - Chairs etc}
Perk property JustNo_Perk auto
{Autofill - The perk that handles activator text changes}
GlobalVariable property JustNo_Sit auto
{Autofill - game checks this when showing activators with FurnitureClassRelaxation}
GlobalVariable property JustNo_Drink auto
{Autofill - game checks this when showing activators matching IsWaterObject}

string _modName = "JustNo" const

string _noSitMain = "fNoSit:Main" const
string _noDrinkMain = "fNoDrink:Main" const

event OnQuestInit()
    Init()
endevent

; Called by OnQuestInit()
function Init()
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    OnLoadGame()
    UpdateSettingsFromMCM()

    PlayerRef.AddPerk(JustNo_Perk)
endfunction

; Syncs & configures MCM after save load
Event Actor.OnPlayerLoadGame(Actor akSender)
    OnLoadGame()
    UpdateSettingsFromMCM()
EndEvent

; Called by OnPlayerLoadGame()
function OnLoadGame()
    RegisterForExternalEvent("OnMCMSettingChange|JustNo", "OnMCMSettingChange")
    RegisterForExternalEvent("OnMCMOpen", "OnMCMOpen");
endfunction

function OnMCMOpen()
endfunction

; Updates / cludges all local settings with values from MCM
function UpdateSettingsFromMCM()
    JustNo_Sit.Value = MCM.GetModSettingFloat(_modName, _noSitMain)
    JustNo_Drink.Value = MCM.GetModSettingFloat(_modName, _noDrinkMain)
endfunction

; MCM configuration
function OnMCMSettingChange(string modName, string id)
    if (modName == _modName)
        UpdateSettingsFromMCM()
    endif
endfunction

function Toggle()
    if (JustNo_Sit.Value + JustNo_Drink.Value == 1.0)
        SetSetting(_noSitMain, JustNo_Sit, 1.0)
        SetSetting(_noDrinkMain, JustNo_Drink, 1.0)
    else
        ToggleSit()
        ToggleDrink()
    endif
endfunction

function ToggleSit()
    ToggleGlobalVariable(_noSitMain, JustNo_Sit)
endfunction

function ToggleDrink()
    ToggleGlobalVariable(_noDrinkMain, JustNo_Drink)
endfunction

function ToggleGlobalVariable(string setting, GlobalVariable glob)
    float f = 0.0
    if (glob.value == 0.0)
        f = 1.0
    endif
    SetSetting(setting, glob, f)
endfunction

function SetSetting(string setting, GlobalVariable glob, float value)
    glob.Value = value
    MCM.SetModSettingFloat(_modName, setting, value)
endfunction