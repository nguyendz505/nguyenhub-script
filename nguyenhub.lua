-- Lethal Ape ESP - Only Highlight + Remove Game Text
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
    if data and data.H then
        data.H:Destroy()
        ESP.Highlights[obj] = nil
    end
end

local function createHighlight(obj, color)
    if ESP.Highlights[obj] then return end

    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.4
    h.OutlineTransparency = 0
    h.Parent = obj

    ESP.Highlights[obj] = {H = h}

    -- Xóa highlight khi item mất
    obj.Destroying:Connect(function()
        cleanHighlight(obj)
    end)
end

-- 🔥 Tự động xóa chữ của game (VÀNG, ĐỒNG, MONSTER...)
local function removeGameText(obj)
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
            if v:FindFirstChild("TextLabel") or v.Name:find("Name") or v.Name:find("Label") then
                v:Destroy()
            end
        end
    end
end

-- Main Loop
task.spawn(function()
    while true do
        if ESP.Enabled then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
                    
                    -- Xóa chữ game trước
                    removeGameText(obj)
                    
                    -- Tạo Highlight
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
                        createHighlight(obj, Colors.Monster)
                        
                    elseif (obj:IsA("BasePart") or obj:IsA("MeshPart")) then
                        local n = obj.Name:lower()
                        local color = nil
                        
                        if n:find("gold") or n:find("vang") then color = Colors.Vang
                        elseif n:find("copper") or n:find("dong") then color = Colors.Dong
                        elseif n:find("diamond") or n:find("kim") then color = Colors.KimCuong
                        elseif n:find("emerald") or n:find("luc") then color = Colors.LucBao
                        end
                        
                        if color then
                            createHighlight(obj, color)
                        end
                    end
                end
            end
        else
            for obj in pairs(ESP.Highlights) do
                cleanHighlight(obj)
            end
        end
        task.wait(1)
    end
end)

print("✅ ESP Loaded - Only Highlight + Game Text Removed")
