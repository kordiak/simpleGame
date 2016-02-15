--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

local algorythm = {}

algorythm.calculate = function(gridTab, goalPos)

    local startTime = system.getTimer()

    local possibleResults = {}
    for i = 1, #gridTab do
        possibleResults[i] = {}
        for j = 1, #gridTab[i] do
            possibleResults[i][j] = {}
            if gridTab[i][j].content then
                possibleResults[i][j] = true
            end
        end
    end

  --  logTable(possibleResults)




    --  getNeighbours(column, row)


    --    return possibleResults[math.random(#possibleResults)], system.getTimer() - startTime
end


return algorythm
