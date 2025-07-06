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

class RelaxSubState extends MusicBeatSubstate
{
	var camBack:FlxCamera;
	var camPic:FlxCamera;
	var camHUD:FlxCamera;

	var maskRadius:Float = 150;
	var circleMask:Shape;
	
	var backendPicture:FlxSprite;
	var audio:AudioCircleDisplay;
	var recordPicture:FlxSprite;
	
	var oldBackendPicture:FlxSprite;
	var oldRecordPicture:FlxSprite;
	var oldAudio:AudioCircleDisplay;

	var autoChangeTimer:FlxTimer;
	var enableAutoChange:Bool = true;
	var transitionTime:Float = 0.5;
	var autoChangeDelay:Float = 10;

	public function new()
	{
		super();
        FlxG.state.persistentUpdate = false;
		FlxG.sound.music.stop();
	}

	/**
	 *	@param	sound		音频路径/Openfl的Sound/一个嵌入的Sound类引用
	 *	@param	background	背景图片
	 *  @param	looped		是否循环播放
	 *	@param	record		唱片背景图片（可选）
	 *  @param	autoChange	是否自动切换到下一首（默认为true）
	**/
	public function loadSongs(sound:FlxSoundAsset, background:FlxGraphicAsset, looped:Bool = false, record:FlxGraphicAsset = null, autoChange:Bool = true) {
		var thread = Thread.create(() ->
		{
			if (autoChangeTimer != null) {
				autoChangeTimer.cancel();
				autoChangeTimer.destroy();
				autoChangeTimer = null;
			}
			
			enableAutoChange = autoChange;
			FlxG.sound.playMusic(sound, 1, looped);

			fadeOutOldElements();
			createNewElements(background, record != null ? record : background);
			applyBlurFilter();
			fadeInNewElements();
			
			if (enableAutoChange) {
				autoChangeTimer = new FlxTimer().start(autoChangeDelay, 
					(_) -> loadSongs(Paths.music('freakyMenu'), Paths.image('funkay'), true));
			}
		});
	}

	private function fadeOutOldElements():Void {
		if (backendPicture != null) {
			oldBackendPicture = backendPicture;
			FlxTween.tween(oldBackendPicture, {alpha: 0}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					if (oldBackendPicture != null) {
						remove(oldBackendPicture);
						oldBackendPicture.destroy();
						oldBackendPicture = null;
					}
				}
			});
		}
		
		if (recordPicture != null) {
			oldRecordPicture = recordPicture;
			FlxTween.tween(oldRecordPicture, {alpha: 0, angle: 180}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					if (oldRecordPicture != null) {
						remove(oldRecordPicture);
						oldRecordPicture.destroy();
						oldRecordPicture = null;
					}
				}
			});
		}
		
		if (audio != null) {
			oldAudio = audio;
			FlxTween.tween(oldAudio, {alpha: 0}, transitionTime, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween) {
					if (oldAudio != null) {
						remove(oldAudio);
						oldAudio.destroy();
						oldAudio = null;
					}
				}
			});
		}
	}
	
	private function createNewElements(background:FlxGraphicAsset, recordImage:FlxGraphicAsset):Void {
		backendPicture = new FlxSprite().loadGraphic(background);
		backendPicture.antialiasing = ClientPrefs.data.antialiasing;
		backendPicture.scrollFactor.set(0, 0);
		backendPicture.scale.x = FlxG.width / backendPicture.width;
		backendPicture.scale.y = FlxG.height / backendPicture.height;
		backendPicture.updateHitbox();
		backendPicture.screenCenter();
		backendPicture.cameras = [camBack];
		backendPicture.alpha = 0;
		add(backendPicture);

		audio = new AudioCircleDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 
									  500, 100, 46, 4, FlxColor.WHITE, 150);
		audio.alpha = 0;
		audio.cameras = [camBack];
		add(audio);

		recordPicture = new FlxSprite().loadGraphic(recordImage);
		recordPicture.antialiasing = ClientPrefs.data.antialiasing;
		updatePictureScale();
		recordPicture.cameras = [camPic];
		recordPicture.alpha = 0;
		add(recordPicture);
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
	
	private function fadeInNewElements():Void {
		if (backendPicture != null) {
			FlxTween.tween(backendPicture, {alpha: 1}, transitionTime, {ease: FlxEase.quadOut});
		}
		
		if (recordPicture != null) {
			FlxTween.tween(recordPicture, {alpha: 1, angle: 360}, transitionTime, {ease: FlxEase.quadOut});
		}
		
		if (audio != null) {
			FlxTween.tween(audio, {alpha: 0.7}, transitionTime, {ease: FlxEase.quadOut});
		}
	}
	
	override function create()
	{
		camBack = new FlxCamera();
		camPic = new FlxCamera();
		camHUD = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		camPic.bgColor.alpha = 0;
		camBack.bgColor.alpha = 0;

		FlxG.cameras.add(camBack, false);
		FlxG.cameras.add(camPic, false);
		FlxG.cameras.add(camHUD, false);

		addVirtualPad(LEFT_RIGHT, A_B);
		virtualPad.cameras = [camHUD];

		super.create();

		circleMask = new Shape();
		updateMask();

		loadSongs(Paths.music('gameOver'), Paths.image('menuDesat'), true);
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
		if (autoChangeTimer != null) {
			autoChangeTimer.cancel();
			autoChangeTimer.destroy();
			autoChangeTimer = null;
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
		
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateMask();
	}
}