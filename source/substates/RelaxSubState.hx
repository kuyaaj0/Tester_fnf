package substates;

import objects.AudioDisplay.AudioCircleDisplay;
import objects.state.relaxState.ButtonSprite;
import objects.state.relaxState.TopButtons;
import objects.state.relaxState.SongInfoDisplay;
import objects.state.relaxState.ControlButtons;
import objects.state.relaxState.windows.PlayListWindow;
import openfl.filters.BlurFilter;
import openfl.display.Shape;

import flixel.graphics.frames.FlxFilterFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

import sys.thread.Thread;

import backend.relax.GetInit;
import backend.relax.GetInit.SongLists;
import backend.relax.GetInit.SongInfo;

class RelaxSubState extends MusicBeatSubstate
{
    public static var instance:RelaxSubState;

    public var SongsArray:SongLists = { name: "Unknown", list: [] };
    private var currentSongIndex:Int = 0;
    private var pendingSongIndex:Int = -1;
    public var nowChoose:Array<Int> = [0,0];
    
    // Cameras
    var camBack:FlxCamera;
    var camPic:FlxCamera;
    var camText:FlxCamera;
    var camHUD:FlxCamera;
    public var camOption:FlxCamera;
    var camVpad:FlxCamera;
    
    private var currentBPM:Float = 100;
    private var beatTime:Float = 0.6;
    private var beatTimer:Float = 0;
    private var defaultZoom:Float = 1.0;
    private var zoomIntensity:Float = 0.05;
    public var enableBpmZoom:Bool = true;

    var maskRadius:Float = 150;
    var circleMask:Shape;
    
    var backendPicture:FlxSprite;
    var audio:AudioCircleDisplay;
    var recordPicture:FlxSprite;
    
    var oldBackendPicture:FlxSprite;
    var oldRecordPicture:FlxSprite;

    var transitionTime:Float = 0.5;
    var isTransitioning:Bool = false;
    var transitionTweens:Array<FlxTween> = [];
    
    public var enableRecordRotation:Bool = true;
    public var bgBlur:Bool = false;
    public var controlButtons:ControlButtons;
    public var topButtons:TopButtons;
    public var songInfoDisplay:SongInfoDisplay;
    public var playListWindow:PlayListWindow;
    
    public var SoundGroup:FlxSoundGroup;
    
    var topTrapezoid:FlxSprite;
    var hideTimer:Float = 0;
    var waitingToHide:Bool = false;
    var topTrapezoidTween:FlxTween = null;
    var isTweening:Bool = false;
    
    var clickList:Bool = false;
    var clickOption:Bool = false;
    var clickLock:Bool = false;
    
    var beatTimess:Int = 0;
    var helpBool:Bool = false;
    
    var bgFollowSmooth:Float = 0.2;
    var lastMousePos:FlxPoint = FlxPoint.get();
    var mousePosCache:FlxPoint = FlxPoint.get();
    var centerPoint:FlxPoint = FlxPoint.get(FlxG.width / 2, FlxG.height / 2);
    
    static var spritePool:Array<FlxSprite> = [];
    static var soundPool:Array<FlxSound> = [];

    public function new()
    {
        super();
        FlxG.state.persistentUpdate = false;
        FlxG.sound.music.stop();
        SoundGroup = new FlxSoundGroup();
        addVirtualPad(NONE, B);
    }

