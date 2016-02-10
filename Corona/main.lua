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

local widget = require( "widget" )

-- ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end

    return true
end

-- Create the widget
--local scrollView = widget.newScrollView
--    {
--        top = 100,
--        left = 10,
--        width = 300,
--        height = 400,
--        scrollWidth = 600,
--        scrollHeight = 800,
--        listener = scrollListener,
--hideBackground = false,
--backgroundColor = { 0.4, 0.4, 0.4 } --grey
--    }


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