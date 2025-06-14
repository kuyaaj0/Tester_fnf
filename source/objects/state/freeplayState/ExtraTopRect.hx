package objects.state.freeplayState;

class ExtraTopRect extends FlxSpriteGroup
{
	var background:FlxSprite;
	var text:FlxText;

	var saveColor:FlxColor;

	public var onClick:Void->Void = null;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundSize:Float = 0, roundLeft:Bool = true, texts:String = '',
			textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
	{
		super(X, Y);

		text = new FlxText(textOffset, 0, 0, texts, 17);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;

		background = new FlxSprite(0, 0);
		background.pixels = drawRect(width, height, roundSize, roundLeft);
		background.alpha = 0.4;
		background.color = color;
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);
		add(text);

		text.x += background.width / 2 - text.width / 2;
		text.y += background.height / 2 - text.height / 2;

		this.onClick = onClick;
		this.saveColor = color;
	}

	function drawRect(width:Float, height:Float, roundSize:Float, roundLeft:Bool):BitmapData
	{
		var shape:Shape = new Shape();

		shape.graphics.beginFill(0xFFFFFFFF);
		shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
		if (roundLeft)
			shape.graphics.drawRoundRectComplex(0, 0, width, height, roundSize, 0, 0, 0);
		else
			shape.graphics.drawRoundRectComplex(0, 0, width, height, 0, roundSize, 0, 0);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;

	var needFocusCheck:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (!ignoreCheck)
			onFocus = FlxG.mouse.overlaps(this);

		if (onFocus && onClick != null && FlxG.mouse.justReleased)
			onClick();

		if (onFocus)
		{
			text.color = FlxColor.BLACK;
			background.color = FlxColor.WHITE;
			background.alpha = 0.4;
			needFocusCheck = true;
		}
		else
		{
			if (needFocusCheck)
			{
				text.color = FlxColor.WHITE;
				background.alpha = 0.4;
				background.color = saveColor;
				needFocusCheck = false;
			}
		}
	}
}
