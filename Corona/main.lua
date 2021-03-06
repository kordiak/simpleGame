--=============================================================================
-- hiding status bar
--=============================================================================
display.setStatusBar(display.HiddenStatusBar)


--======================================
--
--     INIT MODULE
--
--======================================
local saveFile = require("code.global.saveAndLoad")
local boardCreator = require("code.boardLibrary.boardCreator")
local properties = require("code.global.properties")
local mainHero, levelGoal, mainBoard, heroCanMove, hexAxe
local functions = {}
local enemiesTable = {}

local simpleGhostEnemiesTable = {}
local advencedGhostEnemiesTable = {}
local distanceEnemyAndHero = {}
local maxDistanceEnemyAndHero = {}
local miniDistanceEnemyAndHero = {}
miniDistanceEnemyAndHero.distance = properties.miniDistanceHandler
maxDistanceEnemyAndHero.distance = 0
local overlay, play, load, exit

table.insert(enemiesTable, simpleGhostEnemiesTable)
table.insert(enemiesTable, advencedGhostEnemiesTable)

-- print (saveFile.loadFile.level)
heroCanMove = true

mainBoard = boardCreator.new()




local myText = display.newText({ text = 0, font = properties.font, fontSize = properties.resourcesUsageFont })
myText:scale(0.7, 0.7)
myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
myText:setFillColor(1, 1, 1)

local levelIndicator = display.newText({ text = "Level " .. properties.currentLevel, font = properties.font, fontSize = properties.resourcesUsageFont })
levelIndicator:scale(0.7, 0.7)
levelIndicator.x, levelIndicator.y = display.screenOriginX + levelIndicator.contentWidth * 0.5 + 10, display.screenOriginY + levelIndicator.height / 2 + 10
levelIndicator:setFillColor(1, 1, 1)

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

functions.startingMenuContent = function()
    play = display.newText({ text = "Play", font = properties.font, fontSize = properties.mainMenuFontSize })
    play.x, play.y = properties.center.x, display.screenOriginY + play.height * 2
    play:setFillColor(1, 1, 1)
    play.name = "play"
    play:addEventListener("touch", functions.mainMenuTouch)

    load = display.newText({ text = "Load", font = properties.font, fontSize = properties.mainMenuFontSize })
    load.x, load.y = play.x, play.y + load.height * 2
    load:setFillColor(1, 1, 1)
    load.name = "load"
    load:addEventListener("touch", functions.mainMenuTouch)


    exit = display.newText({ text = "Exit", font = properties.font, fontSize = properties.mainMenuFontSize })
    exit.x, exit.y = load.x, load.y + exit.height * 2
    exit:setFillColor(1, 1, 1)
    exit.name = "exit"
    exit:addEventListener("touch", functions.mainMenuTouch)
end

functions.hiddingMainMenu = function()
    overlay.isVisible = false
    play.isVisible = false
    load.isVisible = false
    exit.isVisible = false
end

functions.revalingMainMenu = function()
    overlay.isVisible = true
    play.isVisible = true
    load.isVisible = true
    exit.isVisible = true
end

functions.startingMenu = function()
    overlay = display.newRect(properties.center.x, properties.center.y, properties.width, properties.height)
    overlay:setFillColor(0, 0, 0, 1)
    overlay.name = 'overlay'
    overlay:addEventListener("touch", functions.mainMenuTouch)
    functions.startingMenuContent()
end

