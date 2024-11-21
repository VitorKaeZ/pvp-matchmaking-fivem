function FormTeamsForMatch()
    local teams = {
        ['blue'] = { players = {} },
        ['red'] = { players = {} },
    }

    local maxSlots = 5

    local function getGroupSize(group)
        local count = 0
        for _ in pairs(group.players) do
            count = count + 1
        end
        return count
    end


    local function canAddGroupToTeam(team, groupSize)
        return (#team.players + groupSize) <= maxSlots
    end


    for groupName, group in pairs(Queue) do
        local groupSize = getGroupSize(group)


        if not Queue[groupName].inTeam then
            if #teams['blue'].players < maxSlots then
                if canAddGroupToTeam(teams['blue'], groupSize) then
                    for playerId, player in pairs(Queue[groupName].players) do
                        local playerData = {
                            id = playerId,
                            name = player.nick,
                            group = groupName,
                            isLeaderofGroup = player.leader
                        }
                        table.insert(teams['blue'].players, playerData)
                    end
                    Queue[groupName].inTeam = true
                end
            elseif #teams['red'].players < maxSlots then
                if canAddGroupToTeam(teams['red'], groupSize) then
                    for playerId, player in pairs(Queue[groupName].players) do
                        local playerData = {
                            id = playerId,
                            name = player.nick,
                            group = groupName,
                            isLeaderofGroup = player.leader
                        }
                        table.insert(teams['red'].players, playerData)
                    end
                    Queue[groupName].inTeam = true
                end
            end
        end


        if #teams['blue'].players == maxSlots and #teams['red'].players == maxSlots then
            break
        end
    end

    return teams
end

RegisterServerEvent("testMatchmaking", function()
    local teams = FormTeamsForMatch()

    for teamName, team in pairs(teams) do
        print(#team.players)

        for _, player in pairs(team.players) do
            print(json.encode(player))
        end
    end
end)
