package states;

import states.MainMenuState;

class RelaxState extends MusicBeatState{
    public var camGame:FlxCamera;
    public var camRelax:FlxCamera;
    public var camHUD:FlxCamera;

    public function new() {
        super();
        
        camGame = initPsychCamera();

        camRelax = new FlxCamera();
        camHUD = new FlxCamera();

        camHUD.bgColor.alpha = 0;
        camRelax.bgColor.alpha = 0;

        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.add(camRelax, false);

		camRelax.alpha = 0;

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

        FlxTween.tween(camRelax, {alpha: 1}, 1, {ease: FlxEase.quadOut});
    }

    override function update(elapsed:Float) {
        if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
    }
}