package objects.state.freeplayState;

class ResultRect extends FlxSpriteGroup
{
	var background:FlxSprite;

	var colorArrayAlpha:Array<FlxColor> = [
		0x7FFFFF00, // marvelous
		0x7F00FFFF, // sick
		0x7F00FF00, // good
		0x7FFF7F00, // bad
		0x7FFF5858, // shit
		0x7FFF0000 // miss
	];
	var ColorArray:Array<FlxColor> = [
		0xFFFFFF00, // marvelous
		0xFF00FFFF, // sick
		0xFF00FF00, // good
		0xFFFF7F00, // bad
		0xFFFF5858, // shit
		0xFFFF0000 // miss
	];
	var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000;

	var _width:Float;
	var _height:Float;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0)
	{
		super();
		background = new FlxSprite();
		background.alpha = 0;
		add(background);
		updateRect();

		this._width = width;
		this._height = height;
	}

	public function updateRect(?timeGroup:Array<Float>, ?msGroup:Array<Float>, ?timeLength:Float)
	{
		var shape:Shape = new Shape();

		if (msGroup != null && timeGroup != null && msGroup.length > 0)
		{
			for (i in 0...msGroup.length)
			{
				var color:FlxColor;
				if (Math.abs(msGroup[i]) <= ClientPrefs.data.marvelousWindow && ClientPrefs.data.marvelousRating)
					color = ColorArray[0];
				else if (Math.abs(msGroup[i]) <= ClientPrefs.data.sickWindow)
					color = ColorArray[1];
				else if (Math.abs(msGroup[i]) <= ClientPrefs.data.goodWindow)
					color = ColorArray[2];
				else if (Math.abs(msGroup[i]) <= ClientPrefs.data.badWindow)
					color = ColorArray[3];
				else if (Math.abs(msGroup[i]) <= safeZoneOffset)
					color = ColorArray[4];
				else
					color = ColorArray[5];

				var data = msGroup[i];
				if (Math.abs(msGroup[i]) > safeZoneOffset)
					data = safeZoneOffset;

				shape.graphics.beginFill(color);
				shape.graphics.drawCircle(_width * (timeGroup[i] / timeLength), _height / 2 + _height / 2 * (data / safeZoneOffset), 1.8);
				shape.graphics.endFill();
			}
		}

		shape.graphics.beginFill(0x7FFFFFFF);
		shape.graphics.drawRect(0, _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		shape.graphics.beginFill(colorArrayAlpha[0]);
		shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.marvelousWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.marvelousWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		shape.graphics.beginFill(colorArrayAlpha[1]);
		shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.sickWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.sickWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		shape.graphics.beginFill(colorArrayAlpha[2]);
		shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.goodWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.goodWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		shape.graphics.beginFill(colorArrayAlpha[3]);
		shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.badWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.badWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		shape.graphics.beginFill(colorArrayAlpha[4]);
		shape.graphics.drawRect(1, _height / 2 - (safeZoneOffset / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.drawRect(0, _height / 2 + (safeZoneOffset / safeZoneOffset) * _height / 2 - 1, _width, 1);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(_width), Std.int(_height + 5), true, 0);
		bitmap.draw(shape);

		background.pixels = bitmap;
		background.alpha = 1;
	}
}
