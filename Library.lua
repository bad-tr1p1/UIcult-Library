local BaseURL = getgenv().UI_Base_URL or "https://raw.githubusercontent.com/YourUser/YourRepo/main/CustomUI/"

local Theme = loadstring(game:HttpGet(BaseURL .. "Theme.lua"))()
local Utils = loadstring(game:HttpGet(BaseURL .. "Utils.lua"))()

local Library = {
    AccentUpdate = {},
    ScreenGui = nil,
    Toggled = true,
    Config = {
        Title = "UI Library",
        Center = true,
        AutoShow = true,
        TabPadding = 8
    }
}
getgenv().LinoriaLib = Library

local UserInputService = game:GetService("UserInputService")

function Library:SetOpen(bool)
    self.Toggled = bool
    if self.ScreenGui then
        self.ScreenGui.Enabled = bool
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

local Elements = loadstring(game:HttpGet(BaseURL .. "Elements.lua"))()

function Library:CreateWindow(config)
    local config = config or {}
    -- Сливаем дефолтный конфиг с тем, что передал юзер
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
        Position = self.Config.Center and UDim2.new(0.5, -230, 0.5, -290) or UDim2.new(0, 50, 0, 50),
        Size = UDim2.new(0, 460, 0, 580),
        BorderSizePixel = 0
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

    local TitleBar = Utils:Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
    }, {
        Utils:Create("TextLabel", {
            Text = self.Config.Title,
            Font = Theme.Default.Font,
            TextSize = Theme.Default.FontSize,
            TextColor3 = Theme.Default.TextColor,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -10, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1
        })
    })

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

    function Tabs:CreateTab(name)
        local TabButton = Utils:Create("TextButton", {
            Name = name .. "_Tab",
            Parent = TabList,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = FirstTab and Theme.Default.MainColor or Theme.Default.DarkBorder,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = FirstTab and Theme.Default.TextColor or Theme.Default.TextDark,
            Font = Theme.Default.Font,
            TextSize = Theme.Default.FontSize,
            AutomaticSize = Enum.AutomaticSize.X
        })
        
        Utils:Create("UIPadding", {Parent = TabButton, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})

        local TabContent = Utils:Create("ScrollingFrame", {
            Name = name .. "_Content",
            Parent = ContentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = FirstTab,
            ScrollBarThickness = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utils:Create("UIListLayout", {Padding = UDim.new(0, 12), HorizontalAlignment = Enum.HorizontalAlignment.Center})
        })

        local Indicator = Utils:Create("Frame", {
            Parent = TabButton,
            Size = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = Theme.Default.AccentColor,
            BorderSizePixel = 0,
            Visible = FirstTab
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

        FirstTab = false

        local TabMethods = {}
        function TabMethods:AddGroupBox(label)
            local GroupBoxHolder = Utils:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0.96, 0, 0, 0),
                BackgroundColor3 = Theme.Default.DarkBorder,
                BorderSizePixel = 0
            })

            local GroupBox = Utils:Create("Frame", {
                Parent = GroupBoxHolder,
                Position = UDim2.new(0, 1, 0, 1),
                Size = UDim2.new(1, -2, 1, -2),
                BackgroundColor3 = Theme.Default.SecondaryColor,
                BorderSizePixel = 0
            }, {
                Utils:Create("TextLabel", {
                    Text = " " .. label .. " ",
                    Position = UDim2.new(0, 10, 0, -8),
                    Size = UDim2.new(0, 0, 0, 16),
                    BackgroundColor3 = Theme.Default.SecondaryColor,
                    TextColor3 = Theme.Default.TextColor,
                    Font = Theme.Default.Font,
                    TextSize = Theme.Default.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0
                }),
                Utils:Create("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                Utils:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 6)})
            })

            GroupBox:FindFirstChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                GroupBoxHolder.Size = UDim2.new(0.96, 0, 0, GroupBox:FindFirstChild("UIListLayout").AbsoluteContentSize.Y + 22)
            end)

            local GroupMethods = {}
            function GroupMethods:AddButton(t, c) return Elements:Button(GroupBox, t, c) end
            function GroupMethods:AddToggle(t, d, c) return Elements:Toggle(GroupBox, t, d, c) end
            function GroupMethods:AddSlider(t, min, max, d, c) return Elements:Slider(GroupBox, t, min, max, d, c) end
            function GroupMethods:AddDropdown(t, o, d, c) return Elements:Dropdown(GroupBox, t, o, d, c) end
            return GroupMethods
        end
        return TabMethods
    end
    return Tabs
end

function Library:LoadingScreen(config)
    local callback
    if type(config) == "function" then
        callback = config
        config = {}
    else
        config = config or {}
        callback = config.Callback or function() end
    end

    local Player = game:GetService("Players").LocalPlayer
    local Screen = Utils:Create("ScreenGui", {
        Name = "UIcult_Loader",
        Parent = game.CoreGui
    })

    local Frame = Utils:Create("Frame", {
        Parent = Screen,
        Size = UDim2.new(0, 420, 0, 100),
        Position = UDim2.new(0.5, -210, 0.5, -50),
        BackgroundColor3 = Theme.Default.DarkBorder,
        BorderSizePixel = 0
    })

    local Border = Utils:Create("Frame", {
        Parent = Frame,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.AccentColor,
        BorderSizePixel = 0
    })

    local Inner = Utils:Create("Frame", {
        Parent = Border,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundColor3 = Theme.Default.MainColor,
        BorderSizePixel = 0
    })

    local Avatar = Utils:Create("ImageLabel", {
        Parent = Inner,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0, 12),
        BackgroundColor3 = Theme.Default.OutlineColor,
        Image = game:GetService("Players"):GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BorderSizePixel = 0
    }, {
        Utils:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })

    local UserName = Utils:Create("TextLabel", {
        Parent = Inner,
        Text = Player.DisplayName or Player.Name,
        Font = Theme.Default.Font,
        TextSize = 13,
        TextColor3 = Theme.Default.TextColor,
        Position = UDim2.new(0, 62, 0, 12),
        Size = UDim2.new(0, 150, 0, 40),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- НАЗВАНИЕ ЗАБЛОКИРОВАНО НА UIcult
    local Title = Utils:Create("TextLabel", {
        Parent = Inner,
        Text = "UIcult",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Default.AccentColor,
        Position = UDim2.new(1, -115, 0, 8),
        Size = UDim2.new(0, 100, 0, 25),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right
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

    local Pentagram = Utils:Create("ImageLabel", {
        Parent = Inner,
        Name = "Pentagram",
        Image = PentaImage,
        ImageColor3 = Theme.Default.AccentColor,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -48, 0, 31),
        Size = UDim2.new(0, 24, 0, 24),
        BorderSizePixel = 0
    })

    local Bar = Utils:Create("TextLabel", {
        Parent = Inner,
        Text = "[ ]",
        Font = Theme.Default.Font,
        TextSize = 14,
        TextColor3 = Theme.Default.AccentColor,
        Position = UDim2.new(0, 0, 1, -38),
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1
    })

    task.spawn(function()
        local hashes = ""
        local total_hashes = 24
        for i = 1, total_hashes do
            hashes = hashes .. "#"
            Bar.Text = "[" .. hashes .. string.rep(" ", total_hashes - i) .. "]"
            local delay = math.random(5, 15) / 100
            if i % 5 == 0 then delay = delay + 0.4 end
            task.wait(delay)
        end
        task.wait(0.5)
        Screen:Destroy()
        callback()
    end)
end

return Library
