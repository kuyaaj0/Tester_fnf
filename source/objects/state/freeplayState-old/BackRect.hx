package objects.state.freeplayState;

class BackRect extends FlxSpriteGroup // back button
{
	var background:Rect;
	var bg2:FlxSprite;
	var button:FlxSprite;
	var text:FlxText;

	public var onClick:Void->Void = null;

	var saveColor:FlxColor = 0;
	var saveColor2:FlxColor = 0;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
	{
		super(X, Y);

		bg2 = new FlxSprite(-60);
		bg2.pixels = drawRect(width, height);
		bg2.color = color;
		bg2.antialiasing = ClientPrefs.data.antialiasing;
		add(bg2);

		background = new Rect(0, 0, height, height);
		background.color = color;
		add(background);

		var line = new Rect(background.width - 3, 0, 3, height, 0, 0, 0xFFFFFFFF);
		line.alpha = 0.75;
		add(line);

		button = new FlxSprite(0, 0).loadGraphic(Paths.image('menuExtend/FreePlayState/playButton'));
		button.scale.set(0.4, 0.4);
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.x += background.width / 2 - button.width / 2;
		button.y += background.height / 2 - button.height / 2;
		button.flipX = true;
		add(button);

		text = new FlxText(70, 0, 0, texts, 18);
		text.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		text.antialiasing = ClientPrefs.data.antialiasing;
		add(text);

		text.x += background.width / 2 - text.width / 2;
		text.y += background.height / 2 - text.height / 2;

		this.onClick = onClick;
		this.saveColor = color;
		saveColor2 = color;
		saveColor2.lightness = 0.5;
	}

	function drawRect(width:Float, height:Float):BitmapData
	{
		var shape:Shape = new Shape();

		var p1:Point = new Point(10, 0);
		var p2:Point = new Point(width + 10, 0);
		var p3:Point = new Point(width, height);
		var p4:Point = new Point(0, height);

		shape.graphics.beginFill(0xFFFFFFFF);
		shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
		shape.graphics.moveTo(p1.x, p1.y);
		shape.graphics.lineTo(p2.x, p2.y);
		shape.graphics.lineTo(p3.x, p3.y);
		shape.graphics.lineTo(p4.x, p4.y);
		shape.graphics.lineTo(p1.x, p1.y);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var onFocus:Bool = false;

	var bgTween:FlxTween;
	var textTween:FlxTween;
	var focused:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FreeplayState.instance.ignoreCheck)
			return;

		onFocus = FlxG.mouse.overlaps(this);

		if (onFocus && onClick != null && FlxG.mouse.justReleased)
			onClick();

		if (onFocus)
		{
			if (!focused)
			{
				focused = true;
				if (bgTween != null)
					bgTween.cancel();
				bgTween = FlxTween.tween(bg2, {x: 0}, 0.3, {ease: FlxEase.backInOut});

				if (textTween != null)
					textTween.cancel();
				textTween = FlxTween.tween(text, {x: 105}, 0.3, {ease: FlxEase.backInOut});

				background.color = saveColor2;
			}
		}
		else
		{
			if (focused)
			{
				focused = false;
				if (bgTween != null)
					bgTween.cancel();
				bgTween = FlxTween.tween(bg2, {x: -60}, 0.3, {ease: FlxEase.backInOut});

				if (textTween != null)
					textTween.cancel();
				textTween = FlxTween.tween(text, {x: 77}, 0.3, {ease: FlxEase.backInOut});

				background.color = saveColor;
			}
		}
	}
}