functions.startGame = function()

    functions.environmentGenerator = function()

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
                    --  print ( properties.lastPickedHexForEnvironmentForestGenerator)
                    q = false
                    local eviCount = math.round(((properties.forestSize - properties.currentLevel)) / properties.numberOfForests)
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
                                --  print ("C",c)
                                --   print ( mainBoard[properties.lastPickedHexForEnvironmentForestGenerator].coherentHexes[c])
                                local smallForest = display.newImageRect(properties.environment[r], 90, 90)
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
                                print("EXCEDED MAX NUMBER OF SiMULATiONS")
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
    end

    functions.enemyCreator = function()
        for p = 1, (properties.enemiesNumber + math.round(properties.currentLevel / 2)) do
            local q = true
            while q do
                local i = math.random(1, #mainBoard - 5)
                if mainBoard[i].isFree then
                    local enIndi = math.random(1, 3)
                    local img = properties.enemy[enIndi]
                    local enemy = display.newImageRect(img, 90, 90)
                    enemy.x = mainBoard[i].x
                    enemy.y = mainBoard[i].y
                    enemy.boardPositiong = i
                    enemy.type = "simpleMeleeGhost"
                    mainBoard[i].isFree = false
                    mainBoard[i].isWalkAble = false
                    mainBoard[i].content = enemy
                    table.insert(simpleGhostEnemiesTable, enemy)
                    table.insert(enemiesTable, enemy)

                    q = false
                end
            end
        end
        functions.environmentGenerator()
    end
    functions.mainHeroCreator = function()
        if not mainHero then

            mainHero = display.newImageRect(properties.mainCharacterSkin, 90, 90)
            mainHero.x = mainBoard[#mainBoard].x
            mainHero.y = mainBoard[#mainBoard].y
            mainBoard[#mainBoard].isFree = false
            mainBoard[#mainBoard].isWalkAble = false
            mainHero.currentHex = #mainBoard
        end

        if not levelGoal then

            levelGoal = display.newImageRect(properties.levelGoal, 90, 90)
            levelGoal.x = mainBoard[1].x
            levelGoal.y = mainBoard[1].y
            mainBoard[1].isFree = false
            mainBoard[1].isWalkAble = false
            mainBoard[1].content = levelGoal
        end
        functions.enemyCreator()
    end
    functions.mainHeroCreator()
    functions.HUDCreator()
end

functions.newLevel = function()
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
    heroCanMove = true
end
functions.simpleGhostEnemiesMove = function()
    for i = 1, #simpleGhostEnemiesTable do
        --TODO enemy movement

        --- MELEE IS TRYING TO GO TOWARDS YOU!!! ---
        for j = 1, #mainBoard[simpleGhostEnemiesTable[i].boardPositiong].coherentHexes do
            local a = mainBoard[simpleGhostEnemiesTable[i].boardPositiong].coherentHexes[j]
            print("Board Position", mainBoard[simpleGhostEnemiesTable[i].boardPositiong].coherentHexes[j])
            distanceEnemyAndHero = (((((((mainBoard[a].x) ^ 2) ^ (1 / 2)) - (((mainBoard[mainHero.currentHex].x) ^ 2) ^ (1 / 2))) ^ 2) ^ (1 / 2)) + ((((((mainBoard[a].y) ^ 2) ^ (1 / 2)) - (((mainBoard[mainHero.currentHex].y) ^ 2) ^ (1 / 2))) ^ 2) ^ (1 / 2)))
            print("Distance", distanceEnemyAndHero)
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
        print("Max distance", maxDistanceEnemyAndHero.distance, "on Hex :", maxDistanceEnemyAndHero.hexNumber)

        print("Mini distance", miniDistanceEnemyAndHero.distance, "on Hex :", miniDistanceEnemyAndHero.hexNumber)
        if miniDistanceEnemyAndHero.hexNumber then


            -- enemiesTable[i].x =  mainBoard[miniDistanceEnemyAndHero.hexNumber].x
            --  enemiesTable[i].y =  mainBoard[miniDistanceEnemyAndHero.hexNumber].y

            mainBoard[simpleGhostEnemiesTable[i].boardPositiong].isFree = true
            mainBoard[simpleGhostEnemiesTable[i].boardPositiong].isWalkAble = true
            mainBoard[miniDistanceEnemyAndHero.hexNumber].content = mainBoard[simpleGhostEnemiesTable[i].boardPositiong].content
            mainBoard[simpleGhostEnemiesTable[i].boardPositiong].content = nil
            simpleGhostEnemiesTable[i].boardPositiong = miniDistanceEnemyAndHero.hexNumber
            mainBoard[miniDistanceEnemyAndHero.hexNumber].isFree = false
            mainBoard[simpleGhostEnemiesTable[i].boardPositiong].isWalkAble = false

            transition.to(simpleGhostEnemiesTable[i], { time = properties.enemyTransTime, x = mainBoard[simpleGhostEnemiesTable[i].boardPositiong].x, y = mainBoard[simpleGhostEnemiesTable[i].boardPositiong].y, onComplete = functions.enemyTransCompleted })

            functions.distanceForEnemyReset()
        end
    end
end
functions.advencedGhostEnemiesMove = function()
    local advencedMoveCheckerTable = {}
    local possibleEnemyHex
    local startingEnemyPos
    local whileCounter = 0
    local o = true



    for i = 1, #simpleGhostEnemiesTable do --- FOR EACH ENEMY IN TABLE
    --TODO enemy movement

        startingEnemyPos = simpleGhostEnemiesTable[i].boardPositiong

        --- MELEE IS TRYING TO GO TOWARDS YOU!!! ---
        for j = 1, #mainBoard[startingEnemyPos].coherentHexes do
            local a = mainBoard[startingEnemyPos].coherentHexes[j]
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
                    possibleEnemyHex = a
                end
            end
        end
      if possibleEnemyHex then
            print (possibleEnemyHex)
        end

    end




    print (#advencedMoveCheckerTable)


end
functions.enemyMove = function()

 --functions.simpleGhostEnemiesMove()
   functions.advencedGhostEnemiesMove()
end
functions.hexPressed = function(params)
--  print (params.hexNumber)

    if heroCanMove == true then

        for i = 1, #mainBoard[mainHero.currentHex].coherentHexes do
            if mainBoard[mainHero.currentHex].coherentHexes[i] == tonumber(params.hexNumber) then
                if mainBoard[tonumber(params.hexNumber)].isWalkAble == true then

                    mainBoard[mainHero.currentHex].isFree = true
                    mainBoard[mainHero.currentHex].isWalkAble = true
                    mainHero.currentHex = tonumber(params.hexNumber)

                    heroCanMove = false
                    transition.to(mainHero, { time = properties.heroTransTime, delay = 100, x = mainBoard[tonumber(params.hexNumber)].x, y = mainBoard[tonumber(params.hexNumber)].y, onComplete = functions.transCompleted })
                    --mainHero.x =  mainBoard[tonumber(params.hexNumber)].x
                    --  mainHero.y =  mainBoard[tonumber(params.hexNumber)].y

                    mainBoard[tonumber(params.hexNumber)].isWalkAble = false
                    mainBoard[tonumber(params.hexNumber)].isFree = false




                elseif mainBoard[tonumber(params.hexNumber)].content == levelGoal then
                    transition.to(mainHero, { time = properties.heroTransTime, delay = 100, x = mainBoard[tonumber(params.hexNumber)].x, y = mainBoard[tonumber(params.hexNumber)].y, onComplete = functions.newLevel })



                    -- mainBoard.new()
                end
            end
        end
    end
end

functions.nextlevel = function()
    properties.lastPickedHexForEnvironmentForestGenerator = 0
end

functions.HUDtouch = function(event)
    if event.phase == "ended" then
        if event.target.name == "restart" then
            properties.currentLevel = properties.currentLevel - 1
            --        if properties.currentLevel < 1 then
            --            properties.currentLevel = 1
            --            end
            functions.newLevel()
        elseif event.target.name == "hexAxe" then
            native.requestExit()
        end
    end
end

functions.HUDCreator = function()
    if not hexAxe then
        hexAxe = display.newImageRect(properties.hexTexturePath, 88, 77)
        hexAxe.x = properties.width - hexAxe.width / 2
        hexAxe.y = mainBoard[#mainBoard].y + hexAxe.height * 1.5
        hexAxe.name = "hexAxe"
        local hexContent = display.newImageRect("graphicsRaw/items/axe.png", 90, 90)
        hexContent.x = hexAxe.x
        hexContent.y = hexAxe.y
        hexAxe:addEventListener("touch", functions.HUDtouch)



        local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
        hex.name = "restart"
        hex.x = properties.x + hex.width / 2
        hex.y = mainBoard[#mainBoard].y + hex.height * 1.5

        hex:addEventListener("touch", functions.HUDtouch)
    end
end

--functions.startingMenu()
functions.startGame()






local frames = 0
local function getFps()
    local returnF = tostring(frames)
    frames = 0
    return returnF
end

local function updateText()
    collectgarbage()
    myText.text = "  FPS : " .. getFps() .. "   Memory: " .. (math.round(collectgarbage("count") * 100)) / 100 .. "    Texture: " .. (math.round(system.getInfo("textureMemoryUsed"))) / 10000
    myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
    myText:toFront()
end

local function enterframeFunc()
    frames = frames + 1
    --    for i = 1, #mainBoard do
    --        if  mainBoard[i].isWalkAble then
    --            mainBoard[i]:setFillColor (1,0,0,0.2)
    --        else
    --            mainBoard[i]:setFillColor (1,1,1)
    --        end
    --    end
end

timer.performWithDelay(1000, updateText, 0)
Runtime:addEventListener("enterFrame", enterframeFunc)
Runtime:addEventListener("hexPressed", functions.hexPressed)
