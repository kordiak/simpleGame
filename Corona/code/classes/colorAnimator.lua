local functions = {}

local startingColor, desiredColor , stepColors , time,object, colorMathTable, onCancelColor
local frameCounter = 1

local goalAchived = false


local function startColorToEndColor()
    if not goalAchived then
    if frameCounter < (math.round(time/16) -1) then
        object:setFillColor (colorMathTable[1] + stepColors[1],colorMathTable[2] + stepColors[2],colorMathTable[3] + stepColors[3] )
        for i =1, #colorMathTable do
            colorMathTable[i] = colorMathTable[i] + stepColors[i]
        end
    elseif frameCounter == math.round(time/16) then
        object:setFillColor (unpack(desiredColor))
        goalAchived = true
        frameCounter = 1
    end
    end

end

local function endColorToStartColor()
    if goalAchived then
    if frameCounter < (math.round(time/16) -1) then
        object:setFillColor (colorMathTable[1] - stepColors[1],colorMathTable[2] - stepColors[2],colorMathTable[3] - stepColors[3] )
        for i =1, #colorMathTable do
            colorMathTable[i] = colorMathTable[i] - stepColors[i]
        end
    elseif frameCounter == math.round(time/16) then
        object:setFillColor (unpack(startingColor))
        goalAchived = false
        frameCounter = 1
    end
    end

end

local function onFrame()
    if goalAchived then
        endColorToStartColor()
        else
        startColorToEndColor()
    end
    frameCounter = frameCounter + 1
  --
end

functions.new = function (params)
    assert (params.object)
    assert (params.desiredColor)
    assert (params.startingColor)
    startingColor = params.startingColor
    desiredColor = params.desiredColor
    onCancelColor = params.onCancelColor or startingColor
    time = params.time or 5000
    object = params.object
    stepColors = {((((startingColor[1]-desiredColor[1])^2)^(1/2))/math.round(time/16)),((((startingColor[2]-desiredColor[2])^2)^(1/2))/math.round(time/16)),((((startingColor[3]-desiredColor[3])^2)^(1/2))/math.round(time/16)) }
    for i =1, #stepColors do
        if startingColor[i] > desiredColor[i] then
            stepColors[i] = stepColors[i] * -1
            elseif startingColor[i] < desiredColor[i] then

        end
    end
    colorMathTable = startingColor

end

functions.cancel = function ()
    Runtime:removeEventListener ("enterFrame", onFrame)
    object:setFillColor(unpack(onCancelColor))
end









Runtime:addEventListener( "enterFrame", onFrame )

return functions