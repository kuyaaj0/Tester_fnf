function onSectionHit() 
      doTweenZoom('tween', 'camGame', (mustHitSection and 0.8 or 1), 0.9,'sineInOut')
end

function onTweenCompleted(t) 
     if t == 'tween' then
     setProperty('defaultCamZoom', getProperty('camGame.zoom')) 
    end
end