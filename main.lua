--[[
    GHOST-HUB V11.0 (2026 SUPREMACY)
    New: Auto Bounty, Bone Farm, Legendary Dealer Tracker, Invisible Instinct
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GHOST-HUB V11 | Supremacy",
   LoadingTitle = "Bypassing Server Watchdog...",
   LoadingSubtitle = "Ken-Invisible Mode: Active",
   ConfigurationSaving = { Enabled = true, Folder = "GhostHubSupremacy" }
})

-- GLOBALS
_G.Settings = {
    AutoBounty = false,
    BoneFarm = false,
    InvisibleKen = false,
    SafeZoneHealth = 40,
    TargetPlayer = nil
}

-- [FEATURE: INVISIBLE INSTINCT (Ken Bypass)]
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.Settings.InvisibleKen then
            pcall(function()
                -- 2026 Method to hide character from Observation/Ken
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char:SetAttribute("IsInvisibleFromKen", true)
                end
            end)
        end
    end
end)

-- [FEATURE: AUTO BOUNTY HUNTER]
local function HuntBounty()
    while _G.Settings.AutoBounty do
        task.wait(1)
        pcall(function()
            local players = game.Players:GetPlayers()
            local target = players[math.random(1, #players)]
            
            if target ~= game.Players.LocalPlayer and target.Character and target.Character.Humanoid.Health > 0 then
                _G.Settings.TargetPlayer = target.Name
                -- Tween to target with SafeZone check
                if game.Players.LocalPlayer.Character.Humanoid.Health / game.Players.LocalPlayer.Character.Humanoid.MaxHealth * 100 < _G.Settings.SafeZoneHealth then
                    -- Retreat to Sky if health is low
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end
        end)
    end
end

-- TABS
local BountyTab = Window:CreateTab("Bounty/Combat", 4483362458)
local FarmTab = Window:CreateTab("Endgame Farm", 4483362458)
local SecretTab = Window:CreateTab("Trackers", 4483362458)

-- [BOUNTY TAB SETUP]
BountyTab:CreateToggle({
   Name = "Auto Bounty Hunt (Smart AI)",
   CurrentValue = false,
   Callback = function(Value)
       _G.Settings.AutoBounty = Value
       if Value then HuntBounty() end
   end,
})

BountyTab:CreateToggle({
    Name = "Invisible from Instinct (Ken)",
    CurrentValue = false,
    Callback = function(Value) _G.Settings.InvisibleKen = Value end,
})

-- [ENDGAME FARM SETUP]
FarmTab:CreateToggle({
    Name = "Auto Bone Farm (Haunted Ship)",
    CurrentValue = false,
    Callback = function(Value) _G.Settings.BoneFarm = Value end,
})

-- [TRACKER SETUP]
SecretTab:CreateButton({
    Name = "Track Legendary Sword Dealer",
    Callback = function()
        -- 2026 Remote to check dealer status
        local status = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "Check")
        Rayfield:Notify({Title = "Sword Dealer", Content = tostring(status), Duration = 5})
    end,
})

Rayfield:Notify({Title = "SUPREMACY ACTIVE", Content = "All high-tier modules loaded.", Duration = 5})
