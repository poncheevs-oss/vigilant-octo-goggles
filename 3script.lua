-- Улучшенный автокликер для кнопок "Hunter" и "Hunters"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Рекурсивный поиск кнопки по имени
local function findButton(parent, name)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == name and (child:IsA("TextButton") or child:IsA("ImageButton")) then
            return child
        end
        local found = findButton(child, name)
        if found then
            return found
        end
    end
    return nil
end

-- Имитация клика: сначала firesignal, затем реальный клик мышью
local function clickButton(button)
    if not button then return end

    -- Способ 1: firesignal (если доступен)
    if firesignal and button.MouseButton1Click then
        firesignal(button.MouseButton1Click)
    else
        -- Способ 2: вызов всех подключённых функций
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
    end

    -- Способ 3: реальный клик мышью по центру кнопки
    if button.AbsolutePosition and button.AbsoluteSize then
        local pos = button.AbsolutePosition + button.AbsoluteSize / 2
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    end
end

-- Ждём появления обеих кнопок (до 30 секунд)
local hunterButton = nil
local huntersButton = nil
local timeout = 30
local startTime = tick()

while tick() - startTime < timeout do
    hunterButton = findButton(PlayerGui, "Hunter")
    huntersButton = findButton(PlayerGui, "Hunters")
    if hunterButton and huntersButton then
        break
    end
    task.wait(0.5)
end

-- Нажимаем "Hunter"
if hunterButton then
    clickButton(hunterButton)
else
    warn("Кнопка 'Hunter' не найдена")
end

-- Задержка 0.25 секунды
task.wait(0.25)

-- Нажимаем "Hunters"
if huntersButton then
    clickButton(huntersButton)
else
    warn("Кнопка 'Hunters' не найдена")
end
