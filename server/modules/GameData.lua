GameData = {}
GameData.__index = GameData

function GameData:new(data)
    local instance = setmetatable(data, GameData)
    return instance
end

function GameData:isIncompleteTeam()
    if self.status == "waiting" then
        if self.teams.defenders:TeamHaveSlot() or self.teams.attackers:TeamHaveSlot() then
            return self
        end
    end
    return nil
end

function GameData:initializeMatch()
    self.rounds = { current = 1, data = {} }
    self.status = "inProgress"
end

function GameData:logRound(roundId, roundData)
    self.rounds.data[roundId] = roundData
end

function GameData:getMatch()
    return self
end
