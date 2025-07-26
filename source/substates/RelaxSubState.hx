package substates;

import objects.AudioDisplay.AudioCircleDisplay;
import objects.state.relaxState.*;
import objects.state.relaxState.windows.PlayListWindow;
import objects.state.relaxState.windows.OptionWindow;

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
    
	public var SongsArray:SongLists = {
		name: "Unknown",
		list: []
	};
	private var currentSongIndex:Int = 0;
	private var pendingSongIndex:Int = -1;
	
	public var nowChoose:Array<Int> = [0,0];

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

	var maskRadius:Float = 150;
	var circleMask:Shape;
	
	var backendPicture:FlxSprite;
	var audio:AudioCircleDisplay;
	var recordPicture:FlxSprite;
	
	var oldBackendPicture:FlxSprite;
	var oldRecordPicture:FlxSprite;
	var oldAudio:AudioCircleDisplay;

	var transitionTime:Float = 0.5;
	var isTransitioning:Bool = false;
	
	public var controlButtons:ControlButtons;
	public var topButtons:TopButtons;
	public var backButtons:BackButtons;
	public var songInfoDisplay:SongInfoDisplay;
	
	public var LyricsMap:Map<Int, String> = new Map();
	public var songLyrics:FlxText;
	
	public var playListWindow:PlayListWindow;
	public var optionWindow:OptionWindow;
	
	var Sound1:FlxSound = new FlxSound();
	var Sound2:FlxSound = new FlxSound();
	
	var DebugText:FlxText;
	
	//options var
	public var enableBpmZoom:Bool = true; //启用唱片根据bpm zoom
	public var enableRecordRotation:Bool = true; //启用唱片旋转
	public var bgBlur:Bool = false; //启用背景高斯模糊
	public var NextSongs:String = "Next"; //播放下一个歌曲的方式 ["Next", "Restart", "Random"]
	

	public function new()
	{
		super();
        FlxG.state.persistentUpdate = false;
		FlxG.sound.music.stop();
	}
	
	public function inspectFile(NowInfo:SongInfo):Array<Dynamic>{
	    var result:Array<Dynamic> = [];
	    var error:String = " ";
	    if (NowInfo.sound != null && NowInfo.sound.length > 0){
	        for (i in NowInfo.sound){
	            if (!FileSystem.exists(i)){  //以防万一如果有一个歌曲不存在就终止加载
	                error += "can't find '" + i + "'\n";
	            }
	        }
	    }
	    
	    if (NowInfo.background != null && NowInfo.background.length > 0){
	        for (i in NowInfo.background){
	            if (!FileSystem.exists(i)){  //以防万一如果有一个背景不存在就终止加载
	                error += "can't find '" + i + "'\n";
	            }
	        }
	    }
	    
	    if (NowInfo.record != null && NowInfo.record.length > 0){
	        for (i in NowInfo.record){
	            if (!FileSystem.exists(i)){  //以防万一如果有一个曲绘唱片不存在就终止加载
	                error += "can't find '" + i + "'\n";
	            }
	        }
	    }
	    
	    result = [true, ""];
	    if (error != " ") result = [false, error];
	    
	    return result;
	}

	/**
	 *	@param	songInfo	歌曲信息
	**/
	public function loadSongs(songInfo:SongInfo = null):Void {
		if (isTransitioning || songInfo == null) return;
		var res:Array<Dynamic> = inspectFile(songInfo);
		if (!res[0]){
		    DebugText.text = res[1];
		    return;
		}
		
		isTransitioning = true;
		Sound1.destroy();
		Sound2.destroy();

		if (songInfo.sound != null && songInfo.sound.length > 0) {
            if (songInfo.sound.length > 1) {
                Sound1.loadEmbedded(songInfo.sound[1], false, true);
                Sound1.play();
            }
            
            if (songInfo.sound.length > 2) {
                Sound2.loadEmbedded(songInfo.sound[2], false, true);
                Sound2.play();
            }
        }
        
        LyricsMap = GetInit.getSongLyrics(songInfo)[0];
        songLyrics.font = GetInit.getSongLyrics(songInfo)[1];
		
		FlxG.sound.music.stop();
		if (songInfo.sound != null && songInfo.sound.length > 0) {
			FlxG.sound.playMusic(songInfo.sound[0], 1);
			
			FlxG.sound.music.onComplete = () -> {
			    switch(NextSongs){
			        case 'Next':
			            nextSong();
			        case 'Restart':
			            FlxG.sound.resume();
			        case 'Random':
			            var randomNum:Int = FlxG.random.int(0, SongsArray.list.length - 1);
			            loadSongs(SongsArray.list[randomNum]);
			            currentSongIndex = randomNum;
			    }
			};
			
			if (songInfoDisplay.songLengthText != null) {
				songInfoDisplay.songLengthText.text = "0:00 / 0:00";
				songInfoDisplay.songLengthText.screenCenter(X);
			}
		}
		
		if (backendPicture != null) {
			oldBackendPicture = backendPicture;
			backendPicture = null;
		}
		
		if (recordPicture != null) {
			oldRecordPicture = recordPicture;
			recordPicture = null;
		}
		
		if (audio != null) {
			oldAudio = audio;
			audio = null;
		}
		
		var backgroundImage:FlxGraphicAsset = (songInfo.background != null && songInfo.background.length > 0) ? songInfo.background[0] : null;
		var recordImage:FlxGraphicAsset = (songInfo.record != null && songInfo.record.length > 0) ? songInfo.record[0] : null;
		
		createNewElements(backgroundImage, recordImage);
		applyBlurFilter();
		
		updateSongInfoDisplay(songInfo);
		
		var allComplete:Bool = false;
		var newElementsComplete:Bool = false;
		var oldElementsComplete:Bool = false;
		
		function checkAllComplete() {
			if (newElementsComplete && oldElementsComplete && !allComplete) {
				allComplete = true;
				isTransitioning = false;
				
				if (pendingSongIndex != -1) {
					var indexToLoad = pendingSongIndex;
					pendingSongIndex = -1;
					
					new FlxTimer().start(0.1, function(_) {
						if (indexToLoad >= 0 && indexToLoad < SongsArray.list.length) {
							currentSongIndex = indexToLoad;
							loadSongs(SongsArray.list[currentSongIndex]);
						}
					});
				}
			}
		}
		
		fadeInNewElements(() -> {
			newElementsComplete = true;
			checkAllComplete();
		});
		
		fadeOutOldElements(() -> {
			oldElementsComplete = true;
			checkAllComplete();
		});
	}

	private function fadeOutOldElements(onComplete:Void->Void):Void {
		var tweenCount = 0;
		var totalTweens = 0;
		
		if (oldBackendPicture != null) totalTweens++;
		if (oldRecordPicture != null) totalTweens++;
		if (oldAudio != null) totalTweens++;
		
		if (totalTweens == 0) {
			onComplete();
			return;
		}
		
		function checkComplete() {
			tweenCount++;
			if (tweenCount >= totalTweens) {
				onComplete();
			}
		}
		
		if (oldBackendPicture != null) {
			FlxTween.tween(oldBackendPicture, {alpha: 0}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					remove(oldBackendPicture);
					oldBackendPicture.destroy();
					oldBackendPicture.kill();
					oldBackendPicture = null;
					checkComplete();
				}
			});
		}
		
		if (oldRecordPicture != null) {
			FlxTween.tween(oldRecordPicture, {alpha: 0, angle: 180}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					remove(oldRecordPicture);
					oldRecordPicture.destroy();
					oldRecordPicture.kill();
					oldRecordPicture = null;
					checkComplete();
				}
			});
		}
		
		if (oldAudio != null) {
			FlxTween.tween(oldAudio, {alpha: 0}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					remove(oldAudio);
					oldAudio.destroy();
					oldAudio = null;
					checkComplete();
				}
			});
		}
	}
	
	private function createNewElements(background:FlxGraphicAsset, recordImage:FlxGraphicAsset):Void {
		if (background != null) {
			backendPicture = new FlxSprite().loadGraphic(background);
			backendPicture.antialiasing = ClientPrefs.data.antialiasing;
			backendPicture.scale.set(1.1,1.1);
			backendPicture.updateHitbox();
			backendPicture.screenCenter();
			backendPicture.cameras = [camBack];
			backendPicture.alpha = 0;
			add(backendPicture);
		}

		audio = new AudioCircleDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 
									  500, 100, 46, 4, FlxColor.WHITE, 150);
		audio.alpha = 0;
		audio.cameras = [camBack];
		add(audio);

		var actualRecordImage:FlxGraphicAsset = recordImage;
		if (actualRecordImage == null && background != null) {
			actualRecordImage = background;
		}
		
		if (actualRecordImage != null) {
			recordPicture = new FlxSprite().loadGraphic(actualRecordImage);
			recordPicture.antialiasing = ClientPrefs.data.antialiasing;
			updatePictureScale();
			recordPicture.cameras = [camPic];
			recordPicture.alpha = 0;
			add(recordPicture);
		}
	}
	
	/**
	 * 更新歌曲信息显示
	 * @param songInfo 歌曲信息
	 */
	private function updateSongInfoDisplay(songInfo:SongInfo):Void {
		if (songInfo == null) return;
		
		currentBPM = songInfo.bpm > 0 ? songInfo.bpm : 100;
		beatTime = 60 / currentBPM;
		beatTimer = 0;
		
		songInfoDisplay.updateSongInfo(
			songInfo, 
			controlButtons.MiddleButton.x, 
			controlButtons.MiddleButton.y, 
			controlButtons.MiddleButton.width, 
			controlButtons.MiddleButton.height
		);
	}
		
	private function applyBlurFilter():Void {
		if (backendPicture != null && bgBlur) {
			var blurFilter:BlurFilter = new BlurFilter(10, 10, 1);
			var filterFrames = FlxFilterFrames.fromFrames(backendPicture.frames, 
														Std.int(backendPicture.width), 
														Std.int(backendPicture.height), 
														[blurFilter]);
			filterFrames.applyToSprite(backendPicture, false, true);
		}
	}
	
	private function fadeInNewElements(onComplete:Void->Void):Void {
		var tweenCount = 0;
		var totalTweens = 0;
		
		if (backendPicture != null) totalTweens++;
		if (recordPicture != null) totalTweens++;
		if (audio != null) totalTweens++;
		
		if (totalTweens == 0) {
			onComplete();
			return;
		}
		
		function checkComplete() {
			tweenCount++;
			if (tweenCount >= totalTweens) {
				onComplete();
			}
		}
		
		if (backendPicture != null) {
			FlxTween.tween(backendPicture, {alpha: 1}, transitionTime, {
				ease: FlxEase.quadOut,
				onComplete: function(_) checkComplete()
			});
		}
		
		if (recordPicture != null) {
			FlxTween.tween(recordPicture, {alpha: 1, angle: 360}, transitionTime, {
				ease: FlxEase.quadOut,
				onComplete: function(_) checkComplete()
			});
		}
		
		if (audio != null) {
			FlxTween.tween(audio, {alpha: 0.7}, transitionTime, {
				ease: FlxEase.quadOut,
				onComplete: function(_) checkComplete()
			});
		}
	}

	var topTrapezoid:FlxSprite;
	var hideTimer:Float = 0;
	var waitingToHide:Bool = false;
	var topTrapezoidTween:FlxTween = null;
	var isTweening:Bool = false;

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

	private function createTopButtons():Void {
		topButtons = new TopButtons();
		
		// 设置相机
		for (member in topButtons.members) {
			if (member != null) {
				member.cameras = [camOption];
			}
		}
		
		add(topButtons);
	}

	private function createBackButtons():Void {
		backButtons = new BackButtons();

		for (member in backButtons.members) {
			if (member != null) {
				member.cameras = [camVpad];
			}
		}
		
		add(backButtons);
		backButtons.y = FlxG.height - backButtons.height;

		backButtons.back = function() {
		    Sound1.destroy();
		    Sound2.destroy();
		    FlxG.sound.playMusic(Paths.music('freakyMenu'));
			close();
		}
	}

	override function create()
	{
	    instance = this;
		camBack = new FlxCamera();
		camPic = new FlxCamera();
		camText = new FlxCamera();
		camHUD = new FlxCamera();
		camVpad = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		camPic.bgColor.alpha = 0;
		camText.bgColor.alpha = 0;
		camBack.bgColor.alpha = 0;
		camVpad.bgColor.alpha = 0;

		camOption = new FlxCamera();
		camOption.bgColor.alpha = 0;
		camOption.y = 0;

		FlxG.cameras.add(camBack, false);
		FlxG.cameras.add(camPic, false);
		FlxG.cameras.add(camText, false);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOption, false);
		FlxG.cameras.add(camVpad, false);
		
		//virtualPad.cameras = [camVpad];

		topTrapezoid = new FlxSprite();
		drawTrapezoid(FlxG.width * 0.7, 40);
		topTrapezoid.y = 0;
		topTrapezoid.x = (FlxG.width - topTrapezoid.width) / 2;
		topTrapezoid.scrollFactor.set();
		topTrapezoid.cameras = [camOption];
		add(topTrapezoid);
		camOption.y = -topTrapezoid.height;

		createTopButtons();
		createBackButtons();
		
		defaultZoom = 1.0;
		camPic.zoom = defaultZoom;

		super.create();

		createButtons();

		// 创建歌曲信息显示
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
		
		songLyrics = new FlxText(0, 0, FlxG.width, 'lyrics', 25);
		songLyrics.setFormat(Paths.font('Lang-ZH.ttf'), 25, FlxColor.WHITE, CENTER);
		add(songLyrics);
		songLyrics.cameras = [camHUD];
		
		songLyrics.y = 40;
		
		if (SongsArray.list.length > 0) {
			currentSongIndex = 0;
			pendingSongIndex = -1;
			loadSongs(SongsArray.list[0]);
		}
		
		playListWindow = new PlayListWindow();
		for (i in playListWindow.members){
		    i.cameras = [camOption];
		}
		add(playListWindow);
		
		optionWindow = new OptionWindow();
		for (i in optionWindow.members){
		    i.cameras = [camOption];
		}
		add(optionWindow);
		
	    DebugText = new FlxText(0, 0, FlxG.width, SongsArray.name, 25);
		DebugText.font = Paths.font('Lang-ZH.ttf');
		add(DebugText);
		DebugText.cameras = [camHUD];
	}

	function createButtons(){
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

	override function destroy()
	{
		if (songInfoDisplay.songNameTween != null && songInfoDisplay.songNameTween.active) {
			songInfoDisplay.songNameTween.cancel();
			songInfoDisplay.songNameTween = null;
		}
		
		if (topTrapezoidTween != null && topTrapezoidTween.active) {
			topTrapezoidTween.cancel();
			topTrapezoidTween = null;
		}
		
		if (backendPicture != null) {
			backendPicture.destroy();
			backendPicture = null;
		}
		
		if (recordPicture != null) {
			recordPicture.destroy();
			recordPicture = null;
		}
		
		if (audio != null) {
			audio.destroy();
			audio = null;
		}
		
		if (oldBackendPicture != null) {
			oldBackendPicture.destroy();
			oldBackendPicture = null;
		}
		
		if (oldRecordPicture != null) {
			oldRecordPicture.destroy();
			oldRecordPicture = null;
		}
		
		if (oldAudio != null) {
			oldAudio.destroy();
			oldAudio = null;
		}
		
		if (controlButtons != null) {
			controlButtons.destroy();
			controlButtons = null;
		}
		
		if (topButtons != null) {
			topButtons.destroy();
			topButtons = null;
		}
		
		if (songInfoDisplay != null) {
			songInfoDisplay.destroy();
			songInfoDisplay = null;
		}
		
		if (circleMask != null) {
			circleMask = null;
		}
		
		if (topTrapezoid != null) {
			topTrapezoid.destroy();
			topTrapezoid = null;
		}

		currentSongIndex = 0;
		pendingSongIndex = -1;
		SongsArray = {
			name: "Unknown",
			list: []
		};
		
		super.destroy();
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
	
	var bgFollowSmooth:Float = 0.2;

	var clickList:Bool = false;
	var clickOption:Bool = false;
	var clickLock:Bool = false;
	
	var lastLyrics:String = '';
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateMask();
		
		if (backendPicture != null && !isTransitioning) {
			var mouseX = FlxG.mouse.getScreenPosition(camHUD).x;
			var mouseY = FlxG.mouse.getScreenPosition(camHUD).y;
			var centerX = FlxG.width / 2;
			var centerY = FlxG.height / 2;
			
			var targetOffsetX = (mouseX - centerX) * 0.01;
			var targetOffsetY = (mouseY - centerY) * 0.01;
			
			var currentOffsetX = backendPicture.x - (centerX - backendPicture.width / 2);
			var currentOffsetY = backendPicture.y - (centerY - backendPicture.height / 2);
			
			var smoothX = FlxMath.lerp(currentOffsetX, targetOffsetX, bgFollowSmooth);
			var smoothY = FlxMath.lerp(currentOffsetY, targetOffsetY, bgFollowSmooth);
			
			backendPicture.x = centerX - backendPicture.width / 2 + smoothX;
			backendPicture.y = centerY - backendPicture.height / 2 + smoothY;
		}

		var mousePos = FlxG.mouse.getScreenPosition(camHUD);
		var nearTop = mousePos.y < 50;
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
			
			//我李奶奶的腿要是haxe的毫秒运算能够非常精确那我就不用大费周章了
			//把所有时间戳排序，并读取当前时间戳小且最接近的歌词
            var sortedTimestamps:Array<Int> = [];
            if (LyricsMap != null) {
                sortedTimestamps = [for (time in LyricsMap.keys()) time];
                sortedTimestamps.sort((a, b) -> a - b); // 升序排序
            }
            
            var currentLyric:String = "";
            if (LyricsMap != null && sortedTimestamps.length > 0) {
                var currentTime:Int = Std.int(FlxG.sound.music.time);
                var lastValidTime:Int = -1;
            
                for (time in sortedTimestamps) {
                    if (time <= currentTime) {
                        lastValidTime = time;
                    } else {
                        break;
                    }
                }

                if (lastValidTime != -1) {
                    currentLyric = LyricsMap.get(lastValidTime);
                }
            }
            
            if (currentLyric != lastLyrics) {
                lastLyrics = currentLyric;
                songLyrics.text = currentLyric;
            }
            
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
		
		var mousePos = FlxG.mouse.getScreenPosition(camHUD);
		var isOverLeft = controlButtons.isMouseOverLeftButton(mousePos);
		var isOverMiddle = controlButtons.isMouseOverMiddleButton(mousePos);
		var isOverRight = controlButtons.isMouseOverRightButton(mousePos);

		var isOverList = topButtons.isMouseOverListButton(mousePos);
		var isOverSetting = topButtons.isMouseOverSettingButton(mousePos);
		var isOverRock = topButtons.isMouseOverLockButton(mousePos);
		
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
					Sound1.pause();
					Sound2.pause();
				} else {
					FlxG.sound.music.play();
					Sound1.play();
					Sound2.play();
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
					optionWindow.Hidding = true;
					playListWindow.toggle();
			}
			else if (isOverSetting) {
				clickOption = !clickOption;
				if (clickList && clickOption)
					clickList = !clickOption;
					playListWindow.Hidding = false;
					playListWindow.hide();
					
					optionWindow.Hidding = false;
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
		    Sound1.destroy();
		    Sound2.destroy();
		    FlxG.sound.playMusic(Paths.music('freakyMenu'));
			close();
		}
	}

	var beatTimess:Int = 0;
	var helpBool:Bool = false;

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
		/*
		if(helpBool){
			Main.watermark.scaleX = ClientPrefs.data.WatermarkScale + 0.1;
			Main.watermark.scaleY = ClientPrefs.data.WatermarkScale - 0.1;
		}else{
			Main.watermark.scaleX = ClientPrefs.data.WatermarkScale - 0.1;
			Main.watermark.scaleY = ClientPrefs.data.WatermarkScale + 0.1;
		} //XD
		
		FlxTween.tween(Main.watermark, {scaleX: ClientPrefs.data.WatermarkScale, scaleY: ClientPrefs.data.WatermarkScale}, beatTime * 0.5, {
			ease: FlxEase.quadOut
		});
		*/
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
    	        pendingSongIndex = 0;
    	    }else{
    	        pendingSongIndex = data[1] + 1;
    	    }
    	    nowChoose = data;
    	    currentSongIndex = data[1];
    	    
    	    loadSongs(SongsArray.list[data[1]]);
	    }
	}
}