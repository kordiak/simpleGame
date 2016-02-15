--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 20:13
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")

local board = {}

board.new = function(params)
    if not params then params = {} end

    local group = display.newGroup()
    local boardTab = {}

    local width = params.width or params.height or 2
    local height = params.height or params.width or  2

    local elementSizeIndicator = (properties.width * 0.95 / width)
    if elementSizeIndicator > (properties.height * 0.95 / height) then
        elementSizeIndicator = (properties.height * 0.95 / height)
    end

    local elementSize = math.round(elementSizeIndicator * 0.95)

    for i = 1, width do
        boardTab[i] = {}
        for j = 1, height do
            local cell = display.newRect(0, 0, elementSize, elementSize)
            cell.strokeWidth = 2
            cell:setFillColor( 0,0,0 )
            cell.x = properties.x + (i - 1) * elementSizeIndicator + elementSizeIndicator * (0.5 + width * 0.025)
            cell.y = properties.y + (j - 1) * elementSizeIndicator + elementSizeIndicator * 0.5
            local cellIndicator = display.newText({ text = i .. "," .. j, font = "", fontSize = elementSizeIndicator/3, x = cell.x, y = cell.y })
            boardTab[i][j] = { cell = cell }
         --   cellIndicator:setFillColor(0, 0, 0)
            group:insert(cell)
            group:insert(cellIndicator)
        end
    end

  --  shallowLogTable(boardTab,3)



    log:debug("element Size is : %s", tostring(elementSize))
    return group, boardTab, elementSize
end

return board