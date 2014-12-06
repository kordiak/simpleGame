local properties = require("code.global.properties")


local mainBoard = {}
--for i = 1, 70 do
--mainBoard.new = function ()
local function mainBoardSettings ()
    for i =1, #mainBoard do
        mainBoard[i].isWalkAble = true;
        mainBoard[i].isFree = true;
        mainBoard[i].coherentHexes = {};
        mainBoard[i].content = nil;
    end

    mainBoard[1].coherentHexes = {2,3,5 }
    mainBoard[2].coherentHexes = {4,8,5,1}
    mainBoard[3].coherentHexes = {1,5,9,6 }
    mainBoard[4].coherentHexes = {7,12,8,2}
    mainBoard[5].coherentHexes = {1,2,8,13,9,3}
    mainBoard[6].coherentHexes = {3,9,14,10}
    mainBoard[7].coherentHexes = {11,16,12,4}
    mainBoard[8].coherentHexes = {2,4,12,17,13,5}
    mainBoard[9].coherentHexes = {3,5,13,18,14,6}
    mainBoard[10].coherentHexes = {6,14,19,15 }
    mainBoard[11].coherentHexes = {20,16,7}
    mainBoard[12].coherentHexes = {4,7,16,21,17,8 }
    mainBoard[13].coherentHexes = {5,8,17,22,18,9 }
    mainBoard[14].coherentHexes = {6,9,18,23,19,10 }
    mainBoard[15].coherentHexes = {10,19,24 }
    mainBoard[16].coherentHexes = {7,11,20,25,21,12 }
    mainBoard[17].coherentHexes = {8,12,21,26,22,13 }
    mainBoard[18].coherentHexes = {9,13,22,27,23,14 }
    mainBoard[19].coherentHexes = {10,14,23,28,24,15 }
    mainBoard[20].coherentHexes = {11,29,25,16 }
    mainBoard[21].coherentHexes = {12,16,25,30,26,17 }
    mainBoard[22].coherentHexes = {13,17,26,31,27,18 }



    mainBoard[23].coherentHexes = {14,18,27,32,28,19}
    mainBoard[24].coherentHexes = {15,19,28,33}
    mainBoard[25].coherentHexes = {16,20,29,34,30,21}
    mainBoard[26].coherentHexes = {17,21,30,35,31,22}
    mainBoard[27].coherentHexes = {18,22,31,36,32,23}

    mainBoard[28].coherentHexes = {19,23,32,37,33,24}
    mainBoard[29].coherentHexes = {20,38,34,25}
    mainBoard[30].coherentHexes = {21,25,34,39,35,26}
    mainBoard[31].coherentHexes = {22,26,35,40,36,27}
    mainBoard[32].coherentHexes = {23,27,36,41,37,28}

    mainBoard[33].coherentHexes = {24,28,37,42}
    mainBoard[34].coherentHexes = {25,29,38,43,39,30}
    mainBoard[35].coherentHexes = {26,30,39,44,40,31}
    mainBoard[36].coherentHexes = {27,31,40,45,41,32}
    mainBoard[37].coherentHexes = {28,32,41,46,42,33}

    mainBoard[38].coherentHexes = {29,47,43,34}
    mainBoard[39].coherentHexes = {30,34,43,48,44,35}
    mainBoard[40].coherentHexes = {31,35,44,49,45,36}
    mainBoard[41].coherentHexes = {32,36,45,50,46,37}
    mainBoard[42].coherentHexes = {33,37,46,51 }

    mainBoard[43].coherentHexes = {34,38,47,52,48,39}
    mainBoard[44].coherentHexes = {35,39,48,53,49,40}
    mainBoard[45].coherentHexes = {36,40,49,54,50,41}
    mainBoard[46].coherentHexes = {37,41,50,55,51,42}
    mainBoard[47].coherentHexes = {38,56,52,43}
    mainBoard[48].coherentHexes = {39,43,52,57,53,44}
    mainBoard[49].coherentHexes = {40,44,53,58,54,45}
    mainBoard[50].coherentHexes = {41,45,54,59,55,46}

    mainBoard[51].coherentHexes = {42,46,55,60}
    mainBoard[52].coherentHexes = {43,47,56,61,57,48}
    mainBoard[53].coherentHexes = {44,48,57,62,58,49}
    mainBoard[54].coherentHexes = {45,49,58,63,59,50}
    mainBoard[55].coherentHexes = {46,50,59,64,60,51}
    mainBoard[56].coherentHexes = {47,61,52}
    mainBoard[57].coherentHexes = {48,52,61,65,62,53}
    mainBoard[58].coherentHexes = {49,53,62,66,63,54}
    mainBoard[59].coherentHexes = {50,54,63,67,64,55}
    mainBoard[60].coherentHexes = {51,55,64}

    mainBoard[61].coherentHexes = {52,56,65,57}
    mainBoard[62].coherentHexes = {53,57,65,68,66,58}
    mainBoard[63].coherentHexes = {54,58,66,69,67,59}
    mainBoard[64].coherentHexes = {55,59,67,60}
    mainBoard[65].coherentHexes = {57,61,62}
    mainBoard[66].coherentHexes = {58,62,68,70,69,63}
    mainBoard[67].coherentHexes = {59,63,69,64}
    mainBoard[68].coherentHexes = {62,65,70,66}
    mainBoard[69].coherentHexes = {63,66,70,67}
    mainBoard[70].coherentHexes = {66,68,69}
