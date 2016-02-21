--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 20:13
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")
local button = require("code.modules.button")

local board = {}

board.new = function(params)
    if not params then params = {} end

    local group = display.newGroup()
    local boardTab = {}

    local width = params.width or params.height or 2
    local height = params.height or params.width or 2

    local elementSizeIndicator = (properties.width * 0.95 / width)
    if elementSizeIndicator > (properties.height * 0.8 / height) then
        elementSizeIndicator = (properties.height * 0.8 / height)
    end

    local elementSize = math.round(elementSizeIndicator * 0.95)
    local blocked = false
    local getCell = false

    group.blockBoard = function()
        blocked = not blocked
        log:debug("BOARD IS BLOCKED : %s", tostring(blocked))
    end

    local function setCell(target)
        if getCell then
            return target.column, target.row
        end
        if not blocked then
            if not boardTab[target.column][target.row].goal then
                if not boardTab[target.column][target.row].content then
                    local obstacle = display.newRect(0, 0, elementSize * 0.8, elementSize * 0.8)
                    obstacle:setFillColor(0, 0, 1)
                    obstacle.wall = true
                    obstacle.x = boardTab[target.column][target.row].cell.x
                    obstacle.y = boardTab[target.column][target.row].cell.y
                    group:insert(obstacle)
                    boardTab[target.column][target.row].content = obstacle
                elseif boardTab[target.column][target.row].content.wall then
                    boardTab[target.column][target.row].content:removeSelf()
                    boardTab[target.column][target.row].content = nil
                end
            end
        end
    end

    for i = 1, width do
        boardTab[i] = {}
        for j = 1, height do
            local cell = display.newRect(0, 0, elementSize, elementSize)
            cell.strokeWidth = 2
            cell:setFillColor(unpack(properties.contentColor))
            cell:setStrokeColor(unpack(properties.borderColor))
            cell.x = properties.x + (i - 1) * elementSizeIndicator + elementSizeIndicator * (0.5 + width * 0.025)
            cell.y = properties.y + (j - 1) * elementSizeIndicator + elementSizeIndicator * 0.5
            cell.column = i
            cell.row = j
            local cellIndicator = display.newText({ text = i .. "," .. j, font = "", fontSize = elementSizeIndicator / 3, x = cell.x, y = cell.y + elementSizeIndicator * 0.25 })
            local stepText = display.newText({ text = "", font = "", fontSize = elementSizeIndicator / 3, x = cell.x, y = cell.y - elementSizeIndicator * 0.2 })
            cellIndicator:setFillColor(unpack(properties.borderColor))
            stepText:setFillColor(unpack(properties.borderColor))
            boardTab[i][j] = { cell = cell, stepText = stepText }
            group:insert(cell)
            --  group:insert(cellIndicator)
            --  group:insert(stepText)


            button.mb(cell, setCell)
        end
    end

    --  shallowLogTable(boardTab,3)



    log:debug("element Size is : %s", tostring(elementSize))
    return group, boardTab, elementSize
end

return board