Team = {}
Team.__index = Team

function Team:new()
    local instance = setmetatable({}, Team)
    instance.players = {}
    return instance
end

function Team:addPlayerToTeam(player, playerId)
    local playerData = {
        id = playerId,
        nick = player.nick,
        group = player.group,
        leader = player.leader
    }
    table.insert(self.players, playerData)
end

function Team:canAddGroupToTeam(groupSize)
    local team = getTableSize(self.players) + groupSize
    return team <= 5
end

function Team:getTeamSize()
    return getTableSize(self.players)
end

function Team:TeamHaveSlot()
    local teamSize = getTableSize(self.players)
    return teamSize < 5
end

function Team:getAllPlayersOfTeam()
    return self.players
end
