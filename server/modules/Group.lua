Group = {}
Group.__index = Group

function Group:new()
    local instance = setmetatable({}, Group)
    instance.players = {}
    instance.inTeam = false
    return instance
end

function Group:getSize()
    return getTableSize(self.players)
end
