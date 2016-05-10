--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 19:52
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")

local button = {}


button.new = function(params)

    local group = display.newGroup()

    local buttonBg = display.newRect(params.x or 0, params.y or 0, params.width or 100, params.height or 100)
    if params.bgColor then
        buttonBg:setFillColor(unpack(params.bgColor))
    end
    group:insert(buttonBg)

    local buttonText = display.newText(params.text, buttonBg.x, buttonBg.y, params.font or properties.font, params.fontSize or 50)
    if params.textColor then
        buttonText:setFillColor(unpack(params.textColor))
    end
    group:insert(buttonText)

    function buttonBg:touch(event)
        if (event.phase == "began") then
            -- set touch focus
            display.getCurrentStage():setFocus(self)
            self.isFocus = true

            if params.callback then
                params.callback(event.target)
            end
        elseif (self.isFocus) then
            if (event.phase == "moved") then
            elseif (event.phase == "ended" or event.phase == "cancelled") then
                display.getCurrentStage():setFocus(nil)
                self.isFocus = nil
            end
        end
        return true
    end

    buttonBg:addEventListener("touch", buttonBg)

    return group
end

button.mb = function(obj, cb)
    function obj:touch(event)
        if (event.phase == "began") then
            -- set touch focus
            display.getCurrentStage():setFocus(self)
            self.isFocus = true

            if cb then
                cb(event.target)
            end
        elseif (self.isFocus) then
            if (event.phase == "moved") then
            elseif (event.phase == "ended" or event.phase == "cancelled") then
                display.getCurrentStage():setFocus(nil)
                self.isFocus = nil
            end
        end
        return true
    end

    obj:addEventListener("touch", obj)
end

button.addSubButton = function(minValue, maxValue, interval, currentValue, descriptionText, cb)
    local value = currentValue
    local group = display.newGroup()
    local valueText

    local function minusCb()
        if value - (interval or properties.intervalToChangeValues) >= minValue then
            value = value - (interval or properties.intervalToChangeValues)
            valueText.text = value
            if cb then cb() end
        end
    end

    local function plusCb()
        if value + (interval or properties.intervalToChangeValues) <= maxValue then
            value = value + (interval or properties.intervalToChangeValues)
            valueText.text = value
            if cb then cb() end
        end
    end

    group.getValue = function()
        return value
    end

    local minusButton = display.newImageRect("graphic/minus.png", 96, 96)
    button.mb(minusButton, minusCb)
    group:insert(minusButton)

    valueText = display.newText({ text = value, font = "", fontSize = 26, x = 0, y = 0 })
    valueText.x = minusButton.x + minusButton.contentWidth * 0.5 + 50 * 0.5 + 5
    group:insert(valueText)

    local plusButton = display.newImageRect("graphic/plus.png", 74, 74)
    plusButton.x = valueText.x + 50 * 0.5 + plusButton.contentWidth * 0.5 + 5
    button.mb(plusButton, plusCb)
    group:insert(plusButton)

    local descriptionText = display.newText({ text = descriptionText, font = "", fontSize = 26, x = 0, y = 0 })
    descriptionText.x = valueText.x
    group:insert(descriptionText)


    descriptionText.y = valueText.y - minusButton.contentHeight * 0.5 - 10

    valueText:setFillColor(0, 0, 0)
    descriptionText:setFillColor(0, 0, 0)


    return group
end


button.togBtn = function(descriptionText, value, callback)
    local group = display.newGroup()



    local onButton, offButton
    local state = value

    local textValue = descriptionText

    group.getValue = function()
    return state
    end

    local function toggleCb()
        state = not state
        onButton.isVisible = state
        offButton.isVisible = not state
        if callback then callback(textValue) end
    end

    onButton = display.newImageRect("graphic/check_full.png", 96, 96)
    onButton.isVisible = state
    onButton.isHitTestable = true
    button.mb(onButton, toggleCb)
    group:insert(onButton)

    offButton = display.newImageRect("graphic/check_empty.png", 96, 96)
    offButton.isVisible = not state
    group:insert(offButton)

    local descriptionText = display.newText({ text = descriptionText, font = "", fontSize = 26, x = 0, y = 0 })
    descriptionText:setFillColor(0, 0, 0)
    descriptionText.x = onButton.x + onButton.contentWidth * 0.5 + descriptionText.contentWidth * 0.5 + 5
    group:insert(descriptionText)

    return group
end

return button