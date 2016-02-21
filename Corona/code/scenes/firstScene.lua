local composer = require("composer")
local properties = require("code.global.properties")
local saveAndLoad = require("code.global.saveAndLoad")
local button = require("code.modules.button")

local scene = composer.newScene()

local options = { effect = "crossFade", time = 1500, params = {} }
local rectsFILLcolor = { 0.52, 0.39, 0.39 }
local textCOLOR = { 0.8, 0.498039, 0.372549 }
local functions = {}
local transCompleted = false

local gameScene = "code.scenes.bossScene"

local creators = display.newGroup()
local function remover()
    transition.cancel()
    composer.removeScene("code.scenes.firstScene")
end


local function startCb()
    if transCompleted == true then
        composer.gotoScene("code.scenes.gameScene")
        remover()
    end
end

function scene:create(event)
    local data = saveAndLoad.load(properties.saveFile)
    logTable(data)
    if data.settings then
        if data.settings.movmentTime then
            properties.movmentTime = data.settings.movmentTime
        end
        if data.settings.delayTime then
            properties.delayTime = data.settings.delayTime
        end

        if data.settings.intervalToChangeValues then
            properties.intervalToChangeValues = data.settings.intervalToChangeValues
        end

        if data.settings.pauseAfter then
            properties.pauseAfter = data.settings.pauseAfter
        end
    end

    --    local sceneGroup = self.view
    --
    --    local fileToSave = saveAndLoad.load(properties.saveFile)
    --
    --    local mainButtonsGroup = display.newGroup()
    --
    --    local leftTitle = display.newText("Praca ", -155, properties.y + 100, properties.font, 80)
    --    transition.to(leftTitle, { time = 2500, alpha = 1.0, x = properties.center.x - 175, transition = easing.outBounce })
    --    sceneGroup:insert(leftTitle)
    --
    --    local rightTitle = display.newText("Inzynierska", properties.width + 135, leftTitle.y, properties.font, 80)
    --    transition.to(rightTitle, { time = 2500, alpha = 1.0, x = properties.center.x + 100, transition = easing.outBounce })
    --    sceneGroup:insert(rightTitle)
    --
    --    local subTitle = display.newText("Bartosz Wolski", 0, 0, properties.font, 50)
    --    subTitle.y = leftTitle.y + subTitle.height + 55
    --    subTitle.x = properties.center.x
    --    mainButtonsGroup:insert(subTitle)
    --
    --    local startButton = button.new({ text = "Start", width = 300, height = 100, x = properties.center.x, y = properties.center.y, fontSize = 90, callback = startCb, bgColor = { 1, 1, 1 }, textColor = { 0, 0, 0 } })
    --    mainButtonsGroup:insert(startButton)
    --    mainButtonsGroup.alpha = 0
    --
    --    transition.to(mainButtonsGroup, { time = 1500, alpha = 1.0, transition = easing.inCirc, onComplete = function() transCompleted = true end })
    --
    --    sceneGroup:insert(mainButtonsGroup)
    --    sceneGroup:insert(creators)


    local function showMailPicker()
        -- Create mail options --
        local options =
        {
            to = { "me@me.com", },
            subject = "Algorythms data from : " .. os.date("%c"),
            body = "Email Body",
            attachment =
            {
                { baseDir = system.DocumentsDirectory, filename = properties.saveFile, type = "text" },
            },
        }
        native.showPopup("mail", options)
    end

    composer.gotoScene("code.scenes.gameScene")
end


function scene:destroy(event)
end


function scene:show(event)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene