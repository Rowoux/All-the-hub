-- By NIVIOLARI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "All the hub<By NVIVIOLARI>", HidePremium = false, IntroText = "By NIVIOLARI", SaveConfig = true, ConfigFolder = "OrionTest"})

-- Вкладки
local CRTSCCtab = Window:MakeTab({
    Name = "CRTSCC",
    Icon = "rbxassetid://16152295009",
    PremiumOnly = false
})

-- Значения
_G.AutoFarm = false
_G.FarmSpeed = 0.5
local originalCFrame = nil
local blueprintCount = 0

-- Функции
function AutoFarm(player)
    local blueprintFolder = game.Workspace:FindFirstChild("BlueprintSpawn")

    if blueprintFolder and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        originalCFrame = player.Character.HumanoidRootPart.CFrame -- Сохранение исходного положения игрока
        while true do  -- Запускаем бесконечный цикл
            blueprintCount = 0  -- Сброс счетчика перед началом цикла
            for _, blueprint in pairs(blueprintFolder:GetChildren()) do
                blueprintCount = blueprintCount + 1 -- Увеличиваем счетчик на 1 для каждого чертежа
                if _G.AutoFarm == false then
                    player.Character.HumanoidRootPart.CFrame = originalCFrame -- Возвращение на исходное положение
                    return -- Завершаем выполнение функции
                end
                if blueprint:IsA("Part") or blueprint:IsA("Model") then
                    -- Проверяем, сидит ли игрок, и если да, поднимаем его
                    if player.Character:FindFirstChildOfClass("Humanoid").Sit then
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    player.Character.HumanoidRootPart.CFrame = blueprint.CFrame
                    print("Телепортация к " .. blueprint.Name .. " завершена.")
                    wait(0.5 / _G.FarmSpeed) -- Использование логики для ускорения телепортации
                end
            end
            print("Количество чертежей на карте: " .. blueprintCount)
            if _G.AutoFarm == false then
                player.Character.HumanoidRootPart.CFrame = originalCFrame -- Возвращение на исходное положение
                return -- Завершаем выполнение функции
            end
            wait(0.5 / _G.FarmSpeed) -- Использование логики для ускорения телепортации перед новым циклом
        end
    else
        print("Папка с Blueprints не найдена или проблемы с персонажем.")
    end
end

-- Переключатели
-- Информация по переключателю
CRTSCCtab:AddLabel("Запускает телепортацию на места спавна чертежей")
CRTSCCtab:AddLabel("При деактивации возвращает на исходное положение")

CRTSCCtab:AddToggle({
    Name = "Фарм чертежей",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            local player = game.Players.LocalPlayer
            coroutine.wrap(function() AutoFarm(player) end)()
        end
    end 
})

CRTSCCtab:AddSlider({
    Name = "Скорость фарма",
    Min = 0.1,
    Max = 5,
    Default = 0.5,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.1,
    ValueName = "Скорость",
    Callback = function(Value)
        _G.FarmSpeed = Value
    end
})

OrionLib:Init()
