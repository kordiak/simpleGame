
local Character = {};

Character.new = function(params)

    local skin = params.skin or nil ;
    local width = params.width or 90;
    local height = params.width or 90;
    local type = params.type or "empty";
    local xPosition = params.xPosition or 0;
    local yPosition = params.yPosition or 0;
    local currentHex = params.currentHex or 0;
    local characterLevel = params.characterLevel or 0;
    local characterDiff = params.diff or nil;
    local notHere = false

    local object = display.newImageRect(skin, width, height);
    object.x = xPosition;
    object.y = yPosition;
    object.type = type;
    object.currentHex=currentHex;
    object.diff = characterDiff
    object.notHere =notHere

    object.removeMe = function()
        object:removeSelf();
    --//todo:Consider if it is necessary
    end


    return object;
end

return Character
