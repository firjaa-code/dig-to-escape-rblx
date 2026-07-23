--// ==========================================================
--// SCRIPT MULTI PLACE - AUTO DETECT PLACEID
--// Lobby   : Auto Join Queue + Hard + 1 Player + Create (TANPA UI)
--// Prison  : UI Lengkap (Fly, Noclip, Fullbright, TP)
--// ==========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

local LOBBY_ID = 92122513197996
local PRISON_ID = 73510530738011

--// ==========================================================
--// BAGIAN 1: LOBBY - UI MINIMAL (TOMBOL JOIN QUEUE + STATUS)
--// ==========================================================
local function runQueueSequence(setStatus)
    local EventsFolder = ReplicatedStorage:WaitForChild("Events", 15)
    if not EventsFolder then
        setStatus("Gagal: folder Events tidak ada", Color3.fromRGB(200, 70, 70))
        return
    end

    local GameEvent = EventsFolder:WaitForChild("GameEvent", 10)
    local GameFunction = EventsFolder:WaitForChild("GameFunction", 10)

    setStatus("Fire JoinQueue...", Color3.fromRGB(230, 200, 80))

    -- Trigger UI join queue (butuh fungsi firesignal dari executor)
    if GameEvent then
        local ok, err = pcall(function()
            if typeof(firesignal) == "function" then
                firesignal(GameEvent.OnClientEvent, "JoinQueue", true)
            else
                error("Executor tidak mendukung 'firesignal'")
            end
        end)
        if not ok then
            warn("[AutoQueue] Gagal fire JoinQueue:", err)
            setStatus("Firesignal gagal, lanjut CreateQueue...", Color3.fromRGB(230, 150, 60))
        end
    end

    task.wait(1.5)

    setStatus("Membuat queue Hard/1P...", Color3.fromRGB(230, 200, 80))

    -- Buat queue: Hard, 1 Player
    if GameFunction then
        local ok2, result = pcall(function()
            return table.pack(GameFunction:InvokeServer("CreateQueue", 1, "Hard"))
        end)
        if ok2 then
            print("[AutoQueue] CreateQueue berhasil dipanggil, hasil:", unpack(result))
            if result[1] == true then
                setStatus("Berhasil! Queue Hard/1P dibuat.", Color3.fromRGB(80, 200, 100))
            else
                setStatus("Selesai, cek hasil di console.", Color3.fromRGB(80, 180, 220))
            end
        else
            warn("[AutoQueue] Gagal invoke CreateQueue:", result)
            setStatus("Gagal: " .. tostring(result), Color3.fromRGB(200, 70, 70))
        end
    else
        setStatus("Gagal: GameFunction tidak ada", Color3.fromRGB(200, 70, 70))
    end
end

local function loadLobbyUI()
    if player.PlayerGui:FindFirstChild("LobbyUI") then
        player.PlayerGui.LobbyUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LobbyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 180, 0, 90)
    Main.Position = UDim2.new(1, -190, 0, 10) -- pojok kanan atas (default)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 26)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 10)
    TitleFix.Position = UDim2.new(0, 0, 1, -10)
    TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleFix.BorderSizePixel = 0
    TitleFix.ZIndex = 0
    TitleFix.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Lobby Menu"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -26, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Size = UDim2.new(1, -20, 0, 32)
    JoinBtn.Position = UDim2.new(0, 10, 0, 34)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 150)
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.TextSize = 13
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.Text = "Join Queue (Hard/1P)"
    JoinBtn.Parent = Main
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 18)
    StatusLabel.Position = UDim2.new(0, 10, 0, 68)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 11
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.Text = "Status: menunggu..."
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Main

    local function setStatus(text, color)
        StatusLabel.Text = "Status: " .. text
        StatusLabel.TextColor3 = color or Color3.fromRGB(180, 180, 180)
    end

    local running = false
    JoinBtn.MouseButton1Click:Connect(function()
        if running then return end
        running = true
        JoinBtn.Text = "Sedang proses..."
        JoinBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 100)

        task.spawn(function()
            local ok, err = pcall(function()
                runQueueSequence(setStatus)
            end)
            if not ok then
                setStatus("Error: " .. tostring(err), Color3.fromRGB(200, 70, 70))
            end
            JoinBtn.Text = "Join Queue (Hard/1P)"
            JoinBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 150)
            running = false
        end)
    end)

    --// Drag UI (support touch mobile)
    local dragging = false
    local dragInput, dragStart, startPos

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
end

