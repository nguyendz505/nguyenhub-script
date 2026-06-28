-- Lethal Ape Universal ESP (PC & Mobile)
local ESP = { Enabled = true, Highlights = {} }
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Colors = {
    Vang = Color3.fromRGB(255, 215, 0),
    Dong = Color3.fromRGB(184, 115, 51),
    KimCuong = Color3.fromRGB(0, 255, 255),
    LucBao = Color3.fromRGB(0, 255, 0),
    Monster = Color3.fromRGB(255, 50, 50)
}

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

task.spawn(function()
    while true do
        if ESP.Enabled then
            for obj in pairs(ESP.Highlights) do
                if not isValid(obj) then cleanHighlight(obj) end
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                        createHighlight(obj, Colors.Monster, nil)
                    elseif (obj:IsA("BasePart") or obj:IsA("MeshPart")) and isValid(obj) then
                        local n = obj.Name:lower()
                        local color, name = nil, nil
                        if n:find("gold") or n:find("vang") then color, name = Colors.Vang, "VÀNG"
                        elseif n:find("copper") or n:find("dong") then color, name = Colors.Dong, "ĐỒNG"
                        elseif n:find("diamond") or n:find("kim") then color, name = Colors.KimCuong, "KIM CƯƠNG"
                        elseif n:find("emerald") or n:find("luc") then color, name = Colors.LucBao, "LỤC BẢO" end
                        if color then createHighlight(obj, color, name) end
                    end
                end
            end
        else
            for obj in pairs(ESP.Highlights) do cleanHighlight(obj) end
        end
        task.wait(2)
    end
end)
