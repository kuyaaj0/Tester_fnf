package objects.state.optionState;

class OptionCata extends FlxSpriteGroup
{
	public var mainX:Float;
	public var mainY:Float;

	public var heightSet:Float = 0;
	public var heightSetOffset:Float = 0; //用于特殊的高度处理

	public var option:Array<Option> = [];

	public var bg:RoundRect;

	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y);

		mainX = X;
		mainY = Y;

		bg = new RoundRect(0, 0, width, height, width / 75, LEFT_UP, OptionsState.instance.mainColor);
		bg.alpha = 1.0;
		bg.mainX = mainX;
		bg.mainY = mainY;
		add(bg);
	}

	public function addOption(tar:Option, sameY:Bool = false) {
		var putX:Float = this.width / 4 / 50;
		var putY:Float = heightSet;
		if (sameY) {
			putX += this.width / 2; 
			putY -= option[option.length - 1].height;
		}
		add(tar);

		tar.initX(mainX, putX);
		tar.initY(mainY, putY);

		if (!sameY) heightSet += tar.saveHeight;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		mainX = this.x;
		mainY = this.y;
		bg.mainX = mainX;
		bg.mainY = mainY;
	}

	public function changeHeight(time:Float = 0.6) {
		bg.changeHeight(heightSet + heightSetOffset, time);
	}
}