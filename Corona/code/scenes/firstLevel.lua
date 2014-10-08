local composer = require("composer")
local properties = require("code.global.properties")
local boardCreator = require("code.boardLibary.boardCreator")

local scene = composer.newScene()

local function close()

    composer.gotoScene("")
    composer.removeScene("")
end

function scene:create(event)
    local state = event.params.state
    local sceneGroup = self.view
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

