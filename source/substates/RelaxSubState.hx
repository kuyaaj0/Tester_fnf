package substates;

import objects.AudioDisplay.AudioCircleDisplay;

import openfl.filters.BlurFilter;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

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
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

import sys.thread.Thread;

typedef SongInfo = {
	name: String, 							// 歌曲名称
	sound: Array<FlxSoundAsset>, 			// 音频资源
	background: Array<FlxGraphicAsset>, 	// 背景图像
	record: Array<FlxGraphicAsset>, 		// 唱片图像
	backendVideo: FlxGraphicAsset, 			// 背景视频
	bpm: Float, 							// 每分钟节拍数
	writer: String 							// 作曲家
};

class RelaxSubState extends MusicBeatSubstate
{
	public var SongsArray:Array<SongInfo> = [];
	private var currentSongIndex:Int = 0;
	private var pendingSongIndex:Int = -1;

	var camBack:FlxCamera;
	var camPic:FlxCamera;
	var camText:FlxCamera;
	var camHUD:FlxCamera;
	
	// BPM缩放相关变量
	private var currentBPM:Float = 100;
	private var beatTime:Float = 0.6; // 默认一拍时间（秒）
	private var beatTimer:Float = 0;
	private var defaultZoom:Float = 1.0;
	private var zoomIntensity:Float = 0.05; // 缩放强度
	public var enableBpmZoom:Bool = true; // 是否启用BPM缩放

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
	
	public var enableRecordRotation:Bool = true;
	public var bgBlur:Bool = false;
	
	var songNameText:FlxText;
	var writerText:FlxText;
	var songLengthText:FlxText;
	
	var songNameTween:FlxTween;

	var LeftButton:FlxSprite;
	var MiddleButton:FlxSprite;
	var RightButton:FlxSprite;

	public function new()
	{
		super();
        FlxG.state.persistentUpdate = false;
		FlxG.sound.music.stop();
	}

