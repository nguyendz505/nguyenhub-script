-- Lethal Ape Universal ESP - Fixed Instant Remove
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

local function isValid(obj)
    if not obj or not obj:IsDescendantOf(Workspace) then return false end
    if obj:IsA("Model") and Players:FindFirstChild(obj.Name) then return false end
    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Transparency >= 0.95 then return false end
    return true
end

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

    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0
    h.Parent = obj

    local b = nil
    if name then
        b = Instance.new("BillboardGui")
        b.Size = UDim2.new(0, 130, 0, 60)
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
        t.Parent = b
    end

    ESP.Highlights[obj] = {H = h, B = b}

    -- 🔥 Fix chính: Xóa highlight ngay khi object bị destroy
    local conn
    conn = obj.Destroying:Connect(function()
        cleanHighlight(obj)
        conn:Disconnect()
    end)
end

-- Main Loop (chỉ quét định kỳ để tìm item mới)
task.spawn(function()
    while true do
        if ESP.Enabled then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                        createHighlight(obj, Colors.Monster, "MONSTER")
                        
                    elseif (obj:IsA("BasePart") or obj:IsA("MeshPart")) then
                        local n = obj.Name:lower()
                        local color, name = nil, nil
                        
                        if n:find("gold") or n:find("vang") then 
                            color, name = Colors.Vang, "VÀNG"
                        elseif n:find("copper") or n:find("dong") then 
                            color, name = Colors.Dong, "ĐỒNG"
                        elseif n:find("diamond") or n:find("kim") then 
                            color, name = Colors.KimCuong, "KIM CƯƠNG"
                        elseif n:find("emerald") or n:find("luc") then 
                            color, name = Colors.LucBao, "LỤC BẢO"
                        end
                        
                        if color then
                            createHighlight(obj, color, name)
                        end
                    end
                end
            end
        else
            for obj in pairs(ESP.Highlights) do
                cleanHighlight(obj)
            end
        end
        task.wait(1.2) -- Có thể giảm xuống 0.8 nếu muốn quét nhanh hơn
    end
end)

print("✅ Lethal Ape ESP Loaded - Instant Remove Fixed")
