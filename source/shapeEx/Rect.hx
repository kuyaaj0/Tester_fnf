package shapeEx;

class Rect extends FlxSprite
{
	public var mainRound:Float;
	public function new(X:Float = 0, Y:Float = 0, width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0,
			Color:FlxColor = FlxColor.WHITE, ?Alpha:Float = 1)
	{
		super(X, Y);

		this.mainRound = roundWidth;

		if (Cache.currentTrackedFrames.get('rect-w'+width+'-h:'+height+'-rw:'+roundWidth+'-rh:'+roundHeight) == null) addCache(width, height, roundWidth, roundHeight);
		frames = Cache.currentTrackedFrames.get('rect-w'+width+'-h:'+height+'-rw:'+roundWidth+'-rh:'+roundHeight);
		antialiasing = ClientPrefs.data.antialiasing;
		color = Color;
		alpha = Alpha;
	}

	function drawRect(width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0):BitmapData
	{
		var shape:Shape = new Shape();

		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawRoundRect(0, 0, Std.int(width), Std.int(height), roundWidth, roundHeight);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	function addCache(width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0) {
		var spr:FlxSprite = new FlxSprite();
		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(drawRect(width, height, roundWidth, roundHeight));
		spr.loadGraphic(newGraphic);

		Cache.currentTrackedFrames.set('rect-w'+width+'-h:'+height+'-rw:'+roundWidth+'-rh:'+roundHeight, spr.frames);
	}
}
