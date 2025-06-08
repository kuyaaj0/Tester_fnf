package states;

import states.MainMenuState;
import flixel.sound.FlxSound;


class RelaxState extends MusicBeatState{
    public function new() {
        super();
    }

    override function create(){
	super.create();

        FlxG.sound.playMusic(Paths.music('tea-time'));
	    
        addVirtualPad(LEFT_RIGHT, A_B);
        
	var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG', null, false));
	bg.scrollFactor.set(0, 0);
	bg.scale.x = FlxG.width / bg.width;
	bg.scale.y = FlxG.height / bg.height;
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = ClientPrefs.data.antialiasing;
	add(bg);

        var aa:AudioDisplay = new AudioDisplay(FlxG.sound.music, 50, FlxG.height, 500, 250, 32, 4, FlxColor.WHITE);
	add(aa);
	aa.alpha = 0.7;
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
