-- Loadstring seguro para teleportar a Lobby

-- Esperar a que el juego cargue
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Posición exacta para teleport
local lobbyTeleportPosition = Vector3.new(39, 4, 181)
local canTeleport = true

-- Función para teletransportar con delay
local function teleportIfLobby()
    if not canTeleport then return end
    if player.Team and player.Team.Name == "Lobby" then
        canTeleport = false
        task.delay(7, function() -- Esperar 7 segundos antes del teleport
            local character = player.Character
            if character then
                local hrp = character:WaitForChild("HumanoidRootPart", 5) -- Espera max 5s
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
    onCharacterAdded(player.Character)
end
