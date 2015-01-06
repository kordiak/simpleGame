local composer = require("composer")
local properties = require("code.global.properties")
local physics = require("physics")

local popUp = require("code.popUps.popUp")


local functions = {}

local wallTab = {}
local obstacleTab = {}

local obstacleGroup = display.newGroup()
local wallGroup = display.newGroup()
local levelContent = display.newGroup()

local touchRect, text, elementCounter, arrow, gravityXFactor, sceneGroup, ball, levelGoal, pText, diffucult, LevelFail, timerInactive, levelGoalGraphic
local maxElementCounterValue = 550
local points = 0

local onCollision

local timer1, timer2, timer3, timer4

local maxPoints = math.round((maxElementCounterValue-50) / 50)

local ended = false
local hardCore = false --- - SET TO TRUE FOR HARDCORE MODE when every obstacle kills you

local obstacleYPos = {}

local numOfObstacles = math.random(4, 7) -- 7 is max


--print ("numOfDeadlObs",numOfDeadlObs)

local sceneLoaded = false

local scene = composer.newScene()

local function close()
    physics.stop()
    transition.cancel()
    Runtime:removeEventListener("collision", onCollision)
    timer.cancel(timerInactive)
    if timer1 then
        timer.cancel(timer1)
    end
    if timer2 then
        timer.cancel(timer2)
    end
    local prevScene = composer.getSceneName("previous")
    local currScene = composer.getSceneName("current")
    local options = {
        effect = "crossFade",
        time = 1000,
        params = { score = points }
    }

    properties.bossScene2Score = points

    composer.gotoScene(prevScene, options)
    composer.removeScene(currScene)
end

functions.endGamePopup = function()
    local popUpOne
    ended = true
    local function popUpCallBack()
        popUpOne.removeMe()

        -- functions.endGamePopup()
        --  popUpOne = nil
        close()
    end


    local params = {
        text = "You got " .. points .. " points",
        text2 = "Max was " .. maxPoints,
        fillColor = { 1, 1, 1, 0.8 },
        callBack = popUpCallBack,
        cancelCallBack = nil,
        textColor = { 0, 0, 0 },
        tapToContinue = true,
        twoLines = true,
    }

    media.stopSound()
    popUpOne = popUp.newPopUp1(params)
    sceneGroup:insert(popUpOne)
end

functions.generateWall = function(event)

    local wallElement = display.newCircle(event.x, event.y, 5)
    wallElement:setFillColor(0.85, 0.76, 0.33)
    table.insert(wallTab, wallElement)
    text.text = elementCounter - #wallTab
    physics.addBody(wallElement, "static", { friction = 0.2, bounce = 0.3, radius = 5 })
    wallGroup:insert(wallElement)
end

functions.test = function(x)
    --  display.newImageRect ("graphicsRaw/environment/ghostPill.png",  50, 50)
    ball = display.newCircle(x, 0, 25)
    --   ball = display.newImageRect ("graphicsRaw/environment/ghostPill.png",  80, 80) -- display.newCircle (x , 0,25)
    ball.x = x
    ball:setFillColor(0.67, 0.25, 0.75)
    ball.y = properties.y - ball.height
    ball.type = "objective"
    physics.addBody(ball, { density = 0.8, friction = 0.1, bounce = 0.3, radius = 20 })
    levelContent:insert(ball)

    -- sceneGroup:rotate(-(gravityXFactor*15))
end
functions.touchHandler = function(event)
    if sceneLoaded == true then
        if event.phase == "moved" then
            if event.y < properties.height - properties.height / 10 + properties.y then
                if not ended then
                    if tonumber(text.text) > 0 then
                        functions.generateWall(event)
                    end
                end
            end

            --- functions.playerShooting(event)
        end
        return true
    end
end

functions.textInitation = function(element)
    local text = display.newText({ text = "" .. element, font = properties.font, fontSize = properties.resourcesUsageFont + 15 })
    text:scale(0.7, 0.7)
    text.x, text.y = display.screenOriginX + text.contentWidth * 0.5 + 10, display.screenOriginY + text.height / 2 + 10
    text:setFillColor(1, 1, 1)

    return text
