--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")

local algorythm = {}

algorythm.calculate = function(gridTab, enemyPos, goalPos)

    local limitReached = false
    local startTime = system.getTimer()
    local startColumn = enemyPos[1]
    local startRow = enemyPos[2]
    local goalColumn = goalPos[1]
    local goalRow = goalPos[2]

    local checkIfAnyWon = function(tab)
        for i = 1, #tab do
            if tab[i][#tab[i]].won then
                return true
            end
        end
        return false
    end


    local function isAvalible(c, r, excludesTab)
        if gridTab[c][r].content then
            return false
        end
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
        if iterationsAmount > properties.allResultsSafeIterationsNumber then
            --- performance check for bigger grids it might not be possible to find all chains due to limiation of mobile devices memory
            limitReached = true
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
            local won = false
            if nc == goalColumn and nr == goalRow then
                 won = true
            end
            ins(possibleChainFromHere, neighbour)
            local possibleChains
            local newExcludes = copyMap(exclude)
            newExcludes[tostring(nc .. "." .. nr)] = true
            possibleChains = findPossibleChainsFrom(nc, nr, possibleChainFromHere, newExcludes)
            if possibleChains then
                for j = 1, #possibleChains do
                    ins(possibleChainsFromHere, possibleChains[j])
                end
            else
                if won then
                    ins(possibleChainsFromHere, possibleChainFromHere)
                end
            end
        end

        if #possibleChainsFromHere > 0 then
            return possibleChainsFromHere
        else
            return
        end
    end

    local allChains = findPossibleChainsFrom(startColumn, startRow, {}, {})
    log:debug("ALL CHAIN POSSIBILITY : %s FOUND WITH ITERATIONS : %s",tostring(#allChains), tostring(iterationsAmount))

    for i = 1, #allChains do
        for j = 1, #allChains[i] do
            if allChains[i][j].c == goalColumn and allChains[i][j].r == goalRow then
                for k = #allChains[i], j + 1, -1 do
                    table.remove(allChains[i], k)
                end
                table.insert(allChains[i], { won = true })
                break
            end
        end
    end

    if checkIfAnyWon(allChains) then
        for i = #allChains, 1, -1 do
            if not allChains[i][#allChains[i]].won then
                table.remove(allChains, i)
            end
        end
    end


    local bestResult
    local bestResultLenght = math.huge
    -- get shortest path
    for i = 1, #allChains do
        if #allChains[i] < bestResultLenght and #allChains[i] > 2 then
            bestResultLenght = #allChains[i]
            bestResult = allChains[i]
        end
    end

    return { bestResult[1].c, bestResult[1].r }, system.getTimer() - startTime, limitReached
end


return algorythm
