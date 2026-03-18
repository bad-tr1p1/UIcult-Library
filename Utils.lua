local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = {}

function Utils:Tween(object, time, properties)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Utils:MakeDraggable(frame, parent)
    parent = parent or frame
    local dragging, dragStart, startPos
    local targetPos = parent.Position

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Utils:Tween(parent, 0.08, {Position = targetPos})
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Utils:Create(className, properties, children)
    local object = Instance.new(className)
    for i, v in pairs(properties or {}) do
        object[i] = v
    end
    for i, v in pairs(children or {}) do
        v.Parent = object
    end
    return object
end

return Utils
