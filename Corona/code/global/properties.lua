local properties = {}


properties.width = display.contentWidth + display.screenOriginX * -2
properties.height = display.contentHeight + display.screenOriginY * -2
properties.x = display.screenOriginX
properties.y = display.screenOriginY
properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }
properties.device = system.getInfo("model")

properties.loadSceneFontSize = 30


properties.cornerSize = 0
properties.sizeOfButtons = 100


--properties.font = "Comic Sans MS"
--properties.font = "Debbie-Alternate Regular"
if "Win" == system.getInfo( "platformName" ) then
    properties.font = "Debbie"
elseif "Android" == system.getInfo( "platformName" ) then
    properties.font = "DebbieAlternate"
end
properties.inSquareFont = 60
properties.resourcesUsageFont = properties.width/8
properties.mainMenuFontSize  = 65

properties.directionLeft = "left"
properties.directionRight = "right"


properties.firstSceneTextColor = {0.78,0.654,0.520};
properties.firstSceneRectsColor = {0.16,0.55,0.47677};


properties.buttonTransTime = 400


properties.sceneTitleColor = { r = 1, g = 1, b = 1, a = 1 }

properties.mainBoard2Rows = 36 --- was 18
properties.mainBoard2HexesInRow = 20  --- was 5

properties.firstRow = 0
properties.lastRow = 0
properties.textInHexesAlpha = 1

properties.numberOfForests= 3

--properties.hexTexturePath = "graphicsRaw/mainBoard/emptyHexGravelTexture.png"
--properties.environmentForest1 = "graphicsRaw/environment/smallForest.png"
--properties.enemy1 = "graphicsRaw/enemies/enemy.png"
--properties.enemy={    "graphicsRaw/enemies/enemy.png","graphicsRaw/enemies/enemy.png","graphicsRaw/enemies/enemy.png"}
--properties.levelGoal = "graphicsRaw/items/levelGoal.png"
--properties.mainCharacterSkin = "graphicsRaw/characters/mainCharacter2.png"

properties.ghostImg = "graphicsRaw/bosses/ghost.png"
properties.hexTexturePath = "graphicsRaw/mainBoard/emptyHexWoodTexture.png"
properties.environment = {"graphicsRaw/environment/envi1.png","graphicsRaw/environment/envi2.png","graphicsRaw/environment/envi3.png"}
properties.enemy={"graphicsRaw/enemies/enemy3.png","graphicsRaw/enemies/enemy4.png","graphicsRaw/enemies/enemy5.png","graphicsRaw/enemies/enemy3_nerd.png","graphicsRaw/enemies/enemy2_clown.png"}
properties.levelGoal = "graphicsRaw/items/levelGoal4.png"
properties.mainCharacterSkin = "graphicsRaw/characters/mainCharacter3.png"
properties.missleBone = "graphicsRaw/missle/bone2.png"
properties.forestSize = 10
properties.lastPickedHexForEnvironmentForestGenerator = 1
properties.currentLevel = 1
properties.saveFile = "saveFile.json"

properties.enemiesNumber  = 0
properties.miniDistanceHandler = properties.width + properties.height

properties.heroTransTime = 750
properties.enemyTransTime = 750


--- IMG SHEETS

local options =
{
    width = 64,
    height = 39,
    numFrames = 10
}
properties.boneSheet = graphics.newImageSheet( "graphicsRaw/spirites/boneSheet2.png", options )

properties.boneSequenceData =
{
    name="explode",
    start=1,
    count=10,
    time=400,
    loopCount = 1,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
}



local options =
{
    width = 533,
    height = 522,
    numFrames = 8
}
properties.ghostSheet = graphics.newImageSheet( "graphicsRaw/spirites/ghostBossSheet.png", options )

properties.ghostSequenceData =
{
    name="explode",
    start=1,
    count=8,
    time=450,
    loopCount = 1,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
}



-----

return properties