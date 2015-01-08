local composer = require( "composer" )
local properties = require("code.global.properties")
local saveAndLoad = require("code.global.saveAndLoad")

local scene = composer.newScene()

local options ={}
local rectsFILLcolor = {0.52,0.39,0.39 }
local textCOLOR = {0.8,0.498039,0.372549 }
local goNextSceneFlag = false
local transCompleted = false

local gameScene = "code.scenes.bossScene"

local creators = display.newGroup()
local function remover ()
    transition.cancel()
    composer.removeScene( "code.scenes.firstScene" )
    --[[
    scene.view.rect1:removeSelf()
    scene.view.rect2:removeSelf()
    scene.view.rect1nap:removeSelf()
    scene.view.rect2nap:removeSelf()
    scene.view.nap1:setFillColor(1,1,1,1)
    --]]
end



local function rectTouch( event )
       if transCompleted == true and   goNextSceneFlag == false then
    if ( event.phase == "began" ) then
        if (event.target == scene.view.rect1) then
            goNextSceneFlag = true

            display.getCurrentStage():setFocus( event.target )
            options={effect="crossFade",time=1500,params={ } }
            remover()
            composer.gotoScene("code.scenes.gameScene",options)
            display.getCurrentStage():setFocus(nil)

        elseif (event.target == scene.view.rect2) then
            goNextSceneFlag = true
--
            display.getCurrentStage():setFocus( event.target )
            options={effect="crossFade",time=properties.firstSceneFadeTime,params={} }
            remover()
          --  composer.gotoScene("code.scenes.achivmentsScene")
            composer.gotoScene("code.scenes.optionsScene",options)
            display.getCurrentStage():setFocus(nil)

        elseif (event.target == scene.view.rect3) then
             goNextSceneFlag = true


            display.getCurrentStage():setFocus( event.target )
            options={effect="crossFade",time=properties.firstSceneFadeTime,params={}}
            remover()
           composer.gotoScene("code.scenes.trutorialScene",options)
            display.getCurrentStage():setFocus(nil)

        elseif (event.target == scene.view.rect4) then
            goNextSceneFlag = true
            display.getCurrentStage():setFocus( event.target )
--
--            options={effect="crossFade",time=properties.firstSceneFadeTime}
--           composer.gotoScene("code.scenes.bossScene2",options)


            display.getCurrentStage():setFocus(nil)
           native.requestExit()
        end
    end
    end
    end

function scene:create( event )
    local sceneGroup = self.view


--    --saveAndLoad.save (testTabe , properties.saveFile)
  local fileToSave =  saveAndLoad.load( properties.saveFile )
    if fileToSave then
        if fileToSave.level then
        if fileToSave.level > 4 then
            properties.currentLevel = fileToSave.level - (math.fmod(fileToSave.level, 5))
        end
        end
        if fileToSave.startingFromBeggining then
            properties.startingFromBeggining = fileToSave.startingFromBeggining
            end
    end
    if properties.startingFromBeggining then
        properties.currentLevel = 1
    end
--    saveAndLoad.save (testTabe , properties.saveFile)
    local mainButtonsGroup = display.newGroup()
    local size = properties.sizeOfButtons
    local corners = properties.cornerSize -- SIZE OF CORNERS

--    sceneGroup.tittle = display.newText ("Pétanque", properties.center.x, -100, properties.font, 90)
--    transition.to( sceneGroup.tittle, { time=1500, alpha=1.0, y = 115, transition=easing.outQuint} )
  --  sceneGroup:insert(sceneGroup.tittle)

--    sceneGroup.company = display.newText ("Cluain", properties.x - 100, properties.height - 250, properties.font, 65)
--    transition.to(   sceneGroup.company, { time=2500, alpha=1.0, y = properties.height - 125, x =  properties.center.x - properties.width/4 , transition=easing.inOutBounce} )
--    sceneGroup:insert(sceneGroup.company)

