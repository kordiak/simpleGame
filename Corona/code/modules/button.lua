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

return button