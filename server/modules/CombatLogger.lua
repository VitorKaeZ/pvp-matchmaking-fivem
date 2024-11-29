CombatLogger = {}

function CombatLogger:new(gameData)
    local instance = {
        gameData = gameData
    }
    setmetatable(instance, { __index = CombatLogger })
    return instance
end

function CombatLogger:logCombat(matchId, roundId, attackerId, defenderId, combatData)
    local match = self.gameData:getMatch()
    if not match then return false end

    match.rounds.data[roundId] = match.rounds.data[roundId] or {}
    local roundData = match.rounds.data[roundId]

    roundData[attackerId] = roundData[attackerId] or { caused = {}, received = {} }
    roundData[defenderId] = roundData[defenderId] or { caused = {}, received = {} }

    -- Adicionar dados de combate
    table.insert(roundData[attackerId].caused, combatData)
    table.insert(roundData[defenderId].received, combatData)
end

function CombatLogger:getLogCombat(matchId, roundId)
    local match = self.gameData:getMatch()
    if not match then return false end

    return match.rounds.data[roundId]
end
