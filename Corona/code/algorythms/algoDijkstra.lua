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
    local startingColumn = enemyPos[1]
    local startingRow = enemyPos[2]

    print(goalPos[1],goalPos[2])

    local usedPos = {}
    local function isAvalible(c, r)

        if usedPos[tostring(c .. "." .. r)] then return false end
        return not gridTab[c][r].content
    end

    for i = 1, #gridTab do
        for j = 1, #gridTab[i] do
            gridTab[i][j].stepText.text = ""
        end
    end

    local function getNeighbours(column, row)
        local neighboursTab = {}

        local orderOfInsert = math.random(1, 2)

        local insertByRow = function()
            for i = row - 1, row + 1 do
                if gridTab[column] and gridTab[column][i] and isAvalible(column, i) and i ~= row then
                    table.insert(neighboursTab, { c = column, r = i })
                end
            end
        end
        local insertByColumn = function()
            for i = column - 1, column + 1 do
                if gridTab[i] and gridTab[i][row] and isAvalible(i, row) and i ~= column then
                    table.insert(neighboursTab, { c = i, r = row })
                end
            end
        end

        if orderOfInsert == 1 then
            insertByRow()
            insertByColumn()
        else
            insertByColumn()
            insertByRow()
        end

        return neighboursTab
    end

    local frontierQueue = {}
    local rTab = {}
    rTab[tostring(startingColumn .. "." .. startingColumn)] = {}
    table.insert(frontierQueue, { c = startingColumn, r = startingRow, rt = rTab[tostring(startingColumn .. "." .. startingColumn)] })
    usedPos[tostring(startingColumn .. "." .. startingColumn)] = true

    local moveCounter = 0


    local function calculatePaths()
        while #frontierQueue >= 1 do
            local cell = frontierQueue[1]
            local neightBours = getNeighbours(cell.c, cell.r)
            local rt = cell.rt
            for i = 1, #neightBours do
                local neightbour = neightBours[i]
                local c = neightbour.c
                local r = neightbour.r
                if c == goalPos[1] and r == goalPos[2] then
                    rt[tostring(c .. "." .. r)] = "won"
                    frontierQueue = {}
                    break
                else
                    rt[tostring(c .. "." .. r)] = {}
                    table.insert(frontierQueue, { c = c, r = r, rt = rt[tostring(c .. "." .. r)] })
                    usedPos[tostring(c .. "." .. r)] = true
                end
            end
            moveCounter = moveCounter + 1
            gridTab[cell.c][cell.r].stepText.text = moveCounter
            table.remove(frontierQueue, 1)
        end
    end


    local results = calculatePaths()


    local getGoalResult = function(goalTab)
        local function checkDeeper(wTab, goalDTab)

            for k, v in pairs(goalDTab) do
                if type(v) == "table" then
                    checkDeeper(wTab, v)
                else
                    wTab.won = true
                end
            end
        end

        for k, v in pairs(goalTab[tostring(startingColumn .. "." .. startingColumn)]) do
            if type(v) == "table" then
                local wTab = {}
                wTab.won = false
                checkDeeper(wTab, v)
                if wTab.won then
                    local dotPos = string.find(k, ".", 1, true)
                    local bestResult = { tonumber(string.sub(k, 1, dotPos - 1)), tonumber(string.sub(k, dotPos + 1)) }
                    return bestResult
                end
            else
                if v == "won" then
                    local dotPos = string.find(k, ".", 1, true)
                    local bestResult = { tonumber(string.sub(k, 1, dotPos - 1)), tonumber(string.sub(k, dotPos + 1)) }
                    return bestResult
                end
            end
        end
        return
    end
    local bestResult
    if rTab and type(rTab) == "table" then
        bestResult = getGoalResult(rTab)
    end
    usedPos = {}
    frontierQueue = {}
    rTab ={}
    if bestResult then
        return { bestResult[1], bestResult[2] }, system.getTimer() - startTime
    end
end


return algorythm
