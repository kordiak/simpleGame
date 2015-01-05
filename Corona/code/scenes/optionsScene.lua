local composer = require("composer")
local widget = require("widget")
local properties = require("code.global.properties")
local saveAndLoad = require("code.global.saveAndLoad")
local lfs = require "lfs"
local json = require('json')
local scene = composer.newScene()


local fsr,fsrn, fstr
local fsr2,fsrn2, fstr2

local htranst, etranst

local function rectTouch(event)
    return true
end


function scene:create(event)
    local sceneGroup = self.view
    local fileToSave =  saveAndLoad.load( properties.saveFile )
--    properties.startingFromBeggining
    htranst = properties.heroTransTime
    etranst = properties.enemyTransTime
    if fileToSave then
        if type( fileToSave ) == "table"  then
        logTable (fileToSave)
        htranst = fileToSave.heroTransTime
        etranst = fileToSave.enemyTransTime
        end
        end
    local size = properties.sizeOfButtons
    local corners = properties.cornerSize
    sceneGroup.rect1=display.newRoundedRect(properties.center.x,0,properties.width-20,  size      ,corners)
    sceneGroup.rect1.y = properties.y + sceneGroup.rect1.height/2 + 5
    sceneGroup.rect1nap = display.newText("Back",  sceneGroup.rect1.x, sceneGroup.rect1.y, properties.font, size )
    sceneGroup.rect1:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect1nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup:insert(sceneGroup.rect1)
    sceneGroup:insert(sceneGroup.rect1nap)
    sceneGroup.rect2=display.newRoundedRect(properties.center.x,0,properties.width-20,  size      ,corners)
    sceneGroup.rect2.y = properties.height + properties.y - sceneGroup.rect2.height/2 - 5
    sceneGroup.rect2nap = display.newText("Accept",  sceneGroup.rect2.x, sceneGroup.rect2.y, properties.font, size )
    sceneGroup.rect2:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect2nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup:insert(sceneGroup.rect2)
    sceneGroup:insert(sceneGroup.rect2nap)
    local  function firstScrollBar ()
          fsr=display.newRoundedRect(properties.center.x,0,properties.width-60, 16 ,8)
        fsr.y = sceneGroup.rect1.y + properties.height/4
        fsr:setFillColor(unpack(properties.firstSceneRectsColor))
       fsrn = display.newText("Hero Movment Speed : "..htranst,  fsr.x, 0, properties.font, 50 )
        fsrn.y = fsr.y - fsrn.height*2
        fstr = display.newRect(0,0,80,140)
        fstr.y = fsr.y
        fstr.x = fsr.x - fsr.width/2 + (htranst-350) * ( fsr.width/450 ) --fsr.width
        fstr:setFillColor(0.78,0.12,0.21,0.8)
          function fstr:touch (event)
              if event.phase == "began" then
                  display.getCurrentStage():setFocus( self )
                  self.isFocus = true
              elseif self.isFocus then
                  if event.phase == "moved" then
                      if event.x >= fsr.x - fsr.width/2 and event.x <= fsr.x + fsr.width/2 then
                          fstr.x = event.x
                             htranst = math.round ((event.x - (fsr.x - fsr.width/2)) * ( 450/fsr.width ) + 350)
                          if htranst == 799 then htranst = 800 end
                          fsrn.text = "Hero Animation Speed : "..htranst
                      end
                  elseif event.phase == "ended" or event.phase == "cancelled" then
                      -- reset touch focus
                      display.getCurrentStage():setFocus( nil )
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
    local  function secondScrollBar ()
        fsr2=display.newRoundedRect(properties.center.x,0,properties.width-60, 16 ,8)
        fsr2.y = fsr.y + properties.height/4
        fsr2:setFillColor(unpack(properties.firstSceneRectsColor))
        --  sceneGroup.rect1.y = properties.y + sceneGroup.rect1.height/2 + 5
        fsrn2 = display.newText("Enemy Animation Speed : "..etranst,  fsr2.x, 0, properties.font, 50 )
        fsrn2.y = fsr2.y - fsrn2.height*2
        fstr2 = display.newRect(0,0,80,140)
        fstr2.y = fsr2.y
        fstr2.x = fsr2.x - fsr2.width/2 + (etranst-350) * ( fsr2.width/450 ) --fsr.width
        fstr2:setFillColor(0.78,0.12,0.21,0.8)
        --350  do 800

        function fstr2:touch (event)
            if event.phase == "began" then
                display.getCurrentStage():setFocus( self )
                self.isFocus = true
            elseif self.isFocus then
                if event.phase == "moved" then
                    if event.x >= fsr2.x - fsr2.width/2 and event.x <= fsr2.x + fsr2.width/2 then
                        fstr2.x = event.x
                        etranst = math.round ((event.x - (fsr2.x - fsr2.width/2)) * ( 450/fsr2.width ) + 350)
                        if etranst == 799 then etranst = 800 end
                        fsrn2.text = "Enemy Animation Speed : "..etranst
                    end
                elseif event.phase == "ended" or event.phase == "cancelled" then
                    -- reset touch focus
                    display.getCurrentStage():setFocus( nil )
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
    firstScrollBar()
    secondScrollBar()

    local prevScene = composer.getSceneName( "previous" )
    local currScene = composer.getSceneName( "current" )

    function sceneGroup.rect2:touch (event)
        if event.phase == "ended" then
            print ("FINAL VALUE ARE :  "..htranst,etranst)
            end

        end


    function sceneGroup.rect1:touch (event)
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
