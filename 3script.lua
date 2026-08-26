-- Autoexec: Автоматически нажимает кнопки "Hunter" и "Hunters" при заходе в игру
-- Задержка между нажатиями: 0.25 секунды

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Функция для поиска кнопки по имени (рекурсивно по всем потомкам)
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

-- Функция для имитации клика по кнопке
local function clickButton(button)
    if not button then return end
    -- Попытка использовать firesignal (работает в большинстве эксплоитов)
    if firesignal and button.MouseButton1Click then
        firesignal(button.MouseButton1Click)
    else
        -- Запасной метод: вызов всех подключённых функций
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
    end
end

-- Ждём появления интерфейса (можно увеличить при необходимости)
task.wait(5)

-- Ищем кнопки
local hunterButton = findButton(PlayerGui, "Hunter")
local huntersButton = findButton(PlayerGui, "Hunters")

-- Нажимаем первую кнопку
if hunterButton then
    clickButton(hunterButton)
end

-- Задержка 0.25 секунды
task.wait(0.25)

-- Нажимаем вторую кнопку
if huntersButton then
    clickButton(huntersButton)
end