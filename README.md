# ⛧ UIcult | Professional UI Library ⛧

![Header Image](https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/pentagram.png)

Премиальный интерфейс для Roblox. Высокая производительность, чистый код и современный дизайн.

---

### | Новое в версии 1.2.0
*   **Auto-Balance**: Умное распределение GroupBox между колонками (можно отключить в конфиге).
*   **Neon Headers**: Левое выравнивание заголовков с двойным слоем свечения.
*   **Neon Toggle**: Возможность полностью отключить свечение во вкладке настроек.
*   **Adaptive Neon**: Цвет подстраивается под яркость темы.
*   **Watermark Fix**: Исправлена логика видимости FPS/Ping

---

### | Основные возможности
*   **Макет**: Сбалансированное пространство для функций.
*   **Система тем**: (Chaos, Pur, Elum).
*   **Анимации**: Плавные Sine-ease переходы.
*   **Уведомления**: Динамические пуш-сообщения со встроенным лоадером.
*   **Автономность**: Библиотека сама скачивает необходимые ассеты при первом запуске.

---

### | Пример
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/Library.lua"))()

Library:LoadingScreen(function()
    local Window = Library:CreateWindow({Title = "Project Title", AutoBalance = true})
    local Tab = Window:CreateTab("Main")
    local Group = Tab:AddGroupBox("Settings")
    
    Group:AddToggle("Enabled", true, function(v) end)
    Group:AddSlider("Value", 0, 100, 50, function(v) end)
end)
```

---

### | Информация
*   **Автор**: `bad.tr1p1`
*   **Версия**: `1.2.0`
*   **Управление**: `RightControl` (Скрыть/Показать)

---
*© 2026 UIcult*
