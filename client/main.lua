Queue = {}
Games = Games or {}
Games.data = Games.data or {}


RegisterCommand('testMatchMaking', function(source, args, rawCommand)
    -- MockQueue(3)
    local playerId = PlayerId()
    local serverId = GetPlayerServerId(playerId)
    local playerName = GetPlayerName(playerId)
    local group = { players = {}, inTeam = false }
    group.players[playerName] = {
        id = serverId,
        nick = playerName,
        leader = true
    }
    TriggerServerEvent("Queue", group)
end, true)


RegisterNetEvent("Queue:att")
AddEventHandler("Queue:att", function(data)
    Queue = data
    print("Grupos na Queue:", getTableSize(Queue))
end)

RegisterNetEvent("Games:att")
AddEventHandler("Games:att", function(data)
    Games = data
    print("Jogos em andamento:", getTableSize(Games))
end)
