local properties = {}

properties.width = display.contentWidth + display.screenOriginX * -2
properties.height = display.contentHeight + display.screenOriginY * -2
properties.x = display.screenOriginX
properties.y = display.screenOriginY
properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }
properties.device = system.getInfo("model")
properties.loadSceneFontSize = 30

properties.borderColor = {0,0,0}
properties.contentColor = {1,1,1}

if "Win" == system.getInfo( "platformName" ) then
    properties.font = "Debbie"
elseif "Android" == system.getInfo( "platformName" ) then
    properties.font = "DebbieAlternate"
end

properties.inSquareFont = 60
properties.resourcesUsageFont = properties.width/8
properties.mainMenuFontSize  = 65
properties.firstSceneTextColor = {0,0,0};
properties.firstSceneRectsColor = {0.86,0.85,0.87677};
properties.buttonTransTime = 400
properties.sceneTitleColor = { r = 1, g = 1, b = 1, a = 1 }
properties.saveFile = "saveFile.txt"
properties.heroTransTime = 550
properties.enemyTransTime = 550

properties.movmentTime = 500
properties.delayTime = 500
properties.intervalToChangeValues = 50
properties.pauseAfter = false
properties.maxGoalMoves = 50 -- 5k for daikstra

properties.startingFromBeggining = false

properties.started = false


--- ADD THIS DATA TO SETTINGS

properties.allResultsSafeIterationsNumber = 10000
--properties.allResultsSafeIterationsNumber = 4000000

return properties