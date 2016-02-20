display.setStatusBar(display.HiddenStatusBar)

local saveAndLoad = require("code.global.saveAndLoad")
local composer = require("composer")
local properties = require("code.global.properties")
local boardCreator = require("code.modules.board")
local enemyCreator = require("code.modules.enemyCreator")
local algorythms = require("code.algorythms.algorythmTab")
local bestGoalPlace = require("code.algorythms.bestGoalPlace")
local button = require("code.modules.button")

-- [Nash A. & al. pseudocode](http://aigamedev.com/open/tutorials/theta-star-any-angle-paths/)


local scene = composer.newScene()
local sceneGroup

local function close()
end

function scene:create(event)
    sceneGroup = self.view

    local enemyMove, enemyMoveCompleted -- reference to function

    local moveCounter = 0


    local goalMovedTimes = 1
    local goalMoveAmount = 1
    local moveTime = 500
    local enemies = {}

    local board, gridTab, elementSize = boardCreator.new({ width = 8, height = 8 })
    sceneGroup:insert(board)

    local goal = enemyCreator.new(gridTab, elementSize, 5, 7, true)
    sceneGroup:insert(goal)

    local enemy = enemyCreator.new(gridTab, elementSize, 1, 1)
    sceneGroup:insert(enemy)
    table.insert(enemies, enemy)
    --        local enemy = enemyCreator.new(gridTab, elementSize, 1, 2)
    --        table.insert(enemies, enemy)
    --        local enemy = enemyCreator.new(gridTab, elementSize, 1, 3)
    --        table.insert(enemies, enemy)
    --        local enemy = enemyCreator.new(gridTab, elementSize, 1, 4)
    --        table.insert(enemies, enemy)
    --        local enemy = enemyCreator.new(gridTab, elementSize, 1, 5)
    --        table.insert(enemies, enemy)



    local pickedAlgorythm, algorythmName = algorythms.chooseAlgorythm()

    local function goalMoveCompleted()
        goalMovedTimes = goalMovedTimes + 1
        if goalMovedTimes > goalMoveAmount then
            enemyMove()
        else
            enemyMoveCompleted()
        end
    end

    local enemiesMoveCounter = 0
    function enemyMoveCompleted()
        --        if true then
        --            return true
        --        end
        enemiesMoveCounter = enemiesMoveCounter + 1
        if enemiesMoveCounter == #enemies then
            enemiesMoveCounter = 0
            local movePosition, decisionTime, limitReached = bestGoalPlace.calculate(gridTab, goal.positions, goal) -- if limit is reached it means algorythm wasn't able to compute  all possible results in givin amount of iterations so result might not be actual best one out of all.
            if movePosition then
                gridTab[goal.positions[1]][goal.positions[2]].goal = nil
                goal.positions = movePosition
                gridTab[goal.positions[1]][goal.positions[2]].goal = goal
                moveCounter = moveCounter + 1
                if moveTime <= 0 then
                    goal.x = gridTab[movePosition[1]][movePosition[2]].cell.x
                    goal.y = gridTab[movePosition[1]][movePosition[2]].cell.y
                    goalMoveCompleted()
                else
                    transition.to(goal, { x = gridTab[movePosition[1]][movePosition[2]].cell.x, y = gridTab[movePosition[1]][movePosition[2]].cell.y, time = moveTime, onComplete = goalMoveCompleted })
                end
            else
                print("GAME OVER ", moveCounter)
            end
        end
    end

    enemyMove = function()
        goalMovedTimes = 1
        for i = 1, #enemies do
            local enemy = enemies[i]
            local movePosition, decisionTime = pickedAlgorythm(gridTab, enemy.positions, goal.positions)
            if movePosition then
                if (movePosition[1] == goal.positions[1]) and (movePosition[2] == goal.positions[2]) then
                    enemyMoveCompleted()
                else
                    gridTab[enemy.positions[1]][enemy.positions[2]].content = nil
                    enemy.positions = movePosition
                    gridTab[enemy.positions[1]][enemy.positions[2]].content = enemy
                    if moveTime <= 0 then
                        enemy.x = gridTab[movePosition[1]][movePosition[2]].cell.x
                        enemy.y = gridTab[movePosition[1]][movePosition[2]].cell.y
                        enemyMoveCompleted()
                    else
                        transition.to(enemy, { x = gridTab[movePosition[1]][movePosition[2]].cell.x, y = gridTab[movePosition[1]][movePosition[2]].cell.y, time = moveTime, onComplete = enemyMoveCompleted })
                    end
                end
            else
                enemyMoveCompleted()
            end
        end
    end

    enemyMove()
    --     timer.performWithDelay(800, enemyMove, -1)

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



