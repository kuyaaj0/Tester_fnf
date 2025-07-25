package objects.state.freeplayState;

class DiffRect extends FlxSpriteGroup // songs member for freeplay
{
	var background:Rect;
	var triItems:FlxSpriteGroup;

	var diffName:FlxText;
	var charterName:FlxText;

	var follow:SongRect;

	public var member:Int;

	public function new(name:String, color:FlxColor, charter:String, point:SongRect)
	{
		super();

		background = new Rect(0, 0, 700, 60, 20, 20, color);
		add(background);

		for (i in 0...5)
		{
			var size:Float = FlxG.random.float(10, 25);
			var tri:Triangle = new Triangle(FlxG.random.float(100, background.width - 100),
				FlxG.random.float(background.height / 2 - 25, background.height / 2 - 10), size, 1);
			tri.alpha = FlxG.random.float(0.2, 0.8);
			tri.angle = FlxG.random.float(0, 60);
			add(tri);
		}

		diffName = new FlxText(15, 5, 0, name, 20);
		diffName.borderSize = 0;
		diffName.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, 0xA1393939);
		diffName.antialiasing = ClientPrefs.data.antialiasing;
		add(diffName);

		charterName = new FlxText(15, 30, 0, 'Charter: ' + charter, 12);
		charterName.borderSize = 0;
		charterName.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, 0xA1393939);
		charterName.antialiasing = ClientPrefs.data.antialiasing;
		add(charterName);

		// background.pixels.draw(drawLine(background.width, background.height));

		this.follow = point;

		y = follow.y + lerpPosY;
		x = 660 + Math.abs(y + height / 2 - FlxG.height / 2) / FlxG.height / 2 * 250 + lerpPosX;
	}

	function drawLine(width:Float, height:Float):BitmapData
	{
		var shape:Shape = new Shape();
		var lineSize:Int = 1;
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawRoundRect(0, 0, width, height, 20, 20);
		shape.graphics.drawRoundRect(lineSize, lineSize, width - lineSize * 2, height - lineSize * 2, 20, 20);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var posX:Float = -50;
	public var lerpPosX:Float = 0;
	public var posY:Float = 0;
	public var lerpPosY:Float = 0;
	public var onFocus(default, set):Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (follow.onFocus)
		{
			if (Math.abs(lerpPosY - posY) < 0.1)
				lerpPosY = posY;
			else
				lerpPosY = FlxMath.lerp(posY, lerpPosY, Math.exp(-elapsed * 15));
		}
		else
		{
			onFocus = false;
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(this, {alpha: 0}, 0.1);
			if (Math.abs(lerpPosY - 0) < 0.1)
				lerpPosY = 0;
			else
				lerpPosY = FlxMath.lerp(0, lerpPosY, Math.exp(-elapsed * 15));
		}

		if (onFocus)
		{
			if (Math.abs(lerpPosX - posX) < 0.1)
				lerpPosX = posX;
			else
				lerpPosX = FlxMath.lerp(posX, lerpPosX, Math.exp(-elapsed * 15));
		}
		else
		{
			if (Math.abs(lerpPosX - 0) < 0.1)
				lerpPosX = 0;
			else
				lerpPosX = FlxMath.lerp(0, lerpPosX, Math.exp(-elapsed * 15));
		}

		y = follow.y + lerpPosY;
		x = 660 + Math.abs(y + height / 2 - FlxG.height / 2) / FlxG.height / 2 * 250 + lerpPosX;
	}

	var tween:FlxTween;

	private function set_onFocus(value:Bool):Bool
	{
		if (onFocus == value)
			return onFocus;
		onFocus = value;
		if (onFocus)
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(this, {alpha: 1}, 0.2);
		}
		else
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(this, {alpha: 0.5}, 0.2);
		}
		return value;
	}
}
