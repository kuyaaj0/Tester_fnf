package objects;

class SpriteGroup extends FlxSpriteGroup // Hscripts整组图形
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

	public function spriteAdd(obj:Dynamic)
	{
		add(obj);
	}
}
