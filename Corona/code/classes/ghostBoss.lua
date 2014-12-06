local Boss = {};
local properties = require("code.global.properties")
--[[
    --skin --width --height --type --xPostion --yPosition --currentHex
--]]
Boss.new = function(params)
    if not params then
       params = {}
        end

    local skin = params.skin or properties.ghostImg ;
    local width = params.width or 533;
    local height = params.width or 522;
    local type = params.type or "empty";
    local xPosition = params.xPosition or 0;
    local yPosition = params.yPosition or 0;
    local currentHex = params.currentHex or 0;
    local BossLevel = params.BossLevel or 0;

    local object = display.newImageRect(skin, width, height);
    object.x = xPosition;
    object.y = yPosition;
    object.type = type;
    object.currentHex=currentHex;

    object.removeMe = function()
        object:removeSelf();
        --//todo:Consider if it is necessary
    end


    return object;
end

return Boss
