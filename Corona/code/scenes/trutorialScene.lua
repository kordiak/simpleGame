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



    local size = properties.sizeOfButtons
    local corners = properties.cornerSize
    sceneGroup.rect1 = display.newRoundedRect(properties.center.x, 0, properties.width - 20, size, corners)
    sceneGroup.rect1.y = properties.y + sceneGroup.rect1.height / 2 + 5
    sceneGroup.rect1nap = display.newText("Back", sceneGroup.rect1.x, sceneGroup.rect1.y, properties.font, size)
    sceneGroup.rect1:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect1nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup:insert(sceneGroup.rect1)
    sceneGroup:insert(sceneGroup.rect1nap)


        local prevScene = composer.getSceneName( "previous" )
        local currScene = composer.getSceneName( "current" )

local hintsGroup = display.newGroup()
    local fh = display.newText("1. You need to get to the brain.\n2. Ghost don't kill you but block and send to boss fight.\n3. Boss fights can kill you.\n4. After Boss Fight some ghosts will run scared away based on your score.\n5. Get as far as possible, ghost have some move habits discover them!\n6. Most Importantly have fun, good luck with your adventure!\n7. Extra Tip: Progress is saved :)", 0,0,properties.width-30,properties.height - sceneGroup.rect1.height , properties.font, 45)
    hintsGroup:insert(fh)


    hintsGroup.x = properties.center.x
    hintsGroup.y = properties.center.y + sceneGroup.rect1.height



    sceneGroup:insert(hintsGroup)


    function sceneGroup.rect1:touch(event)
        if event.phase == "ended" then


            composer.gotoScene(prevScene) composer.removeScene(currScene)
        end
    end
    sceneGroup.rect1:addEventListener("touch", sceneGroup.rect1)
  end


function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
