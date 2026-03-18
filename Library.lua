local BaseURL = getgenv().UI_Base_URL or "https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/refs/heads/main/"

local Theme = loadstring(game:HttpGet(BaseURL .. "Theme.lua"))()
local Utils = loadstring(game:HttpGet(BaseURL .. "Utils.lua"))()

local Library = {
    AccentUpdate = {},
    NeonUpdate = {},
    ScreenGui = nil,
    Toggled = true,
    Config = {
        Title = "UI Library",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        AutoBalance = true,
        NeonEnabled = true,
        AnimationType = "Standard"
    }
}
getgenv().LinoriaLib = Library

local UserInputService = game:GetService("UserInputService")

function Library:SetOpen(bool)
    self.Toggled = bool
    local animType = self.Config.AnimationType
    
    if self.ScreenGui then
        if bool then
            self.ScreenGui.Enabled = true
            
            if animType == "Standard" then
                Library.UIScale.Scale = 0
                Utils:Tween(Library.UIScale, 0.4, {Scale = 1}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            elseif animType == "Slide" then
                Library.OuterBorder.Position = UDim2.new(Library.OriginalPosition.X.Scale, Library.OriginalPosition.X.Offset, 1.5, 0)
                Utils:Tween(Library.OuterBorder, 0.5, {Position = Library.OriginalPosition}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                Library.UIScale.Scale = 1
            elseif animType == "Elastic" then
                Library.OuterBorder.Position = UDim2.new(Library.OriginalPosition.X.Scale, Library.OriginalPosition.X.Offset, -1.5, 0)
                Utils:Tween(Library.OuterBorder, 0.8, {Position = Library.OriginalPosition}, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                Library.UIScale.Scale = 1
            end
        else
            task.spawn(function()
                local duration = 0.4
                if animType == "Standard" then
                    Utils:Tween(Library.UIScale, duration, {Scale = 0}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                elseif animType == "Slide" then
                    Utils:Tween(Library.OuterBorder, duration, {Position = UDim2.new(Library.OuterBorder.Position.X.Scale, Library.OuterBorder.Position.X.Offset, 1.5, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                elseif animType == "Elastic" then
                    Utils:Tween(Library.OuterBorder, duration, {Position = UDim2.new(Library.OuterBorder.Position.X.Scale, Library.OuterBorder.Position.X.Offset, -1.5, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                end
                
                task.wait(duration)
                if not self.Toggled then
                    self.ScreenGui.Enabled = false
                end
            end)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        Library.Toggled = not Library.Toggled
        Library:SetOpen(Library.Toggled)
    end
end)

function Library:UpdateAccent(color)
    for _, callback in pairs(self.AccentUpdate) do
        pcall(callback, color)
    end
end

function Library:SetNeonVisibility(bool)
    self.Config.NeonEnabled = bool
    for _, callback in pairs(self.NeonUpdate) do
        pcall(callback, bool)
    end
end

local Elements = loadstring(game:HttpGet(BaseURL .. "Elements.lua"))()

function Library:CreateWindow(config)
    local config = config or {}
    if type(config) == "string" then 
        config = {Title = config} 
    end
    
    for k, v in pairs(config) do self.Config[k] = v end

    local ScreenGui = Utils:Create("ScreenGui", {
        Name = "Linoria_" .. self.Config.Title,
        Parent = game.CoreGui,
        ResetOnSpawn = false,
        Enabled = self.Config.AutoShow
    })
    Library.ScreenGui = ScreenGui

    local OuterBorder = Utils:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Default.DarkBorder,
        Position = self.Config.Center and UDim2.new(0.5, -250, 0.5, -310) or UDim2.new(0, 50, 0, 50),
        Size = UDim2.new(0, 500, 0, 620),
        BorderSizePixel = 0
    })
    Library.OuterBorder = OuterBorder
    Library.OriginalPosition = OuterBorder.Position

    Library.UIScale = Utils:Create("UIScale", {
        Parent = OuterBorder,
        Scale = self.Config.AutoShow and 1 or 0
    })

    local AccentBorder = Utils:Create("Frame", {
        Parent = OuterBorder,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.AccentColor,
        BorderSizePixel = 0
    })

    table.insert(Library.AccentUpdate, function(newColor)
        AccentBorder.BackgroundColor3 = newColor
    end)

    local MainFrame = Utils:Create("Frame", {
        Parent = AccentBorder,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.MainColor,
        BorderSizePixel = 0
    })

    local PentaImage = "rbxassetid://11913904652"
    pcall(function()
        if writefile and getcustomasset then
            if not isfile("pentagram_ui.png") then
                local imageData = game:HttpGet(BaseURL .. "pentagram.png")
                writefile("pentagram_ui.png", imageData)
            end
            PentaImage = getcustomasset("pentagram_ui.png")
        end
    end)

    local TitleBar = Utils:Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
    })

    local TitleLabel = Utils:Create("TextLabel", {
        Parent = TitleBar,
        Text = self.Config.Title,
        Font = Theme.Default.Font,
        TextSize = Theme.Default.FontSize,
        TextColor3 = Theme.Default.TextColor,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X
    })

    local TitleIcon = Utils:Create("ImageLabel", {
        Parent = TitleLabel,
        Position = UDim2.new(1, 10, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        Image = PentaImage,
        ImageColor3 = Theme.Default.AccentColor,
        BackgroundTransparency = 1
    })

    table.insert(Library.AccentUpdate, function(newColor)
        TitleIcon.ImageColor3 = newColor
    end)

    Utils:MakeDraggable(TitleBar, OuterBorder)

    local TabContainer = Utils:Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 6, 0, 25),
        Size = UDim2.new(1, -12, 0, 22),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local TabList = Utils:Create("Frame", {
        Name = "TabList",
        Parent = TabContainer,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = Theme.Default.MainColor,
        BorderSizePixel = 0,
    }, {
        Utils:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 1)
        })
    })

    local ContentFrame = Utils:Create("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        Position = UDim2.new(0, 6, 0, 52),
        Size = UDim2.new(1, -12, 1, -58),
        BackgroundTransparency = 1
    })

    local Tabs = {}
    local FirstTab = true
    local TabCount = 0

        local function CreateColumnMethods(columnFrame)
            local methods = {}
            function methods:AddGroupBox(label)
                local GroupBoxHolder = Utils:Create("Frame", {
                    Parent = columnFrame,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Theme.Default.DarkBorder,
                    BorderSizePixel = 0
                })

                local GroupBox = Utils:Create("Frame", {
                    Parent = GroupBoxHolder,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BackgroundColor3 = Theme.Default.SecondaryColor,
                    BorderSizePixel = 0
                })

                local lightColor = Color3.fromRGB(255, 250, 250):Lerp(Theme.Default.AccentColor, 0.2)
                
                local TitleLabel = Utils:Create("TextLabel", {
                    Parent = GroupBoxHolder,
                    Text = " " .. label .. " ",
                    Position = UDim2.new(0, 10, 0, -8),
                    Size = UDim2.new(0, 0, 0, 16),
                    BackgroundColor3 = Theme.Default.SecondaryColor,
                    TextColor3 = lightColor,
                    Font = Theme.Default.Font,
                    TextSize = Theme.Default.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    ZIndex = 6,
                    RichText = true
                })

                local lastAccent = Theme.Default.AccentColor
                local function GetNeonTextColor(color)
                    return Color3.fromRGB(255, 250, 250):Lerp(color, 0.2)
                end

                local InnerGlow = Utils:Create("UIStroke", {
                    Parent = TitleLabel,
                    Color = lastAccent,
                    Thickness = 0.6,
                    Transparency = 0
                })

                local OuterGlowLabel = Utils:Create("TextLabel", {
                    Parent = TitleLabel,
                    Text = TitleLabel.Text,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = lastAccent,
                    Font = TitleLabel.Font,
                    TextSize = TitleLabel.TextSize,
                    TextXAlignment = TitleLabel.TextXAlignment,
                    ZIndex = 5,
                    RichText = true
                })

                local OuterGlowStroke = Utils:Create("UIStroke", {
                    Parent = OuterGlowLabel,
                    Color = lastAccent,
                    Thickness = 1.6,
                    Transparency = 0.82
                })

                table.insert(Library.AccentUpdate, function(newColor)
                    lastAccent = newColor
                    if Library.Config.NeonEnabled then
                        TitleLabel.TextColor3 = GetNeonTextColor(newColor)
                    end
                    InnerGlow.Color = newColor
                    OuterGlowLabel.TextColor3 = newColor
                    OuterGlowStroke.Color = newColor
                end)

                local function UpdateNeon(enabled)
                    InnerGlow.Enabled = enabled
                    OuterGlowLabel.Visible = enabled
                    TitleLabel.TextColor3 = enabled and GetNeonTextColor(lastAccent) or Theme.Default.TextColor
                end

                table.insert(Library.NeonUpdate, UpdateNeon)
                UpdateNeon(Library.Config.NeonEnabled)

                Utils:Create("UIListLayout", {
                    Parent = GroupBox,
                    Padding = UDim.new(0, 6),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Utils:Create("UIPadding", {
                    Parent = GroupBox,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 6)
                })

                GroupBox:FindFirstChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    GroupBoxHolder.Size = UDim2.new(1, 0, 0, GroupBox:FindFirstChild("UIListLayout").AbsoluteContentSize.Y + 22)
                end)

                local GroupMethods = {}
                function GroupMethods:AddButton(t, c) return Elements:Button(GroupBox, t, c) end
                function GroupMethods:AddToggle(t, d, c) return Elements:Toggle(GroupBox, t, d, c) end
                function GroupMethods:AddSlider(t, min, max, d, c) return Elements:Slider(GroupBox, t, min, max, d, c) end
                function GroupMethods:AddDropdown(t, o, d, c) return Elements:Dropdown(GroupBox, t, o, d, c) end
                return GroupMethods
            end
            return methods
        end

        function Tabs:CreateTab(name, isSettings)
            local layoutOrder = isSettings and 9999 or (TabCount + 1)
            if not isSettings then TabCount = TabCount + 1 end

            local isDefault = false
            if not isSettings and FirstTab then
                isDefault = true
                FirstTab = false
            end

            local TabButton = Utils:Create("TextButton", {
                Name = name .. "_Tab",
                Parent = TabList,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = isDefault and Theme.Default.MainColor or Theme.Default.DarkBorder,
                BorderSizePixel = 0,
                Text = name,
                TextColor3 = isDefault and Theme.Default.TextColor or Theme.Default.TextDark,
                Font = Theme.Default.Font,
                TextSize = Theme.Default.FontSize,
                AutomaticSize = Enum.AutomaticSize.X,
                LayoutOrder = layoutOrder
            })
            
            Utils:Create("UIPadding", {Parent = TabButton, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})

            local TabContent = Utils:Create("ScrollingFrame", {
                Name = name .. "_Content",
                Parent = ContentFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = isDefault,
                ScrollBarThickness = 1,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })

            local LeftColumn = Utils:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0.5, -7, 1, 0),
                Position = UDim2.new(0, 5, 0, 10),
                BackgroundTransparency = 1
            }, {
                Utils:Create("UIListLayout", {Padding = UDim.new(0, 12), HorizontalAlignment = Enum.HorizontalAlignment.Center})
            })

            local RightColumn = Utils:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0.5, -7, 1, 0),
                Position = UDim2.new(0.5, 2, 0, 10),
                BackgroundTransparency = 1
            }, {
                Utils:Create("UIListLayout", {Padding = UDim.new(0, 12), HorizontalAlignment = Enum.HorizontalAlignment.Center})
            })

            LeftColumn.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftColumn.UIListLayout.AbsoluteContentSize.Y, RightColumn.UIListLayout.AbsoluteContentSize.Y) + 30)
            end)
            RightColumn.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftColumn.UIListLayout.AbsoluteContentSize.Y, RightColumn.UIListLayout.AbsoluteContentSize.Y) + 30)
            end)

            local Indicator = Utils:Create("Frame", {
                Parent = TabButton,
                Size = UDim2.new(1, 0, 0, 2),
                BackgroundColor3 = Theme.Default.AccentColor,
                BorderSizePixel = 0,
                Visible = isDefault
            })

            table.insert(Library.AccentUpdate, function(newColor)
                Indicator.BackgroundColor3 = newColor
            end)

            TabButton.MouseButton1Click:Connect(function()
                for _, child in pairs(ContentFrame:GetChildren()) do
                    if child:IsA("ScrollingFrame") then child.Visible = false end
                end
                for _, child in pairs(TabList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Theme.Default.DarkBorder
                        child.TextColor3 = Theme.Default.TextDark
                        if child:FindFirstChild("Frame") then child.Frame.Visible = false end
                    end
                end
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Theme.Default.MainColor
                TabButton.TextColor3 = Theme.Default.TextColor
                Indicator.Visible = true
            end)

            local TabMethods = {
                Left = CreateColumnMethods(LeftColumn),
                Right = CreateColumnMethods(RightColumn)
            }

            function TabMethods:AddGroupBox(label)
                if Library.Config.AutoBalance then
                    local leftSize = LeftColumn.UIListLayout.AbsoluteContentSize.Y
                    local rightSize = RightColumn.UIListLayout.AbsoluteContentSize.Y
                    
                    if leftSize <= rightSize then
                        return self.Left:AddGroupBox(label)
                    else
                        return self.Right:AddGroupBox(label)
                    end
                end
                return self.Left:AddGroupBox(label)
            end

            return TabMethods
        end

    local function AddSettingsTab(tabObj)
        local SettingsTab = tabObj:CreateTab("Settings", true)
        
        local ThemeGroup = SettingsTab.Left:AddGroupBox("UI Appearance")
        ThemeGroup:AddDropdown("Theme Color", {"Chaos", "Pur", "Elum"}, "Elum", function(name)
            Library:UpdateAccent(Theme.Themes[name])
        end)
        
        local MenuSettings = SettingsTab.Right:AddGroupBox("Menu Settings")
        MenuSettings:AddToggle("Watermark Enabled", true, function(v)
            Library:SetWatermarkVisibility(v)
        end)
        MenuSettings:AddToggle("Neon Glow", true, function(v)
            Library:SetNeonVisibility(v)
        end)
        MenuSettings:AddDropdown("Open Animation", {"Standard", "Slide", "Elastic"}, "Standard", function(v)
            Library.Config.AnimationType = v
        end)
    end

    AddSettingsTab(Tabs)
    
    if not self.Config.AutoShow then
        self:SetOpen(false)
    end

    return Tabs
end

local NotifyGui = Utils:Create("ScreenGui", { Name = "UIcult_Notifications", Parent = game.CoreGui })
local NotifyHolder = Utils:Create("Frame", {
    Parent = NotifyGui,
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, -310, 0, 10),
    BackgroundTransparency = 1
}, {
    Utils:Create("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8)
    })
})

