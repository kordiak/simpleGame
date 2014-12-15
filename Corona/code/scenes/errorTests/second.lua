local composer = require("composer")

local scene = composer.newScene()

local function close()

    composer.gotoScene("")
    composer.removeScene("")
end

function scene:create(event)

    local sceneGroup = self.view

    local a = display.newText({ text = "secondScene", font = native.Systemfont, fontSize = 45 })
    a.x, a.y = 450, 450
    a:setFillColor(1, 1, 1)
    local properties = {}
    properties.x = display.screenOriginX
    properties.y = display.screenOriginY

    properties.width = display.contentWidth + display.screenOriginX * -2
    properties.height = display.contentHeight + display.screenOriginY * -2


    properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }



    sceneGroup:insert(a)


    local widget = require( "widget" )

    -- The "onRowRender" function may go here (see example under "Inserting Rows", above)
    local function onRowRender( event )

        -- Get reference to the row group
        local row = event.row

        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth

        local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
        rowTitle:setFillColor( 0 )

        local file
     --   file = "a3.png"
        if event.row.index == 1 then
            file = "a1.png"
        elseif event.row.index == 2 then
            file = "a2.png"
        else
            file = "a3.png"
        end
        local a = display.newImageRect("a.png", 65, 80)
        a.x = 5
        a.anchorX = 0
        a.y = rowHeight/2
        row:insert(a)

        -- Align the label left and vertically centered
        rowTitle.anchorX = 0
        rowTitle.x = 0
        rowTitle.y = rowHeight * 0.5
    end
    -- Create the widget
    local tableView = widget.newTableView
        {
            noLines = true,
            hideBackground = true,
            left = 5,
            top = properties.y,
            height =   properties.height,
            width =  properties.width - 10 ,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener
        }


    -- Insert 40 rows
    for i = 1, 3 do
       local rowHeight = 80
        -- Insert a row into the tableView
        tableView:insertRow{

            rowHeight = rowHeight,
        }
    end
    sceneGroup:insert(tableView)
end

function scene:show(event)
end


function scene:hide(event)
end


function scene:destroy(event)
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

