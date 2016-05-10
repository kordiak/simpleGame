display.setStatusBar(display.HiddenStatusBar)

local saveAndLoad = require("code.global.saveAndLoad")
local composer = require("composer")
local properties = require("code.global.properties")
local boardCreator = require("code.modules.board")
local enemyCreator = require("code.modules.enemyCreator")
local algorythms = require("code.algorythms.algorythmTab")
local bestGoalPlace = require("code.algorythms.bestGoalPlace")
local button = require("code.modules.button")
local settingsPopup = require("code.modules.settingsPopup")

-- [Nash A. & al. pseudocode](http://aigamedev.com/open/tutorials/theta-star-any-angle-paths/)


local scene = composer.newScene()
local sceneGroup
local saveFileData

local function close()
end

function scene:create(event)
    saveFileData = saveAndLoad.load(properties.saveFile)
    sceneGroup = self.view

    local enemyMove, enemyMoveCompleted -- reference to function
    local paused = true
    local readyToUnPause = true
    local pauseButton, playButton
    local moveCounter = 0
    local goalBlocked = false

    local statistics = {}

    local function initalizeStatisticis()
        statistics = nil
        statistics = {
            won = false,
            maxDecisionTime = 0,
            minimalDecisionTime = math.huge,
            avarageDecisionTime = 0,
            totalDecisionTimes = 0,
            algorythmName = "",
            decisionTimes = {}
        }
        statistics.gridWidth = 6
        statistics.girdHeight = 6
    end
    initalizeStatisticis()

    local function addStatistics(decisionTime)
        if decisionTime then
        if statistics.minimalDecisionTime > decisionTime then
            statistics.minimalDecisionTime = decisionTime
        end
        if statistics.maxDecisionTime < decisionTime then
            statistics.maxDecisionTime = decisionTime
        end


        table.insert(statistics.decisionTimes, decisionTime)
            end
    end

    local moveTime = properties.movmentTime
    local enemies = {}

    local bg = display.newRect(properties.center.x, properties.center.y, properties.width, properties.height)
    bg:setFillColor(unpack(properties.contentColor))
    sceneGroup:insert(bg)

    local function ratePopup()
        local rateGroup = display.newGroup()

        local function rated(rate)
            statistics.rating= rate
            rateGroup:removeSelf()
            rateGroup=nil

            saveAndLoad.save(statistics,statistics.algorythmName.."_"..os.date("%Y_%m_%d")..system.getTimer()..".txt")
            initalizeStatisticis()
        end

        local bg = display.newRect(properties.center.x, properties.center.y, properties.width, properties.height)
        bg.alpha = 0.8
        rateGroup:insert(bg)

        local b1 = button.togBtn(1,false,rated)
        b1.x = properties.width * 0.33
        b1.y = 150
        rateGroup:insert(b1)
        local b2 = button.togBtn(2,false,rated)
        b2.y = b1.y
        b2.x = properties.width * 0.66
        rateGroup:insert(b2)
        local b3 = button.togBtn(3,false,rated)
        b3.y = b1.y + 150
        b3.x = properties.width * 0.25
        rateGroup:insert(b3)
        local b4 = button.togBtn(4,false,rated)
        b4.y = b3.y
        b4.x = properties.width * 0.5
        rateGroup:insert(b4)
        local b5 = button.togBtn(5,false,rated)
        b5.y = b4.y
        b5.x = properties.width * 0.75
        rateGroup:insert(b5)

    end

    local board, gridTab, elementSize = boardCreator.new({ width = statistics.gridWidth, height = statistics.girdHeigh })
    sceneGroup:insert(board)

    local goal = enemyCreator.new(gridTab, elementSize, 3, 4, true)
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
        if paused then
            readyToUnPause = true
            return
        end

        if properties.pauseAfter then
            playButton.isVisible = true
            pauseButton.isVisible = false
            paused = true
            return
        end
        enemyMove()
    end

    local enemiesMoveCounter = 0

    local function gameOver()
        print("GAME OVER ", moveCounter)
        for i = 1, #statistics.decisionTimes do
            statistics.totalDecisionTimes = statistics.totalDecisionTimes + statistics.decisionTimes[i]
        end
        statistics.avarageDecisionTime = statistics.totalDecisionTimes / #statistics.decisionTimes



        ratePopup()
    end

    function enemyMoveCompleted()

        enemiesMoveCounter = enemiesMoveCounter + 1
        if enemiesMoveCounter == #enemies then
            enemiesMoveCounter = 0
            local movePosition, decisionTime, limitReached = bestGoalPlace.calculate(gridTab, goal.positions, goal) -- if limit is reached it means algorythm wasn't able to compute  all possible results in givin amount of iterations so result might not be actual best one out of all.
            if movePosition then
                gridTab[goal.positions[1]][goal.positions[2]].goal = nil
                goal.positions = movePosition
                gridTab[goal.positions[1]][goal.positions[2]].goal = goal
                moveCounter = moveCounter + 1
                print(moveCounter)
                if moveCounter > properties.maxGoalMoves then
                    gameOver()
                    return
                end

                if moveTime <= 0 then
                    goal.x = gridTab[movePosition[1]][movePosition[2]].cell.x
                    goal.y = gridTab[movePosition[1]][movePosition[2]].cell.y
                    goalMoveCompleted()
                else
                    transition.to(goal, { x = gridTab[movePosition[1]][movePosition[2]].cell.x, y = gridTab[movePosition[1]][movePosition[2]].cell.y, time = moveTime, onComplete = goalMoveCompleted })
                end
            else
                goalBlocked = true
                gameOver()
            end
        end
    end

    enemyMove = function()
        for i = 1, #enemies do
            local enemy = enemies[i]
            local movePosition, decisionTime = pickedAlgorythm(gridTab, enemy.positions, goal.positions)
            addStatistics(decisionTime)
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


    --     timer.performWithDelay(800, enemyMove, -1)

    local function setSettingsCb()
        moveTime = properties.movmentTime
    end

    local function settingsCb()
        settingsPopup.new(saveFileData, setSettingsCb)
    end



    local function playCb()
        print(paused, readyToUnPause)
        if paused and readyToUnPause then
            board.blockBoard()
            paused = false
            playButton.isVisible = false
            pauseButton.isVisible = true
            enemyMove()
        else
            print("PAUSING!")
            board.blockBoard()
            readyToUnPause = false
            paused = true
            playButton.isVisible = true
            pauseButton.isVisible = false
        end
    end

    local settingsIcon = display.newImageRect("graphic/settings.png", 128, 128)
    settingsIcon.x = properties.x + settingsIcon.contentWidth * 0.5 + 5
    settingsIcon.y = properties.y + properties.height - settingsIcon.contentHeight * 0.5 - 5
    sceneGroup:insert(settingsIcon)
    button.mb(settingsIcon, settingsCb)

    playButton = display.newImageRect("graphic/play.png", 128, 128)
    playButton.x = settingsIcon.x + playButton.contentWidth * 0.5 + settingsIcon.contentWidth * 0.5
    playButton.y = settingsIcon.y
    playButton.isHitTestable = true
    button.mb(playButton, playCb)
    sceneGroup:insert(playButton)

    pauseButton = display.newImageRect("graphic/pause.png", 128, 128)
    pauseButton.isVisible = false
    pauseButton.x = playButton.x
    pauseButton.y = playButton.y
    sceneGroup:insert(pauseButton)


    --   saveAndLoad.save({}, properties.saveFile)
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



