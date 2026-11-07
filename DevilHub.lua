-- DEVIL HUB | Anime Defenders
-- PlaceId: 8304191830

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local endpoints = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server")
local hatchRemotes = ReplicatedStorage:WaitForChild("_TheHatch"):WaitForChild("Remotes")

-- ====================== CONFIG ======================
local Config = {
    AutoFarm = false,
    AutoHatch = false,
    AutoHatchSell = false,
    AutoQuest = false,
    AutoDungeon = false,
    AutoInfiniteTower = false,
    AutoClaimRewards = false,
    AutoEquipBest = false,
    AutoShopBuy = false,
    AutoRedeemCodes = false,
    FarmMap = "",
    FarmDifficulty = 1,
    HatchBanner = "",
    SellRarity = "Common",
    ShopType = "gold",
    RedeemCodeList = {},
}

-- ====================== REMOTE CALLS ======================
local function fireRemote(name, ...)
    local ok, remote = pcall(function()
        return endpoints:WaitForChild(name, 3)
    end)
    if ok and remote then
        if remote:IsA("RemoteFunction") then
            local s, r = pcall(function(...) return remote:InvokeServer(...) end, ...)
            return s and r
        elseif remote:IsA("RemoteEvent") then
            remote:FireServer(...)
            return true
        end
    end
    return nil
end

-- ====================== GUI CORE ======================
if game.CoreGui:FindFirstChild("DevilHub") then
    game.CoreGui:FindFirstChild("DevilHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevilHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(120, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- Logo icon (devil horn unicode)
local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(0, 36, 0, 36)
LogoIcon.Position = UDim2.new(0, 8, 0, 2)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "👿"
LogoIcon.TextSize = 22
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 42, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DEVIL HUB"
Title.TextColor3 = Color3.fromRGB(220, 40, 40)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 150, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "| Anime Defenders"
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 150)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -120, 1, -40)
Content.Position = UDim2.new(0, 120, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Content.BorderSizePixel = 0
Content.Parent = Main

local Pages = {}
local Tabs = {}
local ActiveTab = nil

local tabNames = {"Farm", "Hatch", "Quest", "Dungeon", "Tower", "Rewards", "Misc"}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 600)
    page.Visible = false
    page.Parent = Content
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Pages[name] = page
    return page
end

local function switchTab(name)
    for n, p in pairs(Pages) do
        p.Visible = (n == name)
    end
    for n, t in pairs(Tabs) do
        if n == name then
            t.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
            t.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            t.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
            t.TextColor3 = Color3.fromRGB(140, 140, 150)
        end
    end
    ActiveTab = name
end

for i, name in ipairs(tabNames) do
    createPage(name)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 0, 34)
    tab.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    tab.BorderSizePixel = 0
    tab.Text = "  " .. name
    tab.TextColor3 = Color3.fromRGB(140, 140, 150)
    tab.TextSize = 13
    tab.Font = Enum.Font.GothamBold
    tab.TextXAlignment = Enum.TextXAlignment.Left
    tab.LayoutOrder = i
    tab.Parent = Sidebar
    Tabs[name] = tab
    tab.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ====================== UI COMPONENTS ======================
local function createToggle(parent, text, order, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    holder.BorderSizePixel = 0
    holder.LayoutOrder = order
    holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 42, 0, 22)
    btn.Position = UDim2.new(1, -52, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = holder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "ON" or "OFF"
        btn.BackgroundColor3 = enabled and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(50, 50, 60)
        btn.TextColor3 = enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
        if callback then callback(enabled) end
    end)
    return holder
end

local function createLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(120, 0, 0)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.Parent = parent
    return lbl
end

local function createButton(parent, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback or function() end)
    return btn
end

