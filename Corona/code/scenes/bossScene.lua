display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
local properties = require("code.global.properties")
local firstBoss = require("code.classes.ghostBoss")
local Player = require("code.classes.Player");
local functions = {}

local boss, sceneGroup, hero, bossHpIndicator, shootTimer, touchRect
local bossHp = 10
local hpTab = {}
local missleTab = {}
local started = false

local scene = composer.newScene()

local function gameOver()
    audio.stop()
    media.stopSound()
    composer.removeScene("code.scenes.bossScene")
    composer.gotoScene("code.scenes.bossScene")
end
local function close()
    composer.gotoScene("")
    composer.removeScene("")
end
functions.mainHero = function (boss)
hero  = display.newImageRect(properties.mainCharacterSkin, 90, 90);
hero.alpha = 0
hero.x = properties.center.x
hero.y = properties.height - properties.height/8
transition.to ( hero, { time = 450 , alpha = 1, onComplete = functions.levelReady})
    sceneGroup:insert(hero)
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
    touchRect.isHitTestable = false
    local heroSmash = function ()
        transition.to ( hero, { time = 500, yScale = 0.1, y = hero.y + hero.height/2 + 2, onComplete = gameOver})
    end
    timer.cancel( shootTimer )
    for i=1 , #missleTab do
        transition.cancel( missleTab[i] )
        missleTab[i]:removeSelf()
    end
    missleTab = {}
   -- timer.cancel( hero )
    transition.pause(hero)
    transition.to ( boss, { time = 1500, rotation = 0, y = hero.y, x = hero.x ,xScale = 0.2, yScale =0.2, alpha = 0.5, onComplete = heroSmash})

end
functions.hitChecker = function (event)

   -- print (event.x ,boss.x, boss.width*0.6)
    local index = table.indexOf( missleTab, event )
    if event.x < (hero.x + 60) and event.x > (hero.x - 60) then
        bossHp = bossHp - 1
        bossHpIndicator.text = "Hp " .. bossHp
        end
    table.remove( missleTab, index )
    event:removeSelf()
   if bossHp <= 0 then
       functions.dead()
       end
 --   event.target = nil
end
functions.bossShooting = function()
    if started == true then
        local shoot = math.random(1,100)
        if shoot > 60 then
    if #missleTab < 20 then
        local x = math.random(1+10, properties.width-10)
    local missle = display.newImageRect (properties.missleBone,  70, 41)
        missle.x = x
        missle.y = properties.y - 10
    sceneGroup:insert(missle)
    table.insert (missleTab, missle)
        transition.to ( missle, {time = 4500, x = x, y = hero.y - hero.height/2 + 5, rotation = 960, onComplete = functions.hitChecker})
    end
    end
    end
end
functions.playerMovment = function (event)
    transition.cancel( hero )
transition.to(hero, {time= (((event.x - hero.x)^2)^(1/2))*4, x = event.x })
end

functions.touchHandler = function( event )
    if started == true then
    if event.phase == "began" then
        print( "Touch : " .. event.x , event.y )
       --- functions.playerShooting(event)
        functions.playerMovment(event)
    end
    return true
        end
end
functions.win = function()
    local function afterAniCallback()
        media.stopSound()
        touchRect.isHitTestable = false
        media.playSound( "sounds/boss1Win.mp3" )

        ---TODO what to do after we killed the boss?
    end
    ---BOOM BOOM DIE of GHOST ANIMATION
    local ghostTrap =  display.newImageRect("graphicsRaw/bosses/ghostTrap.png", 269/1.5, 312/1.5);
    ghostTrap.anchorX = -1
    ghostTrap.x = properties.x
    ghostTrap.y = properties.height - ghostTrap.height
    sceneGroup:insert  ( ghostTrap )
    transition.to ( boss, { time = 1500, xScale = 0.01, yScale = 0.01, rotation =1400, y = ghostTrap.y-ghostTrap.height/2 + ghostTrap.height/10, x = ghostTrap.x+ghostTrap.width - ghostTrap.width/10, onComplete =afterAniCallback })
 --   afterAniCallback()

end
functions.survived = function ()
    if bossHp > 0 then
    timer.cancel( shootTimer )
    for i=1 , #missleTab do
    transition.cancel( missleTab[i] )
    missleTab[i]:removeSelf()
    end
    missleTab = {}
    transition.to ( boss, { time = 2500, rotation = 0, y = properties.center.y -  boss.height/2, onComplete = functions.win})
        end
end
function scene:create(event)
    --local state = event.params.state
     sceneGroup = self.view
    local boss = firstBoss.new()
    boss.x = properties.center.x
    boss.y = properties.center.y
    sceneGroup:insert(boss)
  --  functions.playSound()
  media.playSound( "sounds/boss1.mp3" )
    functions.initation(boss)

 touchRect = display.newRect (properties.center.x, properties.center.y, properties.width, properties.height)
    touchRect.isVisible = false
    touchRect.isHitTestable = true
--    local myText = display.newText({ text = 0, font = properties.font, fontSize = properties.resourcesUsageFont })
--    myText:scale(0.7, 0.7)
--    myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
--    myText:setFillColor(1, 1, 1)
--
    bossHpIndicator = display.newText({ text = "Hp " .. bossHp, font = properties.font, fontSize = properties.resourcesUsageFont })
    bossHpIndicator:scale(0.7, 0.7)
    bossHpIndicator.x, bossHpIndicator.y = display.screenOriginX + bossHpIndicator.contentWidth * 0.5 + 10, display.screenOriginY + bossHpIndicator.height / 2 + 10
    bossHpIndicator:setFillColor(1, 1, 1)
    sceneGroup:insert   ( bossHpIndicator )

    touchRect:addEventListener( "touch", functions.touchHandler )
    shootTimer =  timer.performWithDelay( 60, functions.bossShooting, -1 )
    timer.performWithDelay ( 1000*60 * 1, functions.survived, 1)
    --- CURRENTLY NOT USED MAIN MENU

end

function scene:show(event)
    media.playSound()
end


function scene:hide(event)
    media.pauseSound()
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene



