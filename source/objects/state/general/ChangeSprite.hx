package objects.state.general;

import flixel.system.FlxAssets.FlxGraphicAsset;

class ChangeSprite extends FlxSpriteGroup //背景切换
{
	var bg1:MoveSprite;
	var bg2:MoveSprite;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

        bg1 = new MoveSprite(0, 0);
        bg1.antialiasing = ClientPrefs.data.antialiasing;
		add(bg1);

		bg2 = new MoveSprite(0, 0);
        bg2.antialiasing = ClientPrefs.data.antialiasing;
		add(bg2);
	}

    public function load(graphic:FlxGraphicAsset, animated = false, frameWidth = 0, frameHeight = 0, unique = false, ?key:String) {
        bg1.load(graphic, animated, frameWidth, frameHeight, unique, key);
        bg2.load(graphic, animated, frameWidth, frameHeight, unique, key);
        return this;
    }

	var mainTween:FlxTween;
    public function changeSprite(graphic:FlxGraphicAsset, time:Float = 0.6) {
        if (mainTween != null) { 
            mainTween.cancel();
        }

        bg2.loadGraphic(graphic, false, 0, 0, false, null);
        
        mainTween = FlxTween.tween(bg1, {alpha: 0}, time, {
            ease: FlxEase.expoIn,
            onComplete: function(twn:FlxTween)
            {
              bg1.loadGraphic(bg2.graphic);
              bg1.alpha = 1;
            }
		});
    }
}
