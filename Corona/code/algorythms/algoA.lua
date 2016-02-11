--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, enemyPos)

    local startTime = system.getTimer()
    local row = enemyPos[1]
    local column = enemyPos[2]

    local possibleResults = {}

    if gridTab[row][column - 1] and  gridTab[row][column - 1] and not gridTab[row][column - 1].content then
        table.insert(possibleResults, { row, column - 1 })
    end

    if gridTab[row][column + 1] and gridTab[row][column + 1] and  not gridTab[row][column + 1].content then
        table.insert(possibleResults, { row, column + 1 })
    end

    if gridTab[row - 1] then
        if not gridTab[row - 1][column].content then
            table.insert(possibleResults, { row - 1,  column })
        end
    end

    if gridTab[row + 1] then
        if not gridTab[row + 1][column].content then
            table.insert(possibleResults, { row + 1,column })
        end
    end



   --- return possibleResults[math.random(#possibleResults)], system.getTimer() - startTime
end


return algorythm
