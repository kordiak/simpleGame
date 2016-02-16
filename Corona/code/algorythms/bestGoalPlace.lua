--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, goalPos, goal)

    local startTime = system.getTimer()

    local function isAvalible(c, r)
        return not gridTab[c][r].content
    end


    local enemies = {}

    for i = 1, #gridTab do
        for j = 1, #gridTab[i] do
            if gridTab[i][j].content then
                table.insert(enemies, { c = i, r = j })
            end
        end
    end

    local bestResult = {}
    local bestResultLenght = 0

    local function getNeighbours(column, row, columnIndicator, rowIndicator)
        local neighboursTab = {}
        local maxPossibilities = (columnIndicator * 2 + 1) * (rowIndicator * 2 + 1)
        for i = column - columnIndicator, column + columnIndicator do
            for j = row - rowIndicator, row + rowIndicator do
                if gridTab[i] and gridTab[i][j] and isAvalible(i, j) then
                    table.insert(neighboursTab, { i, j })
                end
            end
        end
        local maxReached = false
        if maxPossibilities == #neighboursTab then
            maxReached = true
        end
        return neighboursTab, maxReached
    end

    local function enemySum(column, row)
        local enemySum = 0
        for i = 1, #enemies do
            local eS = math.abs(column - enemies[i].c) + math.abs(row - enemies[i].r)
            enemySum = enemySum + eS
        end
        return enemySum
    end

    local function checkNearesFields(column, row)
        local bestReached = true
        local neighboursTab = {}
        local indicator = 1

        while bestReached do
            neighboursTab, bestReached = getNeighbours(column, row, indicator, indicator)
            indicator = indicator + 1
        end

        if #neighboursTab > bestResultLenght then
            bestResultLenght = #neighboursTab
            bestResult = { column, row }
        elseif #neighboursTab == bestResultLenght then
            if enemySum(column, row) > enemySum(bestResult[1], bestResult[2]) then
                bestResult = { column, row }
            end
        end
    end

    local possibleResults = {}

    local function getNeighbours(column, row)
        local neighboursTab = {}
        for i = column - 1, column + 1 do
            if gridTab[i] and gridTab[i][row] and isAvalible(i, row) and i ~= column then
                table.insert(neighboursTab, { i, row })
            end
        end
        for i = row - 1, row + 1 do
            if gridTab[column] and gridTab[column][i] and isAvalible(column, i) and i ~= row then
                table.insert(neighboursTab, { column, i })
            end
        end
        return neighboursTab
    end

    possibleResults = getNeighbours(goalPos[1], goalPos[2])

    for i = 1, #possibleResults do
        checkNearesFields(possibleResults[i][1], possibleResults[i][2])
    end

    if not goal.moveHistory then
        goal.moveHistory = {}
    end


    local checkHistory = function(compareDepth)
        if #goal.moveHistory - 1 < compareDepth * 2 then
            return false
        end

        local allSame = true
        for i = 1, compareDepth do
            -- print(goal.moveHistory[#goal.moveHistory][1], goal.moveHistory[#goal.moveHistory - (i * 2)][1], goal.moveHistory[#goal.moveHistory][2], goal.moveHistory[#goal.moveHistory - (i * 2)][2])
            if goal.moveHistory[#goal.moveHistory][1] == goal.moveHistory[#goal.moveHistory - (i * 2)][1] and goal.moveHistory[#goal.moveHistory][2] == goal.moveHistory[#goal.moveHistory - (i * 2)][2] then

            else
                allSame = false
            end
        end

        if #goal.moveHistory > (compareDepth + 1) * 2 then
            table.remove(goal.moveHistory, 1)
        end

        return allSame
    end


    if bestResult[1] and bestResult[2] then
        table.insert(goal.moveHistory, bestResult)
        local sameHistory = checkHistory(2) -- indicate the amount of moves that can duplicate before we detect same history of movment

        if sameHistory then
            table.remove(goal.moveHistory, #goal.moveHistory)
            local possiblePos = (getNeighbours(goalPos[1], goalPos[2]))
            if #possiblePos > 1 then
                for i = #possiblePos, 1, -1 do
                    if possiblePos[i][1] == goal.moveHistory[#goal.moveHistory][1] and possiblePos[i][2] == goal.moveHistory[#goal.moveHistory][2] then
                        table.remove(possiblePos, i)
                        break
                    end
                end
                return possiblePos[math.random(#possiblePos)], system.getTimer() - startTime
            else
                return possiblePos[1], system.getTimer() - startTime
            end
        end

        return bestResult, system.getTimer() - startTime
    end
end


return algorythm
