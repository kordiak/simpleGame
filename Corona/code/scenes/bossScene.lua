display.setStatusBar(display.HiddenStatusBar)

local popUp = require ("code.popUps.popUp")

local composer = require("composer")
local properties = require("code.global.properties")
local firstBoss = require("code.classes.ghostBoss")
local Player = require("code.classes.Player");
local functions = {}

local shootFunctions = {}
local shootFunctionsState = {}

local basicShootEnded = true

local deadFunctionInvoked = false

local beganTimers = {}
local movedTimers = {}


local shootTimers = {}

local missleDestination

local shootGroup = display.newGroup()

local boss, sceneGroup, hero, bossHpIndicator, shootTimer, touchRect
local bossHp = 10
local bossHpMax = bossHp
local hpTab = {}
local missleTab = {}
local started = false
local heroCanMove = true

local timeOfShoots = 4500
local timeOfMainHeroMovment = (timeOfShoots - 1900 )/10
local timeOfScene = 90 ---INSECONDS

local generalShootGeneratorEnded = true

local leftToRightShowerTransitionAllowed = true
local rightToLeftShowerTransitionAllowed = true

local shootTimerLeft, shootTimerRight, shootTimerGap

local holdDownMoveTimer

local ScreenPosition = {}

local scene = composer.newScene()
local function stopAllAudio()
    audio.stop()
    media.stopSound()
end

functions.endGamePopup = function (win)
    local popUpOne
  --  ended = true
    local function popUpCallBack()
        popUpOne.removeMe()

        -- functions.endGamePopup()
        --  popUpOne = nil
        local win = win
        audio.stop()
        media.stopSound()
        local prevScene = composer.getSceneName("previous")
        local currScene = composer.getSceneName("current")
        local options = {
            effect = "crossFade",
            time = 1000,
        }

        properties.bossSceneScore = bossHp

        composer.gotoScene(prevScene, options)
        composer.removeScene(currScene)
    end


    local params = {

        text = "You got "..bossHp.." points",
        text2 = "Max was "..bossHpMax,
        fillColor =  { 1, 1, 1, 0.8 },
        callBack = popUpCallBack,
        cancelCallBack = nil,
        textColor = { 0, 0, 0 },
        tapToContinue = true,
        twoLines = true,

    }


    popUpOne = popUp.newPopUp1( params)
    sceneGroup:insert(popUpOne)



end

local function gameOver(win)
    functions.endGamePopup(win)
end
local function close()
    composer.gotoScene("")
    composer.removeScene("")
