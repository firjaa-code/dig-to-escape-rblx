--// ==============================
--// SIMPLE MOBILE UI - FLY, NOCLIP, TP
--// ==============================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Hapus UI lama kalau ada (biar bisa di-run ulang)
if player.PlayerGui:FindFirstChild("MobileUI") then
    player.PlayerGui.MobileUI:Destroy()
end

--// ================= SCREEN GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--// ================= MAIN FRAME =================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 190, 0, 220)
Main.Position = UDim2.new(1, -200, 0, 10) -- pojok kanan atas (default)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = false -- kita bikin drag manual biar smooth di mobile
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

--// ================= TITLE BAR (buat drag) =================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Nutup sudut bawah title bar biar rata sama Main
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Script Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

--// Tombol Minimize (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -60, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

--// Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// ================= CONTAINER ISI (biar bisa disembunyikan saat minimize) =================
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1
Container.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Container.Visible = not minimized
    if minimized then
        Main.Size = UDim2.new(0, 190, 0, 35)
    else
        Main.Size = UDim2.new(0, 190, 0, 220)
    end
end)

--// ================= FUNGSI BIKIN BUTTON/LABEL =================
local function buatLabel(teks)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Text = teks
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Container
    return lbl
end

local function buatButton(teks, warna)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = warna or Color3.fromRGB(50, 50, 60)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = teks
    btn.Parent = Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

--// ================= 1. FLY SPEED (INPUT) =================
buatLabel("Fly Speed:")

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, 0, 0, 28)
SpeedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedBox.Text = "3"
SpeedBox.PlaceholderText = "Masukkan speed..."
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 13
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Container
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

local flySpeed = 3
SpeedBox.FocusLost:Connect(function()
    local n = tonumber(SpeedBox.Text)
    if n then
        flySpeed = n
    else
        SpeedBox.Text = tostring(flySpeed)
    end
end)

local FlyBtn = buatButton("Fly: OFF", Color3.fromRGB(50, 50, 60))

--// ================= 2. NOCLIP =================
local NoclipBtn = buatButton("Noclip: OFF", Color3.fromRGB(50, 50, 60))

--// ================= 3 & 4. TOMBOL TELEPORT =================
local TpMineshaftBtn = buatButton("TP Mineshaft", Color3.fromRGB(40, 90, 150))
local TpEscapeBtn = buatButton("TP Escape", Color3.fromRGB(40, 90, 150))

--// ==================================================
--// LOGIKA FLY
--// ==================================================
local flying = false
local flyConn
local bodyVel

local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local moveVector = humanoid.MoveDirection
            if moveVector.Magnitude > 0 then
                moveDir = (camera.CFrame.LookVector * Vector3.new(1,0,1)).Unit * moveVector.Z * -1
                    + camera.CFrame.RightVector * moveVector.X
            end
        end
        bodyVel.Velocity = moveDir * flySpeed * 16
    end)
end

local function stopFly()
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
end

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyBtn.Text = "Fly: ON"
        startFly()
    else
        FlyBtn.Text = "Fly: OFF"
        stopFly()
    end
end)

--// ==================================================
--// LOGIKA NOCLIP
--// ==================================================
local noclip = false
local noclipConn

NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        NoclipBtn.Text = "Noclip: ON"
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipBtn.Text = "Noclip: OFF"
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end)

--// ==================================================
--// LOGIKA TELEPORT
--// ==================================================
local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

TpMineshaftBtn.MouseButton1Click:Connect(function()
    teleportTo(Vector3.new(-29, -974, 54))
end)

TpEscapeBtn.MouseButton1Click:Connect(function()
    teleportTo(Vector3.new(-30, -917, 2795))
end)

--// ==================================================
--// DRAG UI (SUPPORT MOBILE TOUCH)
--// ==================================================
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