	/**
	 *	@param	songInfo	歌曲信息
	**/
	public function loadSongs(songInfo:SongInfo = null):Void {
		if (isTransitioning || songInfo == null) return;
		isTransitioning = true;
		
		// 预加载资源
		if (songInfo.background != null && songInfo.background.length > 0) {
			for (bg in songInfo.background) {
				Paths.image(bg);
			}
		}
		
		if (songInfo.record != null && songInfo.record.length > 0) {
			for (rec in songInfo.record) {
				Paths.image(rec);
			}
		}
		
		if (songInfo.sound != null && songInfo.sound.length > 0) {
			for (snd in songInfo.sound) {
				Paths.music(snd);
			}
		}
		
		// 停止当前音乐并播放新音乐
		FlxG.sound.music.stop();
		if (songInfo.sound != null && songInfo.sound.length > 0) {
			FlxG.sound.playMusic(songInfo.sound[0], 1);
			FlxG.sound.music.onComplete = () -> {
				// 歌曲结束时直接切换到下一首
				nextSong();
			};
			
			// 重置歌曲进度文本
			if (songLengthText != null) {
				songLengthText.text = "0:00 / 0:00";
				songLengthText.screenCenter(X);
			}
			
			// 更新中间按钮图标为暂停状态
			drawPlayPauseIcon(true);
		}
		
		// 保存旧元素以便淡出
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
		
		// 创建新元素
		var backgroundImage:FlxGraphicAsset = (songInfo.background != null && songInfo.background.length > 0) ? songInfo.background[0] : null;
		var recordImage:FlxGraphicAsset = (songInfo.record != null && songInfo.record.length > 0) ? songInfo.record[0] : null;
		
		createNewElements(backgroundImage, recordImage);
		applyBlurFilter();
		
		// 更新歌曲信息显示
		updateSongInfoDisplay(songInfo);
		
		var allComplete:Bool = false;
		var newElementsComplete:Bool = false;
		var oldElementsComplete:Bool = false;
		
		function checkAllComplete() {
			if (newElementsComplete && oldElementsComplete && !allComplete) {
				allComplete = true;
				isTransitioning = false;
				
				// 检查是否有待播放的歌曲
				if (pendingSongIndex != -1) {
					var indexToLoad = pendingSongIndex;
					pendingSongIndex = -1; // 重置待播放索引
					
					// 使用短延迟确保UI更新完成
					new FlxTimer().start(0.1, function(_) {
						if (indexToLoad >= 0 && indexToLoad < SongsArray.length) {
							currentSongIndex = indexToLoad;
							loadSongs(SongsArray[currentSongIndex]);
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
			backendPicture.scrollFactor.set(0, 0);
			backendPicture.scale.x = backendPicture.scale.y = Math.max(FlxG.width / backendPicture.width, FlxG.height / backendPicture.height) + 0.1;

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
		var actY = FlxG.height / 2;
		var animationDuration:Float = 0.5;
		
		// 设置当前歌曲的BPM
		currentBPM = songInfo.bpm > 0 ? songInfo.bpm : 100; // 使用有效BPM或默认值100
		beatTime = 60 / currentBPM; // 计算一拍的时间（秒）
		beatTimer = 0; // 重置节拍计时器
		
		if (songNameTween != null && songNameTween.active) {
			songNameTween.cancel();
			songNameTween = null;
		}

		if (songNameText != null) {
			songNameTween = FlxTween.tween(songNameText, {y: actY + maskRadius}, animationDuration, {
				ease: FlxEase.quadIn,
				onComplete: function(_) {
					songNameText.text = songInfo.name != null ? songInfo.name : "?????";

					if (writerText != null) {
						writerText.text = songInfo.writer != null ? songInfo.writer : "Unknown";
					}
					
					if (songLengthText != null && FlxG.sound.music != null) {
						var totalLength:Float = FlxG.sound.music.length / 1000;
						var minutes:Int = Math.floor(totalLength / 60);
						var seconds:Int = Math.floor(totalLength % 60);
						
						// 更新文本内容为"0:00 / 总时间"
						songLengthText.text = '0:00 / ${minutes}:${seconds < 10 ? "0" + seconds : Std.string(seconds)}';
						
						// 确保文本居中显示在中间按钮上
						songLengthText.x = MiddleButton.x + (MiddleButton.width - songLengthText.width) / 2;
						songLengthText.y = MiddleButton.y + (MiddleButton.height - songLengthText.height) / 2;
					}

					songNameText.updateHitbox();
					songNameText.screenCenter(X);
					songNameText.y = actY - maskRadius;
					
					songNameTween = FlxTween.tween(songNameText, {y: actY}, animationDuration, {
						ease: FlxEase.backOut
					});
				}
			});
		}
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
	
	override function create()
	{
		camBack = new FlxCamera();
		camPic = new FlxCamera();
		camText = new FlxCamera();
		camHUD = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		camPic.bgColor.alpha = 0;
		camText.bgColor.alpha = 0;
		camBack.bgColor.alpha = 0;

		FlxG.cameras.add(camBack, false);
		FlxG.cameras.add(camPic, false);
		FlxG.cameras.add(camText, false);
		FlxG.cameras.add(camHUD, false);
		
		// 设置相机默认缩放值
		defaultZoom = 1.0;
		camPic.zoom = defaultZoom;

		super.create();

		songNameText = new FlxText(0, FlxG.height / 2, FlxG.width, "", 24);
		songNameText.setFormat(Paths.font("montserrat.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songNameText.scrollFactor.set();
		songNameText.borderSize = 2;
		songNameText.cameras = [camText];
		songNameText.alpha = 1;
		add(songNameText);
		songNameText.screenCenter();
		
		writerText = new FlxText(0, songNameText.y + songNameText.height + 10, FlxG.width, "", 16);
		writerText.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		writerText.scrollFactor.set();
		writerText.borderSize = 1.5;
		writerText.cameras = [camText];
		writerText.alpha = 1;
		add(writerText);
		writerText.screenCenter(X);

		createButtons();
		
		// 创建歌曲进度文本并放在屏幕顶部
		songLengthText = new FlxText(0, 20, 0, "0:00 / 0:00", 16);
		songLengthText.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songLengthText.scrollFactor.set();
		songLengthText.borderSize = 2;
		songLengthText.cameras = [camHUD];
		songLengthText.alpha = 1;
		add(songLengthText);
		
		// 确保文本初始位置正确居中在屏幕顶部
		songLengthText.screenCenter(X);

		circleMask = new Shape();
		updateMask();

		initSongsList();
		
		// 初始化索引并加载第一首歌曲
		if (SongsArray.length > 0) {
			currentSongIndex = 0;
			pendingSongIndex = -1;
			loadSongs(SongsArray[0]);
		}
	}

	function createButtons(){
		var buttonHeight = 60; // 减小按钮高度
		var buttonSpacing = 15; // 按钮间距
	
		// 将按钮放在屏幕底部，留出一点边距
		var buttonY = FlxG.height - buttonHeight - 10; // 屏幕底部，上移10像素
	
		// 所有按钮宽度相同，更窄一些
		var buttonWidth = 100;
	
		// 计算按钮组的总宽度并居中
		var totalWidth = buttonWidth * 3 + buttonSpacing * 2;
		var startX = (FlxG.width - totalWidth) / 2;
	
		// 左边按钮尖尖朝左
		LeftButton = new ButtonSprite(startX, buttonY, buttonWidth, buttonHeight, 50, "left");
		LeftButton.scrollFactor.set(0, 0);
	
		// 中间按钮作为暂停/播放按钮
		MiddleButton = new FlxSprite(LeftButton.x + LeftButton.width + buttonSpacing, buttonY);
		MiddleButton.makeGraphic(buttonWidth, Std.int(buttonHeight), FlxColor.WHITE);
		MiddleButton.scrollFactor.set(0, 0);
	
		// 在中间按钮上绘制暂停/播放图标
		drawPlayPauseIcon(false); // 默认显示暂停图标

		// 右边按钮尖尖朝右
		RightButton = new ButtonSprite(MiddleButton.x + MiddleButton.width + buttonSpacing, buttonY, buttonWidth, buttonHeight, 50, "right");
		RightButton.scrollFactor.set(0, 0);

		add(LeftButton);
		add(MiddleButton);
		add(RightButton);
	
		LeftButton.cameras = [camHUD];
		MiddleButton.cameras = [camHUD];
		RightButton.cameras = [camHUD];
	
		// 启用像素完美点击检测
		LeftButton.pixelPerfectPosition = true;
		RightButton.pixelPerfectPosition = true;
		MiddleButton.pixelPerfectPosition = true;
	}

	// 绘制播放/暂停图标
	private function drawPlayPauseIcon(isPlaying:Bool):Void {
		if (MiddleButton == null) return;
	
		// 清除之前的图形
		MiddleButton.makeGraphic(Std.int(MiddleButton.width), Std.int(MiddleButton.height), FlxColor.WHITE, true);
	
		if (isPlaying) {
			// 绘制暂停图标（两个竖条）
			var iconWidth = 12;
			var iconHeight = 30;
			var spacing = 10;
			var startX = (MiddleButton.width - (iconWidth * 2 + spacing)) / 2;
			var startY = (MiddleButton.height - iconHeight) / 2;
		
			// 左侧竖条
			FlxSpriteUtil.drawRect(MiddleButton, startX, startY, iconWidth, iconHeight, FlxColor.BLACK);
		
			// 右侧竖条
			FlxSpriteUtil.drawRect(MiddleButton, startX + iconWidth + spacing, startY, iconWidth, iconHeight, FlxColor.BLACK);
		} else {
			// 绘制播放图标（三角形）
			var iconHeight = 30;
			var iconWidth = 25;
			var startX = (MiddleButton.width - iconWidth) / 2 + 5; // 稍微右移一点使视觉上居中
			var startY = (MiddleButton.height - iconHeight) / 2;
		
			var vertices:Array<FlxPoint> = [
				new FlxPoint(startX, startY),
				new FlxPoint(startX, startY + iconHeight),
				new FlxPoint(startX + iconWidth, startY + iconHeight/2)
			];
		
			FlxSpriteUtil.drawPolygon(MiddleButton, vertices, FlxColor.BLACK);
		}
	}
	
	private function initSongsList():Void {
		SongsArray = [
			{
				name: "Game Over",
				sound: [Paths.music('gameOver')],
				background: [Paths.image('menuDesat')],
				record: null,
				backendVideo: null,
				bpm: 50,
				writer: "Funkin Team"
			},
			{
				name: "Freaky Menu",
				sound: [Paths.music('freakyMenu')],
				background: [Paths.image('menuBG')],
				record: [Paths.image('funkay')],
				backendVideo: null,
				bpm: 50,
				writer: "Funkin Team"
			},
			{
				name: "Tea Time",
				sound: [Paths.music('tea-time')],
				background: [Paths.image('menuBGBlue')],
				record: [Paths.image('newgrounds_logo')],
				backendVideo: null,
				bpm: 53,
				writer: "Funkin Team"
			},
			{
				name: "Aimai Attitude",
				sound: ["assets/shared/Playlists/example/songs/Aimai-Attitude.ogg"],
				background: ["assets/shared/Playlists/example/art/Aimai-Attitude.png"],
				record: null,
				backendVideo: null,
				bpm: 200,
				writer: "rejection"
			}
		];
	}
	
	/**
	 * 切换到下一首歌曲
	 */
	private function nextSong():Void {
		if (SongsArray.length <= 1) return;
		
		var nextIndex = (currentSongIndex + 1) % SongsArray.length;
		
		if (isTransitioning) {
			// 如果正在过渡中，记录待播放的索引
			pendingSongIndex = nextIndex;
			return;
		}
		
		currentSongIndex = nextIndex;
		loadSongs(SongsArray[currentSongIndex]);
	}
	
	/**
	 * 切换到上一首歌曲
	 */
	private function prevSong():Void {
		if (SongsArray.length <= 1) return;
		
		var prevIndex = (currentSongIndex - 1 + SongsArray.length) % SongsArray.length;
		
		if (isTransitioning) {
			// 如果正在过渡中，记录待播放的索引
			pendingSongIndex = prevIndex;
			return;
		}
		
		currentSongIndex = prevIndex;
		loadSongs(SongsArray[currentSongIndex]);
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
		if (songNameTween != null && songNameTween.active) {
			songNameTween.cancel();
			songNameTween = null;
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
		
		if (circleMask != null) {
			circleMask = null;
		}
		
		if (songNameText != null) {
			songNameText.destroy();
			songNameText = null;
		}
		
		if (writerText != null) {
			writerText.destroy();
			writerText = null;
		}
		
		if (songLengthText != null) {
			songLengthText.destroy();
			songLengthText = null;
		}
		
		currentSongIndex = 0;
		pendingSongIndex = -1;
		SongsArray = [];
		
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateMask();

		writerText.y = songNameText.y + songNameText.height + 10;
		
		// 确保歌曲进度文本始终居中在中间按钮上
		songLengthText.x = MiddleButton.x + (MiddleButton.width - songLengthText.width) / 2;
		songLengthText.y = MiddleButton.y + (MiddleButton.height - songLengthText.height) / 2;
		
		// 实现基于BPM的相机缩放效果
		if (enableBpmZoom && FlxG.sound.music != null && FlxG.sound.music.playing) {
			beatTimer += elapsed;
			
			// 当达到一个节拍时
			if (beatTimer >= beatTime) {
				beatTimer -= beatTime; // 重置计时器，保留余数以保持精确同步
				
				// 瞬间放大然后缓动回原样
				var targetZoom = defaultZoom + zoomIntensity;
				camPic.zoom = targetZoom; // 瞬间放大
				FlxTween.tween(camPic, {zoom: defaultZoom}, beatTime * 0.5, {
					ease: FlxEase.quadOut
				});
			}
		}
		
					// 更新歌曲播放时间和总时间
					if (FlxG.sound.music != null) {
						var currentTime:Float = FlxG.sound.music.time / 1000; // 当前播放时间（秒）
						var totalTime:Float = FlxG.sound.music.length / 1000; // 总时间（秒）
	
						var currentMinutes:Int = Math.floor(currentTime / 60);
						var currentSeconds:Int = Math.floor(currentTime % 60);
						var totalMinutes:Int = Math.floor(totalTime / 60);
						var totalSeconds:Int = Math.floor(totalTime % 60);
	
						// 更新进度文本，显示当前时间/总时间
						songLengthText.text = '${currentMinutes}:${currentSeconds < 10 ? "0" + currentSeconds : Std.string(currentSeconds)} / ${totalMinutes}:${totalSeconds < 10 ? "0" + totalSeconds : Std.string(totalSeconds)}';
	
						// 将时间文本放在屏幕顶部中央
						songLengthText.x = (FlxG.width - songLengthText.width) / 2;
						songLengthText.y = 20; // 距离顶部20像素
					}

					// 确保按钮始终居中并位于屏幕底部
					var totalWidth = LeftButton.width + MiddleButton.width + RightButton.width + 30; // 30是总间距
					var startX = (FlxG.width - totalWidth) / 2;
					var buttonY = FlxG.height - LeftButton.height - 10; // 屏幕底部，上移10像素

					LeftButton.x = startX;
					MiddleButton.x = LeftButton.x + LeftButton.width + 15;
					RightButton.x = MiddleButton.x + MiddleButton.width + 15;

					LeftButton.y = buttonY;
					MiddleButton.y = buttonY;
					RightButton.y = buttonY;
		
					// 确保中间按钮显示正确的图标（播放/暂停）
					if (FlxG.sound.music != null) {
						drawPlayPauseIcon(FlxG.sound.music.playing);
					}

		// 键盘控制
		if (FlxG.keys.justPressed.LEFT) {
			prevSong();
		}
		else if (FlxG.keys.justPressed.RIGHT) {
			nextSong();
		}
		
		// 按钮交互控制
		var mousePos = FlxG.mouse.getScreenPosition(camHUD);
		var isOverLeft = LeftButton.overlapsPoint(mousePos, true, camHUD);
		var isOverMiddle = MiddleButton.overlapsPoint(mousePos, true, camHUD);
		var isOverRight = RightButton.overlapsPoint(mousePos, true, camHUD);
		
		// 悬停效果 - 所有按钮使用相同的悬停效果
		LeftButton.alpha = isOverLeft ? 0.8 : 1.0;
		MiddleButton.alpha = isOverMiddle ? 0.8 : 1.0;
		RightButton.alpha = isOverRight ? 0.8 : 1.0;
		
		// 点击效果
		if (FlxG.mouse.justPressed) {
			if (isOverLeft) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
				FlxTween.tween(LeftButton, {y: LeftButton.y + 5}, 0.1, {
					ease: FlxEase.quadOut,
					onComplete: function(_) FlxTween.tween(LeftButton, {y: LeftButton.y - 5}, 0.1)
				});
				prevSong();
			}
			else if (isOverMiddle && FlxG.sound.music != null) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
				FlxTween.tween(MiddleButton, {y: MiddleButton.y + 5}, 0.1, {
					ease: FlxEase.quadOut,
					onComplete: function(_) FlxTween.tween(MiddleButton, {y: MiddleButton.y - 5}, 0.1)
				});
				
				// 切换播放/暂停状态
				if (FlxG.sound.music.playing) {
					FlxG.sound.music.pause();
				} else {
					FlxG.sound.music.play();
				}
				
				// 更新图标
				drawPlayPauseIcon(FlxG.sound.music.playing);
			}
			else if (isOverRight) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
				FlxTween.tween(RightButton, {y: RightButton.y + 5}, 0.1, {
					ease: FlxEase.quadOut,
					onComplete: function(_) FlxTween.tween(RightButton, {y: RightButton.y - 5}, 0.1)
				});
				nextSong();
			}
		}
		
		if (recordPicture != null && !isTransitioning && enableRecordRotation)
		{
			recordPicture.angle += elapsed * 20;
			if (recordPicture.angle >= 360) recordPicture.angle -= 360;
		}

		if (FlxG.keys.justPressed.A)
		{
			if (!isTransitioning) {
				currentSongIndex = 0;
				loadSongs(SongsArray[0]);
			} else {
				pendingSongIndex = 0;
			}
		}
		else if (FlxG.keys.justPressed.S)
		{
			if (!isTransitioning && SongsArray.length > 1) {
				currentSongIndex = 1;
				loadSongs(SongsArray[1]);
			} else if (SongsArray.length > 1) {
				pendingSongIndex = 1;
			}
		}
		else if (FlxG.keys.justPressed.D)
		{
			if (!isTransitioning && SongsArray.length > 2) {
				currentSongIndex = 2;
				loadSongs(SongsArray[2]);
			} else if (SongsArray.length > 2) {
				pendingSongIndex = 2;
			}
		}

		// 切换BPM缩放效果
		if (FlxG.keys.justPressed.B)
		{
			enableBpmZoom = !enableBpmZoom;
			if (!enableBpmZoom) {
				// 如果禁用缩放效果，恢复默认缩放值
				camPic.zoom = defaultZoom;
			}
		}
		
		if (FlxG.keys.justPressed.ESCAPE || (virtualPad != null && virtualPad.buttonB.justPressed))
		{
			close();
		}
	}
}

class ButtonSprite extends FlxSprite
{
   /**
    * 创建一个梯形按钮
    * @param X 按钮X坐标
    * @param Y 按钮Y坐标
    * @param width 按钮宽度
    * @param height 按钮高度
    * @param shortSide 短边长度
    * @param direction 梯形方向
    */
   public function new(X:Float = 0, Y:Float = 0, width:Int = 100, height:Int = 50, shortSide:Int = 50, direction:String = "right")
    {
        super(X, Y);
        
        // 创建透明背景
        makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        
        // 计算斜边斜率
        var slope = (width - shortSide) / height;
        
        // 逐行绘制
        for (y in 0...height) {
            var startX:Int = 0;
            var endX:Int = width;
            
            if (direction == "right") {
                // 尖尖朝右
                endX = Std.int(width - slope * y);
                startX = 0;
            } else if (direction == "left") {
                // 尖尖朝左
                startX = Std.int(slope * y);
                endX = width;
            }
            
            // 绘制一行
            for (x in startX...endX) {
                pixels.setPixel32(x, y, FlxColor.WHITE);
            }
        }
    }
}