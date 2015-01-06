local composer = require("composer")
local widget = require("widget")
local properties = require("code.global.properties")
local saveAndLoad = require("code.global.saveAndLoad")
local lfs = require "lfs"
local json = require('json')
local scene = composer.newScene()


local fsr, fsrn, fstr
local fsr2, fsrn2, fstr2

local htranst, etranst

local estar, clevel

local function rectTouch(event)
    return true
end


function scene:create(event)
    local sceneGroup = self.view
    local fileToSave = saveAndLoad.load(properties.saveFile)
    --    properties.startingFromBeggining
    htranst = properties.heroTransTime
    etranst = properties.enemyTransTime
    if fileToSave then
        if type(fileToSave) == "table" then
            --print ("LOGGING")
            logTable(fileToSave)
            clevel =  fileToSave.level
            htranst = fileToSave.heroTransTime
            etranst = fileToSave.enemyTransTime
            estar = fileToSave.startingFromBeggining
        end
    end
    local size = properties.sizeOfButtons
    local corners = properties.cornerSize
    sceneGroup.rect1 = display.newRoundedRect(properties.center.x, 0, properties.width - 20, size, corners)
    sceneGroup.rect1.y = properties.y + sceneGroup.rect1.height / 2 + 5
    sceneGroup.rect1nap = display.newText("Back", sceneGroup.rect1.x, sceneGroup.rect1.y, properties.font, size)
    sceneGroup.rect1:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect1nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup:insert(sceneGroup.rect1)
    sceneGroup:insert(sceneGroup.rect1nap)
    sceneGroup.rect2 = display.newRoundedRect(properties.center.x, 0, properties.width - 20, size, corners)
    sceneGroup.rect2.y = properties.height + properties.y - sceneGroup.rect2.height / 2 - 5
    sceneGroup.rect2nap = display.newText("Accept", sceneGroup.rect2.x, sceneGroup.rect2.y, properties.font, size)
    sceneGroup.rect2:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect2nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup:insert(sceneGroup.rect2)
    sceneGroup:insert(sceneGroup.rect2nap)
    local function firstScrollBar()
        fsr = display.newRoundedRect(properties.center.x, 0, properties.width - 60, 16, 8)
        fsr.y = sceneGroup.rect1.y + properties.height / 4
        fsr:setFillColor(unpack(properties.firstSceneRectsColor))
        fsrn = display.newText("Hero Movment Speed : " .. htranst, fsr.x, 0, properties.font, 50)
        fsrn.y = fsr.y - fsrn.height * 2
        fstr = display.newRect(0, 0, 80, 140)
        fstr.y = fsr.y
        fstr.x = fsr.x - fsr.width / 2 + (htranst - 350) * (fsr.width / 450) --fsr.width
        fstr:setFillColor(0.78, 0.12, 0.21, 0.8)
        function fstr:touch(event)
            if event.phase == "began" then
                display.getCurrentStage():setFocus(self)
                self.isFocus = true
            elseif self.isFocus then
                if event.phase == "moved" then
                    if event.x >= fsr.x - fsr.width / 2 and event.x <= fsr.x + fsr.width / 2 then
                        fstr.x = event.x
                        htranst = math.round((event.x - (fsr.x - fsr.width / 2)) * (450 / fsr.width) + 350)
                        if htranst == 799 then htranst = 800 end
                        fsrn.text = "Hero Animation Speed : " .. htranst
                    end
                elseif event.phase == "ended" or event.phase == "cancelled" then
                    -- reset touch focus
                    display.getCurrentStage():setFocus(nil)
                    self.isFocus = nil
                end
            end
            return true
        end

        sceneGroup:insert(fsr)
        sceneGroup:insert(fsrn)
        sceneGroup:insert(fstr)
        fstr:addEventListener("touch", fstr)
    end

    local function secondScrollBar()
        fsr2 = display.newRoundedRect(properties.center.x, 0, properties.width - 60, 16, 8)
        fsr2.y = fsr.y + properties.height / 4
        fsr2:setFillColor(unpack(properties.firstSceneRectsColor))
        --  sceneGroup.rect1.y = properties.y + sceneGroup.rect1.height/2 + 5
        fsrn2 = display.newText("Enemy Animation Speed : " .. etranst, fsr2.x, 0, properties.font, 50)
        fsrn2.y = fsr2.y - fsrn2.height * 2
        fstr2 = display.newRect(0, 0, 80, 140)
        fstr2.y = fsr2.y
        fstr2.x = fsr2.x - fsr2.width / 2 + (etranst - 350) * (fsr2.width / 450) --fsr.width
        fstr2:setFillColor(0.78, 0.12, 0.21, 0.8)
        --350  do 800

        function fstr2:touch(event)
            if event.phase == "began" then
                display.getCurrentStage():setFocus(self)
                self.isFocus = true
            elseif self.isFocus then
                if event.phase == "moved" then
                    if event.x >= fsr2.x - fsr2.width / 2 and event.x <= fsr2.x + fsr2.width / 2 then
                        fstr2.x = event.x
                        etranst = math.round((event.x - (fsr2.x - fsr2.width / 2)) * (450 / fsr2.width) + 350)
                        if etranst == 799 then etranst = 800 end
                        fsrn2.text = "Enemy Animation Speed : " .. etranst
                    end
                elseif event.phase == "ended" or event.phase == "cancelled" then
                    -- reset touch focus
                    display.getCurrentStage():setFocus(nil)
                    self.isFocus = nil
                end
            end
            return true
        end

        --   sceneGroup.rect1:setFillColor(unpack(properties.firstSceneRectsColor))
        --   sceneGroup.rect1nap:setFillColor(unpack(properties.firstSceneTextColor))

        sceneGroup:insert(fsr2)
        sceneGroup:insert(fsrn2)
        sceneGroup:insert(fstr2)
        --    sceneGroup:insert(sceneGroup.rect1nap)


        fstr2:addEventListener("touch", fstr2)
    end

    local function firstCheckBox()
        local firstCheckBox = display.newGroup()
        local fteX

        local function checkBoxTouch(event)
        if event.phase == "ended" then
            if  fteX.isVisible then
                fteX.isVisible = false
                estar = false
            else
                fteX.isVisible = true
                estar = true
            end
        end
        end

        local far3, far4
        far3 = display.newRect(0, 0, 125, 125)
        far4 = display.newRect(0, 0, far3.width + 15, far3.width + 15)

        local fte = display.newText("Start from begining", far3.width / 2 + 15, 0, properties.font, 65)
        fte:setFillColor(unpack(properties.firstSceneRectsColor))
        fte.x = far3.width / 2 + 15 + fte.width / 2

        far3:setFillColor(0, 0, 0)
        far4:setFillColor(unpack(properties.firstSceneRectsColor))

         fteX = display.newText("X", 0, 0, properties.font, 125)
        fteX.isVisible = false
        firstCheckBox:insert(far4)
        firstCheckBox:insert(far3)
        firstCheckBox:insert(fte)
        firstCheckBox:insert(fteX)

        --print ("estar",estar)
        if estar then
            fteX.isVisible = true
            end

        firstCheckBox.x = properties.center.x - properties.width / 2 + far3.width / 2 + 15
        firstCheckBox.y = fsr2.y + properties.height / 5


        firstCheckBox:addEventListener("touch", checkBoxTouch)
        sceneGroup:insert(firstCheckBox)
    end

    firstScrollBar()
    secondScrollBar()
    firstCheckBox()

    local prevScene = composer.getSceneName("previous")
    local currScene = composer.getSceneName("current")

    function sceneGroup.rect2:touch(event)
        if event.phase == "ended" then
            --print("FINAL VALUE ARE :  " .. htranst, etranst)
            properties.heroTransTime = htranst
            properties.enemyTransTime = etranst
            properties.startingFromBeggining = estar or false
         --   properties.currentLevel = estar or false
            fileToSave = {
                level = clevel or 1,
                heroTransTime = properties.heroTransTime,
                enemyTransTime = properties.enemyTransTime,
                startingFromBeggining = properties.startingFromBeggining
            }

            --   tabToSave.level = 5

            saveAndLoad.save(fileToSave, properties.saveFile)

            composer.gotoScene(prevScene) composer.removeScene(currScene)
        end
    end


    function sceneGroup.rect1:touch(event)
        if event.phase == "ended" then


            composer.gotoScene(prevScene) composer.removeScene(currScene)
        end
    end

    sceneGroup.rect2:addEventListener("touch", sceneGroup.rect2)
    sceneGroup.rect1:addEventListener("touch", sceneGroup.rect1)
    --    timer.performWithDelay ( 500, function()     composer.gotoScene(prevScene) composer.removeScene(currScene)  end, 1)
end


function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
