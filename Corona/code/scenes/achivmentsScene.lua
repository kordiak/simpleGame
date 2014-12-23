local composer = require("composer")
local widget = require("widget")
local properties = require("code.global.properties")
local lfs = require "lfs"
local json = require('json')
local scene = composer.newScene()


local rectsFILLcolor = { 0.52, 0.39, 0.39 }
local textCOLOR = { 0.8, 0.498039, 0.372549 }

local loadGroup = display.newGroup()
local round = 1
local loadtext1, loadtext2, loadtext3, file, matchData, gMode, fileName,tableViewForRound,rect1, loadtext4



local function generateTableViewForRounds(matchData)

    local function onRowTouch(event)
        if event.phase == "press" then
            round = event.target.index
            loadtext4.text ="Rounda : "..round
        end
    end

    local function onRowRender(event)

        -- Get reference to the row group
        local row = event.row

        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth

        local rowTitle = display.newText(row, "   Runda   " ..row.index, 0, 0, nil, properties.height / 20)
        rowTitle:setFillColor(unpack(properties.firstSceneTextColor))

        -- Align the label left and vertically centered
        rowTitle.anchorX = 0
        rowTitle.x = 0
        rowTitle.y = rowHeight * 0.5
    end

    local tableView = widget.newTableView
        {
            left = properties.x+2,
            top = loadtext4.y+loadtext4.height/2+4,
            height = (rect1.y -rect1.height/2) - (loadtext4.y+loadtext4.height/2+ 16),
            width = properties.width-4,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener,
            hideBackground = true,
            hideScrollBar = true,
        }

    -- Insert 40 rows
    for i = 1, #matchData.rounds do
        -- Insert a row into the tableView
        tableView:insertRow({
            rowHeight = properties.height / 6,
            rowColor = { default = { unpack(properties.firstSceneRectsColor) }, over = { 1, 0.5, 0, 0.2 } },
            lineColor = { unpack(properties.firstSceneTextColor) }
        })
    end
    return tableView
end


local function generateTableView(files)

    local function onRowTouch(event)
        if event.phase == "press" then

        end
    end

    local function onRowRender(event)

        -- Get reference to the row group
        local row = event.row
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth

        local rowBackGround = display.newImageRect(row, "graphicsRaw/achivments/achivmentsBarDefault.png", properties.width - 10, properties.height/9 )
        rowBackGround.x = rowWidth * 0.5
        rowBackGround.y = rowHeight * 0.5
        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added


        local rowTitle = display.newText(row, "     " .. "Achivment num " .. row.index, 0, 0, nil, properties.height / 26)
        rowTitle:setFillColor(0.85,0.76,0.33)

        -- Align the label left and vertically centered

        rowTitle.x = rowWidth * 0.5
        rowTitle.y = rowHeight * 0.5
    end
-- achivmentsBarDefault
    local tableView = widget.newTableView
        {
            left = properties.x + 4,
            top = properties.y + 4 + properties.height/8,
            height = properties.height - 8 - properties.height/8,
            width = properties.width - 8,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
          --  listener = scrollListener,
            hideBackground = true,
            noLines = true,
            hideScrollBar = true,
        }

    -- Insert 40 rows
    for i = 1, 15 do
        -- Insert a row into the tableView
        tableView:insertRow({
            rowHeight = properties.height/9,
            rowColor = { default={ 1, 1, 1, 0 }, over={ 1, 0.5, 0, 0.2, 0 } },
        })
    end


    return tableView
end

local function rectTouch(event)
    return true
end


function scene:create(event)
    local sceneGroup = self.view

    local tableView = generateTableView()
    --

    sceneGroup:insert(tableView)
    local tableViewBorder = display.newRect(tableView.x, tableView.y, tableView.width + 4, tableView.height + 4)
    tableViewBorder.strokeWidth = 4
    tableViewBorder:setFillColor(0.5, 0, 0, 0)
    tableViewBorder:setStrokeColor(1, 0.42, 0)
    sceneGroup:insert(tableViewBorder)

    local function GeneratePopup()
        local popUpBackground = display.newRect(tableView.x, tableView.y, tableView.width + 4, tableView.height + 4)
        popUpBackground:setFillColor(0, 0, 0)
        loadGroup:insert(popUpBackground)
        loadtext1 = display.newText("Nazwa : ", properties.x + 10, properties.y, native.systemFont, properties.loadSceneFontSize - 15)
        loadtext1.y, loadtext1.x = properties.y + loadtext1.height / 2, properties.x + 4
        loadtext1.anchorX = -1
        loadtext2 = display.newText("Data : ", properties.x + 10, properties.y, native.systemFont, properties.loadSceneFontSize - 15)
        loadtext2.y, loadtext2.x = loadtext1.y + loadtext2.height * 1.5, properties.x + 4
        loadtext2.anchorX = -1
        loadtext3 = display.newText("Tryb gry : ", properties.x + 10, properties.y, native.systemFont, properties.loadSceneFontSize - 15)
        loadtext3.y, loadtext3.x = loadtext2.y + loadtext3.height * 1.5, properties.x + 4
        loadtext3.anchorX = -1
        loadtext4 = display.newText("Rounda : "..round, properties.x + 10, properties.y, native.systemFont, properties.loadSceneFontSize - 15)
        loadtext4.y, loadtext3.x = loadtext3.y + loadtext4.height * 1.5, properties.x + 4
        loadtext4.anchorX = -1
        loadGroup:insert(loadtext1)
        loadGroup:insert(loadtext2)
        loadGroup:insert(loadtext3)
        loadGroup:insert(loadtext4)




        rect1 = display.newRect(0, 0, properties.width / 2 - 8, properties.sizeOfButtons * 2)
        rect1.load = false
        rect1.x, rect1.y = properties.x + 4 + rect1.width / 2, properties.height - rect1.height/2 - 4
        local rect2 = display.newRect(0, 0, properties.width / 2 - 4, properties.sizeOfButtons * 2)
        rect2.load = true
        rect2.x, rect2.y = rect1.x + 4 + rect1.width / 2 + rect2.width / 2,properties.height - rect1.height/2 - 4
        local rect1nap = display.newText("Powrot", rect1.x, rect1.y, native.systemFont, properties.loadSceneFontSize)
        local rect2nap = display.newText("Wczytaj", rect2.x, rect2.y, native.systemFont, properties.loadSceneFontSize)

        rect1:setFillColor(unpack(properties.firstSceneRectsColor))
        rect2:setFillColor(unpack(properties.firstSceneRectsColor))
        rect1nap:setFillColor(unpack(properties.firstSceneTextColor))
        rect2nap:setFillColor(unpack(properties.firstSceneTextColor))

        loadGroup:insert(rect1)
        loadGroup:insert(rect2)
        loadGroup:insert(rect1nap)
        loadGroup:insert(rect2nap)

        popUpBackground:addEventListener("touch", rectTouch)
        popUpBackground:addEventListener("touch", rectTouch)
        popUpBackground:addEventListener("tap", rectTouch)

        local prevScene = composer.getSceneName( "previous" )
        local currScene = composer.getSceneName( "current" )
        composer.setVariable( "ghostToKill", 1 )
        timer.performWithDelay ( 3500, function()     composer.gotoScene(prevScene) composer.removeScene(currScene)  end, 1)
    end

    GeneratePopup()
    loadGroup.isVisible = false
    sceneGroup:insert(loadGroup)
end


function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
