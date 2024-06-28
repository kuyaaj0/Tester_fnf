--Floating Arrows Event uwu
--By Gart00n4321#2330

local speed
local able

function onEvent(name, value1, value2)
	if name == 'Floating Arrows' then
		speed = value2
		if value1 == 'on' then
			able = true
		end
		if value1 == 'off' then
			able = false
		end
		if value1 == '' or value2 == '' or value1 == '' and value2 == '' then
			--do nothing
		end
	end
end

function onStepHit()
	songPos = getSongPosition()
	local currentBeat = (songPos/10000)*(curBpm/100)
	if able == true then
		noteTweenY('defaultOpponentStrumY0', 0, defaultPlayerStrumY0 - 20*math.sin((currentBeat+0*0.25)*math.pi), speed)
		noteTweenY('defaultOpponentStrumY1', 1, defaultPlayerStrumY1 - 20*math.sin((currentBeat+1*0.25)*math.pi), speed)
		noteTweenY('defaultOpponentStrumY2', 2, defaultPlayerStrumY2 - 20*math.sin((currentBeat+2*0.25)*math.pi), speed)
		noteTweenY('defaultOpponentStrumY3', 3, defaultPlayerStrumY3 - 20*math.sin((currentBeat+3*0.25)*math.pi), speed)
		noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 20*math.sin((currentBeat+4*0.25)*math.pi), speed)
		noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 20*math.sin((currentBeat+5*0.25)*math.pi), speed)
		noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 20*math.sin((currentBeat+6*0.25)*math.pi), speed)
		noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 20*math.sin((currentBeat+7*0.25)*math.pi), speed)
	else
		noteTweenY('ogOpponentStrumY0', 0, defaultPlayerStrumY0, speed)
		noteTweenY('ogOpponentStrumY1', 1, defaultPlayerStrumY1, speed)
		noteTweenY('ogOpponentStrumY2', 2, defaultPlayerStrumY2, speed)
		noteTweenY('ogOpponentStrumY3', 3, defaultPlayerStrumY3, speed)
		noteTweenY('ogPlayerStrumY0', 4, defaultPlayerStrumY0, speed)
		noteTweenY('ogPlayerStrumY1', 5, defaultPlayerStrumY1, speed)
		noteTweenY('ogPlayerStrumY2', 6, defaultPlayerStrumY2, speed)
		noteTweenY('ogPlayerStrumY3', 7, defaultPlayerStrumY3, speed)
	end
end