-- ====================== FARM PAGE ======================
local farmPage = Pages["Farm"]
createLabel(farmPage, "⚔️ AUTO FARM", 1)
createToggle(farmPage, "Auto Farm (Loop Stages)", 2, function(v)
    Config.AutoFarm = v
end)
createToggle(farmPage, "Auto Spawn Units", 3, function(v)
    Config.AutoSpawnUnits = v
end)
createToggle(farmPage, "Auto Upgrade Units", 4, function(v)
    Config.AutoUpgradeUnits = v
end)
createToggle(farmPage, "Auto Use Active Attack", 5, function(v)
    Config.AutoActiveAttack = v
end)
createToggle(farmPage, "Auto Vote Wave Skip", 6, function(v)
    Config.AutoWaveSkip = v
end)
createToggle(farmPage, "Auto Retry on Finish", 7, function(v)
    Config.AutoRetry = v
end)

-- ====================== HATCH PAGE ======================
local hatchPage = Pages["Hatch"]
createLabel(hatchPage, "🥚 AUTO HATCH", 1)
createToggle(hatchPage, "Auto Hatch (Banner)", 2, function(v)
    Config.AutoHatch = v
end)
createToggle(hatchPage, "Auto Sell After Hatch", 3, function(v)
    Config.AutoHatchSell = v
end)
createToggle(hatchPage, "Auto Buy From Banner", 4, function(v)
    Config.AutoBuyBanner = v
end)

-- ====================== QUEST PAGE ======================
local questPage = Pages["Quest"]
createLabel(questPage, "📜 AUTO QUEST", 1)
createToggle(questPage, "Auto Accept NPC Quest", 2, function(v)
    Config.AutoQuest = v
end)
createToggle(questPage, "Auto Redeem Quest", 3, function(v)
    Config.AutoRedeemQuest = v
end)
createToggle(questPage, "Auto Secret Quest", 4, function(v)
    Config.AutoSecretQuest = v
end)

-- ====================== DUNGEON PAGE ======================
local dungeonPage = Pages["Dungeon"]
createLabel(dungeonPage, "🏰 AUTO DUNGEON", 1)
createToggle(dungeonPage, "Auto Dungeon Run", 2, function(v)
    Config.AutoDungeon = v
end)
createToggle(dungeonPage, "Auto Open Chests", 3, function(v)
    Config.AutoDungeonChest = v
end)
createToggle(dungeonPage, "Auto Buy Dungeon Shop", 4, function(v)
    Config.AutoDungeonShop = v
end)
createToggle(dungeonPage, "Auto Accept Shrine", 5, function(v)
    Config.AutoDungeonShrine = v
end)

-- ====================== TOWER PAGE ======================
local towerPage = Pages["Tower"]
createLabel(towerPage, "🗼 AUTO INFINITE TOWER", 1)
createToggle(towerPage, "Auto Infinite Tower", 2, function(v)
    Config.AutoInfiniteTower = v
end)
createToggle(towerPage, "Auto Select Roguelike Option", 3, function(v)
    Config.AutoRoguelike = v
end)

-- ====================== REWARDS PAGE ======================
local rewardsPage = Pages["Rewards"]
createLabel(rewardsPage, "🎁 AUTO CLAIM", 1)
createToggle(rewardsPage, "Auto Claim Daily Reward", 2, function(v)
    Config.AutoClaimDaily = v
end)
createToggle(rewardsPage, "Auto Claim Battlepass", 3, function(v)
    Config.AutoClaimBP = v
end)
createToggle(rewardsPage, "Auto Claim Missions", 4, function(v)
    Config.AutoClaimMissions = v
end)
createToggle(rewardsPage, "Auto Claim Daily Missions", 5, function(v)
    Config.AutoClaimDailyMissions = v
end)
createToggle(rewardsPage, "Auto Claim Player Level", 6, function(v)
    Config.AutoClaimLevel = v
end)
createButton(rewardsPage, "Claim All Now", 7, function()
    fireRemote("claim_daily_reward")
    fireRemote("claim_battlepass_rewards")
    fireRemote("request_claim_mission")
    fireRemote("request_claim_dailymission")
    fireRemote("claim_player_level_rewards")
    fireRemote("claim_first_clear_rewards")
end)

