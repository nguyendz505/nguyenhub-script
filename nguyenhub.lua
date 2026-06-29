-- Lethal Ape ESP - Fix Highlight Biến Mất Ngay Khi Nhặt
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
        ESP.Highlights[obj] = nil
    end
end

local function createHighlight(obj, color)
    if ESP.Highlights[obj] then return end

    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.35
    h.OutlineTransparency = 0
    h.Parent = obj

    ESP.Highlights[obj] = {H = h}

    -- 🔥 Fix chính: Xóa highlight NGAY KHI item bị nhặt/destroy
    local connection
    connection = obj.Destroying:Connect(function()
        cleanHighlight(obj)
        if connection then connection:Disconnect() end
    end)
    
    -- Backup nếu Destroying không trigger (một số item bị remove khác)
    local ancestryConn
    ancestryConn = obj.AncestryChanged:Connect(function()
        if not obj:IsDescendantOf(Workspace) then
            cleanHighlight(obj)
            if ancestryConn then ancestryConn:Disconnect() end
        end
    end)
end

-- Main Loop
task.spawn(function()
    while true do
        if ESP.Enabled then
            -- Clean invalid highlights
            for obj in pairs(ESP.Highlights) do
                if not obj or not obj.Parent or not isValid(obj) then
                    cleanHighlight(obj)
                end
            end

            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not ESP.Highlights[obj] then
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
        task.wait(0.8)
    end
end)

local function isValid(obj)
    return obj and obj.Parent and obj:IsDescendantOf(Workspace)
end

print("✅ ESP Loaded - Fix Highlight Biến Mất Ngay Khi Nhặt")
