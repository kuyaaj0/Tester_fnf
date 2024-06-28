function onEvent(name, value1, value2)
    local var string = (value1)
    local var color = (value2)
    if name == "Second Lyric Line" then

        makeLuaText('SECOND', 'Lyrics go here', 1000, 150, 550)
        setTextString('SECOND',  '' .. string)
        setTextFont('SECOND', 'lyrics.ttf')
        setTextColor('SECOND', color)
        setTextSize('SECOND', 30);
        addLuaText('SECOND')
	setObjectCamera('SECOND', 'other');
        setTextAlignment('SECOND', 'center')
        --removeLuaText('SECOND', true)
        
    end
end

