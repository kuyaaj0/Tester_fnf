package substates;

import objects.AudioDisplay.AudioCircleDisplay;

import openfl.filters.BlurFilter;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Graphics;

import flixel.graphics.frames.FlxFilterFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;

class RelaxSubState extends MusicBeatSubstate
{
	var camBack:FlxCamera;
	var camPic:FlxCamera;
	var camHUD:FlxCamera;
	
	// 添加变量控制遮罩大小
	var maskRadius:Float = 150; // 初始遮罩半径
	var circleMask:Shape; // 存储遮罩引用以便更新
	var picture:FlxSprite; // 存储图片引用以便更新

	public function new()
	{
		super();
        FlxG.state.persistentUpdate = false; // 停止更新state
	}

	override function create()
	{
		picture = new FlxSprite().loadGraphic(Paths.image('menuBG', null, false));

		camBack = new FlxCamera();
		camPic = new FlxCamera();
		camHUD = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		camPic.bgColor.alpha = 0;
		camBack.bgColor.alpha = 0;
		
		// 初始化遮罩半径为相机宽度的一半（或更小值）
		maskRadius = Math.min(maskRadius, Math.min(camPic.width, camPic.height) / 2);
		
		// 创建圆形遮罩
		circleMask = new Shape();
		updateMask(); // 创建并更新遮罩
		
		// 应用遮罩到相机
		camPic.flashSprite.mask = circleMask;

		FlxG.cameras.add(camBack, false);
		FlxG.cameras.add(camPic, false);
		FlxG.cameras.add(camHUD, false);

		FlxG.sound.playMusic(Paths.music('tea-time'));

		addVirtualPad(LEFT_RIGHT, A_B);
		virtualPad.cameras = [camHUD];

		var bg:FlxSprite = picture.clone();
		bg.cameras = [camBack];
		bg.scrollFactor.set(0, 0);
		bg.scale.x = FlxG.width / bg.width;
		bg.scale.y = FlxG.height / bg.height;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var blurFilter:BlurFilter = new BlurFilter(10, 10, 1);
		var filterFrames = FlxFilterFrames.fromFrames(bg.frames, Std.int(bg.width), Std.int(bg.height), [blurFilter]);
		filterFrames.applyToSprite(bg, false, true);
		bg.alpha = 0;

		FlxTween.tween(bg, {alpha: 1}, 1, {ease: FlxEase.quadInOut});

		var aa:AudioCircleDisplay = new AudioCircleDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 500, 100, 46, 4, FlxColor.WHITE, 150);
		add(aa);
		aa.alpha = 0.7;
		aa.cameras = [camBack];

		picture.antialiasing = ClientPrefs.data.antialiasing;
		updatePictureScale();
		add(picture);
		picture.cameras = [camPic];

		super.create();
	}
	
	/**
	 * 更新遮罩大小和位置
	 */
	private function updateMask():Void
	{
		// 清除旧的绘图
		circleMask.graphics.clear();
		
		// 重新绘制圆形
		circleMask.graphics.beginFill(0xFFFFFF);
		circleMask.graphics.drawCircle(camPic.width / 2, camPic.height / 2, maskRadius);
		circleMask.graphics.endFill();
		
		// 确保遮罩位于相机中心
		var maxRadius:Float = Math.min(camPic.width, camPic.height) / 2;
		maskRadius = Math.min(maskRadius, maxRadius); // 确保遮罩不会超出相机边界
	}
	
	/**
	 * 更新图片缩放，确保等比例缩放且至少有两边对齐
	 */
	private function updatePictureScale():Void
	{
		// 计算图片需要的缩放比例，确保至少覆盖整个遮罩区域
		var scaleX:Float = (maskRadius * 2) / picture.width;
		var scaleY:Float = (maskRadius * 2) / picture.height;
		var scale:Float = Math.max(scaleX, scaleY); // 取较大的缩放比例，确保完全覆盖
		
		picture.scale.set(scale, scale); // 等比例缩放
		picture.updateHitbox();
		picture.screenCenter(); // 居中显示
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}