    override function create()
    {
        instance = this;
        
        camBack = new FlxCamera();
        camPic = new FlxCamera();
        camText = new FlxCamera();
        camHUD = new FlxCamera();
        camVpad = new FlxCamera();
        camOption = new FlxCamera();

        for (cam in [camHUD, camPic, camText, camBack, camVpad, camOption]) {
            cam.bgColor.alpha = 0;
        }

        FlxG.cameras.add(camBack, false);
        FlxG.cameras.add(camPic, false);
        FlxG.cameras.add(camText, false);
        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.add(camOption, false);
        FlxG.cameras.add(camVpad, false);
        
        virtualPad.cameras = [camVpad];
        
        topTrapezoid = new FlxSprite();
        drawTrapezoid(FlxG.width * 0.7, 40);
        topTrapezoid.y = 0;
        topTrapezoid.x = (FlxG.width - topTrapezoid.width) / 2;
        topTrapezoid.scrollFactor.set();
        topTrapezoid.cameras = [camOption];
        add(topTrapezoid);
        camOption.y = -topTrapezoid.height;

        topButtons = new TopButtons();
        for (member in topButtons.members) {
            if (member != null) {
                member.cameras = [camOption];
            }
        }
        add(topButtons);
        
        defaultZoom = 1.0;
        camPic.zoom = defaultZoom;

        super.create();

        controlButtons = new ControlButtons();
        add(controlButtons.LeftButton);
        add(controlButtons.MiddleButton);
        add(controlButtons.RightButton);
        controlButtons.LeftButton.cameras = [camHUD];
        controlButtons.MiddleButton.cameras = [camHUD];
        controlButtons.RightButton.cameras = [camHUD];
        controlButtons.LeftButton.pixelPerfectPosition = true;
        controlButtons.RightButton.pixelPerfectPosition = true;
        controlButtons.MiddleButton.pixelPerfectPosition = true;

        songInfoDisplay = new SongInfoDisplay();
        add(songInfoDisplay.songNameText);
        add(songInfoDisplay.writerText);
        add(songInfoDisplay.songLengthText);
        songInfoDisplay.songNameText.cameras = [camText];
        songInfoDisplay.writerText.cameras = [camText];
        songInfoDisplay.songLengthText.cameras = [camHUD];

        circleMask = new Shape();
        updateMask();

        initSongsList(0);
        
        if (SongsArray.list.length > 0) {
            currentSongIndex = 0;
            pendingSongIndex = -1;
            loadSongs(SongsArray.list[0]);
        }
        
        playListWindow = new PlayListWindow();
        for (i in playListWindow.members) {
            i.cameras = [camOption];
        }
        add(playListWindow);
        
        var DebugText:FlxText = new FlxText(0, 0, FlxG.width, SongsArray.name, 25);
        DebugText.font = Paths.font('Lang-ZH.ttf');
        add(DebugText);
        DebugText.cameras = [camHUD];
    }

