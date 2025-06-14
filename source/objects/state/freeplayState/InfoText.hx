package objects.state.freeplayState;

class InfoText extends FlxSpriteGroup // freeplay info
{
	public var data(default, set):Float = -9999;
	public var maxData:Float = 0;

	var BlackBG:Rect;
	var WhiteBG:Rect;
	var dataText:FlxText;

	public function new(X:Float, Y:Float, texts:String, maxData:Float)
	{
		super(X, Y);

		this.maxData = maxData;

		var text:FlxText = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;
		add(text);

		BlackBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5, FlxColor.WHITE, 0.6);
		add(BlackBG);

		WhiteBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5);
		add(WhiteBG);

		dataText = new FlxText(490, 0, 0, Std.string(data), 18);
		dataText.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		dataText.antialiasing = ClientPrefs.data.antialiasing;
		add(dataText);

		data = 0;
		antialiasing = ClientPrefs.data.antialiasing;
	}

	private function set_data(value:Float):Float
	{
		if (data == value)
			return data;
		data = value;
		dataText.text = Std.string(data);
		return value;
	}

	override function update(elapsed:Float)
	{
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) > 0.01)
		{
			if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) < 0.005)
				WhiteBG._frame.frame.width = Std.int(WhiteBG.width * (data / maxData));
			else
				WhiteBG._frame.frame.width = Std.int(WhiteBG.width * FlxMath.lerp((data / maxData), (WhiteBG._frame.frame.width / WhiteBG.width),
					Math.exp(-elapsed * 15)));
			WhiteBG.updateHitbox();
		}
		if (WhiteBG._frame.frame.width >= WhiteBG.width)
		{
			WhiteBG._frame.frame.width = WhiteBG.width;
		}
		super.update(elapsed);
	}
}