end
functions.textPInitation = function()
    local pText = display.newText({ text = points .. "/" .. maxPoints, font = properties.font, fontSize = properties.resourcesUsageFont + 15 })
    pText:scale(0.7, 0.7)
    pText.x, pText.y = properties.width - pText.contentWidth - 10, display.screenOriginY + pText.height / 2 + 10
    pText:setFillColor(1, 1, 1)

    return pText
end


functions.levelGoal = function()
    local function levelGoalSpiner()
        transition.to(levelGoalGraphic, { time = 1500, rotation = levelGoalGraphic.rotation + 240, onComplete = levelGoalSpiner })
    end

    levelGoal = display.newCircle(0, 0, 45)
    levelGoal.alpha = 0
    levelGoal.x = math.random(properties.x + properties.width / 10, properties.width - properties.width / 10)
    levelGoal.y = properties.y + properties.height - levelGoal.height / 2

    levelGoalGraphic = display.newImageRect("graphicsRaw/bosses/bucket3.png", 135, 135)
    levelGoalGraphic.x, levelGoalGraphic.y = levelGoal.x, levelGoal.y
    levelGoalGraphic.alpha = 0.8
    levelGoal.type = "objective"
    physics.addBody(levelGoal, "static", { friction = 0.2, bounce = 0.3, radius = 55 })
    levelContent:insert(levelGoal)
    levelContent:insert(levelGoalGraphic)
    levelGoalSpiner()


    LevelFail = display.newRect(properties.center.x, properties.height + properties.height / 5, properties.width * 4, 20)
    LevelFail.type = "outOfScreen"
    physics.addBody(LevelFail, "static", { friction = 0.2, bounce = 0.3 })
    levelContent:insert(LevelFail)
end
functions.goalCollected = function(failure)

    points = points + 1



    maxElementCounterValue = maxElementCounterValue - 50
    functions.levelInitation()
end


function onCollision(event)

    if (event.phase == "began") then
        if event.object1.type == "objective" and event.object2.type == "objective" then
          --  print("YOU WOOOON")
            physics.pause()
            transition.to(ball, { time = 500, x = levelGoal.x, y = levelGoal.y, xScale = 0.1, yScale = 0.1, onComplete = functions.goalCollected })
        end
        if event.object1.isDeadly or event.object2.isDeadly then
            physics.pause()
            transition.to(ball, { time = 500, xScale = 0.1, yScale = 0.1, alpha = 0.2, onComplete = functions.goalNotCollected })
        end
        if event.object1.type == "outOfScreen" or event.object2.type == "outOfScreen" then
            points = points - 1
            physics.pause()
            timer1 = timer.performWithDelay(200, function() functions.goalCollected(true) end)
        end
        -- print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )

    elseif (event.phase == "ended") then

        --  print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
    end
end



functions.arrowInitation = function(rotation)
    local arrow
    local function arrowAnimation()
        if not arrow.scaled then
            arrow.scaled = true
            transition.to(arrow, { time = 350, xScale = 1.1, yScale = 1.1, onComplete = arrowAnimation })
        else
            arrow.scaled = false
            transition.to(arrow, { time = 350, xScale = 0.9, yScale = 0.9, onComplete = arrowAnimation })
        end
    end

    arrow = display.newImageRect("graphicsRaw/bosses/arrow2.png", 512 / 5, 512 / 5)
    arrow.alpha = 0.8
    arrow.x = math.random(properties.x + properties.width / 10, properties.width - properties.width / 10)
    arrow.y = properties.y + arrow.height / 2 + 5

 --   print(rotation)
    arrow:rotate(-(rotation * 15))

    arrowAnimation()
    timer2 = timer.performWithDelay(2560, function() functions.test(arrow.x) end, 1)
    functions.levelGoal()
    return arrow
end

functions.posYGerator = function()



    local rand = math.random
    local t = obstacleYPos
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

