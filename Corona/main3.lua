--=============================================================================
-- hiding status bar
--=============================================================================
display.setStatusBar(display.HiddenStatusBar)


--======================================
--
--     INIT MODULE
--
--======================================
local saveFile = require("code.global.saveAndLoad")
local boardCreator = require("code.boardLibrary.boardCreator")
local properties = require("code.global.properties")
local mainHero, levelGoal, mainBoard,heroCanMove, hexAxe
local functions = {}
local enemiesTable = {}
local distanceEnemyAndHero = {}
local maxDistanceEnemyAndHero = {}
local miniDistanceEnemyAndHero = {}
miniDistanceEnemyAndHero.distance =  properties.miniDistanceHandler
maxDistanceEnemyAndHero.distance = 0
local overlay, play,load,exit

-- print (saveFile.loadFile.level)
heroCanMove = true

mainBoard = boardCreator.new()



local myText = display.newText({ text = 0, font = properties.font, fontSize = properties.resourcesUsageFont })
myText:scale(0.7, 0.7)
myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
myText:setFillColor(1,1,1)

--mainBoard.mainBoardGroup.x = 50

functions.hexPressed = function (params)
    print (params.hexNumber)
  print ("PRESSED HEX POS X",  mainBoard[tonumber(params.hexNumber)].x)
    print ("GROUP POS X",mainBoard.mainBoardGroup.x)
    mainBoard.mainBoardGroup.x = - mainBoard[tonumber(params.hexNumber)].x
    mainBoard.mainBoardGroup.y = - mainBoard[tonumber(params.hexNumber)].y

end


local frames = 0
local function getFps()
    local returnF = tostring(frames)
    frames = 0
    return returnF
end
local function updateText()
    collectgarbage()
    myText.text = "  FPS : " ..getFps().. "   Memory: " .. (math.round(collectgarbage("count")*100))/100  .. "    Texture: " .. (math.round(system.getInfo("textureMemoryUsed")))/10000
    myText.x, myText.y = display.screenOriginX + myText.contentWidth * 0.5, display.contentHeight + display.screenOriginY * -1 - myText.contentHeight * 0.5
    myText:toFront()

end
local function enterframeFunc ()
    frames = frames + 1
--    for i = 1, #mainBoard do
--        if  mainBoard[i].isWalkAble then
--            mainBoard[i]:setFillColor (1,0,0,0.2)
--        else
--            mainBoard[i]:setFillColor (1,1,1)
--        end
--    end
end

timer.performWithDelay(1000, updateText, 0)
Runtime:addEventListener("enterFrame",enterframeFunc)
Runtime:addEventListener("hexPressed", functions.hexPressed)
