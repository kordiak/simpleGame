local composer = require("composer")
local widget = require("widget")
local properties = require("code.global.properties")
local lfs = require "lfs"
local json = require('json')
local scene = composer.newScene()


local function rectTouch(event)
    return true
end


function scene:create(event)
    local sceneGroup = self.view

        local prevScene = composer.getSceneName( "previous" )
        local currScene = composer.getSceneName( "current" )
        timer.performWithDelay ( 500, function()     composer.gotoScene(prevScene) composer.removeScene(currScene)  end, 1)
  end


function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
