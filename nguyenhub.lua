-- NguyenHub Hacker Terminal - Style
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ESP = { Enabled = true, Highlights = {} }

-- --- UI TERMINAL HACKER ---
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 450)
Frame.Position = UDim2.new(0.5, -175, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Nền đen huyền bí
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Viền xanh lá neon
Frame.BorderSizePixel = 3
Frame.Visible = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "> NGUYENHUB_TERMINAL_V1.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code -- Font kiểu terminal
Title.BackgroundTransparency = 1

local LogBox = Instance.new("ScrollingFrame", Frame)
LogBox.Size = UDim2.new(0.95, 0, 0.85, 0)
LogBox.Position = UDim2.new(0.02, 0, 0.1, 0)
LogBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LogBox.ScrollBarThickness = 2
LogBox.BorderSizePixel = 0

local function addLog(text)
    local msg = Instance.new("TextLabel", LogBox)
    msg.Size = UDim2.new(1, 0, 0, 25)
    msg.Text = "> " .. text
    msg.TextColor3 = Color3.fromRGB(0, 255, 0)
    msg.Font = Enum.Font.Code
    msg.TextSize = 14
    msg.BackgroundTransparency = 1
    msg.TextXAlignment = Enum.TextXAlignment.Left
    LogBox.CanvasPosition = Vector2.new(0, LogBox.AbsoluteCanvasSize.Y)
end

addLog("INITIALIZING SYSTEM...")
addLog("CONNECTED TO SERVER: SUCCESS")
addLog("WAITING FOR COMMANDS...")

-- --- LỆNH CHAT /panel ---
LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/panel" then
        Frame.Visible = not Frame.Visible
    end
end)

-- --- ESP & LOGIC (GIỮ NGUYÊN) ---
local function monitorPlayer(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            addLog("TARGET_DOWN: " .. player.Name)
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do monitorPlayer(p) end
Players.PlayerAdded:Connect(monitorPlayer)

task.spawn(function()
    while true do
        if ESP.Enabled then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                    if not ESP.Highlights[obj] then
                        local h = Instance.new("Highlight", obj)
                        h.FillColor = Color3.fromRGB(0, 255, 0)
                        ESP.Highlights[obj] = h
                    end
                end
            end
        end
        task.wait(3)
    end
end)