-- ====================== MISC PAGE ======================
local miscPage = Pages["Misc"]
createLabel(miscPage, "⚙️ MISC", 1)
createToggle(miscPage, "Auto Equip Best Units", 2, function(v)
    Config.AutoEquipBest = v
end)
createToggle(miscPage, "Auto Sell Units", 3, function(v)
    Config.AutoSellUnits = v
end)
createButton(miscPage, "Equip Best Now", 4, function()
    fireRemote("equip_best")
end)
createButton(miscPage, "Teleport to Lobby", 5, function()
    fireRemote("teleport_back_to_lobby")
end)
createButton(miscPage, "Teleport to Hub", 6, function()
    local ok, remote = pcall(function()
        return hatchRemotes:WaitForChild("TeleportToHub", 3)
    end)
    if ok and remote then remote:InvokeServer() end
end)

-- default tab
switchTab("Farm")

-- ====================== DRAG ======================
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ====================== MINIMIZE / CLOSE ======================
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 520, 0, 40) or UDim2.new(0, 520, 0, 380)
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ====================== TOGGLE KEYBIND ======================
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

-- ====================== AUTO LOOPS ======================
local function safeWait(t)
    local s = tick()
    while tick() - s < t do RunService.Heartbeat:Wait() end
end

-- Auto Farm Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoFarm then
            fireRemote("request_start_game")
            safeWait(1)
        end
        if Config.AutoSpawnUnits then
            fireRemote("spawn_unit")
            safeWait(0.5)
        end
        if Config.AutoUpgradeUnits then
            fireRemote("upgrade_unit_ingame")
            safeWait(0.5)
        end
        if Config.AutoActiveAttack then
            fireRemote("use_active_attack")
            safeWait(0.3)
        end
        if Config.AutoWaveSkip then
            fireRemote("vote_wave_skip")
            safeWait(1)
        end
        RunService.Heartbeat:Wait()
    end
end)

-- Auto Hatch Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoHatch then
            fireRemote("buy_from_banner")
            safeWait(0.3)
        end
        if Config.AutoHatchSell then
            fireRemote("autosell_hatched_units")
            safeWait(0.5)
        end
        RunService.Heartbeat:Wait()
    end
end)

-- Auto Quest Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoQuest then
            fireRemote("accept_npc_quest")
            safeWait(1)
        end
        if Config.AutoRedeemQuest then
            fireRemote("redeem_quest")
            safeWait(1)
        end
        if Config.AutoSecretQuest then
            fireRemote("try_complete_secret_quest")
            safeWait(2)
        end
        safeWait(1)
    end
end)

-- Auto Dungeon Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoDungeon then
            fireRemote("dungeon_start")
            safeWait(1)
            fireRemote("dungeon_enter_room")
            safeWait(0.5)
        end
        if Config.AutoDungeonChest then
            fireRemote("dungeon_open_chest")
            safeWait(0.5)
        end
        if Config.AutoDungeonShop then
            fireRemote("dungeon_buy_shop")
            safeWait(0.5)
        end
        if Config.AutoDungeonShrine then
            fireRemote("dungeon_shrine_accept")
            safeWait(0.5)
        end
        safeWait(1)
    end
end)

-- Auto Infinite Tower Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoInfiniteTower then
            fireRemote("request_start_infinite_tower")
            safeWait(1)
        end
        if Config.AutoRoguelike then
            fireRemote("select_roguelike_option")
            safeWait(1)
        end
        safeWait(1)
    end
end)

-- Auto Claim Rewards Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoClaimDaily then
            fireRemote("claim_daily_reward")
        end
        if Config.AutoClaimBP then
            fireRemote("claim_battlepass_rewards")
        end
        if Config.AutoClaimMissions then
            fireRemote("request_claim_mission")
        end
        if Config.AutoClaimDailyMissions then
            fireRemote("request_claim_dailymission")
        end
        if Config.AutoClaimLevel then
            fireRemote("claim_player_level_rewards")
        end
        safeWait(30)
    end
end)

-- Auto Equip Best Loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoEquipBest then
            fireRemote("equip_best")
        end
        safeWait(10)
    end
end)

-- ====================== AUTO SELL UNITS LOOP ======================
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoSellUnits then
            fireRemote("sell_units")
            safeWait(2)
        end
        safeWait(1)
    end
end)

