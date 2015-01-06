--
-- Created by IntelliJ IDEA.
-- User: acer
-- Date: 2014-10-18
-- Time: 20:32
-- To change this template use File | Settings | File Templates.
--
local properties = require("code.global.properties")
local getRandom = function()
    local i = math.random(1,#properties.enemy);
    return i;
end
local Character = require("code.classes.Character");
local Enemy = {}
Enemy.new = function(params)
    local rand =  getRandom()
    params.skin = params.skin or properties.enemy[rand];
    params.type= params.type or "enemy";
    params.diff = rand
    local object=Character.new(params);
    return object;
end
return Enemy;


