# ⛧ UIcult | Professional UI Library ⛧

![Header Image](https://raw.githubusercontent.com/bad-tr1p1/UIcult-Library/main/pentagram.png)

Премиальный интерфейс для Roblox Lua скриптов. Высокая производительность, чистый код и современный дизайн.

**ЗАТОЧЕНО ДЛЯ СОЗДАНИЯ ЧИТ-ПРОЕКТОВ**

---

### | Новое в версии 1.3.0
*   **Menu Animations**: 3 уникальных режима (Standard, Slide, Elastic). Настраивается в меню.
*   **Default Theme**: Основная тема переключена на `Elum`.
*   **Auto-Balance**: Умное распределение GroupBox между колонками.
*   **Neon Headers**: Левое выравнивание заголовков с двойным слоем свечения.
*   **Neon Toggle**: Возможность полностью отключить свечение во вкладке настроек.
*   **Adaptive Neon**: Цвет подстраивается под яркость темы.

---

### | Основные возможности
*   **Макет**: Сбалансированное пространство для функций.
*   **Система тем**: Chaos, Pur, Elum (с мгновенным применением).
*   **Анимации**: Плавные переходы открытия и закрытия.
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
*   **Версия**: `1.3.0`
*   **Управление**: `RightControl` (Скрыть/Показать)
*   **Использование**: `Данный проект предоставляется (as is), без каких-либо гарантий. Автор не несет ответственности за любые возможные последствия, возникшие в результате использования данного проекта. Вся ответственность за использование полностью лежит на вас.`

---
*© 2026 UIcult*
