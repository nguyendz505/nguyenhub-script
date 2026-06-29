-- NguyenHub Final - ESP + Log System
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ESP = { Enabled = true, Highlights = {} }

-- --- UI CONSOLE XANH LÁ ---
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Visible = false

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "NGUYENHUB - SYSTEM"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundTransparency = 1

local LogBox = Instance.new("ScrollingFrame", Frame)
LogBox.Size = UDim2.new(0.9, 0, 0.8, 0)
LogBox.Position = UDim2.new(0.05, 0, 0.1, 0)
LogBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LogBox.ScrollBarThickness = 5

local function addLog(text)
    local msg = Instance.new("TextLabel", LogBox)
    msg.Size = UDim2.new(1, 0, 0, 20)
    msg.Text = "[LOG]: " .. text
    msg.TextColor3 = Color3.fromRGB(0, 255, 0)
    msg.BackgroundTransparency = 1
    msg.TextXAlignment = Enum.TextXAlignment.Left
    LogBox.CanvasPosition = Vector2.new(0, LogBox.AbsoluteCanvasSize.Y)
end

-- --- ESP LOGIC (KHÔNG ĐỔI) ---
local Colors = { Vang = Color3.fromRGB(255, 215, 0), Dong = Color3.fromRGB(184, 115, 51), KimCuong = Color3.fromRGB(0, 255, 255), LucBao = Color3.fromRGB(0, 255, 0), Monster = Color3.fromRGB(255, 50, 50) }

local function isValid(obj)
    if not obj or not obj:IsDescendantOf(Workspace) then return false end
    if obj:IsA("Model") and Players:FindFirstChild(obj.Name) then return false end
    if obj:IsA("BasePart") and obj.Transparency >= 1 then return false end
    return true
end

local function cleanHighlight(obj)
    if ESP.Highlights[obj] then
        if ESP.Highlights[obj].H then ESP.Highlights[obj].H:Destroy() end
        if ESP.Highlights[obj].B then ESP.Highlights[obj].B:Destroy() end
        ESP.Highlights[obj] = nil
    end
end

local function createHighlight(obj, color, name)
    local h = Instance.new("Highlight", obj)
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    local b = nil
    if name then
        b = Instance.new("BillboardGui", obj)
        b.Size = UDim2.new(0, 100, 0, 50)
        b.StudsOffset = Vector3.new(0, 2, 0)
        b.AlwaysOnTop = true
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1,0,1,0)
        t.Text = name
        t.TextColor3 = color
        t.BackgroundTransparency = 1
        t.TextStrokeTransparency = 0
    end
    ESP.Highlights[obj] = {H = h, B = b}
end

-- --- THEO DÕI DIE ---
local function monitorPlayer(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            addLog(player.Name .. " đã bị hạ gục!")
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do monitorPlayer(p) end
Players.PlayerAdded:Connect(monitorPlayer)

-- --- LỆNH CHAT ---
LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/console" then Frame.Visible = not Frame.Visible end
end)

-- --- MAIN LOOP ---
task.spawn(function()
    while true do
        if ESP.Enabled then
            for obj in pairs(ESP.Highlights) do if not isValid(obj) then cleanHighlight(obj) end end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                        createHighlight(obj, Colors.Monster, nil)
                    elseif (obj:IsA("BasePart") or obj:IsA("MeshPart")) and isValid(obj) then
                        local n = obj.Name:lower()
                        local c, nm = nil, nil
                        if n:find("gold") or n:find("vang") then c, nm = Colors.Vang, "VÀNG"
                        elseif n:find("copper") or n:find("dong") then c, nm = Colors.Dong, "ĐỒNG"
                        elseif n:find("diamond") or n:find("kim") then c, nm = Colors.KimCuong, "KIM CƯƠNG"
                        elseif n:find("emerald") or n:find("luc") then c, nm = Colors.LucBao, "LỤC BẢO" end
                        if c then createHighlight(obj, c, nm) end
                    end
                end
            end
        end
        task.wait(2)
    end
end)