--// ==========================================================
--// BAGIAN 2: PRISON - UI LENGKAP
--// ==========================================================
local function loadPrisonUI()

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
    Main.Size = UDim2.new(0, 200, 0, 270)
    Main.Position = UDim2.new(1, -210, 0, 10) -- pojok kanan atas (default)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    --// ================= TITLE BAR =================
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

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

    --// ================= CONTAINER =================
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
        Main.Size = minimized and UDim2.new(0, 200, 0, 35) or UDim2.new(0, 200, 0, 270)
    end)

    --// ================= HELPER =================
    local function buatButton(parentFrame, teks, warna, sizeX)
        local btn = Instance.new("TextButton")
        btn.Size = sizeX and UDim2.new(sizeX, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = warna or Color3.fromRGB(50, 50, 60)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = teks
        btn.Parent = parentFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end

    --// ================= 1. FLY + SPEED (SATU BARIS) =================
    local FlyRow = Instance.new("Frame")
    FlyRow.Size = UDim2.new(1, 0, 0, 32)
    FlyRow.BackgroundTransparency = 1
    FlyRow.Parent = Container

    local FlyBtn = buatButton(FlyRow, "Fly: OFF", Color3.fromRGB(50, 50, 60), 0.65)

    local SpeedBox = Instance.new("TextBox")
    SpeedBox.Size = UDim2.new(0.32, 0, 1, 0)
    SpeedBox.Position = UDim2.new(0.68, 0, 0, 0)
    SpeedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SpeedBox.Text = "3"
    SpeedBox.PlaceholderText = "Spd"
    SpeedBox.Font = Enum.Font.Gotham
    SpeedBox.TextSize = 13
    SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox.ClearTextOnFocus = false
    SpeedBox.Parent = FlyRow
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

    --// ================= 2. NOCLIP =================
    local NoclipBtn = buatButton(Container, "Noclip: OFF", Color3.fromRGB(50, 50, 60))
    NoclipBtn.Size = UDim2.new(1, 0, 0, 32)

    --// ================= 3. FULLBRIGHT =================
    local FullbrightBtn = buatButton(Container, "Fullbright: OFF", Color3.fromRGB(50, 50, 60))
    FullbrightBtn.Size = UDim2.new(1, 0, 0, 32)

    --// ================= 4 & 5. TELEPORT =================
    local TpMineshaftBtn = buatButton(Container, "TP Mineshaft", Color3.fromRGB(40, 90, 150))
    TpMineshaftBtn.Size = UDim2.new(1, 0, 0, 32)

    local TpEscapeBtn = buatButton(Container, "TP Escape", Color3.fromRGB(40, 90, 150))
    TpEscapeBtn.Size = UDim2.new(1, 0, 0, 32)

    --// ==========================================================
    --// LOGIKA FLY (ALA INFINITE YIELD)
    --// ==========================================================
    local flying = false
    local flyConn
    local bg, bv

    local function startFly()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        bg.Parent = hrp

        bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        flyConn = RunService.Heartbeat:Connect(function()
            if not char.Parent or not hum.Parent then return end
            hum:ChangeState(Enum.HumanoidStateType.Physics)

            local camera = workspace.CurrentCamera
            bg.cframe = camera.CFrame

            -- MoveDirection SUDAH dalam world-space (dari WASD atau joystick mobile),
            -- jadi tidak perlu dikali ulang dengan vector kamera (itu penyebab kebalik).
            local moveVector = hum.MoveDirection
            if moveVector.Magnitude > 0 then
                bv.velocity = moveVector.Unit * flySpeed * 16
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    local function stopFly()
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
        if bg then bg:Destroy(); bg = nil end
        if bv then bv:Destroy(); bv = nil end

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
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

    -- Restart fly otomatis kalau karakter respawn saat fly masih aktif
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if flying then
            startFly()
        end
    end)

    --// ==========================================================
    --// LOGIKA NOCLIP
    --// ==========================================================
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

    --// ==========================================================
    --// LOGIKA FULLBRIGHT
    --// ==========================================================
    local fullbright = false
    local originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
    }

    FullbrightBtn.MouseButton1Click:Connect(function()
        fullbright = not fullbright
        if fullbright then
            FullbrightBtn.Text = "Fullbright: ON"
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        else
            FullbrightBtn.Text = "Fullbright: OFF"
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.Ambient = originalLighting.Ambient
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            Lighting.GlobalShadows = originalLighting.GlobalShadows
            Lighting.FogEnd = originalLighting.FogEnd
        end
    end)

    --// ==========================================================
    --// LOGIKA TELEPORT
    --// ==========================================================
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

    --// ==========================================================
    --// DRAG UI (SUPPORT TOUCH MOBILE)
    --// ==========================================================
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
end

--// ==========================================================
--// BAGIAN 3: DETEKSI PLACEID & JALANKAN FUNGSI YANG SESUAI
--// ==========================================================
local currentPlaceId = game.PlaceId

if currentPlaceId == LOBBY_ID then
    print("[Script] Terdeteksi di Lobby - memuat UI Join Queue")
    loadLobbyUI()
elseif currentPlaceId == PRISON_ID then
    print("[Script] Terdeteksi di The Prison - memuat UI")
    loadPrisonUI()
else
    print("[Script] PlaceId (" .. tostring(currentPlaceId) .. ") tidak dikenali, script tidak dijalankan.")
end
