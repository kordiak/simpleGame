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


    local allResults = {}
    local logResults = false

    local function checkField(tab, row, column)
        local isUsed = false
        for i = 1, #tab do
            if tab[i].row == row and tab[i].column == column then
                isUsed = true
            end
        end
        return isUsed
    end

    local function checkPossibleMove(usedTab, currentTab, row, column)
        if not usedTab or #usedTab == 0 then
            return true
        end

        local possibleFields = {}
        if gridTab[row][column - 1] and gridTab[row][column - 1] and not gridTab[row][column - 1].content then
            table.insert(possibleFields, { row = row, column = column - 1 })
        end
        if gridTab[row][column + 1] and gridTab[row][column + 1] and not gridTab[row][column + 1].content then
            table.insert(possibleFields, { row = row, column = column + 1 })
        end
        if gridTab[row - 1] then
            if not gridTab[row - 1][column].content then
                table.insert(possibleFields, { row = row - 1, column = column })
            end
        end
        if gridTab[row + 1] then
            if not gridTab[row + 1][column].content then
                table.insert(possibleFields, { row = row + 1, column = column })
            end
        end
        for i = 1, #usedTab do
            if #possibleFields > 0 then
                for j = #possibleFields, 1, -1 do
                    if possibleFields[j].row == usedTab[i].row and possibleFields[j].column == usedTab[i].column then
                        table.remove(possibleFields, j)
                    end
                end
            end
        end
        for i = 1, #currentTab do
            if #possibleFields > 0 then
                for j = #possibleFields, 1, -1 do
                    if possibleFields[j].row == currentTab[i].row and possibleFields[j].column == currentTab[i].column then
                        table.remove(possibleFields, j)
                    end
                end
            end
        end
        if #possibleFields > 0 then
            return true
        else
            return false
        end
    end

    local function checkAllFields(allTab, currentTab, row, column)
        local possibleMove = true
        if allTab and #allTab > 0 then
            local usedPosition = {}
            for i = 1, #allTab do
                if allTab[i].tab[#currentTab + 1] and allTab[i].tab[#currentTab + 1].column == column and allTab[i].tab[#currentTab + 1].row == row then
                    if allTab[i].tab[#currentTab + 2] then
                        table.insert(usedPosition, allTab[i].tab[#currentTab + 2])
                    end
                end
            end
            if usedPosition then
                possibleMove = checkPossibleMove(usedPosition, currentTab, row, column)
            end
        end
        return possibleMove
    end

    local function checkGoal(row, column)
        local won = false
        if row == goalRow and column == goalColumn then
            won = true
        end
        return won
    end

    local addResult = function(possibleResults, allResults, row, column)
        if gridTab[row][column - 1] and gridTab[row][column - 1] and not gridTab[row][column - 1].content then
            if not checkField(possibleResults, row, column - 1) and checkAllFields(allResults, possibleResults, row, column - 1) then
                table.insert(possibleResults, { row = row, column = column - 1 })
                return true, checkGoal(row, column - 1)
            end
        end
        if gridTab[row][column + 1] and gridTab[row][column + 1] and not gridTab[row][column + 1].content then
            if not checkField(possibleResults, row, column + 1) and checkAllFields(allResults, possibleResults, row, column + 1) then
                table.insert(possibleResults, { row = row, column = column + 1 })
                return true, checkGoal(row, column + 1)
            end
        end
        if gridTab[row - 1] then
            if not gridTab[row - 1][column].content then
                if not checkField(possibleResults, row - 1, column) and checkAllFields(allResults, possibleResults, row - 1, column) then
                    table.insert(possibleResults, { row = row - 1, column = column })
                    return true, checkGoal(row - 1, column)
                end
            end
        end
        if gridTab[row + 1] then
            if not gridTab[row + 1][column].content then
                if not checkField(possibleResults, row + 1, column) and checkAllFields(allResults, possibleResults, row + 1, column) then
                    table.insert(possibleResults, { row = row + 1, column = column })
                    return true, checkGoal(row + 1, column)
                end
            end
        end
        return false
    end

    local atLeastOneWon
    local calcaultePaths = function()
        local continue = true
        local won
        local result = {}
        local function addPaths()
            local row = (#result > 0) and result[#result].row or startRow
            local column = (#result > 0) and result[#result].column or startColumn
            continue, won = addResult(result, allResults, row, column)
            if not continue or won then
                if won then
                    atLeastOneWon = true
                end
                table.insert(allResults, { tab = result, won = won or false })
                result = {}
            end
        end

        while continue and not won do
            addPaths()
        end
    end
    local inital = true
    local counter = 0
    while (#allResults > 0 and #allResults[#allResults].tab > 0 or inital) and counter < 50 do
        counter = counter + 1
        inital = false
        calcaultePaths()
    end


    if atLeastOneWon then
        for i = #allResults, 1, -1 do
            if not allResults[i].won then
                table.remove(allResults, i)
            end
        end
    end
    logTable(allResults)

    local bestResultLen = math.huge
    local bestResult
    for i = 1, #allResults do
        if #allResults[i].tab < bestResultLen then
            bestResultLen = #allResults[i].tab
            bestResult = allResults[i].tab
        end
    end

    logTable(bestResult)







    --  addPaths()




    if bestResult and bestResult[1] and bestResult[1].row and bestResult[1].column then
        return { bestResult[1].row, bestResult[1].column }, system.getTimer() - startTime
    end
end


return algorythm
