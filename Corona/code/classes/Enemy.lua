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
    local img = properties.enemy[i];
    return img;
end

local Character = require("code.classes.Character");

local Enemy = {}
--[[
    --skin --width --height --type --xPostion --yPosition --currentHex
--]]
Enemy.new = function(params)
    params.skin = params.skin or getRandom();
    params.type= params.type or "enemy";
    local object=Character.new(params);
    return object;
end
return Enemy;


