Games = Games or {}
Games.data = Games.data or {}


function FormTeamsFromQueue()
    local blueTeam = Team:new()
    local redTeam = Team:new()

    local maxSlots = 5

    local function getGroupSize(group)
        local count = 0
        for _ in pairs(group.players) do
            count = count + 1
        end
        return count
    end

    local function findIncompleteTeam()
        for _, match in pairs(Games.data) do
            if match:isIncompleteTeam() then
                return match
            end
        end
        return nil
    end

    for groupName, group in pairs(Queue) do
        local groupSize = getGroupSize(group)

        if not group.inTeam then
            local match = findIncompleteTeam()

            if match then
                blueTeam = match.teams.defenders
                redTeam = match.teams.attackers
            end

            if blueTeam:TeamHaveSlot() and blueTeam:canAddGroupToTeam(groupSize) then
                for id, player in pairs(group.players) do
                    blueTeam:addPlayerToTeam(player, id)
                end
                Queue[groupName].inTeam = true
            elseif redTeam:TeamHaveSlot() and redTeam:canAddGroupToTeam(groupSize) then
                for id, player in pairs(group.players) do
                    redTeam:addPlayerToTeam(player, id)
                end
                Queue[groupName].inTeam = true
            end

            if not blueTeam:TeamHaveSlot() and not redTeam:TeamHaveSlot() then
                if not match then
                    local gameData = GameData:new({
                        teams = {
                            defenders = blueTeam,
                            attackers = redTeam,
                        },
                        status = 'ready',
                        rounds = {}
                    })

                    gameData.combatLogger = CombatLogger:new(gameData)


                    local gameIndex = "matchmaking-" .. (getTableSize(Games.data) + 1)

                    Games.data[gameIndex] = gameData
                else
                    match.status = "ready"
                end

                blueTeam = Team:new()
                redTeam = Team:new()
            end
            if not match and (blueTeam:getTeamSize() > 0 or redTeam:getTeamSize() > 0) then
                local gameData = GameData:new({
                    teams = {
                        defenders = blueTeam,
                        attackers = redTeam,
                    },
                    status = 'waiting',
                    rounds = {}
                })

                gameData.combatLogger = CombatLogger:new(gameData)

                local gameIndex = "matchmaking-" .. (getTableSize(Games.data) + 1)

                Games.data[gameIndex] = gameData
            end
        end
    end
end

RegisterNetEvent("combat:log")
AddEventHandler("combat:log", function(matchId, roundId, attackerId, defenderId, combatData)
    local match = Games.data[matchId]
    if match and match.combatLogger then
        match.combatLogger:logCombat(matchId, roundId, attackerId, defenderId, combatData)
    else
        print("Erro: CombatLogger não encontrado para a partida", matchId)
    end
end)

RegisterNetEvent("Queue")
AddEventHandler("Queue", function(data)
    Queue[getTableSize(Queue) + 1] = data
    MockQueue(3)
    MockQueue(3)
    -- MockQueue(2)
end)

RegisterServerEvent("StartMatch")
AddEventHandler("StartMatch", function(matchId)
    local timer = 10
    local match = Games.data[matchId]
    match.status = 'Starting'

    while timer > 0 do
        Wait(1000)
        print("Partida", matchId:match("-(%d+)"), "Começa em", timer, "...")
        timer = timer - 1
    end

    match:initializeMatch()
    MockCombatLogs(matchId)
end)

Citizen.CreateThread(function()
    while true do
        -- MockQueue()
        FormTeamsFromQueue()
        TriggerClientEvent("Queue:att", -1, Queue)
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        for id, match in pairs(Games.data) do
            if match.status == "ready" then
                TriggerEvent("StartMatch", id)
            elseif match.status == "waiting" then
                print("Partida", id:match("-(%d+)"), "Status:", match.status)
                print("Time Azul:", #match.teams.defenders.players, "jogadores")
                print("Time Vermelho:", #match.teams.attackers.players, "jogadores")
            elseif match.status == "inProgress" then
                local combatLog = match.combatLogger:getLogCombat(id, 1)
                print(json.encode(combatLog))
            end
        end


        Citizen.Wait(1000)
    end
end)
