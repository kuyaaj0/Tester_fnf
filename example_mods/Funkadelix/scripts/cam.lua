---@funkinScript

local stuff = {
  disabled = false,
  anims = {
    ['idle'] = {0, 'x'},
    ['danceleft'] = {0, 'x'},
    ['danceright'] = {0, 'x'},
    ['hey'] = {0, 'x'},
    ['singleft'] = {-20, 'x'},
    ['singdown'] = {20, 'y'},
    ['singup'] = {-20, 'y'},
    ['singright'] = {20, 'x'},
    ['idle-loop'] = {0, 'x'},
    ['danceleft-loop'] = {0, 'x'},
    ['danceright-loop'] = {0, 'x'},
    ['hey-loop'] = {0, 'x'},
    ['singleft-loop'] = {-20, 'x'},
    ['singdown-loop'] = {20, 'y'},
    ['singup-loop'] = {-20, 'y'},
    ['singright-loop'] = {20, 'x'},
  },
  check = {
    [true] = 'boyfriend',
    [false] = 'dad',
  },
}

function onUpdatePost(elapsed)
    setProperty('healthBar.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty("timeTxt.visible", false)
setProperty("iconP1.visible", false)
setProperty("iconP2.visible", false)
  if not stuff.disabled then
    local anim_info = stuff.anims[getProperty(stuff.check[mustHitSection]..'.animation.curAnim.name'):lower()]
    if anim_info then
      local var = ((version:find('0.7') ~= nil and 'camGame.scroll' or 'camFollowPos')..'.')..(anim_info[2] or 'x')
      local currentPos = getProperty(var);
      setProperty(var,
        lerp(currentPos,
          currentPos + ((anim_info[1] or 0) * (1 / getProperty('camGame.zoom'))),
          elapsed * getProperty('cameraSpeed') * playbackRate
        )
      );
    end
  end
end

function lerp(a, b, c) return a + (b - a) * c end