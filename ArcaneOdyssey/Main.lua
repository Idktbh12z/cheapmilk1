if getgenv().PMAO == true then return end
getgenv().PMAO = true

local lib = loadstring(game:HttpGet("https://gist.githubusercontent.com/Idktbh12z/e557ec01b8234cccb7d88f2c12691a5a/raw/3824e26041944a83ec39ff0b033f994b1bbdbadd/UiLib.lua"))()
local Veynx = lib.new("Snowy | Arcane Odyssey [DEV]")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local Camera = workspace.CurrentCamera
local Map = workspace:WaitForChild("Map", 10)
local MagicModule = require(game:GetService("ReplicatedStorage"):WaitForChild("RS",10).Modules.Magic)
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local TpDebounce = false
local FillDebounce = false
local RanConnectGodmode = false
local ModifiedMagic = nil

local DropdownTpList = {}
local MagicList = {}
local DeathScreenConnections = {}

task.spawn(function()
    while task.wait(1) do
        for _,Player in ReplicatedStorage.RS.UnloadPlayers:GetChildren() do
            Player.Parent = game.Workspace.NPCs
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        for _,Instance in LocalPlayer.PlayerGui:GetChildren() do
            if Instance.Name:lower() == "deathscreen" then
                Instance.Enabled = false
            end
        end
    end
end)

local remotes = {
    "DealAttackDamage",
    "DealStrengthDamage",
    "DealWeaponDamage",
    "DealMagicDamage"
}

for _, Folder in Map:GetChildren() do
    if Folder:FindFirstChild("Center") then table.insert(DropdownTpList, Folder.Name) end
end

for _,Magic in MagicModule["Types"] do
    table.insert(MagicList, _)
end

local var = {
    dmgValue = false,
    dmgMulti = 1,
    godmode = false,
    NPCBlock = false,
    FastBoatRepair = false,
    RepairMulti = 1,
    NoTracking = false,
    StaminaReduction = false,
    OneTapStructure = false,
    QuickFillBottles = false,
    ToggleLightning = false,
}

local uiPages = {}
local uiSecs = {}

uiPages.Main = Veynx:addPage("Main")
uiPages.Exploits = Veynx:addPage("Exploits")
uiPages.Travel = Veynx:addPage("Teleports")
uiPages.Misc = Veynx:addPage("Misc")

uiSecs.Godmode = uiPages.Main:addSection("Godmode")
uiSecs.dmgExploits = uiPages.Main:addSection("Damage Exploits")
uiSecs.NPCE = uiPages.Main:addSection("NPC Exploits")
uiSecs.UI = uiPages.Main:addSection("UI")

uiSecs.TP = uiPages.Travel:addSection("Teleports")

uiSecs.Misc = uiPages.Misc:addSection("Misc")

uiSecs.BoatExploits = uiPages.Exploits:addSection("Boat Exploits")
uiSecs.ItemExploits = uiPages.Exploits:addSection("Item Exploits")
uiSecs.PlayerExploits = uiPages.Exploits:addSection("Player Exploits")
uiSecs.MagicExploits = uiPages.Exploits:addSection("Magic Exploits")

uiSecs.Godmode:addToggle("Godmode.", false, function(value)
    var["godmode"] = value
end)

uiSecs.NPCE:addToggle("No NPC Aggro.", false, function(value)
    var["NPCBlock"] = value
end)

uiSecs.PlayerExploits:addToggle("No location tracking.", false, function(value)
    var["NoTracking"] = value
end)

uiSecs.PlayerExploits:addToggle("Spawn dark sea lightning", false, function(value)
    var["ToggleLightning"] = value
end)

uiSecs.PlayerExploits:addToggle("Reduced stamina consumption.", false, function(value)
    var["StaminaReduction"] = value

    Veynx:Notify("Warning!", "This could get you banned.")
end)

uiSecs.dmgExploits:addSlider("Damage multiplier amount.", 1, 1, 15, function(value)
    var["dmgMulti"] = value
end)

uiSecs.dmgExploits:addToggle("Damage multiplier.", false, function(value)
    var["dmgValue"] = value

    Veynx:Notify("Warning!", "This multiplies damage against players, use it wisely.")
end)

uiSecs.BoatExploits:addToggle("Ship repair multiplier.", false, function(value)
    var["FastBoatRepair"] = value
end)

uiSecs.BoatExploits:addSlider("Ship repair multi (costs galleons).", 1, 1, 50, function(value)
    var["RepairMulti"] = value
end)

uiSecs.MagicExploits:addToggle("One tap buildings/structures.", false, function(value)
    var["OneTapStructure"] = value
end)

uiSecs.UI:addKeybind("Toggle UI.", Enum.KeyCode.Equals, function(value)
    Veynx:toggle()
end)

