local judgementSize = {500, 163}
local comboSize = {100, 140}

local judgementScale = {0.7, 0.7}
local comboScale = {0.55, 0.55}

local judgementAntialiasing = true
local comboAntialiasing = true

local judgementAnims = {
    {"marvelous-early", 0},
    {"marvelous-late", 0},

    {"sick-early", 0},
    {"sick-late", 0},

    {"good-early", 4},
    {"good-late", 4},

    {"bad-early", 6},
    {"bad-late", 6},

    {"shit-early", 8},
    {"shit-late", 8},

    {"miss-early", 10},
    {"miss-late", 10},
}

local comboAnims = {
    -- normal
    {"-", 0},
    {"0", 1},
    {"1", 2},
    {"2", 3},
    {"3", 4},
    {"4", 5},
    {"5", 6},
    {"6", 7},
    {"7", 8},
    {"8", 9},
    {"9", 10},

    -- eldiabloco
    {"-M", 0},
    {"0M", 1},
    {"1M", 2},
    {"2M", 3},
    {"3M", 4},
    {"4M", 5},
    {"5M", 6},
    {"6M", 7},
    {"7M", 8},
    {"8M", 9},
    {"9M", 10},
}

local judgementCount = 0
local comboCount = 0

local initialMisses = 0
juanestonto=false
function getRatingVar()
	return string.sub(tostring(rating*100), 1, 5)
end
function onRecalculateRating()
    setTextString('S', ''.. score)
    setTextString('S2', ''.. misses)
    setTextString('S3', ''..getRatingVar().. '%')
    end
function onCreate()
if downscroll then
    makeLuaSprite('full healthbar', 'UI/base/full healthbar',1199,170)
setObjectCamera('full healthbar', 'camHUD')
addLuaSprite('full healthbar', true)

makeLuaSprite('empty healthbar', 'UI/base/empty healthbar',1199,170)
setObjectCamera('empty healthbar', 'camHUD')
addLuaSprite('empty healthbar', true)

makeLuaSprite("counter", "UI/base/counter",1025,0)
addLuaSprite("counter", juanestonto)
scaleObject("counter",0.65,0.65)
setObjectCamera('counter','hud')
setProperty('counter.flipY',true)

makeLuaText("S", "0", 830, 750, 600-600)
setTextSize("S", 50)
setTextBorder("S", 2, "000000")
setObjectCamera("S", 'camHUD'); 
setTextColor('S', 'ffffff')
setTextFont('S','tommy.otf')
addLuaText("S", true)

makeLuaText("S2", "0", 760, 750, 685-590)
setTextSize("S2", 15)
setTextBorder("S2", 2, "000000")
setObjectCamera("S2", 'camHUD'); 
setTextColor('S2', 'ffffff')
setTextFont('S2','tommy.otf')
addLuaText("S2", true)

makeLuaText("S3", "0", 960, 750, 685-590)
setTextSize("S3", 15)
setTextBorder("S3", 2, "000000")
setObjectCamera("S3", 'camHUD'); 
setTextColor('S3', 'ffffff')
setTextFont('S3','tommy.otf')
addLuaText("S3", true)

else
    makeLuaSprite('full healthbar', 'UI/base/full healthbar',1199,50)
setObjectCamera('full healthbar', 'camHUD')
addLuaSprite('full healthbar', true)

makeLuaSprite('empty healthbar', 'UI/base/empty healthbar',1199,50)
setObjectCamera('empty healthbar', 'camHUD')
addLuaSprite('empty healthbar', true)

makeLuaSprite("counter", "UI/base/counter",1025,590)
addLuaSprite("counter", juanestonto)
scaleObject("counter",0.65,0.65)
setObjectCamera('counter','hud')

makeLuaText("S", "0", 830, 750, 660)
setTextSize("S", 50)
setTextBorder("S", 2, "000000")
setObjectCamera("S", 'camHUD'); 
setTextColor('S', 'ffffff')
setTextFont('S','tommy.otf')
addLuaText("S", true)

