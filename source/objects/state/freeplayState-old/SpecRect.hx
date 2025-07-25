package objects.state.freeplayState;

class SpecRect extends FlxSprite // freeplay bg rect
{
	var mask:FlxSprite;
	var sprite:FlxSprite;

	public function new(X:Float, Y:Float, Path:String)
	{
		super(X, Y);

		sprite = new FlxSprite(X, Y).loadGraphic(Paths.image(Path, null, false));

		updateRect(sprite.pixels);
	}

	function drawRect():BitmapData
	{
		var shape:Shape = new Shape();

		var p1:Point = new Point(0, 0);
		var p2:Point = new Point(FlxG.width * 0.492, 0);
		var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
		var p4:Point = new Point(0, FlxG.height * 0.4);

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(1, 0xFFFFFF, 1);
		shape.graphics.moveTo(p1.x, p1.y);
		shape.graphics.lineTo(p2.x, p2.y);
		shape.graphics.lineTo(p3.x, p3.y);
		shape.graphics.lineTo(p4.x, p4.y);
		shape.graphics.lineTo(p1.x, p1.y);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	function drawLine():BitmapData
	{
		var shape:Shape = new Shape();

		var p1:Point = new Point(0, 0);
		var p2:Point = new Point(FlxG.width * 0.492, 0);
		var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
		var p4:Point = new Point(0, FlxG.height * 0.4);

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(2, 0xFFFFFF, 1);
		shape.graphics.moveTo(p1.x, p1.y);
		shape.graphics.lineTo(p2.x, p2.y);
		shape.graphics.endFill();

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(2, 0xFFFFFF, 1, true, NONE, NONE, ROUND, 1);
		shape.graphics.moveTo(p2.x, p2.y);
		shape.graphics.lineTo(p3.x, p3.y);
		shape.graphics.endFill();

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(2, 0xFFFFFF, 1);
		shape.graphics.moveTo(p3.x, p3.y);
		shape.graphics.lineTo(p4.x, p4.y);
		shape.graphics.endFill();

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(2, 0xFFFFFF, 1);
		shape.graphics.moveTo(p4.x, p4.y);
		shape.graphics.lineTo(p1.x, p1.y);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public function updateRect(sprite:BitmapData)
	{
		mask = new FlxSprite(0, 0).loadGraphic(drawRect());
		var matrix:Matrix = new Matrix();
		var data:Float = mask.width / sprite.width;
		if (mask.height / sprite.height > data)
			data = mask.height / sprite.height;
		matrix.scale(data, data);
		matrix.translate(-(sprite.width * data - mask.width) / 2, -(sprite.height * data - mask.height) / 2);

		var bitmap:BitmapData = sprite;

		var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
		resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		var lineBitmap:BitmapData = drawLine();
		resizedBitmapData.draw(lineBitmap);

		pixels = resizedBitmapData;
		antialiasing = ClientPrefs.data.antialiasing;
	}
}
