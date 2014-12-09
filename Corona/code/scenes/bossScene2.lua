local composer = require("composer")
local properties = require("code.global.properties")
local physics = require( "physics" )


local functions = {}

local wallTab = {}

local wallGroup = display.newGroup()

local touchRect, text, elementCounter, arrow, gravityXFactor, sceneGroup

local sceneLoaded = false

local scene = composer.newScene()

local function close()
    physics.stop()
    composer.gotoScene("")
    composer.removeScene("")
end

functions.generateWall = function (event)

    local wallElement = display.newRect (event.x , event.y,5,5)
    table.insert (wallTab, wallElement)
    text.text = elementCounter - #wallTab
    physics.addBody( wallElement, "static", { friction=0.2, bounce=0.3 } )
    wallGroup:insert( wallElement )
end

functions.test = function (x)
    local ball = display.newCircle (x , 0,25)
    ball.y = properties.y - ball.height
    physics.addBody( ball, { density=0.8, friction=0.1, bounce=0.3, radius=23 } )
   -- sceneGroup:rotate(-(gravityXFactor*15))
 end
functions.touchHandler = function( event )
    if sceneLoaded == true then
        if event.phase == "moved" then
              if tonumber(text.text) > 0 then
            functions.generateWall(event)
            end

            --- functions.playerShooting(event)

        end
        return true
    end
end

functions.textInitation = function (element)
   local  text = display.newText({ text = "" .. element, font = properties.font, fontSize = properties.resourcesUsageFont })
    text:scale(0.7, 0.7)
    text.x, text.y = display.screenOriginX + text.contentWidth * 0.5 + 10, display.screenOriginY + text.height / 2 + 10
    text:setFillColor(1, 1, 1)
    return text
end

functions.arrowInitation = function (rotation)
    local arrow
   local function arrowAnimation ()
       if not arrow.scaled then
           arrow.scaled = true
        transition.to ( arrow, {time = 350, xScale = 1.1, yScale = 1.1, onComplete = arrowAnimation})
       else
           arrow.scaled = false
           transition.to ( arrow, {time = 350, xScale = 0.9, yScale = 0.9, onComplete = arrowAnimation})
           end
    end
    arrow = display.newImageRect ("graphicsRaw/bosses/arrow.png",  512/5, 512/5)
    arrow.x = math.random (properties.x + 10, properties.width - 10)
    arrow.y = properties.y + arrow.height/2 + 5

    print (rotation)
          arrow:rotate(-(rotation*15))

    arrowAnimation()
    timer.performWithDelay( 2560, function ()   functions.test(arrow.x) end, 1 )

    return arrow
end
function scene:create(event)
    sceneGroup = self.view
    physics.start()
    gravityXFactor = math.random (-2,2)
    physics.setGravity( gravityXFactor, 12 )
   -- physics.setDrawMode( "debug" )
    -- physics.setScale( 5 )
    sceneLoaded = true
    touchRect = display.newRect (properties.center.x, properties.center.y, properties.width, properties.height)
    touchRect.isVisible = false
    touchRect.isHitTestable = true
    touchRect:addEventListener( "touch", functions.touchHandler )

    elementCounter = 400

    text = functions.textInitation(elementCounter)
    sceneGroup:insert   ( text )
    arrow = functions.arrowInitation(gravityXFactor)
    sceneGroup:insert   ( arrow )
    sceneGroup:insert   ( wallGroup )


end

function scene:show(event)
end


function scene:hide(event)
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

