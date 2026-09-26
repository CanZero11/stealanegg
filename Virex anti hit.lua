--==================================================
-- VIREX HUB SAE
-- FULL CLIENT SCRIPT
--==================================================

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local LogoId = "rbxassetid://YOUR_IMAGE_ASSET_ID"
local targetParent = (gethui and gethui()) or PlayerGui

--==================================================
-- REMOVE OLD GUI
--==================================================

local oldGui = targetParent:FindFirstChild("VirexHubGui")
if oldGui then
    oldGui:Destroy()
end

--==================================================
-- STATE
--==================================================

local AntiHitEnabled = false
local IsTeleporting = false
local GlobalChatOpen = false
local UnreadMessages = 0
local GlobalChatRemote = nil
local CurrentScale = 1
local CurrentBackground = "Aura Red"

--==================================================
-- SCREEN GUI
--==================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VirexHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = targetParent

--==================================================
-- MAIN FRAME
--==================================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(240, 190)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -95)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 8)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(125, 10, 25)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(30, 7, 12)
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(28, 28)
logo.Position = UDim2.fromOffset(7, 5)
logo.BackgroundTransparency = 1
logo.Image = LogoId
logo.ZIndex = 12
logo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -75, 1, 0)
title.Position = UDim2.fromOffset(42, 0)
title.BackgroundTransparency = 1
title.Text = "VIREX HUB"
title.TextColor3 = Color3.fromRGB(255, 220, 225)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(26, 26)
closeButton.Position = UDim2.new(1, -32, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(100, 10, 20)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.ZIndex = 13
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeButton

--==================================================
-- TABS
--==================================================

local mainTab = Instance.new("TextButton")
mainTab.Size = UDim2.fromOffset(112, 23)
mainTab.Position = UDim2.fromOffset(6, 43)
mainTab.BackgroundColor3 = Color3.fromRGB(105, 10, 25)
mainTab.Text = "MAIN"
mainTab.TextColor3 = Color3.new(1, 1, 1)
mainTab.Font = Enum.Font.GothamBold
mainTab.TextSize = 10
mainTab.ZIndex = 12
mainTab.Parent = mainFrame

local mainTabCorner = Instance.new("UICorner")
mainTabCorner.CornerRadius = UDim.new(0, 6)
mainTabCorner.Parent = mainTab

local miscTab = Instance.new("TextButton")
miscTab.Size = UDim2.fromOffset(112, 23)
miscTab.Position = UDim2.fromOffset(122, 43)
miscTab.BackgroundColor3 = Color3.fromRGB(45, 10, 15)
miscTab.Text = "MISC"
miscTab.TextColor3 = Color3.fromRGB(220, 180, 185)
miscTab.Font = Enum.Font.GothamBold
miscTab.TextSize = 10
miscTab.ZIndex = 12
miscTab.Parent = mainFrame

local miscTabCorner = Instance.new("UICorner")
miscTabCorner.CornerRadius = UDim.new(0, 6)
miscTabCorner.Parent = miscTab

--==================================================
-- CONTENT
--==================================================

local mainContent = Instance.new("Frame")
mainContent.Size = UDim2.new(1, -12, 1, -72)
mainContent.Position = UDim2.fromOffset(6, 70)
mainContent.BackgroundTransparency = 1
mainContent.ZIndex = 11
mainContent.Parent = mainFrame

local miscContent = Instance.new("Frame")
miscContent.Size = UDim2.new(1, -12, 1, -72)
miscContent.Position = UDim2.fromOffset(6, 70)
miscContent.BackgroundTransparency = 1
miscContent.Visible = false
miscContent.ZIndex = 11
miscContent.Parent = mainFrame

--==================================================
-- ANTI-HIT
--==================================================

local antiHitBtn = Instance.new("TextButton")
antiHitBtn.Size = UDim2.new(1, 0, 0, 38)
antiHitBtn.Position = UDim2.fromOffset(0, 0)
antiHitBtn.BackgroundColor3 = Color3.fromRGB(55, 8, 15)
antiHitBtn.Text = "🛡 Anti-Hit : OFF"
antiHitBtn.TextColor3 = Color3.fromRGB(255, 220, 225)
antiHitBtn.Font = Enum.Font.GothamBold
antiHitBtn.TextSize = 11
antiHitBtn.ZIndex = 12
antiHitBtn.Parent = mainContent

local antiCorner = Instance.new("UICorner")
antiCorner.CornerRadius = UDim.new(0, 7)
antiCorner.Parent = antiHitBtn

--==================================================
-- GLOBAL CHAT BUTTON
--==================================================

local globalBtn = Instance.new("TextButton")
globalBtn.Size = UDim2.new(1, 0, 0, 38)
globalBtn.Position = UDim2.fromOffset(0, 45)
globalBtn.BackgroundColor3 = Color3.fromRGB(55, 8, 15)
globalBtn.Text = "🌐 Virex Global"
globalBtn.TextColor3 = Color3.fromRGB(255, 220, 225)
globalBtn.Font = Enum.Font.GothamBold
globalBtn.TextSize = 11
globalBtn.ZIndex = 12
globalBtn.Parent = mainContent

local globalCorner = Instance.new("UICorner")
globalCorner.CornerRadius = UDim.new(0, 7)
globalCorner.Parent = globalBtn

--==================================================
-- MISC
--==================================================

local bgTitle = Instance.new("TextLabel")
bgTitle.Size = UDim2.new(1, 0, 0, 24)
bgTitle.BackgroundTransparency = 1
bgTitle.Text = "Background Style"
bgTitle.TextColor3 = Color3.fromRGB(255, 220, 225)
bgTitle.Font = Enum.Font.GothamBold
bgTitle.TextSize = 10
bgTitle.TextXAlignment = Enum.TextXAlignment.Left
bgTitle.ZIndex = 12
bgTitle.Parent = miscContent

local bgButton = Instance.new("TextButton")
bgButton.Size = UDim2.new(1, 0, 0, 32)
bgButton.Position = UDim2.fromOffset(0, 25)
bgButton.BackgroundColor3 = Color3.fromRGB(55, 8, 15)
bgButton.Text = "Aura Red"
bgButton.TextColor3 = Color3.fromRGB(255, 220, 225)
bgButton.Font = Enum.Font.GothamBold
bgButton.TextSize = 10
bgButton.ZIndex = 12
bgButton.Parent = miscContent

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 7)
bgCorner.Parent = bgButton