end
local function mainBoardGenerator()
local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
hex.x = properties.center.x
hex.y = hex.height/2
--hex:setFillColor (0,1,0)
--TODO : w jakim miejscu zapisac ze jest to nasz pierwszy wiersz ( miejsce spawnu gracza, obecnie sie koloruje )

table.insert(mainBoard,hex)

for i =1, 2 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x - hex.width/2 -  hex.width/4 + hex.width * (i-1) + hex.width/2 * (i-1)
    hex.y = hex.height
    table.insert(mainBoard,hex)
end

    for i=1,3 do
        local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
        hex.x = properties.center.x - hex.width/2 -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1)
        hex.y = hex.height * 1.5
        table.insert(mainBoard,hex)
    end

for i=1,4 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x -hex.width - hex.width/4 -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1)
    hex.y = hex.height * 2
    table.insert(mainBoard,hex)
end


for a =1,6 do
for i=1,5 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x -hex.width - hex.width -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1)
    hex.y = hex.height * (1.5 + a)
    table.insert(mainBoard,hex)
end

for i=1,4 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x +hex.width -hex.width - hex.width -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1) -hex.width/4
    hex.y = hex.height * (2+a)
    table.insert(mainBoard,hex)
end

end

for i=1,3 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x - hex.width/2 -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1)
    hex.y = hex.height *8.5
    table.insert(mainBoard,hex)
end

for i =1, 2 do
    local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
    hex.x = properties.center.x - hex.width/2 -  hex.width/4 + hex.width * (i-1) + hex.width/2 * (i-1)
    hex.y = hex.height * 9
    table.insert(mainBoard,hex)
end
local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
hex.x = properties.center.x
hex.y = hex.height * 9.5
--TODO: to samo co z pierwszy wierszem
--hex:setFillColor (1,0,0)
table.insert(mainBoard,hex)

mainBoardSettings()
end
local function mainBoardGenerator2 ()
    for a =1,properties.mainBoard2Rows/2 do
        properties.lastRow = a
        properties.firstRow = a
        for i=1,5 do
            local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
            hex.x = properties.center.x -hex.width - hex.width -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1)
            hex.y = hex.height * (-0.5 + a)
            table.insert(mainBoard,hex)
            if  properties.firstRow == 1 then
                --TODO : w jakim miejscu zapisac ze jest to nasz pierwszy wiersz ( miejsce spawnu gracza, obecnie sie koloruje )
                hex:setFillColor (0,1,0)
                end
        end

        for i=1,4 do
            local hex = display.newImageRect(properties.hexTexturePath, 88, 77)
            hex.x = properties.center.x +hex.width -hex.width - hex.width -  hex.width + hex.width * (i-1) + hex.width/2 * (i-1) -hex.width/4
            hex.y = hex.height * a
            table.insert(mainBoard,hex)
            if properties.lastRow == (properties.mainBoard2Rows/2) then
               --TODO : w jakim miejscu zapisac ze jest to nasz ostatni wierz ( miejsce spawnu gracza, obecnie sie koloruje )
                hex:setFillColor (1,0,0)
                end
        end

    end
end
local function setText ()
    for i = 1, #mainBoard do
    mainBoard[i].text = display.newText({ text = i, font = properties.font, fontSize = properties.inSquareFont })
    mainBoard[i].text:setFillColor(0.42,0.56,0.76, properties.textInHexesAlpha)
    mainBoard[i].text.x = mainBoard[i].x
    mainBoard[i].text.y = mainBoard[i].y
end
end
local function touchControl (event)
    if event.phase == "began" then
        display.getCurrentStage():setFocus( event.target )
        event.target.isFocus = true

      --  event.target:setFillColor (0.255,0.64,0.42,0.5)
--        for i =1 , #event.target.coherentHexes do
--            mainBoard[event.target.coherentHexes[i]]:setFillColor (1,0,0,0.2)
--        end


    elseif event.target.isFocus then
        if event.phase =="ended" then
        display.getCurrentStage():setFocus( nil )
        event.target.isFocus = nil
     --   event.target:setFillColor( 1,1,1)

        for i =1 , #event.target.coherentHexes do
            -- event.target.coherentHexes[i]
            mainBoard[event.target.coherentHexes[i]]:setFillColor (1,1,1)

        end

        Runtime:dispatchEvent({
            name = "hexPressed",
            hexNumber = event.target.text.text
        })





            end
    end
    return true
end
local function touchListener ()
    for i =1 , #mainBoard do
        mainBoard[i]:addEventListener("touch", touchControl)
        end
end

mainBoard.removeMe = function ()
    for i =1 , #mainBoard do
        mainBoard[i]:removeEventListener("touch", touchControl)
        mainBoard[i]:removeSelf()
        mainBoard[i] = nil
    end
end

mainBoardGenerator()
setText()
touchListener()

--return mainBoard
--end

return mainBoard