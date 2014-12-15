local composer = require("composer")


local scene = composer.newScene()


function scene:create(event)
    local gotoNextSceneFlag = true
local function touchHandler()
    if gotoNextSceneFlag then
        gotoNextSceneFlag = false
        local options = {
            effect = "slideLeft",
            time = 5800
                    }
        composer.removeScene("code.scenes.errorTests.first")
        composer.gotoScene("code.scenes.errorTests.second",options)
        end
print ("SAA")
end

    local sceneGroup = self.view

    local a = display.newText({ text = "firstScene", font = native.Systemfont, fontSize = 45 })

    a:setFillColor(1, 1, 1)
    local properties = {}
    properties.x = display.screenOriginX
    properties.y = display.screenOriginY

    properties.width = display.contentWidth + display.screenOriginX * -2
    properties.height = display.contentHeight + display.screenOriginY * -2

    a.x, a.y =properties.width-a.width/2 , 450
    properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }


    local b = display.newRect(properties.center.x,properties.center.y,properties.width,properties.height)
    b:setFillColor(1,0,0)
    sceneGroup:insert(b)
    sceneGroup:insert(a)

    a:addEventListener("touch", touchHandler)
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