    /**
     * 加载新歌曲
     */
    public function loadSongs(songInfo:SongInfo = null):Void 
    {
        if (isTransitioning || songInfo == null) return;
        
        cleanupTransitionTweens();
        
        isTransitioning = true;
        
        // 先停止并清理现有资源
        FlxG.sound.music.stop();
        SoundGroup.pause();
        SoundGroup.clear();
        
        // 清理旧的显示对象
        if (audio != null) {
            remove(audio);
            audio.destroy();
            audio = null;
        }
        
        Thread.create(() -> {
            // 预加载资源
            if (songInfo.background != null) {
                for (bg in songInfo.background) {
                    Paths.image(bg);
                }
            }
            
            if (songInfo.record != null) {
                for (rec in songInfo.record) {
                    Paths.image(rec);
                }
            }
            
            if (songInfo.sound != null) {
                for (snd in songInfo.sound) {
                    Paths.music(snd);
                }
            }
            
            FlxG.camera.flash(FlxColor.BLACK, 0.3, null, true);
            
            // 创建新资源
            var newBackendPicture:FlxSprite = null;
            var newRecordPicture:FlxSprite = null;
            var newAudio:AudioCircleDisplay = null;
            
            if (songInfo.background != null && songInfo.background.length > 0) {
                newBackendPicture = getSpriteFromPool();
                newBackendPicture.loadGraphic(songInfo.background[0]);
                newBackendPicture.antialiasing = ClientPrefs.data.antialiasing;
                newBackendPicture.scale.set(1.1, 1.1);
                newBackendPicture.updateHitbox();
                newBackendPicture.screenCenter();
                newBackendPicture.cameras = [camBack];
                newBackendPicture.alpha = 0;
            }
            
            if (songInfo.record != null && songInfo.record.length > 0) {
                newRecordPicture = getSpriteFromPool();
                newRecordPicture.loadGraphic(songInfo.record[0]);
                newRecordPicture.antialiasing = ClientPrefs.data.antialiasing;
                newRecordPicture.cameras = [camPic];
                newRecordPicture.alpha = 0;
            }
            
            if (songInfo.sound != null && songInfo.sound.length > 0) {
                FlxG.sound.playMusic(songInfo.sound[0], 1);
                FlxG.sound.music.onComplete = nextSong;
                
                newAudio = new AudioCircleDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 
                                                500, 100, 46, 4, FlxColor.WHITE, 150);
                newAudio.alpha = 0;
                newAudio.cameras = [camBack];
            }
            
            // 在主线程执行添加和动画
            FlxG.camera.list.splice(FlxG.camera.list.indexOf(camBack), 1);
            FlxG.camera.list.splice(FlxG.camera.list.indexOf(camPic), 1);
            
            FlxG.calls.push(function() {
                // 添加新元素
                if (newBackendPicture != null) {
                    add(newBackendPicture);
                    if (bgBlur) {
                        var blurFilter = new BlurFilter(10, 10, 1);
                        var filterFrames = FlxFilterFrames.fromFrames(newBackendPicture.frames, 
                                                                    Std.int(newBackendPicture.width), 
                                                                    Std.int(newBackendPicture.height), 
                                                                    [blurFilter]);
                        filterFrames.applyToSprite(newBackendPicture, false, true);
                    }
                }
                
                if (newAudio != null) {
                    add(newAudio);
                }
                
                if (newRecordPicture != null) {
                    add(newRecordPicture);
                    updatePictureScale();
                }
                
                // 淡入新元素
                var tweenCount = 0;
                var totalTweens = [newBackendPicture, newAudio, newRecordPicture].filter(obj -> obj != null).length;
                
                function checkNewComplete() {
                    if (++tweenCount >= totalTweens) {
                        // 淡出旧元素
                        var oldTweenCount = 0;
                        var totalOldTweens = [backendPicture, audio, recordPicture].filter(obj -> obj != null).length;
                        
                        function checkOldComplete() {
                            if (++oldTweenCount >= totalOldTweens) {
                                // 清理旧资源
                                if (backendPicture != null) {
                                    remove(backendPicture);
                                    returnToPool(backendPicture);
                                }
                                if (audio != null) {
                                    remove(audio);
                                    audio.destroy();
                                }
                                if (recordPicture != null) {
                                    remove(recordPicture);
                                    returnToPool(recordPicture);
                                }
                                
                                // 更新引用
                                backendPicture = newBackendPicture;
                                audio = newAudio;
                                recordPicture = newRecordPicture;
                                
                                isTransitioning = false;
                                
                                if (pendingSongIndex != -1) {
                                    var indexToLoad = pendingSongIndex;
                                    pendingSongIndex = -1;
                                    loadSongs(SongsArray.list[indexToLoad]);
                                }
                            }
                        }
                        
                        if (totalOldTweens > 0) {
                            if (backendPicture != null) {
                                FlxTween.tween(backendPicture, {alpha: 0}, transitionTime, {
                                    ease: FlxEase.quadIn,
                                    onComplete: checkOldComplete
                                });
                            }
                            if (audio != null) {
                                FlxTween.tween(audio, {alpha: 0}, transitionTime, {
                                    ease: FlxEase.quadIn,
                                    onComplete: checkOldComplete
                                });
                            }
                            if (recordPicture != null) {
                                FlxTween.tween(recordPicture, {alpha: 0}, transitionTime, {
                                    ease: FlxEase.quadIn,
                                    onComplete: checkOldComplete
                                });
                            }
                        } else {
                            checkOldComplete();
                        }
                    }
                }
                
                if (totalTweens > 0) {
                    if (newBackendPicture != null) {
                        FlxTween.tween(newBackendPicture, {alpha: 1}, transitionTime, {
                            ease: FlxEase.quadOut,
                            onComplete: checkNewComplete
                        });
                    }
                    if (newAudio != null) {
                        FlxTween.tween(newAudio, {alpha: 0.7}, transitionTime, {
                            ease: FlxEase.quadOut,
                            onComplete: checkNewComplete
                        });
                    }
                    if (newRecordPicture != null) {
                        FlxTween.tween(newRecordPicture, {alpha: 1, angle: 360}, transitionTime, {
                            ease: FlxEase.quadOut,
                            onComplete: checkNewComplete
                        });
                    }
                } else {
                    checkNewComplete();
                }
                
                // 重新添加相机
                FlxG.cameras.add(camBack, false);
                FlxG.cameras.add(camPic, false);
            });
        });
    }

    private function drawTrapezoid(topWidth:Float, height:Float):Void {
        var bottomWidth = topWidth * 0.8;
        var sideSlope = (topWidth - bottomWidth) / 2;
        
        topTrapezoid.makeGraphic(Std.int(topWidth), Std.int(height), FlxColor.TRANSPARENT, true);
        
        var vertices = [
            new FlxPoint(0, 0),
            new FlxPoint(topWidth, 0),
            new FlxPoint(topWidth - sideSlope, height), 
            new FlxPoint(sideSlope, height)
        ];
        FlxSpriteUtil.drawPolygon(topTrapezoid, vertices, 0xFF24232C);
    }

    private function updateMask():Void
    {
        if (circleMask == null) {
            circleMask = new Shape();
        }
        
        var maxRadius:Float = Math.min(FlxG.stage.stageWidth, FlxG.stage.stageHeight) / 2;
        maskRadius = Math.min(maskRadius, maxRadius);
        
        circleMask.graphics.clear();
        circleMask.graphics.beginFill(0xFFFFFF);
        
        var scaledRadius:Float = Math.min(
            maskRadius * (FlxG.stage.stageHeight / FlxG.height), 
            maskRadius * (FlxG.stage.stageWidth / FlxG.width)
        );
        
        circleMask.graphics.drawCircle(
            FlxG.stage.stageWidth / 2, 
            FlxG.stage.stageHeight / 2, 
            scaledRadius
        );
        circleMask.graphics.endFill();

        camPic.flashSprite.mask = circleMask;
        camText.flashSprite.mask = circleMask;
    }

    private function updatePictureScale():Void
    {
        if (recordPicture == null) return;
        
        var scaleX:Float = (maskRadius * 2) / recordPicture.width;
        var scaleY:Float = (maskRadius * 2) / recordPicture.height;
        var scale:Float = Math.max(scaleX, scaleY);

        recordPicture.scale.set(scale, scale);
        recordPicture.updateHitbox();
        recordPicture.screenCenter();
    }

    private function initSongsList(ListNum:Int = 0):Void {
        SongsArray = GetInit.getList(ListNum);
    }

    /**
     * 切换到下一首歌曲
     */
    private function nextSong():Void {
        if (SongsArray.list.length <= 1) return;
        
        var nextIndex = (currentSongIndex + 1) % SongsArray.list.length;
        
        if (isTransitioning) {
            pendingSongIndex = nextIndex;
            return;
        }
        
        currentSongIndex = nextIndex;
        loadSongs(SongsArray.list[currentSongIndex]);
    }
    
    /**
     * 切换到上一首歌曲
     */
    private function prevSong():Void {
        if (SongsArray.list.length <= 1) return;
        
        var prevIndex = (currentSongIndex - 1 + SongsArray.list.length) % SongsArray.list.length;
        
        if (isTransitioning) {
            pendingSongIndex = prevIndex;
            return;
        }
        
        currentSongIndex = prevIndex;
        loadSongs(SongsArray.list[currentSongIndex]);
    }

    private function handleTopTrapezoidVisibility(nearTop:Bool, elapsed:Float):Void {
        if (nearTop) {
            if (waitingToHide) {
                waitingToHide = false;
                hideTimer = 0;
            }
            
            if (camOption.y < 0 && !isTweening) {
                if (topTrapezoidTween != null && topTrapezoidTween.active) {
                    topTrapezoidTween.cancel();
                }
                
                isTweening = true;
                topTrapezoidTween = FlxTween.tween(camOption, {y: 0}, 0.3, {
                    ease: FlxEase.quadOut,
                    onComplete: function(_) {
                        isTweening = false;
                    }
                });
            }
        } 
        else {
            if (!waitingToHide && !isTweening) {
                waitingToHide = true;
                hideTimer = 0;
            }
            
            if (waitingToHide) {
                if(!clickList && !clickOption) hideTimer += elapsed;
                if (hideTimer >= 3.0 && !isTweening) {
                    waitingToHide = false;

                    if (topTrapezoidTween != null && topTrapezoidTween.active) {
                        topTrapezoidTween.cancel();
                    }
                    
                    isTweening = true;
                    topTrapezoidTween = FlxTween.tween(camOption, {y: -topTrapezoid.height}, 0.3, {
                        ease: FlxEase.quadIn,
                        onComplete: function(_) {
                            isTweening = false;
                        }
                    });
                }
            }
        }
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        updateMask();
        
        if (backendPicture != null && !isTransitioning) {
            mousePosCache = FlxG.mouse.getScreenPosition(camHUD, mousePosCache);
            var targetOffsetX = (mousePosCache.x - centerPoint.x) * 0.01;
            var targetOffsetY = (mousePosCache.y - centerPoint.y) * 0.01;
            
            var currentOffsetX = backendPicture.x - (centerPoint.x - backendPicture.width / 2);
            var currentOffsetY = backendPicture.y - (centerPoint.y - backendPicture.height / 2);
            
            var smoothX = FlxMath.lerp(currentOffsetX, targetOffsetX, bgFollowSmooth);
            var smoothY = FlxMath.lerp(currentOffsetY, targetOffsetY, bgFollowSmooth);
            
            backendPicture.x = centerPoint.x - backendPicture.width / 2 + smoothX;
            backendPicture.y = centerPoint.y - backendPicture.height / 2 + smoothY;
        }

        mousePosCache = FlxG.mouse.getScreenPosition(camHUD, mousePosCache);
        var nearTop = mousePosCache.y < 50;
        handleTopTrapezoidVisibility(nearTop, elapsed);

        songInfoDisplay.writerText.y = songInfoDisplay.songNameText.y + songInfoDisplay.songNameText.height + 10;
        
        songInfoDisplay.updateSongLengthPosition(
            controlButtons.MiddleButton.x,
            controlButtons.MiddleButton.y,
            controlButtons.MiddleButton.width,
            controlButtons.MiddleButton.height
        );
        
        if (enableBpmZoom && FlxG.sound.music != null && FlxG.sound.music.playing) {
            beatTimer += elapsed;
            
            if (beatTimer >= beatTime) {
                beatTimer -= beatTime;
                onBPMBeat();
            }
        }
        
        if (FlxG.sound.music != null) {
            var currentTime:Float = FlxG.sound.music.time / 1000;
            var totalTime:Float = FlxG.sound.music.length / 1000;
            
            songInfoDisplay.updateSongLength(currentTime, totalTime);
            
            songInfoDisplay.updateSongLengthPosition(
                controlButtons.MiddleButton.x,
                controlButtons.MiddleButton.y,
                controlButtons.MiddleButton.width,
                controlButtons.MiddleButton.height
            );
        }

        if (FlxG.keys.justPressed.LEFT) {
            prevSong();
        }
        else if (FlxG.keys.justPressed.RIGHT) {
            nextSong();
        }
        
        mousePosCache = FlxG.mouse.getScreenPosition(camHUD, mousePosCache);
        var isOverLeft = controlButtons.isMouseOverLeftButton(mousePosCache);
        var isOverMiddle = controlButtons.isMouseOverMiddleButton(mousePosCache);
        var isOverRight = controlButtons.isMouseOverRightButton(mousePosCache);

        var isOverList = topButtons.isMouseOverListButton(mousePosCache);
        var isOverSetting = topButtons.isMouseOverSettingButton(mousePosCache);
        var isOverRock = topButtons.isMouseOverLockButton(mousePosCache);
        
        controlButtons.setButtonAlphas(isOverLeft, isOverMiddle, isOverRight);
        topButtons.setButtonAlphas(isOverList, isOverSetting, isOverRock, clickList, clickOption, clickLock);
        
        if (FlxG.mouse.justPressed) {
            if (isOverLeft) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
                controlButtons.animateLeftButtonPress(0.1);
                prevSong();
            }
            else if (isOverMiddle && FlxG.sound.music != null) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
                
                if (FlxG.sound.music.playing) {
                    FlxG.sound.music.pause();
                    SoundGroup.pause();
                } else {
                    FlxG.sound.music.play();
                    SoundGroup.resume();
                }
            }
            else if (isOverRight) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
                controlButtons.animateRightButtonPress(0.1);
                nextSong();
            }
            else if (isOverList) {
                clickList = !clickList;
                if (clickList && clickOption)
                    clickOption = !clickList;
                    playListWindow.toggle();
            }
            else if (isOverSetting) {
                clickOption = !clickOption;
                if (clickList && clickOption)
                    clickList = !clickOption;
                    playListWindow.Hidding = false;
                    playListWindow.hide();
                trace('setting');
            }
            else if (isOverRock) {
                clickLock = !clickLock;
                camVpad.alpha = clickLock ? 0 : 1;
            }
        }
        
        if (recordPicture != null && !isTransitioning && enableRecordRotation)
        {
            recordPicture.angle += elapsed * 20;
            if (recordPicture.angle >= 360) recordPicture.angle -= 360;
        }

        if (FlxG.keys.justPressed.B)
        {
            enableBpmZoom = !enableBpmZoom;
            if (!enableBpmZoom) {
                camPic.zoom = defaultZoom;
            }
        }
        
        if (controls.BACK) {
            removeVirtualPad();
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
            close();
        }
    }

    function onBPMBeat(){
        var targetZoom = defaultZoom + zoomIntensity;
        camPic.zoom = targetZoom;

        controlButtons.handleBeatAnimation(beatTime);
        
        FlxTween.tween(camPic, {zoom: defaultZoom}, beatTime * 0.5, {
            ease: FlxEase.quadOut
        });
        
        beatTimess++;
        helpBool = !helpBool;
        
        topButtons.handleBeatAnimation(helpBool, beatTime);
        
        if(helpBool){
            Main.watermark.scaleX = ClientPrefs.data.WatermarkScale + 0.1;
            Main.watermark.scaleY = ClientPrefs.data.WatermarkScale - 0.1;
        }else{
            Main.watermark.scaleX = ClientPrefs.data.WatermarkScale - 0.1;
            Main.watermark.scaleY = ClientPrefs.data.WatermarkScale + 0.1;
        }
        
        FlxTween.tween(Main.watermark, {scaleX: ClientPrefs.data.WatermarkScale, scaleY: ClientPrefs.data.WatermarkScale}, beatTime * 0.5, {
            ease: FlxEase.quadOut
        });

        if(beatTimess == 4)
        {
            beatTimess = 0;
            fourTimeBeat();
        }
    }
    
    function fourTimeBeat() {
        controlButtons.handleFourTimeBeatAnimation(beatTime);
        
        var currentY = songInfoDisplay.songLengthText.y;
        songInfoDisplay.songLengthText.y += 5;
        
        FlxTween.tween(songInfoDisplay.songLengthText, {y: currentY}, beatTime * 0.5, {
            ease: FlxEase.quadOut
        });
    }

    public function OtherListLoad(data:Array<Int> = null){
        try{
            if(data[0] >= GetInit.getListNum())
                data[0] = GetInit.getListNum() - 1;
                
            SongsArray = GetInit.getList(data[0]);
            
            if(data[1] >= SongsArray.list.length){
                data[1] = SongsArray.list.length - 1;
            }
            
            nowChoose = data;
            currentSongIndex = data[1];
            loadSongs(SongsArray.list[data[1]]);
        } catch(e:Dynamic) {
            trace('Error loading other list: $e');
        }
    }
    
    static function getSpriteFromPool():FlxSprite 
    {
        while (spritePool.length > 0) {
            var sprite = spritePool.pop();
            if (sprite != null && sprite.graphic != null) {
                sprite.revive();
                return sprite;
            }
        }
        return new FlxSprite();
    }
    
    static function returnToPool(sprite:FlxSprite) 
    {
        if (sprite != null) {
            sprite.kill();
            if (sprite.graphic != null) {
                sprite.graphic.bitmap.dispose();
                sprite.graphic.destroy();
            }
            spritePool.push(sprite);
        }
    }
    
    static function getSoundFromPool():FlxSound 
    {
        if (soundPool.length > 0) {
            var sound = soundPool.pop();
            sound.revive();
            return sound;
        }
        return new FlxSound();
    }
    
    static function returnToPoolSound(sound:FlxSound) 
    {
        if (sound != null) {
            sound.kill();
            soundPool.push(sound);
        }
    }
    
    function cleanupTransitionTweens()
    {
        for (tween in transitionTweens) {
            if (tween != null && tween.active) {
                tween.cancel();
            }
        }
        transitionTweens = [];
    }

    override function destroy()
    {
        cleanupTransitionTweens();
        
        // 清理声音资源
        if (FlxG.sound.music != null) {
            FlxG.sound.music.stop();
            FlxG.sound.music.destroy();
        }
        
        if (SoundGroup != null) {
            SoundGroup.destroy();
            SoundGroup = null;
        }
        
        // 清理显示对象
        var toDestroy = [backendPicture, recordPicture, oldBackendPicture, oldRecordPicture, audio];
        for (obj in toDestroy) {
            if (obj != null) {
                if (contains(obj)) remove(obj);
                obj.destroy();
            }
        }
        
        // 清理对象池
        for (sprite in spritePool) {
            sprite.destroy();
        }
        spritePool = [];
        
        for (sound in soundPool) {
            sound.destroy();
        }
        soundPool = [];
        
        // 其他清理
        if (circleMask != null) {
            circleMask.graphics.clear();
            circleMask = null;
        }
        
        super.destroy();
    }
}