uiSecs.ItemExploits:addButton("Quick fill empty bottles.", function(value)
    if FillDebounce == true then return end
    FillDebounce = true

    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    Humanoid:UnequipTools()

    for i = 1,100 do
        game:GetService("ReplicatedStorage").RS.Remotes.Misc.EmptyBottle:FireServer()
    end

    task.delay(1, function()
        FillDebounce = false
    end)
end)

uiSecs.PlayerExploits:addButton("Toggle insanity effects.", function(value)
    local InsanityLocalScript = LocalPlayer.PlayerGui:WaitForChild("Temp",10):FindFirstChild("Insanity")
    InsanityLocalScript.Disabled = not InsanityLocalScript.Disabled
end)

uiSecs.Misc:addButton("ArcaneYield (modded IY).", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Idktbh12z/ArcaneYIELD/refs/heads/main/main.lua"), true)()
end)

uiSecs.TP:addDropdown("Teleports", DropdownTpList, function(value)
    if TpDebounce then return end
    TpDebounce = true
    local Island = Map:FindFirstChild(value)
    if not Island then return end

    local Center = Island:FindFirstChild("Center")
    if not Center then return end

    if value == "Harvest Island" then
        local OldPos = Center.Position

        Center.Position = Vector3.new(7236, 598, 343)

        task.delay(1, function()
            Center.Position = OldPos
        end)
    end

    local LandingPos = value == "Mount Othrys" and CFrame.new(0,-25000,0) or CFrame.new(0, 1000, 0)

    LocalPlayer.Character.HumanoidRootPart.CFrame = Center.CFrame * LandingPos
    task.wait()
    LocalPlayer.Character.HumanoidRootPart.Anchored = true

    task.delay(15, function()
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
        TpDebounce = false
    end)
end)

uiSecs.MagicExploits:addDropdown("[Magic]", MagicList, function(value)
    if not MagicModule["Types"][value] then return end

    ModifiedMagic = value
end)

uiSecs.MagicExploits:addTextbox("Size", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num >= 75 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: 50") end

    MagicModule["Types"][ModifiedMagic].Size = num
end)

uiSecs.MagicExploits:addTextbox("Speed", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num >= 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: <3") end

    MagicModule["Types"][ModifiedMagic].Speed = num
end)

uiSecs.MagicExploits:addTextbox("Imbue Speed", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num >= 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high.  \n Suggested value: <3") end

    MagicModule["Types"][ModifiedMagic].ImbueSpeed = num
end)

task.spawn(function()
    local StaminaHook
    StaminaHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "StaminaCost") and var["StaminaReduction"] == true then
            if args[1] then
                args[1] = 0
            end
        end

        return StaminaHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local OneTapStructureHook
    OneTapStructureHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "DamageStructure") and var["OneTapStructure"] == true then
            for i=1,250 do
                self.InvokeServer(self, unpack(args))
            end
        end

        return OneTapStructureHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local LightningHook
    LightningHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "UpdateLastSeen") and var["ToggleLightning"] == true then
            if args[1] then
                args[1] = "The Dark Sea"
            end
            if args[2] then
                args[2] = ""
            end
        end

        return LightningHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local FastRepairHook
    FastRepairHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "RepairHammer") and var["FastBoatRepair"] == true then
            for i=1,var["RepairMulti"] do
                self.InvokeServer(self, unpack(args))
            end
        end

        return FastRepairHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local NoTrackingHook
    NoTrackingHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "UpdateLastSeen") and var["NoTracking"] == true then
            if args[1] then
                args[1] = ""
            end

            if args[2] then
                args[2] = ""
            end
        end

        return NoTrackingHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local damageHook
    damageHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and table.find(remotes, tostring(self)) and var["dmgValue"] then
            for i = 1, var["dmgMulti"] do
                self.FireServer(self, unpack(args))
            end
        end

        return damageHook(self, unpack(args))
    end))
end)

task.spawn(function()
    local godHook
    godHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }

        if not checkcaller() and (tostring(self) == "DealAttackDamage" or tostring(self) == "DealBossDamage") and var["godmode"] then
            if args[2] == LocalPlayer.Character then
                args[2] = nil
            end
        elseif not checkcaller() and tostring(self) == "DealMagicDamage" and var["godmode"] then
            if args[2] == LocalPlayer.Character then
                args[2] = nil
            end
        elseif not checkcaller() and (tostring(self) == "DealStrengthDamage" or tostring(self) == "DealWeaponDamage") and var["godmode"] then
            if args[3] == LocalPlayer.Character then
                args[3] = nil
            end
        end

        return godHook(self, unpack(args))
    end))
end)

task.spawn(function()
    local blockHook
    blockHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and tostring(self) == "TargetBehavior" and method == "InvokeServer" and var["NPCBlock"] then
            return
        end

        return blockHook(self, unpack(args))
    end))
end)
