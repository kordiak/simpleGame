--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, enemyPos, goalPos)

    local startTime = system.getTimer()
    local startRow = enemyPos[1]
    local startColumn = enemyPos[2]
    local goalRow = goalPos[1]
    local goalColumn = goalPos[1]

    local gridTab = {}
    for i = 1, 2 do
        gridTab[i] = {}
        for j = 1, 3 do
            gridTab[i][j] = {}
        end
    end

    local function isAvalible(c, r, excludesTab)
        return not excludesTab[tostring(c .. "." .. r)]
    end

    local function getNeighbours(column, row, excludesTab)
        local neighboursTab = {}
        for i = column - 1, column + 1 do
            if gridTab[i] and gridTab[i][row] and isAvalible(i, row, excludesTab) and i ~= column then
                table.insert(neighboursTab, { c = i, r = row })
            end
        end
        for i = row - 1, row + 1 do
            if gridTab[column] and gridTab[column][i] and isAvalible(column, i, excludesTab) and i ~= row then
                table.insert(neighboursTab, { c = column, r = i })
            end
        end
        return neighboursTab
    end

    local function copyList(listToCopy)
        local newList = {}
        for i = 1, #listToCopy do
            table.insert(newList, listToCopy[i])
        end
        return newList
    end

    local function copyMap(mapToCopy)
        local newMap = {}
        for k, v in pairs(mapToCopy) do
            newMap[k] = v
        end
        return newMap
    end


    local iterationsAmount = 1
    local ins = table.insert

    local function findPossibleChainsFrom(c, r, chain, exclude)
        if iterationsAmount > 100000 then
            --- performance check for bigger grids it might not be possible to find all chains due to limiation of mobile devices memory
            return
        end
        iterationsAmount = iterationsAmount + 1
        local neighbours = getNeighbours(c, r, exclude)
        local possibleChainsFromHere = {}
        -- add them to exclusion & check for
        for i = 1, #neighbours do
            local neighbour = neighbours[i]
            local nc, nr = neighbour.c, neighbour.r
            local possibleChainFromHere = copyList(chain)
            ins(possibleChainFromHere, neighbour)
            local possibleChains
            local newExcludes = copyMap(exclude)
            newExcludes[tostring(c .. "." .. r)] = true
            possibleChains = findPossibleChainsFrom(nc, nr, possibleChainFromHere, newExcludes)
            if possibleChains then
                for j = 1, #possibleChains do
                    ins(possibleChainsFromHere, possibleChains[j])
                end
            else
                ins(possibleChainsFromHere, possibleChainFromHere)
            end
        end
        if #possibleChainsFromHere > 0 then
            return possibleChainsFromHere
        else
            return
        end
    end

    local allChains = findPossibleChainsFrom(1, 1, {}, {})
    logTable(allChains)
end


return algorythm