-- ====================== AUTO SHOP LOOP ======================
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoShopBuy then
            pcall(function()
                local shops = {
                    "buy_gold_shop_item",
                    "buy_bsd_shop_item",
                    "buy_trophy_shop_item",
                    "buy_raidshop_shop_item",
                }
                for _, shop in ipairs(shops) do
                    fireRemote(shop)
                    safeWait(0.5)
                end
            end)
        end
        safeWait(15)
    end
end)

-- ====================== AUTO TRAVELLING MERCHANT ======================
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoMerchant then
            fireRemote("buy_travelling_merchant_item")
            safeWait(1)
        end
        safeWait(5)
    end
end)

-- ====================== AUTO REDEEM CODES ======================
local DefaultCodes = {
    "RELEASE", "UPDATE1", "UPDATE2", "UPDATE3", "UPDATE4", "UPDATE5",
    "100KLIKES", "200KLIKES", "500KLIKES", "1MLIKES", "SORRY",
    "THANKYOU", "SUMMER", "CHRISTMAS", "NEWYEAR", "ANIME",
}

local function redeemAllCodes()
    for _, code in ipairs(DefaultCodes) do
        fireRemote("redeem_code", code)
        safeWait(0.3)
    end
    for _, code in ipairs(Config.RedeemCodeList) do
        fireRemote("redeem_code", code)
        safeWait(0.3)
    end
end

-- ====================== STATUS LOG SYSTEM ======================
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusLog"
StatusFrame.Size = UDim2.new(0, 200, 0, 120)
StatusFrame.Position = UDim2.new(1, -210, 1, -130)
StatusFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
StatusFrame.BackgroundTransparency = 0.15
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = ScreenGui
Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
local statusStroke = Instance.new("UIStroke", StatusFrame)
statusStroke.Color = Color3.fromRGB(80, 0, 0)
statusStroke.Thickness = 1

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, 0, 0, 20)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "👿 DEVIL STATUS"
StatusTitle.TextColor3 = Color3.fromRGB(120, 0, 0)
StatusTitle.TextSize = 11
StatusTitle.Font = Enum.Font.GothamBlack
StatusTitle.Parent = StatusFrame

local StatusLog = Instance.new("TextLabel")
StatusLog.Size = UDim2.new(1, -10, 1, -24)
StatusLog.Position = UDim2.new(0, 5, 0, 22)
StatusLog.BackgroundTransparency = 1
StatusLog.Text = ""
StatusLog.TextColor3 = Color3.fromRGB(180, 180, 190)
StatusLog.TextSize = 10
StatusLog.Font = Enum.Font.Code
StatusLog.TextXAlignment = Enum.TextXAlignment.Left
StatusLog.TextYAlignment = Enum.TextYAlignment.Top
StatusLog.TextWrapped = true
StatusLog.Parent = StatusFrame

local logLines = {}
local function addLog(msg)
    table.insert(logLines, os.date("[%H:%M:%S] ") .. msg)
    if #logLines > 7 then table.remove(logLines, 1) end
    StatusLog.Text = table.concat(logLines, "\n")
end

addLog("DEVIL HUB loaded")
addLog("Player: " .. LocalPlayer.Name)

-- status update loop
spawn(function()
    while ScreenGui.Parent do
        local active = {}
        if Config.AutoFarm then table.insert(active, "Farm") end
        if Config.AutoHatch then table.insert(active, "Hatch") end
        if Config.AutoDungeon then table.insert(active, "Dungeon") end
        if Config.AutoInfiniteTower then table.insert(active, "Tower") end
        if Config.AutoQuest then table.insert(active, "Quest") end
        if #active > 0 then
            addLog("Active: " .. table.concat(active, ", "))
        end
        safeWait(15)
    end
end)

-- ====================== SETTINGS SAVE / LOAD ======================
local HttpService = game:GetService("HttpService")
local SAVE_FILE = "DevilHub_Settings.json"

local function saveSettings()
    local ok, err = pcall(function()
        if writefile then
            local data = HttpService:JSONEncode(Config)
            writefile(SAVE_FILE, data)
            addLog("Settings saved")
        end
    end)
end