function Library:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 5

    local NotifyFrame = Utils:Create("Frame", {
        Parent = NotifyHolder,
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0,
        Transparency = 1
    })

    local Accent = Utils:Create("Frame", {
        Parent = NotifyFrame,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.AccentColor,
        BorderSizePixel = 0,
        Transparency = 1
    })

    table.insert(Library.AccentUpdate, function(newColor)
        Accent.BackgroundColor3 = newColor
    end)

    local Main = Utils:Create("Frame", {
        Parent = Accent,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.MainColor,
        BorderSizePixel = 0,
        Transparency = 1
    })

    Utils:Create("TextLabel", {
        Parent = Main,
        Text = title:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Default.AccentColor,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(1, -20, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Transparency = 1
    })

    Utils:Create("TextLabel", {
        Parent = Main,
        Text = content,
        Font = Theme.Default.Font,
        TextSize = 12,
        TextColor3 = Theme.Default.TextColor,
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 1, -30),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Transparency = 1
    })

    task.spawn(function()
        Utils:Tween(NotifyFrame, 0.4, {Transparency = 0})
        Utils:Tween(Accent, 0.4, {Transparency = 0})
        Utils:Tween(Main, 0.4, {Transparency = 0})
        for _, v in pairs(Main:GetChildren()) do 
            if v:IsA("TextLabel") then
                Utils:Tween(v, 0.4, {TextTransparency = 0}) 
            end
        end

        task.wait(duration)

        Utils:Tween(NotifyFrame, 0.4, {Transparency = 1})
        Utils:Tween(Accent, 0.4, {Transparency = 1})
        Utils:Tween(Main, 0.4, {Transparency = 1})
        for _, v in pairs(Main:GetChildren()) do 
            if v:IsA("TextLabel") then
                Utils:Tween(v, 0.4, {TextTransparency = 1}) 
            end
        end
        
        task.wait(0.4)
        NotifyFrame:Destroy()
    end)
