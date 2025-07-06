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

	var camBack:FlxCamera;
	var camPic:FlxCamera;
	var camText:FlxCamera;
	var camHUD:FlxCamera;

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
	
	// 歌曲信息显示
	var songNameText:FlxText;
	var writerText:FlxText;

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
			FlxG.sound.music.onComplete = () -> nextSong();
		}
		
		// 保存旧元素以便淡出
		if (backendPicture != null) {
			oldBackendPicture = backendPicture;
			backendPicture = null;
		}
		
		if (recordPicture != null) {
			oldRecordPicture = recordPicture.clone();
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
			backendPicture.scale.x = backendPicture.scale.y = Math.min(FlxG.width / backendPicture.width, FlxG.height / backendPicture.height) + 0.1;

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

		// 如果recordImage为null但background不为null，则使用background作为唱片图片
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
		var actY = songNameText.y;
		if (songNameText != null) {
			Thread.create(() ->{
				FlxTween.tween(songNameText, {y: songNameText.y + maskRadius}, 1, {
					ease: FlxEase.quadIn,
					onComplete: function(_) {
						songNameText.text = songInfo.name != null ? songInfo.name : "?????";
						songNameText.updateHitbox();
						songNameText.screenCenter(X);
						songNameText.y = actY - maskRadius;
						FlxTween.tween(songNameText, {y: actY}, 1, {
							ease: FlxEase.backOut
						});
					}
				});
			});
			
		}
		if (writerText != null) {
			writerText.text = songInfo.writer != null ? songInfo.writer : "?????";
			writerText.screenCenter();
			writerText.updateHitbox();
		}
	}
		
	private function applyBlurFilter():Void {
		if (backendPicture != null) {
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

		super.create();

		// 初始化歌曲信息显示
		songNameText = new FlxText(0, FlxG.height - 80, FlxG.width, "", 24);
		songNameText.setFormat(Paths.font("montserrat.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songNameText.scrollFactor.set();
		songNameText.borderSize = 2;
		songNameText.cameras = [camText];
		add(songNameText);
		songNameText.screenCenter();
		
		writerText = new FlxText(0, FlxG.height - 50, FlxG.width, "", 16);
		writerText.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		writerText.scrollFactor.set();
		writerText.borderSize = 1.5;
		writerText.cameras = [camText];
		add(writerText);
		writerText.screenCenter();

		circleMask = new Shape();
		updateMask();

		// 初始化歌曲列表
		initSongsList();
		
		// 加载第一首歌曲
		if (SongsArray.length > 0) {
			loadSongs(SongsArray[0]);
		}
	}
	
	/**
	 * 初始化歌曲列表
	 */
	private function initSongsList():Void {
		// 示例歌曲，实际应用中可以从配置文件或其他来源加载
		SongsArray = [
			{
				name: "Game Over",
				sound: [Paths.music('gameOver')],
				background: [Paths.image('menuDesat')],
				record: null,
				backendVideo: null,
				bpm: 100,
				writer: "Kawai Sprite"
			},
			{
				name: "Freaky Menu",
				sound: [Paths.music('freakyMenu')],
				background: [Paths.image('menuBG')],
				record: [Paths.image('funkay')],
				backendVideo: null,
				bpm: 102,
				writer: "Kawai Sprite"
			},
			{
				name: "Tea Time",
				sound: [Paths.music('tea-time')],
				background: [Paths.image('menuBGBlue')],
				record: [Paths.image('newgrounds_logo')],
				backendVideo: null,
				bpm: 120,
				writer: "Kawai Sprite"
			}
		];
	}
	
	/**
	 * 切换到下一首歌曲
	 */
	private function nextSong():Void {
		if (SongsArray.length <= 1) return;
		
		currentSongIndex = (currentSongIndex + 1) % SongsArray.length;
		loadSongs(SongsArray[currentSongIndex]);
	}
	
	/**
	 * 切换到上一首歌曲
	 */
	private function prevSong():Void {
		if (SongsArray.length <= 1) return;
		
		currentSongIndex = (currentSongIndex - 1 + SongsArray.length) % SongsArray.length;
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
		
		// 清空歌曲数组
		SongsArray = [];
		
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateMask();

		// 键盘控制
		if (FlxG.keys.justPressed.LEFT || (virtualPad != null && virtualPad.buttonLeft.justPressed))
		{
			prevSong();
		}
		else if (FlxG.keys.justPressed.RIGHT || (virtualPad != null && virtualPad.buttonRight.justPressed))
		{
			nextSong();
		}
		
		// 旋转唱片
		if (recordPicture != null && !isTransitioning && enableRecordRotation)
		{
			recordPicture.angle += elapsed * 20; // 调整旋转速度
			if (recordPicture.angle >= 360) recordPicture.angle -= 360;
		}

		writerText.y = songNameText.y + songNameText.height + 10;
		
		// 测试按键 - 可以根据需要移除
		if (FlxG.keys.justPressed.A)
		{
			loadSongs(SongsArray[0]);
		}
		else if (FlxG.keys.justPressed.S)
		{
			loadSongs(SongsArray[1]);
		}
		else if (FlxG.keys.justPressed.D)
		{
			loadSongs(SongsArray[2]);
		}
		
		// 返回按钮
		if (FlxG.keys.justPressed.ESCAPE || (virtualPad != null && virtualPad.buttonB.justPressed))
		{
			close();
		}
	}
}