require("code.otherLibrary.console")
log = logging.console()
logTable = logging.logTable
shallowLogTable = logging.shallowLogTable

--=============================================================================
-- hiding status bar
--=============================================================================
display.setStatusBar(display.HiddenStatusBar)


--======================================
--
--     INIT MODULE
--
--======================================

local composer = require("composer")
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
composer.gotoScene("code.scenes.firstScene");


local function onKeyEvent( event )
    local returnValue = true
    local prevScene = composer.getSceneName("previous")
    local currScene = composer.getSceneName("current")

    if (event.phase=="up" and event.keyName=="back") then
        local options={effect="crossFade",time=750,params={}}
   if prevScene then
       if currScene ~= "code.scenes.bossScene" and currScene ~= "code.scenes.bossScene2" then
           if currScene == "code.scenes.firstScene" then
               native.requestExit()
               elseif currScene == "code.scenes.gameScene" then
               composer.gotoScene("code.scenes.firstScene",options)
               else
        composer.gotoScene(prevScene,options)
               end
       end
    end

    return returnValue
    end
    end

-- Add the key callback
Runtime:addEventListener( "key", onKeyEvent )