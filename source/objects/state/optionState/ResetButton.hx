package objects.state.optionState;

class ResetRect extends FlxSpriteGroup
{
	var rect:Rect;
	var follow:OptionCata;

	public function new(x:Float, y:Float, width:Float, height:Float)
	{
		super(x, y);

		rect = new Rect(0, 0, 550, 50, 20, 20);
		rect.color = 0x24232C;
		add(rect);

		var text = new FlxText(0, 0, 0, Language.get('Reset'), 25);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;
		text.y += rect.height / 2 - text.height / 2;
		text.x += rect.width / 2 - text.width / 2;
		add(text);

		this.follow = point;
	}

	public var onFocus:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (OptionsState.instance.avgSpeed > 0.1)
			return;

		onFocus = FlxG.mouse.overlaps(this);

		if (onFocus)
		{
			rect.color = 0x53b7ff;
			if (FlxG.mouse.justReleased)
				onClick();
		}
		else
		{
			rect.color = 0x24232C;
		}
	}

	function onClick()
	{
		follow.resetData();
	}
}