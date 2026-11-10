-- line keyless build | 2 games | generated 2026-11-10 18:22 UTC
-- no key, no handshake. modules come from github

local CATALOG = {
    { id = "99-nights-in-the-forest", name = "99 Nights in the Forest", placeId = 79546208627805, url = "https://raw.githubusercontent.com/loloubrawl-gif/line-drops/main/j/457179814b/modules/naiko-99-nights.lua" },
    { id = "backrooms-company", name = "Backrooms Company", placeId = 109423220190564, url = "https://raw.githubusercontent.com/loloubrawl-gif/line-drops/main/j/457179814b/modules/naiko-backrooms-company.lua" },
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

for _, old in ipairs(pg:GetChildren()) do
    if old:IsA("ScreenGui") and old.Name == "line" then
        old:Destroy()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "line"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 1000
gui.Parent = pg

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 400)
main.Position = UDim2.new(0, 60, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.9
stroke.Parent = main

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 34)
bar.BackgroundTransparency = 1
bar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamMedium
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(235, 238, 242)
title.Text = "line · 2 games"
title.Parent = bar

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(22, 22)
close.Position = UDim2.new(1, -30, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(32, 34, 40)
close.AutoButtonColor = false
close.Text = ""
close.Parent = bar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = close
local closeX = Instance.new("TextLabel")
closeX.Size = UDim2.fromScale(1, 1)
closeX.BackgroundTransparency = 1
closeX.Text = "×"
closeX.TextSize = 14
closeX.TextColor3 = Color3.fromRGB(200, 205, 215)
closeX.Parent = close

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -46)
scroll.Position = UDim2.fromOffset(8, 40)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new()
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 16)
status.Position = UDim2.new(0, 10, 1, -20)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(110, 116, 128)
status.Text = ""
status.Parent = main

local function say(text)
    status.Text = tostring(text)
end

local function launch(entry)
    say("loading " .. entry.name .. "...")
    local ok, src = pcall(function()
        return game:HttpGet(entry.url)
    end)
    if not ok or type(src) ~= "string" or #src < 200 then
        say("download failed")
        return
    end
    say("running " .. entry.name)
    local done, err = pcall(function()
        loadstring(src, "=line:" .. entry.id)()
    end)
    if not done then
        say("error: " .. tostring(err):sub(1, 90))
    end
end

for index, entry in ipairs(CATALOG) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = index
    btn.Parent = scroll

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.TextColor3 = Color3.fromRGB(225, 229, 236)
    label.Text = entry.name
    label.Parent = btn

    if entry.placeId and entry.placeId == game.PlaceId then
        btn.BackgroundColor3 = Color3.fromRGB(24, 44, 32)
        label.Text = entry.name .. "  · current"
    end

    btn.Activated:Connect(function()
        launch(entry)
    end)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(34, 37, 44)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = entry.placeId == game.PlaceId
            and Color3.fromRGB(24, 44, 32) or Color3.fromRGB(24, 26, 31)
    end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(#CATALOG * 34, 1))

close.Activated:Connect(function()
    gui:Destroy()
end)

-- drag
local dragging, dragStart, startPos
bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

say("ready")
return true
