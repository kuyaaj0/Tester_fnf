package substates;

import objects.AudioDisplay.AudioCircleDisplay;

class RelaxSubState extends MusicBeatSubstate
{
	var camHUD:FlxCamera;

	public function new()
	{
		super();
        FlxG.state.persistentUpdate = false; // 停止更新state
	}

	override function create()
	{
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);

		FlxG.sound.playMusic(Paths.music('tea-time'));

		addVirtualPad(LEFT_RIGHT, A_B);
		virtualPad.cameras = [camHUD];

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG', null, false));
		bg.scrollFactor.set(0, 0);
		bg.scale.x = FlxG.width / bg.width;
		bg.scale.y = FlxG.height / bg.height;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var aa:AudioCircleDisplay = new AudioCircleDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 500, 500, 32, 4, FlxColor.WHITE, 100);
		add(aa);
		aa.alpha = 0.7;

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}