--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:59
-- To change this template use File | Settings | File Templates.
--
local enemy = {}

enemy.new = function(gridTab, elementSize, column, row, goal)
    local enemy = display.newRect(gridTab[column][row].cell.x, gridTab[column][row].cell.y, elementSize * 0.8, elementSize * 0.8)
    enemy:setFillColor(1, 0, 0)
    if goal then
        enemy:setFillColor(0, 1, 0)
        gridTab[column][row].goal = enemy
    else
        gridTab[column][row].content = enemy
    end
    enemy.positions = { column, row }
    return enemy
end

return enemy