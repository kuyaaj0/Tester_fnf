package states;

import states.MainMenuState;
import flixel.sound.FlxSound;


class RelaxState extends MusicBeatState{
    var camGame:FlxCamera;
    var camHUD:FlxCamera;
    public function new() {
        super();
	camGame = initPsychCamera();
    }

    override function create(){

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

        var aa:AudioDisplay = new AudioDisplay(FlxG.sound.music, FlxG.width / 2, FlxG.height / 2, 500, 500, 32, 4, FlxColor.WHITE, true);
	add(aa);
	aa.alpha = 0.7;

	super.create();
    }

    override function update(elapsed:Float) {
        if (controls.BACK)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		MusicBeatState.switchState(new MainMenuState());
	}
	super.update(elapsed);
    }
}
