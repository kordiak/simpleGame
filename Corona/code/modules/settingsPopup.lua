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
    overlay:setFillColor(0, 0, 0)
    overlay.alpha = 0.75

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


    local movmentTimeBtn = button.addSubButton(0,1500,50,properties.movmentTime,"Movment Time")
    movmentTimeBtn.x = properties.x + 50
    group:insert(movmentTimeBtn)
    logTable(data)


    return group
end

return popup

