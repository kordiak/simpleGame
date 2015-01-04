display.setStatusBar(display.HiddenStatusBar)

local popUp = require("code.popUps.popUp")
local saveAndLoad = require("code.global.saveAndLoad")
local composer = require("composer")
local properties = require("code.global.properties")
local boardCreator = require("code.boardLibrary.boardCreator")
local boardCreator = require("code.boardLibrary.boardCreator")
local properties = require("code.global.properties")
local Enemy = require("code.classes.Enemy");
local Player = require("code.classes.Player");
local elementCreator = require("code.classes.elementCreator");
local forestGeneratorHelper = require("code.boardLibrary.forestGeneratorHelper")

local mainHero, levelGoal, mainBoard, heroCanMove, hexAxe, hexRestart, forestRandomizer, forestOccupiedTab, backGroundOfMainMap, checkingIfMoreGhostsToRemove
local isBlocked = false
local popUpShown = false

local ghostPosInTabToRemove = {}
local functions = {}
local enemiesTable = {}
local simpleGhostEnemiesTable = {}
local advencedGhostEnemiesTable = {}
local distanceEnemyAndHero = {}
local maxDistanceEnemyAndHero = {}
local miniDistanceEnemyAndHero = {}
miniDistanceEnemyAndHero.distance = properties.miniDistanceHandler
maxDistanceEnemyAndHero.distance = 0
local overlay, play, load, exit, sceneGroup, removeEnemy

table.insert(enemiesTable, simpleGhostEnemiesTable)
table.insert(enemiesTable, advencedGhostEnemiesTable)

heroCanMove = true
mainBoard = boardCreator;

local scene = composer.newScene()

local function close()
    composer.gotoScene("")
    composer.removeScene("")
end

