package objects.state.freeplayState;

class OrderRect extends FlxSpriteGroup
{
	var touchFix:Rect;
	var bg:FlxSprite;
	var display:Rect;

	var follow:Bool;

	public function new(X:Float, Y:Float, width:Float, height:Float, point:Bool)
	{
		super(X, Y);

		this.follow = point;

		bg = new FlxSprite();
		bg.pixels = drawRect(50, 20);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.x += width - bg.width - 15;
		bg.y += height / 2 - bg.height / 2;
		add(bg);

		display = new Rect(width - bg.width - 15 - 15, height / 2 - bg.height / 2, 80, 20, 20, 20);
		display.color = 0xFF52F9;
		resetUpdate();
		add(display);

		var text = new FlxText(0, 0, 0, Language.get('searchSorted', 'fp'), 18);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;
		add(text);

		text.y += height / 2 - text.height / 2;
	}

	function drawRect(width:Float, height:Float):BitmapData
	{
		var shape:Shape = new Shape();

		shape.graphics.beginFill(0xFF52F9);
		shape.graphics.drawRoundRect(0, 0, width, height, height, height);
		shape.graphics.endFill();

		var line:Int = 2;

		shape.graphics.beginFill(0x24232C);
		shape.graphics.drawRoundRect(line, line, width - line * 2, height - line * 2, height - line * 2, height - line * 2);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var onFocus:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		onFocus = FlxG.mouse.overlaps(display);

		if (onFocus && FlxG.mouse.justReleased)
			onClick();
	}

	var tween:FlxTween;
	var state:Bool = false;

	function onClick()
	{
		if (tween != null)
			tween.cancel();
		if (!state)
		{
			tween = FlxTween.tween(display, {alpha: 1}, 0.1);
		}
		else
		{
			tween = FlxTween.tween(display, {alpha: 0}, 0.1);
		}
		state = !state;
		FreeplayState.instance.useSort = state;
	}

	public function resetUpdate()
	{
		if (follow == true)
		{
			display.alpha = 1;
			state = true;
		}
		else
		{
			display.alpha = 0;
			state = false;
		}
	}
}