end
functions.timerCancel = function ()

    print ("TIMER CANCEL")
    touchRect.canGetTouch = false
    for i=1, #shootTimers do
        timer.cancel( shootTimers[i] )
    end

    local function callback()

        transition.cancel( "missleTrans" )
    --    print ("XAXAXAA", #missleTab)
        for i=1 , #missleTab do
            missleTab[i]:removeSelf()
            missleTab[i] = nil
             --   table.remove (missleTab, i)
                end

        end

       callback()
end
functions.mainHero = function (boss)
hero  = display.newImageRect(properties.mainCharacterSkin, 90, 90);
hero.alpha = 0
hero.x = ScreenPosition[4]
hero.pos = 4
hero.y = properties.height - hero.height/2 - hero.height/10 + properties.y
transition.to ( hero, { time = 450 , alpha = 1, onComplete = functions.levelReady})
    sceneGroup:insert(hero)

missleDestination = hero.y
end
functions.screenPosGenerator = function ()
for i=1, 7 do
    ScreenPosition[i] = properties.x + ((properties.width/10)*(i+1))
    end
end
functions.bossTransitions = function ()
    local bossPositon = nil
    local time = 1000
    local function bossMovment ()
        -- functions.bossShooting()
        if not bossPositon then
            time = 500
        end
        if bossPositon == "right" then
            -- started = true
            time = 1000
            bossPositon = "left"
            transition.to ( boss, { time = time, x= properties.x + ((boss.width*0.5)/2), onComplete = bossMovment})
        else
            time = 1000
            bossPositon = "right"
            transition.to ( boss, { time = time, x= properties.width - ((boss.width*0.5)/2), onComplete = bossMovment})
        end
    end
    bossMovment()
end
functions.levelReady = function ()
    started = true



end

functions.initation =  function (object)
    boss = object

    local counter = 0
    local alpha = 0
    local scale = 1.1
    local moveFactor = 15
local function flash()
    counter = counter + 1
    if counter < 50 then
    if alpha == 0 then
        alpha = 1
        scale = 0.9
        else
        alpha = 0
        scale  = 1.1
        end
    transition.to ( object, { time = 50, alpha = alpha, xScale = scale, yScale = scale, onComplete = flash})

    elseif counter >= 50 and counter < 65 then
if moveFactor == 15 then
    moveFactor = -15
else
    moveFactor = 15
    end

        transition.to ( object, { time = 75, alpha = alpha, x= object.x + moveFactor, y = object.y - moveFactor, onComplete = flash})
    elseif counter >= 65 and counter < 80 then
        if moveFactor == 15 then
            moveFactor = -15
        else
            moveFactor = 15
        end

        transition.to ( object, { time = 75, alpha = alpha, x= object.x - moveFactor, y = object.y - moveFactor, onComplete = flash})
        elseif counter >= 80 then
        transition.to ( object, { time = 2500, rotation = 360, xScale = 0.5, yScale = 0.5, y = properties.y -  object.height, onComplete = functions.mainHero})
    end


end

flash()
      --  transition.to( square, { time=1500, alpha=0, x=(w-50), y=(h-50), onComplete=listener1 } ))
end

functions.playSound = function()
   local path  = system.pathForFile( "boss1.mp3" , system.ResourceDirectory )
    print (path)

end
functions.dead = function ()
    deadFunctionInvoked = true
local nextDeathStep = function ()
    local function audioCompleted()
        gameOver()
    end
    stopAllAudio()



    local winSound = audio.loadSound( "sounds/ghostBossLaugh.mp3" )
    audio.play( winSound, { onComplete= audioCompleted } )
end
    local heroSmash = function ()
        transition.to ( hero, { time = 500, yScale = 0.1, y = hero.y + hero.height/2 + 2, onComplete = nextDeathStep})
    end
    functions.timerCancel()
    bossHp = 0


   -- timer.cancel( hero )
    transition.pause(hero)
    transition.to ( boss, { time = 1500, rotation = 0, y = hero.y, x = hero.x ,xScale = 0.2, yScale =0.2, alpha = 0.5, onComplete = heroSmash})



end

functions.bossSprite = function (callback)
    local bossSprite = display.newSprite(properties.ghostSheet, properties.ghostSequenceData )
    bossSprite.x = boss.x ; bossSprite.y = boss.y
    boss:removeSelf()
    boss = nil
    bossSprite:play()

    local function spriteListener( event )
        if event.phase == "ended" then
            callback()
            event.target:removeSelf()
        end
    end

    -- Add sprite listener
    bossSprite:addEventListener( "sprite", spriteListener )
end
functions.spriteGenerator = function (event)
    local afterMissle = display.newSprite( properties.boneSheet, properties.boneSequenceData )
    afterMissle.width = event.widht
    afterMissle.height = event.height
    afterMissle.x = event.x ; afterMissle.y = event.y
    afterMissle:play()

    local function spriteListener( event )
        if event.phase == "ended" then
            event.target:removeSelf()
        end
    end

    -- Add sprite listener
    afterMissle:addEventListener( "sprite", spriteListener )
