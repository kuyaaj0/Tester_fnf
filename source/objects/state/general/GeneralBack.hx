package objects.state.general;

class GeneralBack extends FlxSpriteGroup
{
	var background:Rect;
	var button:FlxSprite;
	var text:FlxText;

	public var onClick:Void->Void = null;

	var saveColor:FlxColor = 0;
	var saveColor2:FlxColor = 0;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null,
			flipButton:Bool = false)
	{
		super(X, Y);

		background = new Rect(0, 0, width, height);
		background.color = color;
		add(background);

		button = new FlxSprite(0, 0).loadGraphic(Paths.image('menuExtend/Others/playButton'));
		button.scale.set(0.4, 0.4);
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.y += background.height / 2 - button.height / 2;
		if (flipButton)
			button.flipX = true;
		add(button);

		text = new FlxText(40, 0, 0, texts, 25);
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

	public var onFocus:Bool = false;

	var bgTween:FlxTween;
	var textTween:FlxTween;
	var focused:Bool = false;

	var firstClick:Array<Float> = [0, 0];
	var canClick:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		onFocus = FlxG.mouse.overlaps(this);
		if(FlxG.mouse.justPressed) firstClick = [FlxG.mouse.x, FlxG.mouse.y];

		if(FlxG.mouse.pressed && canClick && (Math.abs(FlxG.mouse.x - firstClick[0]) > 20 || Math.abs(FlxG.mouse.y - firstClick[1]) > 20))
		{
			canClick = false;
		}

		if (onFocus && onClick != null && FlxG.mouse.justReleased && canClick)
			onClick();

		if (FlxG.mouse.justReleased && !canClick)
			canClick = true;

		if (onFocus)
		{
			if (!focused)
			{
				focused = true;
				background.color = saveColor2;
			}
		}
		else
		{
			if (focused)
			{
				focused = false;
				background.color = saveColor;
			}
		}
	}
}
