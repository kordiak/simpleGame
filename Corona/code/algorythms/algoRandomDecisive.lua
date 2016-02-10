--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, enemyPos, goalPos)

    local row = enemyPos[1]
    local column = enemyPos[2]

    local possibleResults = {}

    if gridTab[row][column - 1] and gridTab[row][column - 1] and not gridTab[row][column - 1].content then
        table.insert(possibleResults, { row, column - 1 })
    end

    if gridTab[row][column + 1] and gridTab[row][column + 1] and not gridTab[row][column + 1].content then
        table.insert(possibleResults, { row, column + 1 })
    end

    if gridTab[row - 1] then
        if not gridTab[row - 1][column].content then
            table.insert(possibleResults, { row - 1, column })
        end
    end

    if gridTab[row + 1] then
        if not gridTab[row + 1][column].content then
            table.insert(possibleResults, { row + 1, column })
        end
    end


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

    return bestResult
end

return algorythm
