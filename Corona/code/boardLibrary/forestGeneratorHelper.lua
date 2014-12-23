local properties = require("code.global.properties")

local forestGeneratorHelper = {};

forestGeneratorHelper.new = function()

    forestGeneratorHelper.tab = {}


    forestGeneratorHelper.tab[1] = {1,2,3,4,5}
    forestGeneratorHelper.tab[2] = {31,2,6,4,5 }

    return forestGeneratorHelper.tab

end

return forestGeneratorHelper
