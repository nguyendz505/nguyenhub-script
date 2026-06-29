-- Lethal Ape ESP - Only Highlight + XÓA HẾT CHỮ GAME
local ESP = {
    Enabled = true,
    Highlights = {}
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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
    h.FillTransparency = 0.35
    h.OutlineTransparency = 0.1
    h.Parent = obj

    ESP.Highlights[obj] = {H = h}

    obj.Destroying:Connect(function()
        cleanHighlight(obj)
    end)
end

-- 🔥 XÓA CHỮ GAME MẠNH HƠN
local function removeAllGameText()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            local text = obj:FindFirstChildWhichIsA("TextLabel")
            if text and (text.Text:find("VÀNG") or text.Text:find("ĐỒNG") or text.Text:find("KIM") or text.Text:find("LỤC") or text.Text:find("MONSTER")) then
                obj:Destroy()
            end
        end
    end
end

-- Main ESP
task.spawn(function()
    while true do
        if ESP.Enabled then
            removeAllGameText()   -- Xóa chữ liên tục

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
        end
        task.wait(0.8)
    end
end)

-- Xóa chữ mỗi frame (rất mạnh)
RunService.Heartbeat:Connect(removeAllGameText)

print("✅ ESP Loaded - ĐÃ XÓA HẾT CHỮ GAME")
