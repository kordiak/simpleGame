local wavesObject = {}

local waveTable = {}
local positionsTable = {}
local maskFile

wavesObject.new = function(params)
    local group = display.newGroup()
    local wavesGroup = display.newGroup()
    local waveType = params.type
    local time = params.time or 1000
    local x = params.x
    local y = params.y
    local fileName, waveHeight, waveWidth

    if waveType == "wave" then
        fileName = "graphicsRaw/waves/wave.png"
        waveWidth = 255
        waveHeight = 27
        maskFile = "graphicsRaw/waves/wave-mask.png"
    elseif waveType == "fish" then
        fileName = "graphicsRaw/waves/waves-fish.png"
        waveWidth= 680
        waveHeight = 107
        maskFile = "graphicsRaw/waves/waves-boat-fish-mask.png"
    elseif waveType == "boat" then
        fileName = "graphicsRaw/waves/waves-boat.png"
        waveWidth = 680
        waveHeight = 107
        maskFile = "graphicsRaw/waves/waves-boat-fish-mask.png"
    else
        local waveIndi = math.random(1, 3)
        if waveIndi == 1 then
            fileName = "graphicsRaw/waves/wave.png"
            waveWidth = 255
            waveHeight = 27
            maskFile = "graphicsRaw/waves/wave-mask.png"
        elseif waveIndi == 2 then
            fileName = "graphicsRaw/waves/waves-fish.png"
            waveWidth= 680
            waveHeight = 107
            maskFile = "graphicsRaw/waves/waves-boat-fish-mask.png"
        else
            fileName = "graphicsRaw/waves/waves-boat.png"
            waveWidth = 680
            waveHeight = 107
            maskFile = "graphicsRaw/waves/waves-boat-fish-mask.png"
        end
    end

    local function wavesGenerator ()
    for i=1,3 do
        local wave = display.newImageRect( fileName,   waveWidth/2, waveHeight/2 )
        wave.number = i
        wavesGroup:insert(wave)
        table.insert(waveTable, wave)
        wave.x = wave.width* (i-2)
        local destX= wave.x
        table.insert(positionsTable,destX)

        end
    end
    logTable(params)
local transitions
    wavesGenerator()

    --print(waveTable[2].width)

    local mask = graphics.newMask( maskFile )
    wavesGroup:setMask(mask)

    local transCounter = 0
    local function transCompleted ()
        transCounter = transCounter +1
        if transCounter == 3 then
            transCounter = 0
            local copyOfTable = table.copy (waveTable)
            waveTable[1] = copyOfTable[3]
            waveTable[2] = copyOfTable[1]
            waveTable[3] = copyOfTable[2]
            transitions()
        end
        end

   function transitions ()
    for i =1, #waveTable do
        if i == 1 then
        transition.to( waveTable[i], { time=time, x =positionsTable[2], onComplete = transCompleted}  )
        elseif i == 2 then
            transition.to( waveTable[i], { time=time, x =positionsTable[3], onComplete = transCompleted}   )
        else
            waveTable[i].x = positionsTable[1]
            transition.to( waveTable[i], { time=time, x =positionsTable[1], onComplete = transCompleted}   )
        end
        end


    end
    transitions()

    group:insert(wavesGroup)
if x and y then
    group.x = x
    group.y = y
end

    wavesObject.remove = function ()
        for i=1,#waveTable do
    transition.cancel(waveTable[i])
    waveTable[i]:removeSelf()
    end
    end
    return group
end

return wavesObject