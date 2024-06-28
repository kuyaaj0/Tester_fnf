function onCreate()
makeLuaSprite('halloweenBG', 'stages/wek2/back', 200, 0)
scaleObject('halloweenBG', 2, 2)
makeLuaSprite('halloweenBG2', 'stages/wek2/overlay', 200, 0)
scaleObject('halloweenBG2', 2, 2)

	addLuaSprite('halloweenBG', false);
	addLuaSprite('halloweenBG2', true);
end
function onStepHit()
    if curStep == 576 then
setProperty('defaultCamZoom',0.83)
    end

    if curStep == 848 then
setProperty('defaultCamZoom',0.9)
    end
end