end
functions.hitChecker = function (event)

   -- print (event.x ,boss.x, boss.width*0.6)
    local index = table.indexOf( missleTab, event )
    if event.pos == hero.pos or event.pos == hero.prevPos then
        system.vibrate()
        bossHp = bossHp - 1
        bossHpIndicator.text = "Hp " .. bossHp
    end

   functions.spriteGenerator(event)

   if missleTab[index] then
       missleTab[index]:removeSelf()
   end
    table.remove( missleTab, index )

   if bossHp <= 0 then
       bossHp = 0
       bossHpIndicator.text = "Hp " .. bossHp
       if deadFunctionInvoked == false then
       functions.dead()
           end
       end
 --   event.target = nil
end
functions.missleGenerator = function (x, shotPos)
    local missle = display.newImageRect (properties.missleBone,  properties.width/10, 41)
    missle.x = x
    missle.pos = shotPos
    missle.y = properties.y - 10
    sceneGroup:insert(missle)
    table.insert (missleTab, missle)

    return missle
end
functions.gapInTheMissles = function ()
    local transNumber = 0
    local shootRemoved = math.random(1,#ScreenPosition)
    local function shoot()
         if transNumber == 7 then
     local randomizer = math.random(1,2)
     if shootRemoved == 1 then
         shootRemoved = shootRemoved + 1
         elseif shootRemoved == #ScreenPosition then
         shootRemoved = shootRemoved - 1
     else
     if randomizer == 1 then
     shootRemoved = shootRemoved + 1
     elseif randomizer == 2 then
         shootRemoved = shootRemoved - 1
         end
         end
     end
        for i=1, #ScreenPosition do
            if i == shootRemoved then

            elseif i == shootRemoved + 1 and transNumber == 7  then

            elseif i == shootRemoved + 1 and transNumber == 8  then

            elseif i == shootRemoved - 1 and transNumber == 7  then

            elseif i == shootRemoved - 1 and transNumber == 8  then
                else
            local missle = functions.missleGenerator(ScreenPosition[i], i)


        if transNumber == 14 then
            timer.performWithDelay ( timeOfShoots + 500, function () shootFunctionsState[3] = true end )
            timer.performWithDelay ( timeOfShoots/4.2, function () generalShootGeneratorEnded = true end )
            end
            transition.to ( missle, {time = timeOfShoots, x = missle.x, y = missleDestination , rotation = math.random(780,1150),tag = "missleTrans", onComplete = functions.hitChecker})
            end
            end

    end

    shootFunctionsState[3] = false
    shootTimerGap=  timer.performWithDelay( 160, function () transNumber = transNumber + 1; shoot()   end,#ScreenPosition*2  )
    table.insert (shootTimers, shootTimerGap)
end

functions.leftToRightShower = function(callback, numbToDisable,counter)
    local shotPos = 0
    local shootRemoved = math.random(1,#ScreenPosition)
    local function shoot()

        if shotPos == #ScreenPosition then
            if not numbToDisable then
            timer.performWithDelay ( timeOfShoots/2, function () shootFunctionsState[1] = true end )
            timer.performWithDelay ( timeOfShoots/4.5, function () generalShootGeneratorEnded = true end )
            end
            if counter then
                print ("current COUTNTER STATE IS", counter)
            if counter == 2 then
                timer.performWithDelay ( timeOfShoots/2, function () shootFunctionsState[numbToDisable] = true end )
                timer.performWithDelay ( timeOfShoots/3, function () generalShootGeneratorEnded = true end )
            end
            end
            if callback then
                if numbToDisable and counter then
                    timer.performWithDelay ((timeOfShoots+1500)/10, function()  callback (nil , numbToDisable,counter)  end)

                else
                    timer.performWithDelay ((timeOfShoots+1500)/10, function()  callback ()  end)
                end
            end
        end
        if shotPos == shootRemoved then
            return
            else
        local x = ScreenPosition[shotPos]
        local missle = display.newImageRect (properties.missleBone,  properties.width/10, 41)
        missle.x = x
        missle.pos = shotPos
        missle.y = properties.y - 10
        sceneGroup:insert(missle)
        table.insert (missleTab, missle)
        transition.to ( missle, {time = timeOfShoots, x = x, y = missleDestination , rotation = math.random(780,1150), tag = "missleTrans", onComplete = functions.hitChecker})
            end

    end
    if numbToDisable then
        shootFunctionsState[numbToDisable] = false
        else
    shootFunctionsState[1] = false
    end

    if counter then
        counter = counter + 1
        end

    shootTimerLeft=  timer.performWithDelay( 120, function () shotPos = shotPos + 1; shoot()   end,#ScreenPosition  )
    table.insert (shootTimers, shootTimerLeft)
end

functions.rightToLeftShower = function(callback, numbToDisable,counter)
    local shotPos = #ScreenPosition + 1
    local shootRemoved = math.random(1,#ScreenPosition)
    local function shoot()

        if shotPos == 1 then
            if not numbToDisable then
            timer.performWithDelay ( timeOfShoots/2, function () shootFunctionsState[2] = true end )
            timer.performWithDelay ( timeOfShoots/4.5, function () generalShootGeneratorEnded = true end )
                end
            if counter then
                print ("current COUTNTER STATE IS", counter)
            if counter == 2 then
                timer.performWithDelay ( timeOfShoots/2, function () shootFunctionsState[numbToDisable] = true end )
                timer.performWithDelay ( timeOfShoots/3, function () generalShootGeneratorEnded = true end )
            end
            end
            if callback then

                if numbToDisable and counter then
                    timer.performWithDelay ((timeOfShoots+1500)/10, function()  callback (nil , numbToDisable,counter)  end)
                    else
                    timer.performWithDelay ((timeOfShoots+1500)/10, function()  callback ()  end)
                    end
                end
        end
        if shotPos == shootRemoved then
            return
        else
            local x = ScreenPosition[shotPos]
            local missle = display.newImageRect (properties.missleBone,  properties.width/10, 41)
            missle.x = x
            missle.pos = shotPos
            missle.y = properties.y - 10
            sceneGroup:insert(missle)
            table.insert (missleTab, missle)
            transition.to ( missle, {time = timeOfShoots, x = x, y = missleDestination , rotation = math.random(780,1150),tag = "missleTrans", onComplete = functions.hitChecker})
        end

    end

    if numbToDisable then
        shootFunctionsState[numbToDisable] = false
    else
        shootFunctionsState[2] = false
    end

    if counter then
        counter = counter + 1
    end
    shootTimerRight=  timer.performWithDelay( 120, function () shotPos = shotPos - 1; shoot()   end,#ScreenPosition  )
    table.insert (shootTimers, shootTimerRight)
end

functions.functionInsertingTab = function ()

    --- INSERTING FUNCTIONS IN TABLE FOR EASIER RANDOMIZATION IN  ' advencedBossShootingHanlder '

    table.insert(shootFunctions,functions.leftToRightShower)
    table.insert(shootFunctions,functions.rightToLeftShower)
    table.insert(shootFunctions,functions.gapInTheMissles)
    table.insert(shootFunctions,functions.doubleBulletChain)




    for i=1,#shootFunctions do
        table.insert(shootFunctionsState,true)
        end
end

functions.doubleBulletChain = function ()
    local numbToDisable = 4
    local counter = 0
    local randomizer = math.random(1,2)
    if randomizer == 1 then
        shootFunctions[1](shootFunctions[2],numbToDisable,counter  )
    else
        shootFunctions[2](shootFunctions[1],numbToDisable,counter  )
    end
end

functions.advencedBossShootingHanlder = function ()
    if started == true and generalShootGeneratorEnded == true then
        local basicMode = math.random(1,3)
        local specialMode = math.random(1,#shootFunctions)
        if basicMode == 1 and basicShootEnded == true then
            basicShootEnded = false
            generalShootGeneratorEnded = false
            functions.bossShooting()

            else
if specialMode == 1 then
        if shootFunctionsState[1] == true and generalShootGeneratorEnded == true then
            generalShootGeneratorEnded = false
            shootFunctions[1]()
        end
        elseif specialMode == 2 then
         if shootFunctionsState[2] == true and generalShootGeneratorEnded == true then
             generalShootGeneratorEnded = false
             shootFunctions[2]()
         end
elseif specialMode == 3 then
        if shootFunctionsState[3] == true and generalShootGeneratorEnded == true then
            print("XAXAXA", generalShootGeneratorEnded)
            generalShootGeneratorEnded = false
            shootFunctions[3]()
        end
elseif specialMode == 4 then
        if shootFunctionsState[4] == true and generalShootGeneratorEnded == true then
            generalShootGeneratorEnded = false
            shootFunctions[4]()

        end
end
end


end

end

functions.bossShooting = function()

        local shoot = math.random(25,60)
        local shootCounter = 0

  local function shootDaMissle ()
      if shootCounter == shoot then
          timer.performWithDelay ( timeOfShoots/4.5, function () generalShootGeneratorEnded = true  basicShootEnded= true end )

          end
        local tablePos = math.random(1,7)
        local x = ScreenPosition[tablePos]
    local missle = display.newImageRect (properties.missleBone,  properties.width/10, 41)
        missle.x = x
        missle.pos = tablePos
        missle.y = properties.y - 10
        shootGroup:insert(missle)
    table.insert (missleTab, missle)
        transition.to ( missle, {time = timeOfShoots, x = x, y = missleDestination , rotation = math.random(580,1150), tag = "missleTrans", onComplete = functions.hitChecker})
  end
 local basicShootTimer = timer.performWithDelay (timeOfShoots/20, function() shootCounter=shootCounter+1 shootDaMissle() end,shoot )
        table.insert (shootTimers, basicShootTimer)

end
functions.playerMovment = function (event)
    local function clearPrevousPos()
        hero.prevPos = 0
        heroCanMove = true
    end
  if heroCanMove == true then

    if event.x + hero.width/2 < hero.x then
        print ("LEFT" ,event.x -hero.width, hero.x)
        if (hero.pos-1) > 0 then
            heroCanMove = false
        hero.prevPos = hero.pos
        hero.pos = hero.pos - 1
transition.to(hero, {time= timeOfMainHeroMovment, x = ScreenPosition[hero.pos] , onComplete = clearPrevousPos })
            end
    elseif event.x -hero.width/2 > hero.x then
        print ("RIGHT" ,event.x +hero.width, hero.x)
    if (hero.pos) < #ScreenPosition  then
        heroCanMove = false
        hero.prevPos = hero.pos
        hero.pos = hero.pos + 1
        transition.to(hero, {time= timeOfMainHeroMovment, x =  ScreenPosition[hero.pos], onComplete = clearPrevousPos })
        end
    end
    end
end

functions.touchHandler = function( event )
    if touchRect.canGetTouch == false then
        return true
        end

    local function clearTimers (flag)
        for i =1, #beganTimers do
            timer.cancel(beganTimers[i] )
        end
        for j =1, #movedTimers do
            timer.cancel(movedTimers[j] )
        end
        if flag then
       movedTimers = {}
      beganTimers = {}
            end

    end
    if started == true then
        print( "Touch : " .. event.x , event.y, event.phase, #beganTimers, #movedTimers )
    if event.phase == "began" then
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true
        clearTimers()

        local holdTimer = timer.performWithDelay(10,function() functions.playerMovment(event) end,-1 )

        table.insert (beganTimers, holdTimer)

       --- functions.playerShooting(event)
    elseif event.target.isFocus then
        if event.phase == "moved" then
            clearTimers()



          local moveTimer = timer.performWithDelay(10,function() functions.playerMovment(event) end,-1 )

            table.insert (movedTimers, moveTimer)
        elseif event.phase == "ended" then
            display.getCurrentStage():setFocus( nil )
            event.target.isFocus = false
            clearTimers(true)



            end
    end
    return true
        end
end
functions.win = function()
    local function afterAniCallback()
        local function audioCompleted()
        gameOver(true)
        end
        media.stopSound()

        functions.timerCancel()

        local winSound = audio.loadSound( "sounds/boss1Win.mp3" )
        audio.play( winSound, { onComplete= audioCompleted } )


        ---TODO what to do after we killed the boss?
    end
    ---BOOM BOOM DIE of GHOST ANIMATION
--    local ghostTrap =  display.newImageRect("graphicsRaw/bosses/ghostTrap.png", 269/1.5, 312/1.5);
--    ghostTrap.anchorX = -1
--    ghostTrap.x = properties.x
--    ghostTrap.y = properties.height - ghostTrap.height
--    sceneGroup:insert  ( ghostTrap )
 --   transition.to ( boss, { time = 1500, xScale = 0.01, yScale = 0.01, rotation =1400, y = ghostTrap.y-ghostTrap.height/2 + ghostTrap.height/10, x = ghostTrap.x+ghostTrap.width - ghostTrap.width/10, onComplete =afterAniCallback })
 --   afterAniCallback()

    ---- TODO add missle with boom sprite to animate killing the boss


    functions.bossSprite(afterAniCallback)

end
functions.survived = function ()
    if bossHp > 0 then
        for i=1, #shootTimers do
    timer.cancel( shootTimers[i] )
    end
    for i=1 , #missleTab do
        functions.spriteGenerator(missleTab[i])
    transition.cancel( missleTab[i] )
    missleTab[i]:removeSelf()
    end
    missleTab = {}
    transition.to ( boss, { time = 2500, rotation = 0, xScale = 1.15, yScale = 1.15, y = properties.center.y -  boss.height/2, onComplete = functions.win})
        end
end
function scene:create(event)
    --local state = event.params.state
     sceneGroup = self.view
    functions.screenPosGenerator()

    functions.functionInsertingTab()

    local boss = firstBoss.new()
    boss.x = properties.center.x
    boss.y = properties.center.y

  --  functions.playSound()
  media.playSound( "sounds/boss1.mp3" )
    functions.initation(boss)

 touchRect = display.newImageRect ("graphicsRaw/backGrounds/bgBoss2.png",properties.width, properties.height)
    touchRect.x, touchRect.y =   properties.center.x, properties.center.y
    -- touchRect.isVisible = false
    touchRect.canGetTouch = true


--    local myText = display.newText({ text = 0, font = properties.font, fontSize = properties.resourcesUsageFont })
--    myText:scale(0.7, 0.7)
--    myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
--    myText:setFillColor(1, 1, 1)
--
    bossHpIndicator = display.newText({ text = "Hp " .. bossHp, font = properties.font, fontSize = properties.resourcesUsageFont })
    bossHpIndicator:scale(0.7, 0.7)
    bossHpIndicator.x, bossHpIndicator.y = display.screenOriginX + bossHpIndicator.contentWidth * 0.5 + 10, display.screenOriginY + bossHpIndicator.height / 2 + 10
    bossHpIndicator:setFillColor(1, 1, 1)
    sceneGroup:insert   ( touchRect )
    sceneGroup:insert(boss)
    sceneGroup:insert   ( bossHpIndicator )
    sceneGroup:insert   ( shootGroup )


    touchRect:addEventListener( "touch", functions.touchHandler )
    shootTimer =  timer.performWithDelay( 50, functions.advencedBossShootingHanlder, -1 )
    table.insert (shootTimers, shootTimer)
    timer.performWithDelay ( 1000* timeOfScene * 1, functions.survived, 1)

    local function test()
    for i=1, #ScreenPosition do
    local rect = display.newRect(ScreenPosition[i],properties.center.y,(properties.width/#ScreenPosition)/2 - 5,35)
    sceneGroup:insert(rect)
    end
    end
    ---- UNCOMENT FOR TESTING PURPOSES
  --  test()
    --- CURRENTLY NOT USED MAIN MENU

end

function scene:show(event)
    if (event.phase == "did") then
    media.playSound()
        end
end


function scene:hide(event)
    if (event.phase == "did") then
    media.pauseSound()
        end
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene



