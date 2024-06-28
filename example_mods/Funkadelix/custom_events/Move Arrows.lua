arrowMoveX = 0
arrowMoveY = 0
toggle = false
function onUpdatePost(elapsed)
    if toggle then
        for i = 0,7 do
            defaultY = i >= 4 and _G[('defaultPlayerStrumY')..(i-4)] or _G[('defaultOpponentStrumY')..(i)]
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultY + arrowMoveY * math.cos((curDecBeat + i * 0.40) * math.pi))
        end
    end
end

function onEvent(n,v1,v2)
      if n == 'Move Arrows' then
          toggle = not toggle
          arrowMoveX = tonumber(v1)
          arrowMoveY = tonumber(v2)
              if not toggle then
            defaultY = i >= 4 and _G[('defaultPlayerStrumY')..(i-4)] or _G[('defaultOpponentStrumY')..(i)]
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultY)
              end
      end
end