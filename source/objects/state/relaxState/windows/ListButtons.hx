package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;

class ListButtons extends FlxSpriteGroup
{
    public static final DEFAULT_COLOR:FlxColor = 0xFF5C5970;
    public static final CORNER_RADIUS:Float = 8;
    public static final PADDING:Float = 10;
    
    private var background:FlxSprite;
    private var text:FlxText;
    
    public var onClick:Void->Void = null;
    private var isPressed:Bool = false;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 180, height:Float = 40, label:String = "")
    {
        super();
        
        background = new FlxSprite(x,y);
        background.makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRect(background, 0, 0, width, height, CORNER_RADIUS, CORNER_RADIUS, DEFAULT_COLOR);
        add(background);
        
        text = new FlxText(PADDING + x, PADDING + y, width, label);
        text.autoSize = true;
        text.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, LEFT);
        text.fieldHeight = height;
        add(text);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            isPressed = true;
        }
        
        if (isPressed && FlxG.mouse.justReleased && FlxG.mouse.overlaps(this)) {
            if (onClick != null) onClick();
            isPressed = false;
        }
        
        if(isPressed) setColor(0xFF908BB0);
        else setColor(0xFF5C5970);
    }
    
    public function setText(newText:String):Void
    {
        text.text = newText;
    }
    
    public function setColor(color:FlxColor):Void
    {
        FlxSpriteUtil.drawRoundRect(background, 0, 0, background.width, background.height, CORNER_RADIUS, CORNER_RADIUS, color);
    }
}