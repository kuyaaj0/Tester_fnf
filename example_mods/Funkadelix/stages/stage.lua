function onCreate()
makeLuaSprite('stageback', 'stages/wek1/stage', -100, -100)
scaleObject('stageback', 2, 2)
setScrollFactor('stageback', 0.9, 0.9)
makeLuaSprite('stagecurtains', 'stages/wek1/curtains', -100, 0)
setScrollFactor('stagecurtains', 1, 1)
scaleObject('stagecurtains', 2.1, 2)

	addLuaSprite('stageback', false)
	addLuaSprite('stagecurtains', false)
	
end
function onStepHit()
    if curStep == 894 then
setProperty('defaultCamZoom',0.9)
    end

    if curStep == 958 then
setProperty('defaultCamZoom',0.8)
    end

    if curStep == 1024 then
setProperty('defaultCamZoom',0.9)
    end

    if curStep == 1068 then
setProperty('defaultCamZoom',0.7)
    end

    if curStep == 1672 then
setProperty('defaultCamZoom',0.9)
    end

    if curStep == 1791 then
setProperty('defaultCamZoom',0.8)
    end

    if curStep == 1920 then
setProperty('defaultCamZoom',0.7)
    end

    if curStep == 2470 then
setProperty('camHUD.alpha', 0.001)
setProperty('camGame.alpha', 0.001) 
    end
end