local scaleTitle = Instance.new("TextLabel")
scaleTitle.Size = UDim2.new(1, 0, 0, 24)
scaleTitle.Position = UDim2.fromOffset(0, 64)
scaleTitle.BackgroundTransparency = 1
scaleTitle.Text = "GUI Scale"
scaleTitle.TextColor3 = Color3.fromRGB(255, 220, 225)
scaleTitle.Font = Enum.Font.GothamBold
scaleTitle.TextSize = 10
scaleTitle.TextXAlignment = Enum.TextXAlignment.Left
scaleTitle.ZIndex = 12
scaleTitle.Parent = miscContent

local scaleButton = Instance.new("TextButton")
scaleButton.Size = UDim2.new(1, 0, 0, 32)
scaleButton.Position = UDim2.fromOffset(0, 89)
scaleButton.BackgroundColor3 = Color3.fromRGB(55, 8, 15)
scaleButton.Text = "Scale: 100%"
scaleButton.TextColor3 = Color3.fromRGB(255, 220, 225)
scaleButton.Font = Enum.Font.GothamBold
scaleButton.TextSize = 10
scaleButton.ZIndex = 12
scaleButton.Parent = miscContent

local scaleCorner = Instance.new("UICorner")
scaleCorner.CornerRadius = UDim.new(0, 7)
scaleCorner.Parent = scaleButton

local scaleObject = Instance.new("UIScale")
scaleObject.Scale = 1
scaleObject.Parent = mainFrame

local function setScale(value)
    CurrentScale = value
    scaleObject.Scale = value
    scaleButton.Text = "Scale: " .. math.floor(value * 100) .. "%"
end

scaleButton.Activated:Connect(function()
    if CurrentScale == 1 then
        setScale(0.85)
    elseif CurrentScale == 0.85 then
        setScale(0.75)
    elseif CurrentScale == 0.75 then
        setScale(1.15)
    else
        setScale(1)
    end
end)

bgButton.Activated:Connect(function()
    if CurrentBackground == "Aura Red" then
        CurrentBackground = "Dark"
        mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        bgButton.Text = "Dark"
    else
        CurrentBackground = "Aura Red"
        mainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 8)
        bgButton.Text = "Aura Red"
    end
end)

--==================================================
-- TABS
--==================================================

