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
    private var textScrollSpeed:Float = 10;
    private var textScrollTimer:Float = 0;
    private var textScrollDelay:Float = 1.0;
    private var textScrollPosition:Float = 0;
    private var needsScrolling:Bool = false;
    private var originalTextX:Float = 0;
    
    public function new(label:String = "", x:Float = 0, y:Float = 0, width:Float = 180, height:Float = 40)
    {
        super(x, y);
        
        background = new FlxSprite();
        background.makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRect(background, 0, 0, width, height, CORNER_RADIUS, CORNER_RADIUS, DEFAULT_COLOR);
        add(background);
        
        text = new FlxText(PADDING, PADDING, width - PADDING * 2, label);
        text.setFormat(null, 16, FlxColor.WHITE, LEFT);
        originalTextX = text.x;
        add(text);
        
        checkTextOverflow();
    }
    
    private function checkTextOverflow():Void
    {
        var textWidth = text.width;
        var availableWidth = background.width - PADDING * 2;
        
        needsScrolling = textWidth > availableWidth;
        
        if (needsScrolling)
        {
            textScrollPosition = 0;
            textScrollTimer = 0;
        }
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (needsScrolling)
        {
            textScrollTimer += elapsed;
            
            if (textScrollTimer >= textScrollDelay)
            {
                textScrollPosition -= textScrollSpeed * elapsed;
                var maxScroll = text.width - (background.width - PADDING * 2);
                
                if (textScrollPosition <= -maxScroll)
                {
                    textScrollPosition = 0;
                    textScrollTimer = 0;
                }
                
                text.x = originalTextX + textScrollPosition;
            }
        }
    }
    
    public function setText(newText:String):Void
    {
        text.text = newText;
        textScrollPosition = 0;
        text.x = originalTextX;
        checkTextOverflow();
    }
    
    public function setColor(color:FlxColor):Void
    {
        FlxSpriteUtil.drawRoundRect(background, 0, 0, background.width, background.height, CORNER_RADIUS, CORNER_RADIUS, color);
    }
}