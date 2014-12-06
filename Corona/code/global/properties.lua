local properties = {}


properties.width = display.contentWidth + display.screenOriginX * -2
properties.height = display.contentHeight + display.screenOriginY * -2
properties.x = display.screenOriginX
properties.y = display.screenOriginY
properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }
properties.device = system.getInfo("model")

properties.font = native.systemFont
properties.inSquareFont = 60
properties.resourcesUsageFont = 40
properties.mainMenuFontSize  = 65

properties.directionLeft = "left"
properties.directionRight = "right"

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


return properties