local function showMain()
    mainContent.Visible = true
    miscContent.Visible = false
    mainTab.BackgroundColor3 = Color3.fromRGB(105, 10, 25)
    miscTab.BackgroundColor3 = Color3.fromRGB(45, 10, 15)
end

local function showMisc()
    mainContent.Visible = false
    miscContent.Visible = true
    mainTab.BackgroundColor3 = Color3.fromRGB(45, 10, 15)
    miscTab.BackgroundColor3 = Color3.fromRGB(105, 10, 25)
end

mainTab.Activated:Connect(showMain)
miscTab.Activated:Connect(showMisc)

--==================================================
-- ANTI-HIT ROUTE
--==================================================

local TeleportPoints = {
    Vector3.new(500.62, 241.28, -366.64),
    Vector3.new(504.45, 155.80, -366.35),
    Vector3.new(508.30, 70.28, -366.03),
    Vector3.new(513.86, 70.28, -366.25),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(524.32, 70.28, -366.59),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(538.01, 70.28, -365.55),
    Vector3.new(546.80, 70.28, -364.40)
}

-- ULTRA FAST
local ANTI_HIT_SPEED = 0.005

--==================================================
-- LOADING
--==================================================

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.fromOffset(220, 75)
loadingFrame.Position = UDim2.new(0.5, -110, 0.5, -38)
loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 5, 8)
loadingFrame.BorderSizePixel = 0
loadingFrame.Visible = false
loadingFrame.ZIndex = 100
loadingFrame.Parent = screenGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = loadingFrame

local loadingStroke = Instance.new("UIStroke")
loadingStroke.Color = Color3.fromRGB(125, 10, 25)
loadingStroke.Thickness = 1.5
loadingStroke.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.fromOffset(0, 7)
loadingText.BackgroundTransparency = 1
loadingText.Text = "VIREX TELEPORTING..."
loadingText.TextColor3 = Color3.fromRGB(255, 220, 225)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 11
loadingText.ZIndex = 101
loadingText.Parent = loadingFrame

local loadingBarBack = Instance.new("Frame")
loadingBarBack.Size = UDim2.new(1, -24, 0, 8)
loadingBarBack.Position = UDim2.fromOffset(12, 48)
loadingBarBack.BackgroundColor3 = Color3.fromRGB(45, 10, 15)
loadingBarBack.BorderSizePixel = 0
loadingBarBack.ZIndex = 101
loadingBarBack.Parent = loadingFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(1, 0)
loadingBarCorner.Parent = loadingBarBack

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(150, 10, 30)
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 102
loadingBar.Parent = loadingBarBack

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(1, 0)
loadingBarFillCorner.Parent = loadingBar

local function StopTeleportLoading()
    IsTeleporting = false
    loadingBar.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.Visible = false
end

local function TeleportRoute(character)

    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    IsTeleporting = true
    loadingFrame.Visible = true
    loadingBar.Size = UDim2.new(0, 0, 1, 0)

    for i, position in ipairs(TeleportPoints) do

        if not AntiHitEnabled then
            StopTeleportLoading()
            return
        end

        if not root.Parent then
            StopTeleportLoading()
            return
        end

        root.CFrame = CFrame.new(position)

        local progress = i / #TeleportPoints

        TweenService:Create(
            loadingBar,
            TweenInfo.new(
                ANTI_HIT_SPEED,
                Enum.EasingStyle.Linear
            ),
            {
                Size = UDim2.new(progress, 0, 1, 0)
            }
        ):Play()

        task.wait(ANTI_HIT_SPEED)
    end

    StopTeleportLoading()
end

antiHitBtn.Activated:Connect(function()

    AntiHitEnabled = not AntiHitEnabled

    if AntiHitEnabled then
        antiHitBtn.Text = "🛡 Anti-Hit : ON"
        antiHitBtn.BackgroundColor3 = Color3.fromRGB(105, 10, 25)
    else
        antiHitBtn.Text = "🛡 Anti-Hit : OFF"
        antiHitBtn.BackgroundColor3 = Color3.fromRGB(55, 8, 15)

        if IsTeleporting then
            StopTeleportLoading()
        end
    end

end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)

    if player ~= LocalPlayer then return end
    if not AntiHitEnabled then return end
    if IsTeleporting then return end

    local character = LocalPlayer.Character
    if not character then return end

    task.spawn(function()
        TeleportRoute(character)
    end)

end)

