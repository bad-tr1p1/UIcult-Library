# ⛧ UIcult | Professional UI Library ⛧

![Header Image](https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/pentagram.png)

Премиальный интерфейс для Roblox, разработанный для обеспечения максимальной производительность и эстетики вашего проекта.

---

### | Основные возможности
*   **Двухколоночный макет**: Оптимизированное пространство для большого количества функций.
*   **Интеллектуальный скролл**: Автоматическая подстройка под контент с минималистичным дизайном.
*   **Система тем**: Мгновенное переключение цветовых схем (Chaos, Pur, Elum).
*   **Анимации**: Плавные Sine-ease переходы элементов.
*   **Уведомления**: Динамические пуш-сообщения со встроенным лоадером.

---

### | Пример
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/Library.lua"))()

Library:LoadingScreen(function()
    local Window = Library:CreateWindow({Title = "UIcult Project", Center = true})
    local Tab = Window:CreateTab("Main")
    local Group = Tab.Left:AddGroupBox("Settings")
    
    Group:AddToggle("Enabled", true, function(val) print(val) end)
    Group:AddSlider("Value", 0, 100, 50, function(val) print(val) end)
end)
```

---

### 👤 Информация
*   **Автор**: `bad.tr1p1`
*   **Версия**: `1.1.0`
*   **Лицензия**: Личное использование

---
*© 2026 UIcult*