functions.obstacleGenerator = function(isDeadly)
    --local obstacle = display.newImageRect ("graphicsRaw/bosses/wall2.png",  420, 209)
    local obstacle
    obstacle = display.newRect(0, 0, math.round(properties.height / 15), math.round(properties.height / 15))
    --skyMountain
  --  print(math.round(properties.height / 15))
    if isDeadly then
        obstacle.isDeadly = true
        obstacle:setFillColor(1, 0, 0, 0.9)
    else
        obstacle.isDeadly = false
        obstacle:setFillColor(1, 0.46, 0, 0.9)
    end



    local rotate = math.random(1, 2)
    local rotate2 = math.random(1, 2)


    --obstacle:rotate (math.random(15,60))
    functions.posYGerator()
   --- logTable(obstacleYPos)
    local xRand = math.random(1, 2)
    if xRand == 1 then
        obstacle.x = properties.x - obstacle.width
    else
        obstacle.x = properties.width + obstacle.width
    end
    --obstacle.y = properties.center.y
    local yRand = math.random(1, #obstacleYPos)

    obstacle.y = obstacleYPos[yRand] * 100
    table.remove(obstacleYPos, yRand)
    physics.addBody(obstacle, "static", { friction = 0.2, bounce = 0.3 })

    local function obstacleRotation()
        local rotationFactor
        if rotate == 1 then
            if rotate2 == 1 then
                rotationFactor = (math.random(15, 60))
            else
                rotationFactor = (-math.random(15, 60))
            end
            transition.to(obstacle, { time = 500, rotation = rotationFactor })
        end
    end

    transition.to(obstacle, { time = 1500, x = math.random(properties.x, properties.width), onComplete = obstacleRotation })


    obstacleGroup:insert(obstacle)
end
functions.goalNotCollected = function()




    maxElementCounterValue = maxElementCounterValue - 50
    functions.levelInitation()
end
functions.levelInitation = function()


    numOfObstacles = math.random(4, 7)
    if timerInactive then
        timer.cancel(timerInactive)
    end

    levelContent:removeSelf()
    wallGroup:removeSelf()
    obstacleGroup:removeSelf()
    obstacleGroup = display.newGroup()
    wallGroup = display.newGroup()
    levelContent = display.newGroup()
    wallTab = {}
    obstacleYPos = {}

    if maxElementCounterValue <= 0 then

        functions.endGamePopup()

        return true
    end

    for i = 2, (properties.height - 200) / 100 do
        local a = i
        table.insert(obstacleYPos, a)
    end


    physics.start()
    gravityXFactor = math.random(-2, 2)
    physics.setGravity(gravityXFactor, 12)
    local flag

    local numOfDeadlObs = math.round(properties.currentLevel/13)
    if numOfDeadlObs < 1 then
        numOfDeadlObs = 1
    end

    --print ( "numOfDeadlObs",numOfDeadlObs)
    for i = 1, numOfObstacles do

        if numOfDeadlObs >= 1 then
            flag = true
            numOfDeadlObs = numOfDeadlObs - 1
        else
            flag = false
        end

        if hardCore then
            flag = true
        end

        functions.obstacleGenerator(flag)
    end

    functions.continueInitation = function()
        elementCounter = maxElementCounterValue
        text = functions.textInitation(elementCounter)
        pText = functions.textPInitation()

        arrow = functions.arrowInitation(gravityXFactor)

        levelContent:insert(arrow)
        levelContent:insert(text)
        levelContent:insert(pText)

        levelContent:insert(wallGroup)
        sceneGroup:insert(levelContent)

        timerInactive = timer.performWithDelay(12000, functions.goalNotCollected)
    end

    functions.continueInitation()
end

function scene:create(event)

    sceneGroup = self.view
    if event.params then
        diffucult = event.params.diff or nil
        maxElementCounterValue = event.params.cValue or 500
    end
    media.stopSound()
    local backgroundMusic = ( "sounds/boss2Sound.mp3" )
    media.playSound( backgroundMusic)
    sceneLoaded = true
    touchRect = display.newImageRect("graphicsRaw/backGrounds/bgBoss3.png", properties.width, properties.height)
    touchRect.x, touchRect.y = properties.center.x, properties.center.y
    --- touchRect.isVisible = false
    touchRect.isHitTestable = true
    sceneGroup:insert(touchRect)
    touchRect:addEventListener("touch", functions.touchHandler)
    functions.levelInitation()




    Runtime:addEventListener("collision", onCollision)
end

function scene:show(event)
    if (event.phase == "did") then
      --  media.playSound()
        end
end


function scene:hide(event)
    if (event.phase == "will") then
     --   media.pauseSound()
    end
end


function scene:destroy(event)
    Runtime:removeEventListener("collision", onCollision)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

