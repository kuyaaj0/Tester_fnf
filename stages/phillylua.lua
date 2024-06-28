function onCreate()

makeLuaSprite('overlay', 'stages/wek3/overlay', -800, -400)
scaleObject('overlay', 3, 3)


makeAnimatedLuaSprite('beams','stages/wek3/philly',0,0)
scaleObject('beams', 2, 2)
addAnimationByPrefix('beams', '1','beams', 1,true)

makeAnimatedLuaSprite('buildings','stages/wek3/philly',0,0)
scaleObject('buildings', 2, 2)
addAnimationByPrefix('buildings', '1','buildings', 1,true)

makeAnimatedLuaSprite('roof','stages/wek3/philly',0,0)
scaleObject('roof', 2, 2)
addAnimationByPrefix('roof', '1','roof', 1,true)

makeAnimatedLuaSprite('sky','stages/wek3/philly',0,0)
scaleObject('sky', 2, 2)
addAnimationByPrefix('sky', '1','sky', 1,true)

addLuaSprite('sky', false)
addLuaSprite('buildings', false)
addLuaSprite('beams', false)
addLuaSprite('roof', false)
addLuaSprite('overlay', false)

end

