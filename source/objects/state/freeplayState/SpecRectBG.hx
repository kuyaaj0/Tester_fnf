package objects.state.freeplayState;

class SpecRectBG extends FlxSprite // freeplay bg rect
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic(drawRect());
		antialiasing = ClientPrefs.data.antialiasing;
	}

	function drawRect():BitmapData
	{
		var shape:Shape = new Shape();

		var p1:Point = new Point(0, 0);
		var p2:Point = new Point(FlxG.width * 0.55, 0);
		var p3:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
		var p4:Point = new Point(0, FlxG.height * 0.5);

		var p5:Point = new Point(0, FlxG.height * 0.5);
		var p6:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
		var p7:Point = new Point(FlxG.width * 0.55, FlxG.height * 1);
		var p8:Point = new Point(0, FlxG.height * 1);

		shape.graphics.beginFill(0x000000);
		shape.graphics.lineStyle(1, 0x000000, 1);
		shape.graphics.moveTo(p1.x, p1.y);
		shape.graphics.lineTo(p2.x, p2.y);
		shape.graphics.lineTo(p3.x, p3.y);
		shape.graphics.lineTo(p4.x, p4.y);
		shape.graphics.lineTo(p1.x, p1.y);
		shape.graphics.endFill();

		shape.graphics.beginFill(0x000000);
		shape.graphics.lineStyle(1, 0x000000, 1);
		shape.graphics.moveTo(p5.x, p5.y);
		shape.graphics.lineTo(p6.x, p6.y);
		shape.graphics.lineTo(p7.x, p7.y);
		shape.graphics.lineTo(p8.x, p8.y);
		shape.graphics.lineTo(p5.x, p5.y);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(p8.y), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}
}