function scene:create(event)
    sceneGroup = self.view
    --    local myText = display.newText({ text = 0, font = properties.font, fontSize = properties.resourcesUsageFont })
    --    myText:scale(0.7, 0.7)
    --    myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
    --    myText:setFillColor(1, 1, 1)
    --    sceneGroup:insert(myText)
    local levelIndicator = display.newText({ text = "Level " .. properties.currentLevel, font = properties.font, fontSize = properties.resourcesUsageFont })
    levelIndicator:scale(0.7, 0.7)
    levelIndicator.x, levelIndicator.y = properties.x + levelIndicator.contentWidth * 0.5 + 35, properties.y + levelIndicator.height / 2 + 10
    levelIndicator:setFillColor(1, 1, 1)
    sceneGroup:insert(levelIndicator)
    functions.afterGhostRemoveCallBack = function()
        popUpShown = false
    end
    functions.saveIntoFiles = function()
        local tabToSave
        local saveFile = saveAndLoad.load(properties.saveFile)
        if saveFile then
            logTable(saveFile)
            tabToSave = saveFile
            if tabToSave.level < properties.currentLevel then
                tabToSave.level = properties.currentLevel
            end
        else
            tabToSave = {
                level = properties.currentLevel,
                heroTransTime = properties.heroTransTime,
                enemyTransTime = properties.enemyTransTime
            }
        end
        --    tabToSave.level = 5

        saveAndLoad.save(tabToSave, properties.saveFile)
    end


    functions.removeGhosts = function(score)
        local transCounter = 0
        local GhostToRemove
        if score == 1 then
            GhostToRemove = 1
        else
            GhostToRemove = math.round(score / 2)
        end
        print("GhostsToRemoveNumber is " .. GhostToRemove)
        for i = 1, #mainBoard[mainHero.currentHex].coherentHexes do
            for j = 1, #simpleGhostEnemiesTable do
                if mainBoard[mainHero.currentHex].coherentHexes[i] == simpleGhostEnemiesTable[j].currentHex then
                    if not simpleGhostEnemiesTable[j].notHere then
                        if GhostToRemove > 0 then
                            GhostToRemove = GhostToRemove - 1
                            removeEnemy = function(hexToRemove, extraGhost)
                                local hexNum = simpleGhostEnemiesTable[hexToRemove].currentHex
                                simpleGhostEnemiesTable[hexToRemove].notHere = true
                                table.insert(ghostPosInTabToRemove, hexToRemove)
                                mainBoard[hexNum].isFree = true
                                mainBoard[hexNum].isWalkAble = true
                                if mainBoard[hexNum].content then
                                    mainBoard[hexNum].content:removeSelf()
                                    mainBoard[hexNum].content = nil
                                end
                                transCounter = transCounter - 1
                                if transCounter == 0 then
                                    timer.performWithDelay(50, functions.afterGhostRemoveCallBack)
                                end
                                if extraGhost then
                                    functions.ghostToRemoveAgain()
                                end
                            end
                            transCounter = transCounter + 1
                            transition.to(simpleGhostEnemiesTable[j], { time = 1200, rotation = 960, xScale = 0.1, yScale = 0.1, onComplete = function() removeEnemy(j) end })
                            --- print("HEX THAT NEEMY IS ON IS " .. simpleGhostEnemiesTable[j].currentHex)
                        end
                    end
                end
            end
        end
        functions.ghostToRemoveAgain = function()
            local flag = false
            if GhostToRemove > 0 then
                print("GhostToRemove", GhostToRemove)
                local p = math.random(1, #simpleGhostEnemiesTable)
                if not simpleGhostEnemiesTable[p].notHere then
                    simpleGhostEnemiesTable[p].notHere = true
                    GhostToRemove = GhostToRemove - 1
                    transition.to(simpleGhostEnemiesTable[p], { time = 1200, rotation = 960, xScale = 0.1, yScale = 0.1, onComplete = function() removeEnemy(p, true) end })
                else
                    for o = 1, #simpleGhostEnemiesTable do
                        if not simpleGhostEnemiesTable[o].notHere then
                            flag = true
                        end
                    end
                    if flag then
                        functions.ghostToRemoveAgain()
                    end
                end
            end
        end
        functions.ghostToRemoveAgain()
    end
    functions.lostGame = function()
        local popUpOne
        local function popUpCallBack()
            popUpOne.removeMe()
            --  mainBoard.removeMe()
            local options = { effect = "crossFade", time = properties.firstSceneFadeTime }
            local fileToSave = saveAndLoad.load(properties.saveFile)

            if fileToSave then
                if fileToSave.level > 4 then
                    properties.currentLevel = fileToSave.level - (math.fmod(fileToSave.level, 5))
                    if properties.startingFromBeggining then
                    properties.currentLevel = 0
                        end
                end

            else
                properties.currentLevel = 0
            end
            print(" properties.currentLevel = 0", properties.currentLevel)
            functions.newLevel()

            composer.gotoScene("code.scenes.firstScene", options)
            --composer.removeScene("code.scenes.gameScene")
        end

        local params = {
            text = "You lost",
            text2 = "Boss was stronger",
            fillColor = { 1, 1, 1, 0.8 },
            callBack = popUpCallBack,
            cancelCallBack = nil,
            textColor = { 0, 0, 0 },
            tapToContinue = true,
            twoLines = true,
        }
        popUpOne = popUp.newPopUp1(params)
        sceneGroup:insert(popUpOne)
    end
    functions.afterBossFight = function()
        local score
        print(properties.bossScene2Scor, properties.bossScene1Scor)
        if properties.started == true then
            if properties.bossScene2Score > 0 then
                score = properties.bossScene2Score
                properties.bossScene2Score = 0
            elseif properties.bossScene1Score > 0 then
                score = properties.bossScene1Score
                properties.bossScene1Scor = 0
            else
                functions.lostGame()
            end
        end
        if score then
            functions.removeGhosts(score)
        end
    end
    --- CURRENTLY NOT USED MAIN MENU
    functions.mainMenuTouch = function(event)
        if event.phase == "ended" then
            --  print (event.target.name)
            if event.target.name == "play" then
                functions.hiddingMainMenu()
                functions.startGame()
            end
        end
        return true
    end
    functions.endGamePopup = function()
        local popUpOne
        local function popUpCallBack()
            popUpOne.removeMe()
            popUpShown = false
            local options = { effect = "crossFade", time = properties.firstSceneFadeTime }
            local rand = math.random(1, (properties.bossScene1Chance + properties.bossScene2Chance))
            if rand < properties.bossScene1Chance then
                properties.bossScene1Chance = properties.bossScene1Chance + 10
                properties.bossScene2Chance = properties.bossScene2Chance - 10
                composer.gotoScene("code.scenes.bossScene", options)
            else
                properties.bossScene1Chance = properties.bossScene1Chance - 10
                properties.bossScene2Chance = properties.bossScene2Chance + 10
                composer.gotoScene("code.scenes.bossScene2", options)
            end
        end

        local params = {
            text = "You got blocked",
            text2 = "Boss fight awaits",
            fillColor = { 1, 1, 1, 0.8 },
            callBack = popUpCallBack,
            cancelCallBack = nil,
            textColor = { 0, 0, 0 },
            tapToContinue = true,
            twoLines = true,
        }
        popUpOne = popUp.newPopUp1(params)
        sceneGroup:insert(popUpOne)
    end
    functions.isBlockedChecker = function()
        isBlocked = true
        for i = 1, #mainBoard[mainHero.currentHex].coherentHexes do
            if mainBoard[mainBoard[mainHero.currentHex].coherentHexes[i]].isFree then
                isBlocked = false
            end
            if mainBoard[mainBoard[mainHero.currentHex].coherentHexes[i]].content == levelGoal then
                isBlocked = false
            end
        end
        if isBlocked == true then
            if popUpShown == false then
                popUpShown = true
                functions.endGamePopup()
                media.stopSound()
            end
        end
        heroCanMove = true
    end
    functions.insertingIntoScenegroup = function()
        for i = 1, #mainBoard do
            sceneGroup:insert(mainBoard[i])
            sceneGroup:insert(mainBoard[i].text)
            mainBoard[i].text:toBack()
            mainBoard[i]:toBack()
            backGroundOfMainMap:toBack()
        end
        for i = 1, #simpleGhostEnemiesTable do
            sceneGroup:insert(simpleGhostEnemiesTable[i])
        end
        sceneGroup:insert(levelGoal)
        sceneGroup:insert(mainHero)
        --  sceneGroup:insert(hexAxe)
        -- sceneGroup:insert(hexAxe.backGround)
        --  sceneGroup:insert(hexRestart)
    end
    functions.forestGeneratorHelper = function()
        forestOccupiedTab = forestGeneratorHelper.new()
        forestRandomizer = math.random(1, #forestOccupiedTab)
        for i = 1, #forestOccupiedTab[forestRandomizer] do
            mainBoard[forestOccupiedTab[forestRandomizer][i]].isFree = false
        end
    end
    functions.startGame = function()
        functions.saveIntoFiles()
        functions.environmentGenerator = function()
            functions.forestGeneratorHelper()
            local numberOfForest = properties.numberOfForests - 1 + math.random(1, 6)
            for i = 1, properties.numberOfForests do
                local r = math.random(1, 3)
                local q = true
                while q do
                    local i = math.random(1, #mainBoard)
                    if mainBoard[i].isFree then
                        local smallForest = display.newImageRect(properties.environment[r], 90, 90)
                        smallForest.x = mainBoard[i].x
                        smallForest.y = mainBoard[i].y
                        mainBoard[i].isFree = false
                        mainBoard[i].isWalkAble = false
                        mainBoard[i].content = smallForest
                        properties.lastPickedHexForEnvironmentForestGenerator = i
                        q = false
                        sceneGroup:insert(smallForest)
                        local eviCount = math.round(((((properties.currentLevel - properties.forestSize) ^ 2) ^ (1 / 2))) / properties.numberOfForests)
                        if eviCount < 3 then
                            eviCount = 3
                        end
                        for j = 1, eviCount do
                            local o = true
                            local whileCounter = 0
                            while o do
                                local c = math.random(1, #mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes)
                                whileCounter = whileCounter + 1
                                if mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].isFree then
                                    local smallForest = display.newImageRect(properties.environment[r], 90, 90)
                                    sceneGroup:insert(smallForest)
                                    smallForest.x = mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].x
                                    smallForest.y = mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].y
                                    mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].isFree = false
                                    mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].isWalkAble = false
                                    mainBoard[mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]].content = smallForest
                                    properties.lastPickedHexForEnvironmentForestGenerator = mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c]
                                    o = false
                                end
                                if whileCounter > 2500 then
                                    o = false
                                end
                            end
                        end
                    end
                end
                for i = 1, #simpleGhostEnemiesTable do
                    simpleGhostEnemiesTable[i]:toFront()
                end
                mainHero:toFront()
            end
            for i = 1, #forestOccupiedTab[forestRandomizer] do
                if not mainBoard[forestOccupiedTab[forestRandomizer][i]].content then
                    --- mainBoard[forestOccupiedTab[forestRandomizer][i]]:setFillColor (1,1,1)
                    mainBoard[forestOccupiedTab[forestRandomizer][i]].isFree = true
                end
            end
        end
        elementCreator.new(mainBoard, functions.environmentGenerator, simpleGhostEnemiesTable, enemiesTable);
        mainHero, levelGoal = elementCreator.mainHeroCreator(mainHero, levelGoal)
        elementCreator.enemyCreator()
        --- functions.HUDCreator()
        if not backGroundOfMainMap then
            backGroundOfMainMap = display.newImageRect("graphicsRaw/backGrounds/gameBackground.jpg", properties.width, properties.height)
            backGroundOfMainMap.x, backGroundOfMainMap.y = properties.center.x, properties.center.y
            sceneGroup:insert(backGroundOfMainMap)
        end
        functions.insertingIntoScenegroup()
    end
    functions.newLevel = function()
        transition.cancel(mainHero)
        heroCanMove = true
        mainBoard[mainHero.currentHex].isFree = true
        mainBoard[mainHero.currentHex].isWalkAble = true
        mainHero.x = mainBoard[#mainBoard].x
        mainHero.y = mainBoard[#mainBoard].y
        mainBoard[#mainBoard].isFree = false
        mainBoard[#mainBoard].isWalkAble = false
        mainHero.currentHex = #mainBoard
        simpleGhostEnemiesTable = {}
        for i = 1, #mainBoard do
            if mainBoard[i].content then
                if mainBoard[i].content ~= levelGoal then
                    mainBoard[i].content:removeSelf()
                    mainBoard[i].isFree = true
                    mainBoard[i].isWalkAble = true
                    mainBoard[i].content = nil
                end
            end
        end
        properties.currentLevel = properties.currentLevel + 1

        functions.startGame()
        levelIndicator.text = "Level " .. properties.currentLevel
    end
    functions.transCompleted = function()
        functions.enemyMove()
    end
    functions.distanceForEnemyReset = function()
        miniDistanceEnemyAndHero.hexNumber = nil
        maxDistanceEnemyAndHero.hexNumber = nil
        miniDistanceEnemyAndHero.distance = properties.miniDistanceHandler
        maxDistanceEnemyAndHero.distance = 0
    end
    functions.enemyTransCompleted = function()
        functions.isBlockedChecker()
    end
    functions.simpleGhostEnemiesMove = function(monster)
        for j = 1, #mainBoard[monster.currentHex].coherentHexes do
            local a = mainBoard[monster.currentHex].coherentHexes[j]
            distanceEnemyAndHero = (((((((mainBoard[a].x) ^ 2) ^ (1 / 2)) - (((mainBoard[mainHero.currentHex].x) ^ 2) ^ (1 / 2))) ^ 2) ^ (1 / 2)) + ((((((mainBoard[a].y) ^ 2) ^ (1 / 2)) - (((mainBoard[mainHero.currentHex].y) ^ 2) ^ (1 / 2))) ^ 2) ^ (1 / 2)))
            if maxDistanceEnemyAndHero.distance < distanceEnemyAndHero then
                if mainBoard[a].isFree == true then
                    maxDistanceEnemyAndHero.distance = distanceEnemyAndHero
                    maxDistanceEnemyAndHero.hexNumber = a
                end
            end
            if miniDistanceEnemyAndHero.distance > distanceEnemyAndHero then
                if mainBoard[a].isFree == true then
                    miniDistanceEnemyAndHero.distance = distanceEnemyAndHero
                    miniDistanceEnemyAndHero.hexNumber = a
                end
            end
        end
        if miniDistanceEnemyAndHero.hexNumber then
            mainBoard[monster.currentHex].isFree = true
            mainBoard[monster.currentHex].isWalkAble = true
            mainBoard[miniDistanceEnemyAndHero.hexNumber].content = mainBoard[monster.currentHex].content
            mainBoard[monster.currentHex].content = nil
            monster.currentHex = miniDistanceEnemyAndHero.hexNumber
            mainBoard[miniDistanceEnemyAndHero.hexNumber].isFree = false
            mainBoard[monster.currentHex].isWalkAble = false
            transition.to(monster, { time = properties.enemyTransTime, x = mainBoard[monster.currentHex].x, y = mainBoard[monster.currentHex].y, onComplete = functions.enemyTransCompleted })
            functions.distanceForEnemyReset()
        end
    end
    functions.roflmaoGhostEnemiesMove = function(monster)
        local p = true
        local pcounter = 0
        while p do
            pcounter = pcounter + 1
            local randHex = math.random(1, #mainBoard[monster.currentHex].coherentHexes)
            local a = mainBoard[monster.currentHex].coherentHexes[randHex]
            if mainBoard[a].isFree == true then
                miniDistanceEnemyAndHero.hexNumber = a
            end
            if pcounter > 1500 then
                p = false
            end
        end
        if miniDistanceEnemyAndHero.hexNumber then
            mainBoard[monster.currentHex].isFree = true
            mainBoard[monster.currentHex].isWalkAble = true
            mainBoard[miniDistanceEnemyAndHero.hexNumber].content = mainBoard[monster.currentHex].content
            mainBoard[monster.currentHex].content = nil
            monster.currentHex = miniDistanceEnemyAndHero.hexNumber
            mainBoard[miniDistanceEnemyAndHero.hexNumber].isFree = false
            mainBoard[monster.currentHex].isWalkAble = false
            transition.to(monster, { time = properties.enemyTransTime, x = mainBoard[monster.currentHex].x, y = mainBoard[monster.currentHex].y, onComplete = functions.enemyTransCompleted })
            functions.distanceForEnemyReset()
        end
    end
    functions.enemyMove = function()
        for i = 1, #simpleGhostEnemiesTable do
            if not simpleGhostEnemiesTable[i].notHere then
                if simpleGhostEnemiesTable[i].diff == 4 then
                    functions.simpleGhostEnemiesMove(simpleGhostEnemiesTable[i])
                elseif simpleGhostEnemiesTable[i].diff == 5 then
                    functions.roflmaoGhostEnemiesMove(simpleGhostEnemiesTable[i])
                else
                    local randomizer = math.random(1, 10)
                    if randomizer < 3 then
                        functions.roflmaoGhostEnemiesMove(simpleGhostEnemiesTable[i])
                    else
                        functions.simpleGhostEnemiesMove(simpleGhostEnemiesTable[i])
                    end
                end
            end
        end
        local flag = false
        for o = 1, #simpleGhostEnemiesTable do
            if simpleGhostEnemiesTable[o].notHere then
                flag = true
            end
        end
        if flag then
            heroCanMove = true
        end
    end
    functions.hexPressed = function(params)
        if heroCanMove == true then
            for i = 1, #mainBoard[mainHero.currentHex].coherentHexes do
                if mainBoard[mainHero.currentHex].coherentHexes[i] == tonumber(params.hexNumber) then
                    if mainBoard[tonumber(params.hexNumber)].isWalkAble == true then
                        print("MOVING TOOO", params.hexNumber)
                        mainBoard[mainHero.currentHex].isFree = true
                        mainBoard[mainHero.currentHex].isWalkAble = true
                        mainHero.currentHex = tonumber(params.hexNumber)
                        heroCanMove = false
                        transition.to(mainHero, { time = properties.heroTransTime, delay = 100, x = mainBoard[tonumber(params.hexNumber)].x, y = mainBoard[tonumber(params.hexNumber)].y, onComplete = functions.transCompleted })
                        --mainHero.x =  mainBoard[tonumber(params.hexNumber)].x
                        --  mainHero.y =  mainBoard[tonumber(params.hexNumber)].y
                        mainBoard[tonumber(params.hexNumber)].isWalkAble = false
                        mainBoard[tonumber(params.hexNumber)].isFree = false
                    elseif mainBoard[tonumber(params.hexNumber)].content == levelGoal or tonumber(params.hexNumber) == 1 then
                        transition.to(mainHero, { time = properties.heroTransTime, delay = 100, x = mainBoard[tonumber(params.hexNumber)].x, y = mainBoard[tonumber(params.hexNumber)].y, onComplete = functions.newLevel })
                        heroCanMove = false
                        -- mainBoard.new()
                    end
                end
            end
        end
    end
    functions.nextlevel = function()
        properties.lastPickedHexForEnvironmentForestGenerator = 0
    end
    --    functions.HUDtouch = function(event)
    --        if event.phase == "ended" then
    --            if event.target.name == "restart" then
    --                properties.currentLevel = properties.currentLevel - 1
    --                --        if properties.currentLevel < 1 then
    --                --            properties.currentLevel = 1
    --                --            end
    --                functions.newLevel()
    --            elseif event.target.name == "hexAxe" then
    --                native.requestExit()
    --            end
    --        end
    --    end

    --    functions.HUDCreator = function()
    --        if not hexAxe then
    --            hexAxe = display.newImageRect(properties.hexTexturePath, 88, 77)
    --            hexAxe.x = properties.width - hexAxe.width / 2
    --            hexAxe.y = mainBoard[#mainBoard].y + hexAxe.height * 1.5
    --            hexAxe.name = "hexAxe"
    --            hexAxe.backGround = display.newImageRect("graphicsRaw/items/axe.png", 90, 90)
    --            hexAxe.backGround.x = hexAxe.x
    --            hexAxe.backGround.y = hexAxe.y
    --            hexAxe:addEventListener("touch", functions.HUDtouch)
    --            hexRestart = display.newImageRect(properties.hexTexturePath, 88, 77)
    --            hexRestart.name = "restart"
    --            hexRestart.x = properties.x + hexRestart.width / 2
    --            hexRestart.y = mainBoard[#mainBoard].y + hexRestart.height * 1.5
    --            hexRestart:addEventListener("touch", functions.HUDtouch)
    --
    --            hexRestart.isVisible = false
    --            hexAxe.backGround.isVisible = false
    --            hexAxe.isVisible = false
    --        end
    --    end

    functions.playSoundRandom = function()


        local a = math.random(1, 7)
        local backgroundMusic = ("sounds/backGroundSoundTrack/" .. a .. ".mp3")
        --       print ("HAHAHAHAH",a,backgroundMusic)
        media.playSound(backgroundMusic, functions.playSoundRandom)

        --  media.playSound("sounds/backGroundSoundTrack/" .. a .. ".mp3")
    end

    functions.startGame()

    --  functions.playSoundRandom()

    --    local frames = 0
    --    local function getFps()
    --        local returnF = tostring(frames)
    --        frames = 0
    --        return returnF
    --    end
    --
    --    local function updateText()
    --        collectgarbage()
    --        myText.text = "  FPS : " .. getFps() .. "   Memory: " .. (math.round(collectgarbage("count") * 100)) / 100 .. "    Texture: " .. (math.round(system.getInfo("textureMemoryUsed"))) / 10000
    --        myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
    --        myText:toFront()
    --    end
    --
    local function enterframeFunc()
        -- frames = frames + 1
        --    for i = 1, #mainBoard do
        --        if  mainBoard[i].isWalkAble then
        --            mainBoard[i]:setFillColor (1,0,0,0.2)
        --        else
        --            mainBoard[i]:setFillColor (1,1,1)
        --        end
        --    end
        for i = 1, #mainBoard do
            if mainBoard[i].isFree then
                mainBoard[i]:setFillColor(1, 1, 1)
            else
                mainBoard[i]:setFillColor(1, 0, 0)
            end
        end
    end

    --
    --    timer.performWithDelay(1000, updateText, 0)
    --  Runtime:addEventListener("enterFrame", enterframeFunc)

    Runtime:addEventListener("hexPressed", functions.hexPressed)
end

function scene:show(event)
    if (event.phase == "did") then
        heroCanMove = true
        functions.playSoundRandom()
        functions.afterBossFight()
        properties.started = true
    end
end


function scene:hide(event)
    if (event.phase == "did") then
        heroCanMove = false
    end
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene



