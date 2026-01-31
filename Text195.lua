-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Posición exacta para teleport
local lobbyTeleportPosition = Vector3.new(39, 4, 181)

-- Flag para evitar que se acumulen múltiples teleportaciones
local canTeleport = true

-- Función para teletransportar con delay
local function teleportIfLobby()
    if not canTeleport then return end
    if player.Team and player.Team.Name == "Lobby" then
        canTeleport = false
        task.delay(7, function() -- Espera 7 segundos antes de teleportar
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(lobbyTeleportPosition)
            end
            canTeleport = true -- permitir futuras teleportaciones si cambia de team
        end)
    end
end

-- Función para manejar cuando el personaje aparece (spawn / respawn)
local function onCharacterAdded(character)
    teleportIfLobby()
end

-- Conectar a CharacterAdded
player.CharacterAdded:Connect(onCharacterAdded)

-- Escuchar cambios de team
player:GetPropertyChangedSignal("Team"):Connect(teleportIfLobby)

-- Ejecutar al inicio si ya hay personaje
if player.Character then
    onCharacterAdded(player.Character)
end