local function loadSettings()
    local ok, err = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            local raw = readfile(SAVE_FILE)
            local data = HttpService:JSONDecode(raw)
            for k, v in pairs(data) do
                if Config[k] ~= nil then
                    Config[k] = v
                end
            end
            addLog("Settings loaded")
        end
    end)
end

loadSettings()

-- ====================== MISC PAGE EXTRAS ======================
createLabel(miscPage, "🛒 SHOP & CODES", 7)
createToggle(miscPage, "Auto Buy All Shops", 8, function(v)
    Config.AutoShopBuy = v
end)
createToggle(miscPage, "Auto Buy Travelling Merchant", 9, function(v)
    Config.AutoMerchant = v
end)
createButton(miscPage, "Redeem All Codes", 10, function()
    addLog("Redeeming codes...")
    redeemAllCodes()
    addLog("Codes redeemed")
end)

createLabel(miscPage, "💾 SETTINGS", 11)
createButton(miscPage, "Save Settings", 12, function()
    saveSettings()
end)
createButton(miscPage, "Load Settings", 13, function()
    loadSettings()
end)

-- ====================== ENHANCED FARM LOGIC ======================
local gameFinished = false
local inGame = false

pcall(function()
    local s2c = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("server_to_client")
    s2c:WaitForChild("game_finished", 5).OnClientEvent:Connect(function()
        gameFinished = true
        inGame = false
        addLog("Game finished")
    end)
    s2c:WaitForChild("wave_started", 5).OnClientEvent:Connect(function(wave)
        addLog("Wave " .. tostring(wave or "?"))
    end)
    s2c:WaitForChild("loot_spawned", 5).OnClientEvent:Connect(function()
        if Config.AutoFarm then
            fireRemote("redeem_loot")
        end
    end)
    s2c:WaitForChild("show_roguelike_options", 5).OnClientEvent:Connect(function()
        if Config.AutoRoguelike then
            safeWait(0.5)
            fireRemote("select_roguelike_option", 1)
            addLog("Roguelike option selected")
        end
    end)
    s2c:WaitForChild("travelling_merchant_opened", 5).OnClientEvent:Connect(function()
        if Config.AutoMerchant then
            addLog("Merchant appeared — buying")
            for i = 1, 5 do
                fireRemote("buy_travelling_merchant_item", i)
                safeWait(0.3)
            end
        end
    end)
end)

-- Smart farm loop (replaces basic one)
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoFarm and Config.AutoRetry and gameFinished then
            gameFinished = false
            safeWait(2)
            fireRemote("teleport_back_to_lobby")
            safeWait(3)
            fireRemote("request_start_game")
            addLog("Auto retry — starting new game")
            safeWait(2)
        end
        safeWait(1)
    end
end)

-- Auto loot collection loop
spawn(function()
    while ScreenGui.Parent do
        if Config.AutoFarm then
            pcall(function()
                fireRemote("redeem_loot")
            end)
        end
        safeWait(3)
    end
end)

-- ====================== ANTI-AFK ======================
local VirtualUser = game:GetService("VirtualUser")
spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        safeWait(60)
    end
end)

LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    addLog("Anti-AFK triggered")
end)

-- ====================== AUTO RECONNECT ======================
spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            local teleportService = game:GetService("TeleportService")
            local connected = LocalPlayer:GetNetworkPing() < 10
            if not connected or not LocalPlayer.Character then
                addLog("Connection lost — reconnecting...")
                safeWait(3)
                teleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
        safeWait(10)
    end
end)

-- ====================== NOTIFICATION ======================
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 280, 0, 40)
notif.Position = UDim2.new(0.5, -140, 0, -50)
notif.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
notif.TextColor3 = Color3.fromRGB(255, 255, 255)
notif.Text = "👿 DEVIL HUB Loaded | RightCtrl to toggle"
notif.TextSize = 13
notif.Font = Enum.Font.GothamBold
notif.Parent = ScreenGui
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Position = UDim2.new(0.5, -140, 0, 10)
}):Play()

task.delay(3, function()
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -140, 0, -50)
    }):Play()
    task.wait(0.6)
    notif:Destroy()
end)