end

local WatermarkGui = Utils:Create("ScreenGui", { Name = "UIcult_Watermark", Parent = game.CoreGui, Enabled = false })
local WatermarkFrame = Utils:Create("Frame", {
    Parent = WatermarkGui,
    Size = UDim2.new(0, 240, 0, 24),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Theme.Default.DarkBorder,
    BorderSizePixel = 0,
    Visible = true
})

local WAccent = Utils:Create("Frame", {
    Parent = WatermarkFrame,
    Size = UDim2.new(1, -2, 1, -2),
    Position = UDim2.new(0, 1, 0, 1),
    BackgroundColor3 = Theme.Default.AccentColor,
    BorderSizePixel = 0
})

table.insert(Library.AccentUpdate, function(newColor)
    WAccent.BackgroundColor3 = newColor
end)

local WMain = Utils:Create("Frame", {
    Parent = WAccent,
    Size = UDim2.new(1, -2, 1, -2),
    Position = UDim2.new(0, 1, 0, 1),
    BackgroundColor3 = Theme.Default.MainColor,
    BorderSizePixel = 0
})

local WLabel = Utils:Create("TextLabel", {
    Parent = WMain,
    Text = "UIcult | FPS: 0 | Ping: 0ms",
    Font = Theme.Default.Font,
    TextSize = 12,
    TextColor3 = Theme.Default.TextColor,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Center
})

