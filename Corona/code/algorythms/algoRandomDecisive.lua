--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, enemyPos, goalPos)

    local column = enemyPos[1]
    local row = enemyPos[2]



    local possibleResults = {}

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
                table.insert(possibleResults, { i, row })
            end
        end
        for i = row - 1, row + 1 do
            if gridTab[column] and gridTab[column][i] and isAvalible(column, i) and i ~= row then
                table.insert(possibleResults, { column, i })
            end
        end
        return neighboursTab
    end

    getNeighbours(column, row)


    local bestResult
    local rowDiff = math.huge
    local columnDiff = math.huge

    for i = 1, #possibleResults do
        local rowD = math.abs(goalPos[1] - possibleResults[i][1])
        local columnD = math.abs(goalPos[2] - possibleResults[i][2])

        if rowD > columnD then
            if rowDiff > rowD then
                rowDiff = rowD
                bestResult = possibleResults[i]
            end
        else
            if columnDiff > columnD then
                columnDiff = columnD
                bestResult = possibleResults[i]
            end
        end
    end

    possibleResults = {}
    return bestResult
end

return algorythm
