package objects.state.optionState.backend;

class OptionCata extends FlxSpriteGroup
{
	public var mainX:Float;
	public var mainY:Float;

	public var heightSet:Float;
	public var heightSetOffset:Float;

	public var option:Array<Option> = [];

	var bg:RoundRect;

	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y);

		bg = new RoundRect(0, 0, width, height, width / 10, LEFT_UP);
		add(bg);

	}

	public function addOption(tar:Option) {
		tar.follow = this;
		add(tar);
	}

	public function heightChange(data:Float, type:Int) {

	}
}