makeLuaText("S2", "0", 760, 750, 607)
setTextSize("S2", 15)
setTextBorder("S2", 2, "000000")
setObjectCamera("S2", 'camHUD'); 
setTextColor('S2', 'ffffff')
setTextFont('S2','tommy.otf')
addLuaText("S2", true)

makeLuaText("S3", "0", 960, 750, 607)
setTextSize("S3", 15)
setTextBorder("S3", 2, "000000")
setObjectCamera("S3", 'camHUD'); 
setTextColor('S3', 'ffffff')
setTextFont('S3','tommy.otf')
addLuaText("S3", true)

end

    get = getProperty
    getFromClass = getPropertyFromClass
    getFromGroup = getPropertyFromGroup
    set = setProperty
    setFromClass = setPropertyFromClass
    setFromGroup = setPropertyFromGroup

    string.startsWith = stringStartsWith
    string.endsWith = stringEndsWith
    string.split = stringSplit


    popUpScoreCustom("sick", "0", false, false, true)
end

function onCreatePost()
    set("showRating", false)
    set("showComboNum", false)
end

function popUpScoreCustom(rating, comboStr, isMiss, showEarly, preload)
    judgementCount = judgementCount + 1

    local assetModifier = getFromClass("states.PlayState", "isPixelStage") and "pixel" or "base"

    -- judgement sprite
    makeLuaSprite("judgement"..judgementCount, "",460,10)
if downscroll then
makeLuaSprite("judgement"..judgementCount, "",460,10+590)
end
    loadGraphic("judgement"..judgementCount, "UI/"..assetModifier.."/judgements", judgementSize[1], judgementSize[2])
    addLuaSprite("judgement"..judgementCount, true)
    scaleObject("judgement"..judgementCount, judgementScale[1], judgementScale[2])
    updateHitbox("judgement"..judgementCount)
    setObjectCamera("judgement"..judgementCount,'camHUD')

    set("judgement"..judgementCount..".antialiasing", judgementAntialiasing and getFromClass("backend.ClientPrefs", "globalAntialiasing") or false)
    set("judgement"..judgementCount..".acceleration.y", 50.0 * playbackRate * playbackRate)
    set("judgement"..judgementCount..".velocity.y", math.random(-50) * playbackRate)
   
    if preload then
        set("judgement"..judgementCount..".alpha", 0.0001)
    end

    runTimer("judgementAlphaTimer"..judgementCount, (getFromClass("backend.Conductor", "crochet") * 0.001) / playbackRate)

    for i = 1, #judgementAnims do
        addAnimation("judgement"..judgementCount, judgementAnims[i][1], {judgementAnims[i][2]}, 0, true)
    end

    playAnim("judgement"..judgementCount, rating.."-"..(showEarly and "early" or "late"))

    -- combo sprites
    local comboSplit = string.split(comboStr, "")

    for i = 1, #comboSplit do
        comboCount = comboCount + 1
        makeLuaSprite("combo"..comboCount, "",((screenWidth * 0.55) - 90) + (43 * (i-1))-50, (screenHeight * 0.5) - 260)
        if downscroll then
        makeLuaSprite("combo"..comboCount, "",((screenWidth * 0.55) - 90) + (43 * (i-1))-50, (screenHeight * 0.5) - 260+440)
        end
        loadGraphic("combo"..comboCount, "UI/"..assetModifier.."/combo", comboSize[1], comboSize[2])
        addLuaSprite("combo"..comboCount, true)
        scaleObject("combo"..comboCount, comboScale[1], comboScale[2])
        updateHitbox("combo"..comboCount)
        setObjectCamera("combo"..comboCount,'camHUD')
        
        set("combo"..comboCount..".antialiasing", comboAntialiasing and getFromClass("backend.ClientPrefs", "globalAntialiasing") or false)
        set("combo"..comboCount..".acceleration.y", math.random(50.0) * playbackRate * playbackRate)
        set("combo"..comboCount..".velocity.y", math.random(-50) * playbackRate)

        if preload then
            set("combo"..comboCount..".alpha", 0.0001)
        end

        runTimer("comboAlphaTimer"..comboCount, (getFromClass("backend.Conductor", "crochet") * 0.002) / playbackRate)

        if isMiss then
            set("combo"..comboCount..".color", getColorFromHex("d93f51"))
        end
    
        for i = 1, #comboAnims do
            addAnimation("combo"..comboCount, comboAnims[i][1], {comboAnims[i][2]}, 0, true)
        end
    
        playAnim("combo"..comboCount, comboSplit[i]..(rating == "marvelous" and "M" or ""))
    end
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
    local rating = getFromGroup("notes", id, "rating")
    if rating == "unknown" or isSustainNote then return end

    local noteDiff = getSongPosition() - getFromGroup("notes", id, "strumTime")
    local showEarly = noteDiff < 0

    if get("ratingFC") == "SFC" or botPlay then rating = "marvelous" end

    popUpScoreCustom(rating, tostring(get("combo")), false, showEarly)

    initialMisses = get("songMisses")
