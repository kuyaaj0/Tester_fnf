package states;

import states.MainMenuState;
import flixel.sound.FlxSound;


class RelaxState extends MusicBeatState{
    public var camRelax:FlxCamera;
    public var camHUD:FlxCamera;

    public function new() {
        super();
	camRelax = new FlxCamera();
        camHUD = new FlxCamera();

        camHUD.bgColor.alpha = 0;
        camRelax.bgColor.alpha = 0;

        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.add(camRelax, false);
    }

    override function create(){
	super.create();

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
	bg.cameras = [camRelax];

        var aa:AudioDisplay = new AudioDisplay(FlxG.sound.music, 100, 100, 500, 250, 16, 4, FlxColor.WHITE);
	add(aa);
	    
        aa.cameras = [camRelax];
	aa.alpha = 0.7;
    }

    override function update(elapsed:Float) {
	super.update(elapsed);
        if (controls.BACK)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		MusicBeatState.switchState(new MainMenuState());
	}
    }
}
