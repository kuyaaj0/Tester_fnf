package objects.state.optionState.backend;

class StateButton extends FlxSpriteGroup{
    public var bg:Rect;
	var stateName:FlxText;

    var follow:Option;

	public function new(width:Float, height:Float, follow:Option)
	{
        super(); //直接跟随option的x和y
        this.follow = follow;

		bg = new Rect(0, 0, width, height, width / 75, width / 75, EngineSet.mainColor, 0.5);
		add(bg);

		stateName = new FlxText(0, 0, 0, follow.description, Std.int(bg.width / 20));
		stateName.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(bg.width / 20), 0xffffff, CENTER, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        stateName.antialiasing = ClientPrefs.data.antialiasing;
		stateName.borderStyle = NONE;
		stateName.x += (bg.width - stateName.width) / 2;
        stateName.y += (bg.height - stateName.height) / 2;
		stateName.alpha = 0.8;
		stateName.blend = ADD;
		stateName.active = false;
		add(stateName);
	}
}