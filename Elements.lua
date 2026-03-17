local BaseURL = getgenv().UI_Base_URL or "https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/refs/heads/main/"

local Theme = loadstring(game:HttpGet(BaseURL .. "Theme.lua"))()
local Utils = loadstring(game:HttpGet(BaseURL .. "Utils.lua"))()
local Lib = getgenv().LinoriaLib

local Elements = {}

function Elements:Button(parent, text, callback)
    local Holder = Utils:Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local Inner = Utils:Create("Frame", {
        Parent = Holder,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.OutlineColor,
        BorderSizePixel = 0
    })

    local Main = Utils:Create("TextButton", {
        Parent = Inner,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.SecondaryColor,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Theme.Default.TextColor,
        Font = Theme.Default.Font,
        TextSize = 13, -- Ранее было 11
        AutoButtonColor = false
    })

    Main.MouseButton1Click:Connect(function()
        Main.BackgroundColor3 = Theme.Default.OutlineColor
        task.wait(0.1)
        Main.BackgroundColor3 = Theme.Default.SecondaryColor
        callback()
    end)

    return Holder
end

function Elements:Toggle(parent, text, default, callback)
    local Toggled = default or false
    
    local ToggleFrame = Utils:Create("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 16),
    })

    local IndicatorOuter = Utils:Create("Frame", {
        Parent = ToggleFrame,
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local IndicatorInner = Utils:Create("Frame", {
        Parent = IndicatorOuter,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.OutlineColor,
        BorderSizePixel = 0
    })

    local Main = Utils:Create("TextButton", {
        Parent = IndicatorInner,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Toggled and (Theme.Default.AccentColor) or Theme.Default.SecondaryColor,
        BorderSizePixel = 0,
        Text = ""
    })

    local Label = Utils:Create("TextLabel", {
        Parent = ToggleFrame,
        Text = text,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Toggled and Theme.Default.TextColor or Theme.Default.TextDark,
        Font = Theme.Default.Font,
        TextSize = 13, -- Ранее было 11
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Btn = Utils:Create("TextButton", {
        Parent = ToggleFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    })

    Btn.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        Main.BackgroundColor3 = Toggled and Theme.Default.AccentColor or Theme.Default.SecondaryColor
        Label.TextColor3 = Toggled and Theme.Default.TextColor or Theme.Default.TextDark
        callback(Toggled)
    end)

    if Lib and Lib.AccentUpdate then
        table.insert(Lib.AccentUpdate, function(newColor)
            if Toggled then Main.BackgroundColor3 = newColor end
        end)
    end

    return ToggleFrame
end

function Elements:Slider(parent, text, min, max, default, callback)
    local Value = default or min
    
    local SliderFrame = Utils:Create("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 28),
    })

    Utils:Create("TextLabel", {
        Parent = SliderFrame,
        Text = text,
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Default.TextColor,
        Font = Theme.Default.Font,
        TextSize = 13, -- Ранее было 11
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ValLabel = Utils:Create("TextLabel", {
        Parent = SliderFrame,
        Text = tostring(Value),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 0, 0, 14),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Default.TextDark,
        Font = Theme.Default.Font,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local BG = Utils:Create("Frame", {
        Parent = SliderFrame,
        Position = UDim2.new(0, 0, 0, 16),
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local BGInner = Utils:Create("Frame", {
        Parent = BG,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.OutlineColor,
        BorderSizePixel = 0
    })

    local Main = Utils:Create("Frame", {
        Parent = BGInner,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.SecondaryColor,
        BorderSizePixel = 0
    })

    local Fill = Utils:Create("Frame", {
        Parent = Main,
        Size = UDim2.new((Value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Default.AccentColor,
        BorderSizePixel = 0
    })

    if Lib and Lib.AccentUpdate then
        table.insert(Lib.AccentUpdate, function(newColor)
            Fill.BackgroundColor3 = newColor
        end)
    end

    local function Update(input)
        local pos = math.clamp((input.Position.X - Main.AbsolutePosition.X) / Main.AbsoluteSize.X, 0, 1)
        Value = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValLabel.Text = tostring(Value)
        callback(Value)
    end

    local Dragging = false
    BG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            Update(input)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    return SliderFrame
end

function Elements:Dropdown(parent, text, options, default, callback)
    local Selected = default or options[1]
    local Open = false
    
    local DropdownFrame = Utils:Create("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 34),
        ZIndex = 5
    })

    Utils:Create("TextLabel", {
        Parent = DropdownFrame,
        Text = text,
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Default.TextColor,
        Font = Theme.Default.Font,
        TextSize = 13, -- Ранее было 11
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Holder = Utils:Create("Frame", {
        Parent = DropdownFrame,
        Position = UDim2.new(0, 0, 0, 16),
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local Main = Utils:Create("TextButton", {
        Parent = Holder,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.SecondaryColor,
        BorderSizePixel = 0,
        Text = "  " .. Selected,
        TextColor3 = Theme.Default.TextColor,
        Font = Theme.Default.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })

    local Arrow = Utils:Create("TextLabel", {
        Parent = Main,
        Text = "v",
        Position = UDim2.new(1, -15, 0, 0),
        Size = UDim2.new(0, 15, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Default.TextDark,
        Font = Theme.Default.Font,
        TextSize = 10
    })

    local List = Utils:Create("Frame", {
        Parent = Main,
        Position = UDim2.new(0, -1, 1, 2),
        Size = UDim2.new(1, 2, 0, 0),
        BackgroundColor3 = Theme.Default.DarkBorder,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 10,
        BorderSizePixel = 0
    })

    local ListInner = Utils:Create("Frame", {
        Parent = List,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.SecondaryColor,
        BorderSizePixel = 0
    }, {
        Utils:Create("UIListLayout", {Padding = UDim.new(0, 0)})
    })

    for _, opt in pairs(options) do
        local OptBtn = Utils:Create("TextButton", {
            Parent = ListInner,
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = Theme.Default.SecondaryColor,
            BorderSizePixel = 0,
            Text = "  " .. opt,
            TextColor3 = Theme.Default.TextDark,
            Font = Theme.Default.Font,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11
        })

        OptBtn.MouseButton1Click:Connect(function()
            Selected = opt
            Main.Text = "  " .. Selected
            Open = false
            List.Visible = false
            callback(Selected)
        end)
        
        OptBtn.MouseEnter:Connect(function() OptBtn.TextColor3 = Theme.Default.AccentColor end)
        OptBtn.MouseLeave:Connect(function() OptBtn.TextColor3 = Theme.Default.TextDark end)
    end

    Main.MouseButton1Click:Connect(function()
        Open = not Open
        List.Visible = Open
        List.Size = Open and UDim2.new(1, 2, 0, #options * 18 + 2) or UDim2.new(1, 2, 0, 0)
    end)

    return DropdownFrame
end

return Elements
