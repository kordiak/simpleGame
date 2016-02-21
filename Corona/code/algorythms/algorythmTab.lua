--
-- Created by IntelliJ IDEA.
-- User: Bartosz
-- Date: 2016-02-10
-- Time: 22:10
-- To change this template use File | Settings | File Templates.


local algoRandom = require("code.algorythms.algoRandom")
local algoRandomDecisive = require("code.algorythms.algoRandomDecisive")
local algoAll = require("code.algorythms.algoAll")
local algoResults = require("code.algorythms.algoResults")
local algoResults = require("code.algorythms.algoResults")
local algoDijkstra = require("code.algorythms.algoDijkstra")

local algorythms = {
    algorythmList = {
        algoRandom = algoRandom.calculate,
        algoRandomDecisive = algoRandomDecisive.calculate,
        algoAll = algoAll.calculate,
        algoResults = algoResults.calculate,
        algoDijkstra = algoDijkstra.calculate
    }
}

algorythms.returnList = function()
    return algorythms.algorythmList
end

algorythms.chooseAlgorythm = function(algorythm)
    if not algorythm then algorythm = "" end
    local pickedAlgorythm = algorythms.algorythmList[algorythm]
    local algorythmName = algorythm


    if not pickedAlgorythm then
        local algorythmsNumber = 0

        for k, v in pairs(algorythms.algorythmList) do
            algorythmsNumber = algorythmsNumber + 1
        end

        algorythmsNumber = math.random(algorythmsNumber)

        local algorythmInterval = 0
        for k, v in pairs(algorythms.algorythmList) do
            algorythmInterval = algorythmInterval + 1
            if algorythmInterval == algorythmsNumber then
                pickedAlgorythm = v
                algorythmName = k
            end
        end
    end

    return pickedAlgorythm, algorythmName
end

return algorythms