--==================================================
-- GLOBAL CHAT
--==================================================

local chatFrame = Instance.new("Frame")
chatFrame.Name = "VirexGlobalChat"
chatFrame.Size = UDim2.fromOffset(285, 330)
chatFrame.Position = UDim2.new(0.5, -142, 0.5, -165)
chatFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 10)
chatFrame.BackgroundTransparency = 0.03
chatFrame.BorderSizePixel = 0
chatFrame.Visible = false
chatFrame.Active = true
chatFrame.Draggable = true
chatFrame.ZIndex = 2000
chatFrame.Parent = screenGui

local chatCorner = Instance.new("UICorner")
chatCorner.CornerRadius = UDim.new(0, 10)
chatCorner.Parent = chatFrame

local chatStroke = Instance.new("UIStroke")
chatStroke.Color = Color3.fromRGB(125, 10, 25)
chatStroke.Thickness = 1.5
chatStroke.Parent = chatFrame

local chatHeader = Instance.new("Frame")
chatHeader.Size = UDim2.new(1, 0, 0, 38)
chatHeader.BackgroundColor3 = Color3.fromRGB(30, 7, 12)
chatHeader.BorderSizePixel = 0
chatHeader.ZIndex = 2001
chatHeader.Parent = chatFrame

local chatHeaderCorner = Instance.new("UICorner")
chatHeaderCorner.CornerRadius = UDim.new(0, 10)
chatHeaderCorner.Parent = chatHeader

local chatTitle = Instance.new("TextLabel")
chatTitle.Size = UDim2.new(1, -48, 1, 0)
chatTitle.Position = UDim2.fromOffset(10, 0)
chatTitle.BackgroundTransparency = 1
chatTitle.Text = "🌐 VIREX GLOBAL"
chatTitle.TextColor3 = Color3.fromRGB(255, 220, 225)
chatTitle.Font = Enum.Font.GothamBold
chatTitle.TextSize = 13
chatTitle.TextXAlignment = Enum.TextXAlignment.Left
chatTitle.ZIndex = 2002
chatTitle.Parent = chatHeader

local chatClose = Instance.new("TextButton")
chatClose.Size = UDim2.fromOffset(24, 24)
chatClose.Position = UDim2.new(1, -31, 0, 7)
chatClose.BackgroundColor3 = Color3.fromRGB(100, 10, 20)
chatClose.Text = "×"
chatClose.TextColor3 = Color3.new(1, 1, 1)
chatClose.Font = Enum.Font.GothamBold
chatClose.TextSize = 17
chatClose.ZIndex = 2003
chatClose.Parent = chatHeader

local chatCloseCorner = Instance.new("UICorner")
chatCloseCorner.CornerRadius = UDim.new(0, 7)
chatCloseCorner.Parent = chatClose

local messageScroller = Instance.new("ScrollingFrame")
messageScroller.Size = UDim2.new(1, -12, 1, -91)
messageScroller.Position = UDim2.fromOffset(6, 44)
messageScroller.BackgroundColor3 = Color3.fromRGB(8, 5, 7)
messageScroller.BackgroundTransparency = 0.2
messageScroller.BorderSizePixel = 0
messageScroller.ScrollBarThickness = 2
messageScroller.CanvasSize = UDim2.fromOffset(0, 0)
messageScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
messageScroller.ZIndex = 2001
messageScroller.Parent = chatFrame

local messageCorner = Instance.new("UICorner")
messageCorner.CornerRadius = UDim.new(0, 7)
messageCorner.Parent = messageScroller

local messageLayout = Instance.new("UIListLayout")
messageLayout.Padding = UDim.new(0, 4)
messageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
messageLayout.SortOrder = Enum.SortOrder.LayoutOrder
messageLayout.Parent = messageScroller

local messagePadding = Instance.new("UIPadding")
messagePadding.PaddingTop = UDim.new(0, 5)
messagePadding.PaddingBottom = UDim.new(0, 5)
messagePadding.PaddingLeft = UDim.new(0, 5)
messagePadding.PaddingRight = UDim.new(0, 5)
messagePadding.Parent = messageScroller

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(1, -70, 0, 32)
messageBox.Position = UDim2.new(0, 6, 1, -38)
messageBox.BackgroundColor3 = Color3.fromRGB(35, 8, 13)
messageBox.TextColor3 = Color3.fromRGB(255, 230, 235)
messageBox.PlaceholderColor3 = Color3.fromRGB(170, 120, 125)
messageBox.PlaceholderText = "Message..."
messageBox.Text = ""
messageBox.ClearTextOnFocus = false
messageBox.Font = Enum.Font.Gotham
messageBox.TextSize = 11
messageBox.TextXAlignment = Enum.TextXAlignment.Left
messageBox.ZIndex = 2002
messageBox.Parent = chatFrame

