package objects.state.freeplayState;

class MusicRect extends FlxSpriteGroup
{
	var bg:Rect;
	var display:FlxText;

	public function new(X:Float, Y:Float, text:String)
	{
		super(X, Y);

		bg = new Rect(0, 0, 60, 20, 20, 20, FlxColor.WHITE, 0.3);
		add(bg);

		display = new FlxText(0, 0, 0, text, 15);
		display.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		display.antialiasing = ClientPrefs.data.antialiasing;
		add(display);
		display.x += bg.width / 2 - display.width / 2;
		display.y += bg.height / 2 - display.height / 2;
	}

	var fouced:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (FlxG.mouse.overlaps(bg))
		{
			if (!fouced)
			{
				fouced = true;
				bg.alpha = 1;
				display.color = 0x000000;
			}
		}
		else
		{
			if (fouced)
			{
				fouced = false;
				bg.alpha = 0.3;
				display.color = 0xffffff;
			}
		}
	}
}
