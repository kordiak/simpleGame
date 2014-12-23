local properties = require("code.global.properties")

local forestGeneratorHelper = {};

forestGeneratorHelper.new = function()

forestGeneratorHelper.tab = {}
forestGeneratorHelper.tab[1] = {2,5,9,14,23,27,31,35,39,43,52,57,62,66}
forestGeneratorHelper.tab[2] = {2,8,13,18,27,31,36,41,50,54,58,66 }
forestGeneratorHelper.tab[3] = {5,13,22,31,40,49,58,66 }
forestGeneratorHelper.tab[4] = {2,8,17,26,35,44,53,62,68 }
forestGeneratorHelper.tab[5] = {3,9,18,27,36,45,54,63,69 }
forestGeneratorHelper.tab[6] = {5,8,12,16,25,30,35,44,53,58,63,69 }
forestGeneratorHelper.tab[7] = {2,4,7,11,20,29,38,47,56,61,65,68 }
forestGeneratorHelper.tab[8] = {5,9,14,23,27,31,40,45,50,59,63,66 }
forestGeneratorHelper.tab[9] = {3,6,10,15,24,33,42,51,60,64,67,69 }
forestGeneratorHelper.tab[10] = {3,6,14,18,22,26,30,39,44,49,54,58,62,68 }
forestGeneratorHelper.tab[11] = {5,13,18,23,27,32,36,40,44,49,54,58,66 }
forestGeneratorHelper.tab[12] = {3,9,13,22,31,36,41,46,55,59,63,69 }
forestGeneratorHelper.tab[13] = {2,4,12,21,26,31,40,44,48,52,57,65,68 }
forestGeneratorHelper.tab[14] = {5,8,17,26,35,40,45,54,58,66 }
forestGeneratorHelper.tab[15] = {3,9,13,22,27,23,28,37,46,50,45,40,44,48,57,62,66 }
forestGeneratorHelper.tab[16] = {2,8,13,9,14,19,28,37,41,36,31,26,21,16,20,29,38,43,39,44,53,58,54,59,67,69 }
forestGeneratorHelper.tab[17] = {2,4,7,11,16,21,17,13,18,14,19,24,33,37,32,36,40,35,39,34,38,47,56,61,57,62,58,54,59,67,69 }
forestGeneratorHelper.tab[18] = {2,4,7,11,20,29,38,47,56,61,57,48,39,30,21,17,22,31,40,49,54,50,41,32,23,14,10,15,24,33,42,51,60,64,67,69 }
forestGeneratorHelper.tab[19] = {3,5,8,12,16,20,29,34,30,26,22,18,14,10,15,24,28,32,36,40,44,48,52,61,65,62,58,54,50,46,51,60,64,67,69 }
forestGeneratorHelper.tab[20] = {2,4,7,16,21,26,31,36,41,46,51,60,64,67,69,3,6,10,19,23,27,35,39,43,47,56,61,65,68 }
forestGeneratorHelper.tab[21] = {5,13,17,12,16,20,29,34,39,44,53,58,66,18,14,19,24,33,37,41,45,54 }




return forestGeneratorHelper.tab

end

return forestGeneratorHelper
