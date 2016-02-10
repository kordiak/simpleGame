--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 21:59
-- To change this template use File | Settings | File Templates.
--
local enemy = {}

enemy.new = function(gridTab, elementSize, positions)
    local enemy = display.newRect(gridTab[positions[1]][positions[2]].cell.x, gridTab[positions[1]][positions[2]].cell.y, elementSize * 0.8, elementSize * 0.8)
    enemy:setFillColor(1,0,0)
    gridTab[positions[1]][positions[2]].content = enemy
    enemy.positions = positions
    return enemy
end

return enemy