function onCreate()
makeLuaSprite('halloweenBG', 'stages/wek2/back', 200, 0)
scaleObject('halloweenBG', 2, 2)
makeLuaSprite('halloweenBG2', 'stages/wek2/overlay', 200, 0)
scaleObject('halloweenBG2', 2, 2)

	addLuaSprite('halloweenBG', false);
	addLuaSprite('halloweenBG2', true);
end