Utils:MakeDraggable(WMain, WatermarkFrame)

function Library:SetWatermarkVisibility(bool)
    WatermarkGui.Enabled = bool
end

task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while task.wait() do
        frames = frames + 1
        if tick() - lastUpdate >= 1 then
            local fps = frames
            local stats = game:GetService("Stats")
            local ping = tonumber(string.format("%.0f", stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
            WLabel.Text = string.format("UIcult | %s | FPS: %d | Ping: %dms", os.date("%H:%M:%S"), fps, ping)
            local textSize = game:GetService("TextService"):GetTextSize(WLabel.Text, WLabel.TextSize, WLabel.Font, Vector2.new(1000, 1000))
            WatermarkFrame.Size = UDim2.new(0, textSize.X + 24, 0, 22)
            frames = 0
            lastUpdate = tick()
        end
    end
end)

function Library:LoadingScreen(config)
    local callback
    if type(config) == "function" then
        callback = config
        config = {}
    else
        config = config or {}
        callback = config.Callback or function() end
    end

    local Holder = NotifyHolder

    local LoaderFrame = Utils:Create("Frame", {
        Parent = Holder,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0,
        Transparency = 1
    })

    local Accent = Utils:Create("Frame", {
        Parent = LoaderFrame,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.AccentColor,
        BorderSizePixel = 0,
        Transparency = 1
    })

    local Main = Utils:Create("Frame", {
        Parent = Accent,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.MainColor,
        BorderSizePixel = 0,
        Transparency = 1
    })

    local TitleLabel = Utils:Create("TextLabel", {
        Parent = Main,
        Text = "INITIALIZING CORE...",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.Default.AccentColor,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(1, -20, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Transparency = 1
    })

    local BarLabel = Utils:Create("TextLabel", {
        Parent = Main,
        Text = "[ ]",
        Font = Theme.Default.Font,
        TextSize = 12,
        TextColor3 = Theme.Default.TextColor,
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Transparency = 1
    })

    task.spawn(function()
        Utils:Tween(LoaderFrame, 0.4, {Transparency = 0})
        Utils:Tween(Accent, 0.4, {Transparency = 0})
        Utils:Tween(Main, 0.4, {Transparency = 0})
        Utils:Tween(TitleLabel, 0.4, {TextTransparency = 0})
        Utils:Tween(BarLabel, 0.4, {TextTransparency = 0})

        local hashes = ""
        local total_hashes = 24
        for i = 1, total_hashes do
            hashes = hashes .. "#"
            BarLabel.Text = "[" .. hashes .. string.rep(" ", total_hashes - i) .. "]"
            local delay = math.random(3, 10) / 100
            if i % 6 == 0 then delay = delay + 0.3 end
            task.wait(delay)
        end

        task.wait(0.3)

        Utils:Tween(LoaderFrame, 0.4, {Transparency = 1})
        Utils:Tween(Accent, 0.4, {Transparency = 1})
        Utils:Tween(Main, 0.4, {Transparency = 1})
        Utils:Tween(TitleLabel, 0.4, {TextTransparency = 1})
        Utils:Tween(BarLabel, 0.4, {TextTransparency = 1})

        task.wait(0.4)
        LoaderFrame:Destroy()

        callback()
    end)
end

return Library
