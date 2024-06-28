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