--[[ 
SUPREMACY SOVEREIGN HUB v45.0
ALL FEATURES MERGED INTO ONE SCRIPT
]]

-- =========================
-- 1. SERVICES / PLAYER
-- =========================
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================
-- 2. SAFE TELEPORT
-- =========================
local function SafeTP(cf)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cf
    end
end

-- =========================
-- 3. DATABASE
-- =========================
local SovereignDB = {
    V4 = {Lever = CFrame.new(2800,15,-2500)}
}

-- =========================
-- 4. SETTINGS (ALL FEATURES)
-- =========================
_G.Settings = {
    Aimbot = false,
    FastAttack = true,
    AutoFarm = false,
    BossFarm = false,
    AutoFarmLevel = false,
    QuestMaster = false,
    WeaponHitbox = true
}

-- =========================
-- 5. UI (MERCURY)
-- =========================
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeesss/MercuryLib/main/library.lua"))()
local GUI = Mercury:Create{
    Name = "SUPREMACY v45 (OMNI)",
    Size = UDim2.fromOffset(600,400),
    Theme = Mercury.Themes.Dark
}

local TabDash = GUI:Tab{Name="Dashboard"}
local TabCombat = GUI:Tab{Name="Combat"}
local TabREDz = GUI:Tab{Name="REDz Hub"}

local MoonLabel = TabDash:Label{Text="Moon Phase: ..."}
local TimeLabel = TabDash:Label{Text="Server Time: ..."}

-- =========================
-- 6. DASHBOARD ENGINE
-- =========================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            TimeLabel:SetText("Server Time: "..Lighting.TimeOfDay)
            local d = math.floor(workspace.DistributedGameTime/1200)%8
            local p = {"Full Moon","Waning Gibbous","Last Quarter","Waning Crescent","New Moon","Waxing Crescent","First Quarter","Waxing Gibbous"}
            MoonLabel:SetText("Moon Phase: "..p[d+1])
        end)
    end
end)

-- =========================
-- 7. UI TOGGLES
-- =========================
TabCombat:Toggle{Name="Camera Aimbot", Callback=function(v) _G.Settings.Aimbot=v end}
TabCombat:Toggle{Name="Fast Attack", StartingState=true, Callback=function(v) _G.Settings.FastAttack=v end}
TabCombat:Toggle{Name="Auto Farm NPC", Callback=function(v) _G.Settings.AutoFarm=v end}
TabCombat:Toggle{Name="Boss Farm", Callback=function(v) _G.Settings.BossFarm=v end}
TabCombat:Toggle{Name="Auto Farm Level", Callback=function(v) _G.Settings.AutoFarmLevel=v end}
TabREDz:Toggle{Name="Auto Quest Master", Callback=function(v) _G.Settings.QuestMaster=v end}

-- =========================
-- 8. CAMERA AIMBOT
-- =========================
task.spawn(function()
    while task.wait() do
        if _G.Settings.Aimbot then
            pcall(function()
                local t, d = nil, 1000
                for _,p in pairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local m = (LocalPlayer.Character.HumanoidRootPart.Position -
                                   p.Character.HumanoidRootPart.Position).Magnitude
                        if m < d then d=m t=p.Character.HumanoidRootPart end
                    end
                end
                if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
            end)
        end
    end
end)

-- =========================
-- 9. REAL FAST ATTACK
-- =========================
local CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatController = CombatFramework.activeController

task.spawn(function()
    while task.wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                if CombatController and CombatController.attack then
                    CombatController:attack()
                end
                VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
            end)
        end
    end
end)

-- =========================
-- 10. QUEST DATA (LEVEL FARM)
-- =========================
local QuestData = {
    FirstSea = {
        {Min=1,Max=9,Enemy="Bandit"},
        {Min=10,Max=29,Enemy="Monkey"},
        {Min=30,Max=59,Enemy="Pirate"},
        {Min=60,Max=99,Enemy="Desert Bandit"},
    },
    SecondSea = {
        {Min=700,Max=774,Enemy="Raider"},
        {Min=775,Max=874,Enemy="Mercenary"},
    },
    ThirdSea = {
        {Min=1500,Max=1600,Enemy="Pirate Millionaire"},
    }
}

local function GetSea()
    if game.PlaceId==2753915549 then return "FirstSea"
    elseif game.PlaceId==4442272183 then return "SecondSea"
    elseif game.PlaceId==7449423635 then return "ThirdSea" end
end

local function GetQuestByLevel()
    local sea = GetSea()
    local lvl = LocalPlayer.Data.Level.Value
    for _,q in pairs(QuestData[sea] or {}) do
        if lvl>=q.Min and lvl<=q.Max then return q end
    end
end

-- =========================
-- 11. TARGET SELECTOR
-- =========================
local function GetEnemy(name,boss)
    local c,d=nil,math.huge
    for _,m in pairs(workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("Humanoid") and m.Humanoid.Health>0
        and m:FindFirstChild("HumanoidRootPart") then
            if name and not m.Name:find(name) then continue end
            if boss and not m.Name:lower():find("boss") then continue end
            local mag=(LocalPlayer.Character.HumanoidRootPart.Position-
                       m.HumanoidRootPart.Position).Magnitude
            if mag<d then d=mag c=m end
        end
    end
    return c
end

-- =========================
-- 12. AUTO FARM / BOSS / LEVEL FARM
-- =========================
task.spawn(function()
    while task.wait() do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local target
                if _G.Settings.AutoFarmLevel then
                    local q=GetQuestByLevel()
                    if q then target=GetEnemy(q.Enemy) end
                elseif _G.Settings.BossFarm then
                    target=GetEnemy(nil,true)
                elseif _G.Settings.AutoFarm then
                    target=GetEnemy()
                end

                if target then
                    SafeTP(target.HumanoidRootPart.CFrame*CFrame.new(0,12,6))
                    _G.Settings.FastAttack=true
                end
            end)
        end
    end
end)

-- =========================
-- 13. AUTO QUEST PICKUP
-- =========================
task.spawn(function()
    while task.wait(3) do
        if _G.Settings.AutoFarmLevel and _G.Settings.QuestMaster then
            pcall(function()
                for _,v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("quest") and v:FindFirstChild("HumanoidRootPart") then
                        SafeTP(v.HumanoidRootPart.CFrame)
                        break
                    end
                end
            end)
        end
    end
end)

-- =========================
-- 14. HITBOX EXTENDER
-- =========================
task.spawn(function()
    while task.wait(1) do
        if _G.Settings.WeaponHitbox then
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") then
                    v.HumanoidRootPart.Size=Vector3.new(60,60,60)
                    v.HumanoidRootPart.Transparency=1
                    v.HumanoidRootPart.CanCollide=false
                end
            end
        end
    end
end)

GUI:Notification{
    Title="SUPREMACY v45",
    Text="ALL FEATURES LOADED (Auto Farm Level Enabled)",
    Duration=5
}
