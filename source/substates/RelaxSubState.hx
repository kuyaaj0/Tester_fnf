package substates;

import states.MainMenuState;

class RelaxState extends MusicBeatSubstate{
    public var camRelax:FlxCamera;
    public var camHUD:FlxCamera;

    public function new() {
        super();
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        

        camRelax = new FlxCamera();
        camHUD = new FlxCamera();

        camHUD.bgColor.alpha = 0;
        camRelax.bgColor.alpha = 0;

        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.add(camRelax, false);

		camRelax.alpha = 0;
    }

    override function create(){
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
		bg.cameras = [camRelax];

        var test:AudioDisplay = new AudioDisplay(FlxG.sound.music, 0, FlxG.height, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.WHITE);
		add(test);
		test.alpha = 0.7;
        test.cameras = [camRelax];

        FlxTween.tween(camRelax, {alpha: 1}, 1, {ease: FlxEase.quadOut});

        if (FlxG.sound.music != null) FlxG.sound.music.stop();

        FlxTimer.wait(3, () -> {
            FlxG.sound.playMusic(Paths.sound('freakyMenu'));
        });

        FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.7, {ease: FlxEase.quadOut});
    }

    override function update(elapsed:Float) {
        if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
    }
}