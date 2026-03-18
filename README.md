# ⛧ UIcult | Professional UI Library ⛧

![Header Image](https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/pentagram.png)

Премиальный интерфейс для Roblox. Высокая производительность, чистый код и современный дизайн.

---

### | Новое в версии 1.2.0
*   **Neon Headers**: Левое выравнивание заголовков с двойным слоем свечения (раскаленное ядро + внешняя аура).
*   **Adaptive Neon**: Цвет «ядра» букв больше не статичен — он подстраивается под яркость темы для лучшей видимости.
*   **Watermark Fix**: Полная переработка системы видимости FPS/Ping через ScreenGui (теперь работает без сбоев).
*   **Default Theme**: Стоковой темой назначена `Pur` (Фиолетовый) для демонстрации лучших визуальных эффектов неона.

---

### | Основные возможности
*   **Двухколоночный макет**: Сбалансированное пространство для большого количества функций.
*   **Интеллектуальный скролл**: Автоматическая подстройка области прокрутки.
*   **Система тем**: Мгновенное переключение (Chaos, Pur, Elum).
*   **Анимации**: Плавные Sine-ease переходы (0.3с).
*   **Уведомления**: Динамические пуш-сообщения со встроенным лоадером.

---

### | Пример
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/Library.lua"))()

Library:LoadingScreen(function()
    local Window = Library:CreateWindow({Title = "Project Title", Center = true})
    local Tab = Window:CreateTab("Main")
    local Group = Tab.Left:AddGroupBox("Settings")
    
    Group:AddToggle("Enabled", true, function(val) end)
    Group:AddSlider("Value", 0, 100, 50, function(val) end)
end)
```

---

### | Информация
*   **Автор**: `bad.tr1p1`
*   **Версия**: `1.2.0`
*   **Лицензия**: Личное использование

---
*© 2026 UIcult*
