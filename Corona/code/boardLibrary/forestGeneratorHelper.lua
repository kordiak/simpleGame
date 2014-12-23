local properties = require("code.global.properties")

--
-- Created by IntelliJ IDEA.
-- User: acer
-- Date: 2014-10-13
-- Time: 22:20
-- To change this template use File | Settings | File Templates.
--

local forestGeneratorHelper = {};

--[[
    --skin --width --height --type --xPostion --yPosition --currentHex
--]]
forestGeneratorHelper.new = function()

    forestGeneratorHelper.tab = {}
    forestGeneratorHelper.tab[1] = {1,2,3,4,5}
    forestGeneratorHelper.tab[2] = {31,2,6,4,5 }

    return forestGeneratorHelper.tab

end

return forestGeneratorHelper