--    local function creatorsPopUp (event)
--        if event.phase == "ended" then
--            local function touch()
--                return true
--            end
--            local backGroung = display.newRect(properties.center.x,properties.center.y,properties.width, properties.height)
--            backGroung:setFillColor(0,0,0,0.95)
--
--            local szymon =  display.newImageRect("graphicRaw/szymon.jpg",  379, 491 )
--            szymon.x = properties.center.x
--            szymon.y = properties.height - szymon.height
--            local bartek =  display.newImageRect("graphicRaw/bar.jpg", 720/1.5, 540/1.5 )
--            bartek.x = properties.center.x
--            bartek.y = properties.center.y - bartek.height
--            --        local ala = display.newImageRect("graphicRaw/szymon.jpg", 500, 500);
--            --        ala.x = properties.center.x
--            creators:insert(backGroung)
--            creators:insert(bartek)
--            creators:insert(szymon)
--            creators.alpha = 0
--            transition.to(creators,{time = 2000, alpha =1})
--            timer.performWithDelay( 5000, function() transition.to(creators,{time = 2000, alpha =0, onComplete =function()creators:removeSelf() creators=display.newGroup()     sceneGroup:insert(creators)  end}) end )
--
--            backGroung:addEventListener("touch", touch)
--        end
--        return true
--
--
--
--    local ads = require( "ads" )
--
--    local function adListener( event )
--        if ( event.isError ) then
--            --Failed to receive an ad
--        end
--    end
--
--    ads.init( "admob", "myAppId", adListener )
--
--    ads.show( "banner", { x=0, y=0, appId="otherAppId" } )



    sceneGroup.tittleBackGround = display.newRect (0,0, 400, 100)
    sceneGroup.tittleBackGround.isVisible = false
    sceneGroup.tittleBackGround.isHitTestable = true

    sceneGroup:insert( sceneGroup.tittleBackGround)
    sceneGroup.tittle1 = display.newText ("Ghost", -135, 115, properties.font, 120)

    if fileToSave then
        if fileToSave.level then
    sceneGroup.HiScore = display.newText("Hi score : "..fileToSave.level, properties.x, properties.y, properties.font, 75)
    sceneGroup.HiScore.x = properties.x + sceneGroup.HiScore.width/2 + 15
    sceneGroup.HiScore.y = properties.y + sceneGroup.HiScore.height/2 + 15
    sceneGroup.HiScore:setFillColor(unpack(properties.firstSceneRectsColor))
        end
        end


    transition.to( sceneGroup.tittle1, { time=2500, alpha=1.0, x = properties.center.x - 100, transition=easing.outBounce} )
    sceneGroup:insert(sceneGroup.tittle1)


    sceneGroup.tittle2 = display.newText ("War",properties.width+135, 115, properties.font, 120)

     transition.to( sceneGroup.tittle2, { time=2500, alpha=1.0, x = properties.center.x + 100, transition=easing.outBounce} )
    sceneGroup:insert(sceneGroup.tittle2)

    sceneGroup.tittleBackGround.x =  properties.center.x
    sceneGroup.tittleBackGround.y =  sceneGroup.tittle1.y








    sceneGroup.rect1=display.newRoundedRect(properties.center.x,properties.center.y-size*2,size*3.2,  size*1.5        ,corners)
    sceneGroup.rect2=display.newRoundedRect(properties.center.x,properties.center.y,    size*3.2,     size*1.5,corners)
    sceneGroup.rect3=display.newRoundedRect(properties.center.x,properties.center.y+size*2, size*3.2,     size*1.5,corners)
    sceneGroup.rect4=display.newRoundedRect(properties.center.x,properties.center.y+size*4, size*3.2,     size*1.5,corners)


    sceneGroup.rect1nap = display.newText("Play", properties.center.x,properties.center.y-size*2, properties.font, size )
    sceneGroup.rect2nap = display.newText("Options", properties.center.x,properties.center.y, properties.font, size)
    sceneGroup.rect3nap = display.newText("Tutorial", properties.center.x,properties.center.y+size*2, properties.font, size)
    sceneGroup.rect4nap = display.newText("Exit", properties.center.x,properties.center.y+size*4, properties.font, size*0.86)



    sceneGroup.rect1:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect2:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect3:setFillColor(unpack(properties.firstSceneRectsColor))
    sceneGroup.rect4:setFillColor(unpack(properties.firstSceneRectsColor))


    sceneGroup.rect1nap:setFillColor(unpack(properties.firstSceneTextColor))

    sceneGroup.rect2nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup.rect3nap:setFillColor(unpack(properties.firstSceneTextColor))
    sceneGroup.rect4nap:setFillColor(unpack(properties.firstSceneTextColor))


    mainButtonsGroup:insert(sceneGroup.rect1)
    mainButtonsGroup:insert(sceneGroup.rect2)
    mainButtonsGroup:insert(sceneGroup.rect3)
    mainButtonsGroup:insert(sceneGroup.rect4)

    if sceneGroup.HiScore then
    mainButtonsGroup:insert(sceneGroup.HiScore)
    end


    mainButtonsGroup:insert(sceneGroup.rect1nap)
    mainButtonsGroup:insert(sceneGroup.rect2nap)
    mainButtonsGroup:insert(sceneGroup.rect3nap)
    mainButtonsGroup:insert(sceneGroup.rect4nap)

    mainButtonsGroup.alpha = 0

    local function allowFurther()
    transCompleted = true
    end

    transition.to( mainButtonsGroup, { time=1500, alpha=1.0, transition=easing.inCirc, onComplete = allowFurther} )


    sceneGroup:insert(mainButtonsGroup)
    sceneGroup:insert(creators)






    scene.view.rect1:addEventListener("touch", rectTouch)
    scene.view.rect2:addEventListener("touch", rectTouch)
    scene.view.rect3:addEventListener("touch", rectTouch)
    scene.view.rect4:addEventListener("touch", rectTouch)
 ---   sceneGroup.tittleBackGround:addEventListener("touch", creatorsPopUp)


end


function scene:destroy(event)


    local sceneGroup=self.view

    --[[
    scene.view.rect1:removeEventListener("touch",rectTouch)
    scene.view.rect2:removeEventListener("touch",rectTouch)
    scene.view.rect1nap:removeEventListener("touch",rectTouch)
    scene.view.rect2nap:removeEventListener("touch",rectTouch)
    --]]



end


function scene:show(event)
    goNextSceneFlag = false
    properties.started = false
    media.stopSound()
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene