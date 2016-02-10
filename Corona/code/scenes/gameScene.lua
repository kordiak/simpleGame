display.setStatusBar(display.HiddenStatusBar)

local saveAndLoad = require("code.global.saveAndLoad")
local composer = require("composer")
local properties = require("code.global.properties")
local boardCreator = require("code.modules.board")
local enemyCreator = require("code.modules.enemyCreator")
local algorythms = require("code.algorythms.algorythmTab")
local button = require("code.modules.button")


local scene = composer.newScene()
local sceneGroup

local function close()
end

function scene:create(event)
    sceneGroup = self.view

    local board, gridTab, elementSize = boardCreator.new({ width = 5, height = 10 })
    local enemy = enemyCreator.new(gridTab, elementSize, { 1, 1 })
    local goal = enemyCreator.new(gridTab, elementSize, { 5, 5 })
    local pickedAlgorythm, algorythmName = algorythms.chooseAlgorythm()

    local enemyMove = function()
        local movePosition, decisionTime = pickedAlgorythm(gridTab, enemy.positions, goal.positions)
        gridTab[enemy.positions[1]][enemy.positions[2]].content = nil
        enemy.positions = movePosition
        transition.to(enemy, { x = gridTab[movePosition[1]][movePosition[2]].cell.x, y = gridTab[movePosition[1]][movePosition[2]].cell.y, time = 500 })
        gridTab[enemy.positions[1]][enemy.positions[2]].content = enemy
    end

    timer.performWithDelay(800, enemyMove, -1)

    sceneGroup:insert(board)
    sceneGroup:insert(enemy)

    saveAndLoad.save({}, properties.saveFile)
end

function scene:show(event)
    if (event.phase == "did") then
    end
end


function scene:hide(event)
    if (event.phase == "did") then
    end
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene



