package objects.state.optionState.backend;

class OptionCata extends FlxSpriteGroup
{
	public var mainX:Float;
	public var mainY:Float;

	public var heightSet:Float = 0;
	public var heightSetOffset:Float = 0; //用于特殊的高度处理

	public var option:Array<Option> = [];

	var bg:RoundRect;

	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y);

		mainX = X;
		mainY = Y;

		bg = new RoundRect(0, 0, width, height, width / 10, LEFT_UP);
		add(bg);

	}

	public function addOption(tar:Option, sameY:Bool = false) {
		var putX:Float = this.width / 2 / 10;
		var putY:Float = heightSet;
		if (sameY) {
			putX += this.width / 2; 
			putY -= option[option.length - 1].height;
		}
		add(tar);

		tar.changeX(mainX + putX);
		tar.changeY(mainY + putY);

		if (!sameY) heightSet += tar.height;
	}

	public function changeHeight(time:Float = 0.6) {
		bg.changeHeight(heightSet + heightSetOffset, time);
	}
}