-- Lethal Ape ESP - Chữ Nhỏ + Fix Hiện Chữ
local ESP = {
    Enabled = true,
    Highlights = {}
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Colors = {
    Vang      = Color3.fromRGB(255, 215, 0),
    Dong      = Color3.fromRGB(184, 115, 51),
    KimCuong  = Color3.fromRGB(0, 255, 255),
    LucBao    = Color3.fromRGB(0, 255, 0),
    Monster   = Color3.fromRGB(255, 50, 50)
}

local function cleanHighlight(obj)
    local data = ESP.Highlights[obj]
    if data then
        if data.H then data.H:Destroy() end
        if data.B then data.B:Destroy() end
        ESP.Highlights[obj] = nil
    end
end

local function createHighlight(obj, color, name)
    if ESP.Highlights[obj] then return end

    -- Highlight
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.35
    h.OutlineTransparency = 0
    h.Parent = obj

    -- Chữ nhỏ
    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 90, 0, 35)
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.AlwaysOnTop = true
    b.Parent = obj

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = name
    t.TextColor3 = color
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3 = Color3.new(0,0,0)
    t.Font = Enum.Font.GothamBold
    t.TextScaled = true
    t.TextSize = 16
    t.Parent = b

    ESP.Highlights[obj] = {H = h, B = b}

    obj.Destroying:Connect(function()
        cleanHighlight(obj)
    end)
end

-- Main Loop (tăng tốc độ quét)
task.spawn(function()
    while true do
        if ESP.Enabled then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
                    
                    -- Monster
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                        createHighlight(obj, Colors.Monster, "MONSTER")
                    
                    -- Items
                    elseif (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Model")) then
                        local n = obj.Name:lower()
                        local color, name = nil, nil
                        
                        if n:find("vang") or n:find("gold") then 
                            color, name = Colors.Vang, "VÀNG"
                        elseif n:find("dong") or n:find("copper") then 
                            color, name = Colors.Dong, "ĐỒNG"
                        elseif n:find("kim") or n:find("diamond") then 
                            color, name = Colors.KimCuong, "KIM CƯƠNG"
                        elseif n:find("luc") or n:find("emerald") then 
                            color, name = Colors.LucBao, "LỤC BẢO"
                        end
                        
                        if color and name then
                            createHighlight(obj, color, name)
                        end
                    end
                end
            end
        else
            for obj in pairs(ESP.Highlights) do cleanHighlight(obj) end
        end
        task.wait(0.7)
    end
end)

print("✅ ESP Loaded - Chữ Nhỏ Đã Bật")
