local composer = require("composer")
local properties = require("code.global.properties")

local functions = {}


functions.newPopUp1 = function(params)
    local callback, cancelcallback, fillcolor, text, textcolor, tapToContinue, twoLines, text2

    text = params.text or "No Text In Params"
    text2 = params.text2 or "No Text2 In Params"
    fillcolor = params.fillColor or { 1, 1, 1, 0.8 }
    callback = params.callBack or nil
    cancelcallback = params.cancelCallBack or nil
    textcolor = params.textColor or { 0, 0, 0 }
    tapToContinue = params.tapToContinue or false
    twoLines = params.twoLines or false


    local group = display.newGroup()
    local popUpBg = display.newRect(properties.center.x, properties.center.y, properties.width, properties.height)
    popUpBg:setFillColor(0, 0, 0, 0.4)
    group:insert(popUpBg)


    local frameWidth = math.round(properties.width - 10)
    local frame = display.newImageRect("graphicsRaw/popUp/popUpBg.png", frameWidth, math.round(frameWidth / 1.46)) --- 670 486
    frame.x = properties.center.x
    frame.y = properties.center.y


    local frameFill = display.newRect(properties.center.x, properties.center.y, frame.width - frame.width / 10, frame.height - frame.height / 10)
    frameFill:setFillColor(unpack(fillcolor))
    group:insert(frameFill)
    group:insert(frame)

    local text1 = display.newText({ text = text, font = properties.font, fontSize = 65 })
    text1:setFillColor(unpack(textcolor))
    text1.x = frame.x
    text1.y = frame.y - frameFill.height / 2 + text1.height * 1.5

    group:insert(text1)

    if twoLines then
    local text3 = display.newText({ text = text2, font = properties.font, fontSize = 65 })
    text3:setFillColor(unpack(textcolor))
    text3.x = frame.x
    text3.y =   text1.y + text1.height + 8


    group:insert(text3)
    end

    if tapToContinue then
        local transFunction
        local alpha = 1
        local text2 = display.newText({ text = " tap to Continue", font = properties.font, fontSize = 65 })
        text2:setFillColor(unpack(textcolor))
        text2.x = frame.x
        text2.y = frame.y + frameFill.height / 2 - text1.height * 1.5

         transFunction = function ()
             if alpha == 1 then
                 alpha = 0.5
             else
                 alpha = 1
                 end
          --  transition.to( text2, { time=500, alpha=alpha, onComplete=transFunction } )
        end
        transFunction()
        group:insert(text2)
        end

    local popUpBgTouch = function(event)
        return true
    end

    local frameFillTouch = function(event)
        if tapToContinue then
            if event.phase == "ended" or event.phase == "cancelled" then
                if callback then
                callback()
                    end
            end
        end
    end

    frameFill:addEventListener("touch", frameFillTouch)
    popUpBg:addEventListener("touch", popUpBgTouch)

    group.removeMe = function ()
    if text2 then
        transition.cancel (text2)
    end
    group:removeSelf()
    group = nil
    end
    return group
end




return functions