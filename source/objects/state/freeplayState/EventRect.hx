package objects.state.freeplayState;

class EventRect extends FlxSpriteGroup // freeplay bottom bg rect
{
	public var background:FlxSprite;

	var text:FlxText;

	public var onClick:Void->Void = null;

	var _y:Float = 0;

	public function new(X:Float, Y:Float, texts:String, color:FlxColor, onClick:Void->Void = null, specialCheck:Bool = false)
	{
		super(X, Y);

		text = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;

		background = new FlxSprite().loadGraphic(drawRect(text.width + 60));
		background.color = color;
		background.alpha = 0.5;
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);
		add(text);

		var touchFix:Rect = new Rect(0, 0, (text.width + 60), FlxG.height * 0.1, 0, 0, FlxColor.WHITE, 0);
		add(touchFix);

		text.x += background.width / 2 - text.width / 2;
		text.y += FlxG.height * 0.1 / 2 - text.height / 2;

		_y = Y;
		this.onClick = onClick;
		this.specialCheck = specialCheck;
	}

	function drawRect(width:Float):BitmapData
	{
		var shape:Shape = new Shape();

		var p1:Point = new Point(2, 0);
		var p2:Point = new Point(width + 2, 0);
		var p3:Point = new Point(width, 5);
		var p4:Point = new Point(0, 5);

		shape.graphics.beginFill(0xFFFFFFFF);
		shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
		shape.graphics.moveTo(p1.x, p1.y);
		shape.graphics.lineTo(p2.x, p2.y);
		shape.graphics.lineTo(p3.x, p3.y);
		shape.graphics.lineTo(p4.x, p4.y);
		shape.graphics.lineTo(p1.x, p1.y);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(p2.x), 5, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;

	private var _needACheck:Bool = false;
	var specialCheck = false;

	public function posUpdate(elapsed:Float)
	{
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (!ignoreCheck)
			onFocus = FlxG.mouse.overlaps(this);

		if (onFocus && onClick != null && ((FlxG.mouse.justReleased && !specialCheck) || (FlxG.mouse.justPressed && specialCheck)))
			onClick();

		if (onFocus)
		{
			background.alpha += elapsed * 8;
			if (background.scale.y < 2)
				background.scale.y += elapsed * 8;
		}
		else
		{
			if (background.alpha > 0.5)
				background.alpha -= elapsed * 8;
			if (background.scale.y > 1)
				background.scale.y -= elapsed * 8;
		}

		if (background.scale.y < 1)
			background.scale.y = 1;
		background.y = _y + (background.scale.y - 1) * 2.5;
	}
}
