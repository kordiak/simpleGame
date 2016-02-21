--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-21
-- Time: 13:15
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")
local button = require("code.modules.button")
local saveAndLoad = require("code.global.saveAndLoad")

local popup = {}

popup.new = function(data, callback)
    local group = display.newGroup()
    local overlay = display.newRect(properties.center.x, properties.center.y, properties.width, properties.height)
    overlay:setFillColor(1,1,1)


    local overlayTouch = function()
        return true
    end
    overlay:addEventListener("touch", overlayTouch)
    overlay:addEventListener("tap", overlayTouch)

    group:insert(overlay)

    local closeCb = function()
        group:removeSelf()
        group = nil
    end
    local closeButton = display.newImageRect("graphic/close.png", 96, 96)
    closeButton.x = properties.x + properties.width - closeButton.contentWidth * 0.5 - 5
    closeButton.y = properties.y + closeButton.contentHeight * 0.5 + 5

    button.mb(closeButton, closeCb)
    group:insert(closeButton)


    local movmentTimeBtn = button.addSubButton(0, 1500, nil, properties.movmentTime, "Movment Time")
    movmentTimeBtn.x = properties.x + 100
    group:insert(movmentTimeBtn)

    local delayTimeBtn = button.addSubButton(0, 1500, nil, properties.delayTime, "Delay Time")
    delayTimeBtn.x = properties.x + 100
    delayTimeBtn.y = movmentTimeBtn.y + 150
    group:insert(delayTimeBtn)

    local intervalBtn
    local function invervalCb()
        properties.intervalToChangeValues = intervalBtn.getValue()
    end

    intervalBtn = button.addSubButton(10, 1500, 10, properties.intervalToChangeValues, "Value to change Settings", invervalCb)
    intervalBtn.x = movmentTimeBtn.x
    intervalBtn.y = movmentTimeBtn.x + movmentTimeBtn.contentHeight *0.5 + delayTimeBtn.contentHeight * 0.5 + 100
    group:insert(intervalBtn)
    logTable(data)

    local pauseAfterMoveBtn = button.togBtn("Pause After Move", properties.pauseAfter)
    pauseAfterMoveBtn.y =intervalBtn.y + intervalBtn.contentHeight * 0.5 + pauseAfterMoveBtn.contentHeight * 0.5 + 50
    pauseAfterMoveBtn.x= properties.x + 100
    group:insert(pauseAfterMoveBtn)


    local acceptCb = function()
        properties.movmentTime = movmentTimeBtn.getValue()
        properties.delayTime = delayTimeBtn.getValue()
        properties.intervalToChangeValues = intervalBtn.getValue()
        properties.pauseAfter = pauseAfterMoveBtn.getValue()

        local settingsTab = data
        if not data.settings then data.settings = {} end
        data.settings.movmentTime = properties.movmentTime
        data.settings.delayTime = properties.delayTime
        data.settings.intervalToChangeValues = properties.intervalToChangeValues
        data.settings.pauseAfter = properties.pauseAfter

        saveAndLoad.save(settingsTab, properties.saveFile)
        if callback then
            callback()
        end
        closeCb()
    end
    local acceptButton = display.newImageRect("graphic/accept.png", 96, 96)
    acceptButton.x = closeButton.x
    acceptButton.y = closeButton.y + closeButton.contentHeight * 0.5 + acceptButton.contentHeight * 0.5 + 5

    button.mb(acceptButton, acceptCb)
    group:insert(acceptButton)




    return group
end

return popup

