--
-- Created by IntelliJ IDEA.
-- User: root
-- Date: 29.10.14
-- Time: 16:21
-- To change this template use File | Settings | File Templates.
--

local properties = require("code.global.properties")
local Enemy = require("code.classes.Enemy");
local Player = require("code.classes.Player");

local elementCreator={};

elementCreator.new=function(mainBoard,enemyCallback,simpleGhostEnemiesTable,enemiesTable)

elementCreator.enemyCreator = function()
    for p = 1, (properties.enemiesNumber + math.round(properties.currentLevel / 2)) do
        local q = true
        while q do
            local i = math.random(1, #mainBoard - 5)
            if mainBoard[i].isFree then

                local params = {};
                params.xPosition = mainBoard[i].x;
                params.yPosition = mainBoard[i].y;
                params.currentHex = i;
                params.type = "simpleMeleeGhost";
                local enemy = Enemy.new(params);
                enemy.beforeHex = {}

                mainBoard[i].isFree = false
                mainBoard[i].isWalkAble = false
                mainBoard[i].content = enemy
                mainBoard[i].contentType ="enemy"


                table.insert(simpleGhostEnemiesTable, enemy)
                table.insert(enemiesTable, enemy)

                q = false
            end
        end
    end
    enemyCallback();
end
elementCreator.mainHeroCreator = function(mainHero,levelGoal)
    if not mainHero then

        local params = {};
        params.skin = properties.mainCharacterSkin;
        params.xPosition = mainBoard[#mainBoard].x;
        params.yPosition = mainBoard[#mainBoard].y;
        params.currentHex = #mainBoard;
        mainHero=Player.new(params);


        --mainHero = display.newImageRect(properties.mainCharacterSkin, 90, 90)
        --mainHero.x = mainBoard[#mainBoard].x
        --mainHero.y = mainBoard[#mainBoard].y
        mainBoard[#mainBoard].isFree = false
        mainBoard[#mainBoard].isWalkAble = false
        mainHero.currentHex = #mainBoard
    end

    if not levelGoal then

        levelGoal = display.newImageRect(properties.levelGoal, 90, 90)
        levelGoal.x = mainBoard[1].x
        levelGoal.y = mainBoard[1].y
        mainBoard[1].isFree = false
        mainBoard[1].isWalkAble = false
        mainBoard[1].content = levelGoal
    end
    --elementCreator.enemyCreator();
    return mainHero, levelGoal;
end

end



return elementCreator;

