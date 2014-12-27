--
-- Created by IntelliJ IDEA.
-- User: Szymon
-- Date: 2014-12-06
-- Time: 17:27
-- To change this template use File | Settings | File Templates.



local PriorityQueueCreator = {}
local internalArray = {}
PriorityQueueCreator.new = function()

    local priorityQueue = {}

    priorityQueue.length=#internalArray;
    priorityQueue.put = function(value, weight)



        if (internalArray) then

            local theLastInArray = #internalArray + 1;
            local found = false;
            local element = {};
            element.weight = weight;
            element.value = value;

            for i = 1, #internalArray do

                if (internalArray[i].weight > element.weight) then
                    theLastInArray = i - 1;
                    found = true;

                    break;
                end
            end

            if (found) then
                local tempArray = {}
                for i = 1, theLastInArray - 1 do
                    table.insert(tempArray, internalArray[i]);
                end
                table.insert(tempArray, element);

                if (theLastInArray <= #internalArray) then


                    for i = #tempArray, #internalArray do
                        table.insert(tempArray, internalArray[i]);
                    end
                end

                internalArray = tempArray;
            else
                table.insert(internalArray, element)
            end
            priorityQueue.length=#internalArray;
        end
    end
    priorityQueue.get = function()

        if (#internalArray > 0) then
            local tempArray = {};
            local element = internalArray[1];

            for i = 2, #internalArray do
                table.insert(tempArray,internalArray[i]);
            end

            internalArray=tempArray;
            priorityQueue.length=#internalArray;
            return element;
        end


    end

    priorityQueue.getTable = function()
        return internalArray;
    end

    return priorityQueue;
end


return PriorityQueueCreator;

