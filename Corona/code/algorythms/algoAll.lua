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
    local startColumn = enemyPos[2]
    local startRow = enemyPos[1]

    local goalColumn = goalPos[1]
    local goalRow = goalPos[2]

    local allResults = {}
    local logResults = false

    local function checkField(tab, column, row)
        local isUsed = false
        for i = 1, #tab do
            if tab[i].column == column and tab[i].row == row then
                isUsed = true
            end
        end
        return isUsed
    end

    local function checkPossibleMove(usedTab, currentTab, column, row)
        if not usedTab or #usedTab == 0 then
            return true
        end

        local possibleFields = {}
        if gridTab[column][row - 1] and gridTab[column][row - 1] and not gridTab[column][row - 1].content then
            table.insert(possibleFields, { column = column, row = row - 1 })
        end
        if gridTab[column][row + 1] and gridTab[column][row + 1] and not gridTab[column][row + 1].content then
            table.insert(possibleFields, { column = column, row = row + 1 })
        end
        if gridTab[column - 1] then
            if not gridTab[column - 1][row].content then
                table.insert(possibleFields, { column = column - 1, row = row })
            end
        end
        if gridTab[column + 1] then
            if not gridTab[column + 1][row].content then
                table.insert(possibleFields, { column = column + 1, row = row })
            end
        end

        --        for i = #possibleFields, 1, -1 do
        --            if possibleFields[i].column == goalColumn and possibleFields[i].row == goalRow then
        --                table.remove(possibleFields, i)
        --            end
        --        end

        for i = 1, #usedTab do
            if #possibleFields > 0 then
                for j = #possibleFields, 1, -1 do
                    if possibleFields[j].column == usedTab[i].column and possibleFields[j].row == usedTab[i].row then
                        table.remove(possibleFields, j)
                    end
                end
            end
        end
        for i = 1, #currentTab do
            if #possibleFields > 0 then
                for j = #possibleFields, 1, -1 do
                    if possibleFields[j].column == currentTab[i].column and possibleFields[j].row == currentTab[i].row then
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

    local function checkAllFields(allTab, currentTab, column, row)
        local possibleMove = true
        if allTab and #allTab > 0 then
            local usedPosition = {}
            for i = 1, #allTab do
                if allTab[i].tab[#currentTab + 1] and allTab[i].tab[#currentTab + 1].row == row and allTab[i].tab[#currentTab + 1].column == column then
                    if allTab[i].tab[#currentTab + 2] then
                        table.insert(usedPosition, allTab[i].tab[#currentTab + 2])
                    end
                end
            end
            if usedPosition then
                possibleMove = checkPossibleMove(usedPosition, currentTab, column, row)
            end
        end
        return possibleMove
    end

    local function checkGoal(column, row)
        local won = false
        if column == goalRow and row == goalColumn then
            won = true
        end
        return won
    end

    local addResult = function(possibleResults, allResults, column, row)
        if gridTab[column][row - 1] and gridTab[column][row - 1] and not gridTab[column][row - 1].content then
            if not checkField(possibleResults, column, row - 1) and checkAllFields(allResults, possibleResults, column, row - 1) then
                table.insert(possibleResults, { column = column, row = row - 1 })
                return true, checkGoal(row - 1, column)
            end
        end
        if gridTab[column][row + 1] and gridTab[column][row + 1] and not gridTab[column][row + 1].content then
            if not checkField(possibleResults, column, row + 1) and checkAllFields(allResults, possibleResults, column, row + 1) then
                table.insert(possibleResults, { column = column, row = row + 1 })
                return true, checkGoal(row + 1, column)
            end
        end
        if gridTab[column - 1] then
            if not gridTab[column - 1][row].content then
                if not checkField(possibleResults, column - 1, row) and checkAllFields(allResults, possibleResults, column - 1, row) then
                    table.insert(possibleResults, { column = column - 1, row = row })
                    return true, checkGoal(row, column - 1)
                end
            end
        end
        if gridTab[column + 1] then
            if not gridTab[column + 1][row].content then
                if not checkField(possibleResults, column + 1, row) and checkAllFields(allResults, possibleResults, column + 1, row) then
                    table.insert(possibleResults, { column = column + 1, row = row })
                    return true, checkGoal(row, column + 1)
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
            local column = (#result > 0) and result[#result].column or startRow
            local row = (#result > 0) and result[#result].row or startColumn
            continue, won = addResult(result, allResults, column, row)
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


    local bestResultLen = math.huge
    local bestResult

    for i = 1, #allResults do
        if #allResults[i].tab < bestResultLen and allResults[i].tab[1] and allResults[i].tab[1].column and allResults[i].tab[1].row then
            bestResultLen = #allResults[i].tab
            bestResult = allResults[i].tab
        end
    end


    if bestResult and bestResult[1] and bestResult[1].column and bestResult[1].row then
        logTable(bestResult)
        return { bestResult[1].column, bestResult[1].row }, system.getTimer() - startTime
    end
end


return algorythm