end


ta= 0.6
function onUpdate()
    function lerp(a, b, t)
        return a + (b - a) * t
    end
    h = getProperty('full healthbar.height')
    currentHeight = getProperty('empty healthbar._frame.frame.height')
    targetHeight = getHealth()
     < 2 and
      ((1 - (getHealth() 
      / 2)) * h 
      - 60) 
      or 0.0001
    smoothHeight = lerp(currentHeight, targetHeight, 0.1) 
    setProperty('empty healthbar._frame.frame.height', smoothHeight)

    for i = 0,3 do
		setPropertyFromGroup('strumLineNotes', i, 'x', 150 + (80 * (i % 4)))
	end
	for i = 4,7 do
		setPropertyFromGroup('strumLineNotes', i, 'x', 770 + (80 * (i % 4)))
	end
    for i=0, getProperty('notes.length')-1 do
        if not getPropertyFromGroup('notes',i,'isSustainNote')  then
        setPropertyFromGroup('notes', i, 'scale.x', ta)
        setPropertyFromGroup('notes', i, 'scale.y', ta)
            end
        end
    setPropertyFromGroup('opponentStrums', 0, 'scale.x', ta)
    setPropertyFromGroup('opponentStrums', 1, 'scale.x', ta)
    setPropertyFromGroup('opponentStrums', 2, 'scale.x', ta)
    setPropertyFromGroup('opponentStrums', 3, 'scale.x', ta)
    setPropertyFromGroup('opponentStrums', 0, 'scale.y', ta)
    setPropertyFromGroup('opponentStrums', 1, 'scale.y', ta)
    setPropertyFromGroup('opponentStrums', 2, 'scale.y', ta)
    setPropertyFromGroup('opponentStrums', 3, 'scale.y', ta)
    setPropertyFromGroup('playerStrums', 0, 'scale.x', ta)
    setPropertyFromGroup('playerStrums', 1, 'scale.x', ta)
    setPropertyFromGroup('playerStrums', 2, 'scale.x', ta)
    setPropertyFromGroup('playerStrums', 3, 'scale.x', ta)
    setPropertyFromGroup('playerStrums', 0, 'scale.y', ta)
    setPropertyFromGroup('playerStrums', 1, 'scale.y', ta)
    setPropertyFromGroup('playerStrums', 2, 'scale.y', ta)
    setPropertyFromGroup('playerStrums', 3, 'scale.y', ta)
end
function onTimerCompleted(name)
    if string.startsWith(name, "judgementAlphaTimer") then
        local countLol = name:gsub("judgementAlphaTimer", "")
        doTweenAlpha("judgementAlpha"..countLol, "judgement"..countLol, 0, 0.2 / playbackRate, "linear")
    end

    if string.startsWith(name, "comboAlphaTimer") then
        local countLol = name:gsub("comboAlphaTimer", "")
        doTweenAlpha("comboAlpha"..countLol, "combo"..countLol, 0, 0.2 / playbackRate, "linear")
    end
end

function onTweenCompleted(name)
    if string.startsWith(name, "judgementAlpha") then
        local countLol = name:gsub("judgementAlpha", "")
        removeLuaSprite("judgement"..countLol, true)
    end

    if string.startsWith(name, "comboAlpha") then
        local countLol = name:gsub("comboAlpha", "")
        removeLuaSprite("combo"..countLol, true)
    end
end