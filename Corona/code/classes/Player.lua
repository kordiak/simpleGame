--
-- Created by IntelliJ IDEA.
-- User: acer
-- Date: 2014-10-19
-- Time: 13:55
-- To change this template use File | Settings | File Templates.
--

local Character = require("code.classes.Character");

local Player = {}
--[[
    --skin --width --height --type --xPostion --yPosition --currentHex
--]]
Player.new = function(params)
    params.type = params.type or "player";
    local object=Character.new(params);
    return object;
end
return Player;

