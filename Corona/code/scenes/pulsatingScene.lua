local composer = require( "composer" )
local properties = require("code.global.properties")
local waves = require ("code.classes.waves")

--local colorAnimator = require ("code.classes.colorAnimator")

local scene = composer.newScene()


local creators = display.newGroup()
local function remover ()
    transition.cancel()
    composer.removeScene( "code.scenes.firstScene" )
    --[[
    scene.view.rect1:removeSelf()
    scene.view.rect2:removeSelf()
    scene.view.rect1nap:removeSelf()
    scene.view.rect2nap:removeSelf()
    scene.view.nap1:setFillColor(1,1,1,1)
    --]]
end



function scene:create( event )
    local sceneGroup = self.view
    local mainButtonsGroup = display.newGroup()
    local size = properties.sizeOfButtons
    local corners = properties.cornerSize -- SIZE OF CORNERS

    sceneGroup.tittle1 = display.newText ("Ghost", properties.center.x, 115, properties.font, 90)
    sceneGroup.tittle1:setFillColor (0.125,0.213,0.133)
    sceneGroup:insert(sceneGroup.tittle1)
--
--    local params = {
--        object = sceneGroup.tittle1,
--        startingColor = {0,1,0},
--        desiredColor = {1,0,0},
--        onCancelColor = {1,1,1},
--        time = 5000,
--        callback = nil
--
--    }
--    colorAnimator.new(params)
--
--    timer.performWithDelay (12000,  colorAnimator.cancel)

--
--    local params2 = {
--        type = "wave", -- or fish or boat or random
--        time = 4050, -- time for 1 wave
--        x = properties.center.x,
--        y = properties.center.y
--
--    }
--
--    waves.new(params2)
--
--    timer.performWithDelay (1200,  waves.remove)

    local a = display.newRect (properties.center.x, properties.center.y, 580, properties.height - 50)
    a:setFillColor (1,0,0)

    local mask = graphics.newMask("graphicsRaw/maskTest/mask-progress.png")
    a:setMask(mask)

    a.maskX = 0




end


function scene:destroy(event)


    local sceneGroup=self.view

    --[[
    scene.view.rect1:removeEventListener("touch",rectTouch)
    scene.view.rect2:removeEventListener("touch",rectTouch)
    scene.view.rect1nap:removeEventListener("touch",rectTouch)
    scene.view.rect2nap:removeEventListener("touch",rectTouch)
    --]]



end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene