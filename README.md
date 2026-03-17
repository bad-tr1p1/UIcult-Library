# ⛧ UIcult | Premium Roblox UI Library
![Banner](https://img.shields.io/badge/UIcult-Chaos-red?style=for-the-badge&logo=roblox&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.0.0-black?style=for-the-badge)
**UIcult** — это современная, агрессивная и высокопроизводительная библиотека интерфейсов для Roblox. Создана для тех, кто ценит стиль "Hacker Aesthetic", глубокие черные тона и плавную работу.
---
## ⛧ Особенности (Features)
*   **Dark Aesthetic**: Глубокий черный интерфейс с акцентами в стиле Chaos (Красный), Pur (Фиолетовый) и Elum (Розовый).
*   **Hacker Loader**: Профессиональный экран загрузки с аватаром игрока, мистической пентаграммой и аутентичной полосой загрузки из символов `#`.
*   **Smooth Dragging**: Плавное, интерполированное перетаскивание окон без дерганий.
*   **Hotkey Toggle**: Быстрое скрытие/показ меню на клавишу **Right Control**.
*   **Customizable**: Легкая настройка тем и разделов для ваших собственных скриптов.
---
## ⛧ Быстрый старт (Quick Start)

local BaseURL = "https://raw.githubusercontent.com/ТВОЙ_НИК/ИМЯ_РЕПО/main/CustomUI/"
local Library = loadstring(game:HttpGet(BaseURL .. "Library.lua"))()
Library:LoadingScreen({
    Callback = function()
        local Window = Library:CreateWindow({
            Title = "UIcult | Dashboard",
            Center = true,
            AutoShow = true
        })
        
        -- Создание первой вкладки
        local MainTab = Window:CreateTab("Combat")
        local Group = MainTab:AddGroupBox("Aimbot Settings")
        Group:AddToggle("Enabled", false, function(state)
            print("Aimbot is now:", state)
        end)
        Group:AddSlider("Smoothing", 1, 10, 5, function(val)
            print("Smoothing set to:", val)
        end)
        -- Системная вкладка настроек
        local SettingsTab = Window:CreateTab("Settings")
        local ThemeGroup = SettingsTab:AddGroupBox("Interface")
        ThemeGroup:AddDropdown("Theme Color", {"Chaos", "Pur", "Elum"}, "Chaos", function(name)
            local Theme = loadstring(game:HttpGet(BaseURL .. "Theme.lua"))()
            Library:UpdateAccent(Theme.Themes[name])
        end)
    end
})
