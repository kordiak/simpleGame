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

    if (event.phase=="up" and event.keyName=="back") then
        local options={effect="crossFade",time=750,params={}}
   if prevScene then
        composer.gotoScene(prevScene,options)
       end
    end

    return returnValue
end

-- Add the key callback
Runtime:addEventListener( "key", onKeyEvent )