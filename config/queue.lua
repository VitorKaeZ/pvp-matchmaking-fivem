Queue = {
    -- ['group:1'] = {
    --     players = { [1] = { nick = 'ViperGT', leader = true } },
    --     inTeam = false
    -- },
    -- ['group:2'] = {
    --     players = {
    --         [2] = { nick = 'BlazeGamer', leader = false },
    --         [3] = { nick = 'SpeedRacer', leader = false },
    --         [4] = { nick = 'ShadowNinja', leader = true },
    --         [5] = { nick = 'PhoenixFire', leader = false }
    --     },
    --     inTeam = false

    -- },
    -- ['group:3'] = {
    --     players = {
    --         [6] = { nick = 'ThunderBolt', leader = true },
    --         [7] = { nick = 'GhostRider', leader = false }
    --     },
    --     inTeam = false

    -- },
    -- ['group:4'] = {
    --     players = {
    --         [8] = { nick = 'NeonSpectre', leader = false },
    --         [9] = { nick = 'DriftKing', leader = true }
    --     },
    --     inTeam = false

    -- },
    -- ['group:5'] = {
    --     players = { [10] = { nick = 'MidnightWolf', leader = true } },
    --     inTeam = false
    -- },
    -- ['group:6'] = {
    --     players = { [11] = { nick = 'ViperGT', leader = true } },
    --     inTeam = false
    -- },
    -- ['group:7'] = {
    --     players = {
    --         [12] = { nick = 'BlazeGamer', leader = false },
    --         [13] = { nick = 'SpeedRacer', leader = false },
    --         [14] = { nick = 'ShadowNinja', leader = true },
    --         [15] = { nick = 'PhoenixFire', leader = false }
    --     },
    --     inTeam = false

    -- },
    -- ['group:8'] = {
    --     players = {
    --         [16] = { nick = 'ThunderBolt', leader = true },
    --         [17] = { nick = 'GhostRider', leader = false }
    --     },
    --     inTeam = false

    -- },
    -- ['group:9'] = {
    --     players = {
    --         [18] = { nick = 'NeonSpectre', leader = false },
    --         [19] = { nick = 'DriftKing', leader = true }
    --     },
    --     inTeam = false

    -- },
    -- ['group:10'] = {
    --     players = { [20] = { nick = 'MidnightWolf', leader = true } },
    --     inTeam = false
    -- },
    -- ['group:11'] = {
    --     players = {
    --         [21] = { nick = 'NeonSpectre', leader = false },
    --         [22] = { nick = 'DriftKing', leader = true }
    --     },
    --     inTeam = false
    -- },
    -- ['group:12'] = {
    --     players = { [23] = { nick = 'MidnightWolf', leader = true } },
    --     inTeam = false
    -- },
    -- ['group:13'] = {
    --     players = { [24] = { nick = 'MidnightWolf', leader = true } },
    --     inTeam = false
    -- },
}


function generateRandomPlayer()
    local playerId = math.random(1000, 9999)
    return {
        id = playerId,
        nick = "Player" .. playerId,
        leader = false
    }
end

function getTableSize(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function addGroupToQueue(groupId, groupSize)
    if not Queue[groupId] then -- Verifica se o grupo já não está na fila
        local group = { players = {}, inTeam = false }
        for i = 1, groupSize do
            local player = generateRandomPlayer()
            if i == 1 then player.leader = true end -- Define o primeiro como líder
            group.players[player.nick] = player
        end
        Queue[groupId] = group
        print("Grupo adicionado à fila:", groupId, json.encode(Queue[groupId]))
    end
end

function MockQueue(size)
    local groupId = "group:" .. getTableSize(Queue) + 1
    local groupSize = size or math.random(1, 5)
    addGroupToQueue(groupId, groupSize)
end

function MockCombatLogs(matchId)
    local match = Games.data[matchId]
    if not match then
        print("Erro: Partida não encontrada para ID:", matchId)
        return
    end

    local defenders = match.teams.defenders:getAllPlayersOfTeam()
    local attackers = match.teams.attackers:getAllPlayersOfTeam()

    local weapons = {
        "WEAPON_PISTOL",
        "WEAPON_SHOTGUN",
        "WEAPON_SMG",
        "WEAPON_RIFLE",
        "WEAPON_SNIPER"
    }

    local hitLocations = {
        "Head", "Chest", "Legs", "Arms"
    }

    for round = 1, 5 do
        for _, attacker in pairs(attackers) do
            for _, defender in pairs(defenders) do
                -- Gerar dados mockados de combate
                local combatData = {
                    player = attacker.id,
                    damage = math.random(10, 100),                          -- Dano aleatório entre 10 e 100
                    weapon = weapons[math.random(#weapons)],                -- Selecionar arma aleatória
                    hitLocation = hitLocations[math.random(#hitLocations)], -- Local de acerto aleatório
                }

                -- Registrar combate no CombatLogger
                TriggerEvent("combat:log", matchId, round, attacker.id, defender.id, combatData)

                -- Fazer o defensor também causar dano no atacante (combate bidirecional)
                local counterCombatData = {
                    player = defender.id,
                    damage = math.random(5, 80),                            -- Dano aleatório entre 5 e 80
                    weapon = weapons[math.random(#weapons)],                -- Selecionar arma aleatória
                    hitLocation = hitLocations[math.random(#hitLocations)], -- Local de acerto aleatório
                }

                TriggerEvent("combat:log", matchId, round, defender.id, attacker.id, counterCombatData)
            end
        end
    end

    print("Mock de combates gerado para a partida:", matchId)
end