local messageCorner2 = Instance.new("UICorner")
messageCorner2.CornerRadius = UDim.new(0, 7)
messageCorner2.Parent = messageBox

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.fromOffset(57, 32)
sendButton.Position = UDim2.new(1, -63, 1, -38)
sendButton.BackgroundColor3 = Color3.fromRGB(105, 10, 25)
sendButton.Text = "SEND"
sendButton.TextColor3 = Color3.new(1, 1, 1)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 9
sendButton.ZIndex = 2003
sendButton.Parent = chatFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 7)
sendCorner.Parent = sendButton

local function addGlobalMessage(username, message)

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 0)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.BackgroundColor3 = Color3.fromRGB(30, 8, 13)
    holder.BackgroundTransparency = 0.15
    holder.BorderSizePixel = 0
    holder.ZIndex = 2002
    holder.Parent = messageScroller

    local holderCorner = Instance.new("UICorner")
    holderCorner.CornerRadius = UDim.new(0, 5)
    holderCorner.Parent = holder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 0, 0)
    text.Position = UDim2.fromOffset(5, 4)
    text.AutomaticSize = Enum.AutomaticSize.Y
    text.BackgroundTransparency = 1
    text.TextWrapped = true
    text.Text = tostring(username) .. ": " .. tostring(message)
    text.TextColor3 = Color3.fromRGB(245, 220, 225)
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Top
    text.ZIndex = 2003
    text.Parent = holder

    task.defer(function()
        messageScroller.CanvasPosition = Vector2.new(
            0,
            math.max(0, messageScroller.AbsoluteCanvasSize.Y)
        )
    end)

end

local function updateGlobalButton()

    if UnreadMessages > 0 then
        globalBtn.Text =
            "🌐 Virex Global [" .. UnreadMessages .. "]"
    else
        globalBtn.Text = "🌐 Virex Global"
    end

end

local function openGlobalChat()

    GlobalChatOpen = true
    UnreadMessages = 0
    updateGlobalButton()
    chatFrame.Visible = true

end

local function closeGlobalChat()

    GlobalChatOpen = false
    chatFrame.Visible = false

end

globalBtn.Activated:Connect(openGlobalChat)
chatClose.Activated:Connect(closeGlobalChat)

local function sendGlobalMessage()

    local message = messageBox.Text

    message = message:gsub("[%c]", "")
    message = message:gsub("^%s+", "")
    message = message:gsub("%s+$", "")

    if message == "" then return end

    message = message:sub(1, 180)

    addGlobalMessage(
        LocalPlayer.DisplayName,
        message
    )

    messageBox.Text = ""

    if GlobalChatRemote then
        GlobalChatRemote:FireServer(
            "SEND",
            message
        )
    end

end

sendButton.Activated:Connect(sendGlobalMessage)

messageBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendGlobalMessage()
    end
end)

local function connectGlobalRemote(remote)

    if not remote then return end
    if GlobalChatRemote == remote then return end

    GlobalChatRemote = remote

    remote.OnClientEvent:Connect(function(
        action,
        username,
        message
    )

        if action ~= "MESSAGE" then return end
        if typeof(message) ~= "string" then return end

        addGlobalMessage(
            username,
            message
        )

        if not GlobalChatOpen then
            UnreadMessages += 1
            updateGlobalButton()
        end

    end)

end

local existingRemote =
    ReplicatedStorage:FindFirstChild("VirexGlobalChat")

if existingRemote then
    connectGlobalRemote(existingRemote)
end

ReplicatedStorage.ChildAdded:Connect(function(child)

    if child.Name == "VirexGlobalChat"
       and child:IsA("RemoteEvent") then

        connectGlobalRemote(child)

    end

end)

--==================================================
-- CLOSE GUI
--==================================================

closeButton.Activated:Connect(function()
    screenGui.Enabled = false
end)

--==================================================
-- INITIALIZE
--==================================================

showMain()
updateAntiHit()
updateGlobalButton()

print("[VIREX] Hub loaded.")



