package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;

class ListButtons extends FlxSpriteGroup
{
    public static final DEFAULT_COLOR:FlxColor = 0xFF5C5970;
    public static final PRESSED_COLOR:FlxColor = 0xFF908BB0;
    public static final CHOOSEN_COLOR:FlxColor = 0xFF7A75A0;
    public static final CORNER_RADIUS:Float = 8;
    public static final PADDING:Float = 10;
    
    private var background:FlxSprite;
    private var text:FlxText;
    
    public var onClick:ListButtons->Void = null;
    public var unClick:ListButtons->Void = null;
    public var isPressed:Bool = false;
    public var isChoose:Bool = false;
    public var allowChoose:Bool = true;
    
    private var currentColor:FlxColor = DEFAULT_COLOR;
    private var targetColor:FlxColor = DEFAULT_COLOR;
    private var colorLerpSpeed:Float = 0.2;

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
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed && allowChoose) {
            isPressed = true;
        }
        
        if (isPressed && FlxG.mouse.justReleased) {
            if (onClick != null) onClick(this);
            isPressed = false;
        }
        
        if (!FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            if (unClick != null) unClick(this);
        }
        
        if(isChoose) {
            targetColor = CHOOSEN_COLOR;
        } else {
            targetColor = isPressed ? PRESSED_COLOR : DEFAULT_COLOR;
        }
        
        if (currentColor != targetColor) {
            currentColor = FlxColor.interpolate(currentColor, targetColor, colorLerpSpeed);
            applyColor();
        }
    }
    
    private function applyColor():Void
    {
        FlxSpriteUtil.drawRoundRect(background, 0, 0, background.width, background.height, CORNER_RADIUS, CORNER_RADIUS, currentColor);
    }
    
    public function setColor(color:FlxColor):Void
    {
        targetColor = color;
    }
    
    public function setText(newText:String):Void
    {
        text.text = newText;
    }
}