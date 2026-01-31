-- Loadstring seguro para teleportar a Lobby

-- Esperar a que el juego cargue completamente
if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(2) -- espera extra para scripts pesados u OP_SCRIPT

local Players = game:GetService("Players")

-- Esperar a que LocalPlayer exista
local player
repeat
    player = Players.LocalPlayer
    task.wait()
until player

-- Posición exacta para teleport
local lobbyTeleportPosition = Vector3.new(39, 4, 181)
local canTeleport = true

-- Función para teletransportar con delay
local function teleportIfLobby()
    if not canTeleport then return end
    if player.Team and player.Team.Name == "Lobby" then
        canTeleport = false
        task.spawn(function()
            task.wait(7) -- esperar 7 segundos antes de teleport
            local character = player.Character
            if character then
                -- Esperar que HumanoidRootPart exista (máx 10 segundos)
                local hrp
                local tries = 0
                repeat
                    hrp = character:FindFirstChild("HumanoidRootPart")
                    tries += 1
                    task.wait(0.2)
                until hrp or tries >= 50
                if hrp then
                    hrp.CFrame = CFrame.new(lobbyTeleportPosition)
                end
            end
            canTeleport = true -- permitir futuras teleportaciones si cambias de team
        end)
    end
end

-- Función para manejar respawn
local function onCharacterAdded(character)
    teleportIfLobby()
end

-- Conectar CharacterAdded para que funcione tras morir
player.CharacterAdded:Connect(onCharacterAdded)

-- Escuchar cambios de team
player:GetPropertyChangedSignal("Team"):Connect(teleportIfLobby)

-- Ejecutar al inicio si ya hay character
if player.Character then
    teleportIfLobby()
end
