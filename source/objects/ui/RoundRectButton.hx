
package objects.ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.geom.Matrix;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class RoundRectButton extends FlxGroup
{
    public var bg:FlxSprite;
    public var label:FlxText;
    public var onClick:Void->Void;

    var _w:Float;
    var _h:Float;

    public function new(x:Float, y:Float, w:Float, h:Float, text:String, ?onClick:Void->Void)
    {
        super();

        _w = w;
        _h = h;

        var shape = new Shape();
        shape.graphics.beginFill(FlxColor.fromRGB(30, 30, 30, 180));
        shape.graphics.drawRoundRect(0, 0, w, h, 24, 24);
        shape.graphics.endFill();

        var bmd = new BitmapData(Std.int(w), Std.int(h), true, 0x00000000);
        bmd.draw(shape, new Matrix());

        bg = new FlxSprite(x, y);
        bg.pixels = bmd;
        add(bg);
        bg.alpha = 0.5;

        label = new FlxText(x, y, w, text, 30);
        label.setFormat(Paths.font('loadText.ttf'), 30, FlxColor.WHITE, "center");
        label.y += (h - label.height) / 2;
        add(label);

        this.onClick = onClick;
    }

    var hovered:Bool;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        hovered = (FlxG.mouse.x >= bg.x && FlxG.mouse.x <= bg.x + _w && FlxG.mouse.y >= bg.y && FlxG.mouse.y <= bg.y + _h);

        hide();

        if (FlxG.mouse.justPressed)
        {
            if (hovered)
            {
                if (onClick != null) onClick();
            }
        }
    }
    var helloAlpha1:FlxTween;
    var isPrn:Bool;

    function hide():Void
	{
		if(isPrn && isPrn != hovered){
            isPrn = hovered;
			helloAlpha1 = FlxTween.tween(bg, {alpha: 0.5}, 0.1, {ease: FlxEase.quadOut});
	    }
        if(!isPrn && isPrn != hovered){
            isPrn = hovered;
			helloAlpha1 = FlxTween.tween(bg, {alpha: 0.9}, 0.1, {ease: FlxEase.quadOut});
	    }    
	}
}