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
    local column = enemyPos[1]
    local row = enemyPos[2]





    local function isAvalible(c, r, excludesTab)
        if c == goalPos[1] and r == goalPos[2] then
            return false
        end
        return not gridTab[c][r].content
    end

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

    local possibleResults = getNeighbours(column, row)

    if #possibleResults > 0 then
        return possibleResults[math.random(#possibleResults)], system.getTimer() - startTime
    end
end


return algorythm
