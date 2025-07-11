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
    
    public var onClick:Void->Void = null;
    private var isPressed:Bool = false;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 180, height:Float = 40, label:String = "")
    {
        super(x, y);
        
        background = new FlxSprite();
        background.makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRect(background, 0, 0, width, height, CORNER_RADIUS, CORNER_RADIUS, DEFAULT_COLOR);
        add(background);
        
        text = new FlxText(PADDING, PADDING, 0, label); // width设为0让文本自动扩展
        text.setFormat(null, 16, FlxColor.WHITE, LEFT);
        text.wordWrap = false;
        originalTextX = text.x;
        add(text);
        
        checkTextOverflow();
    }
    
    private function checkTextOverflow():Void {
        text.wordWrap = false;
        text.fieldWidth = 0;
        
        var textWidth = text.width;
        var availableWidth = background.width - PADDING * 2;
        
        needsScrolling = textWidth > availableWidth;
        
        if (needsScrolling) {
            textScrollPosition = 0;
            textScrollTimer = 0;
            text.clipRect = new FlxRect(0, 0, availableWidth, text.height);
        } else {
            text.clipRect = null;
        }
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (needsScrolling) {
           textScrollTimer += elapsed;
           
           if (textScrollTimer >= textScrollDelay) {
               textScrollPosition -= textScrollSpeed * elapsed;
               var maxScroll = text.width - (background.width - PADDING * 2);
               
               if (textScrollPosition <= -maxScroll) {
                   textScrollPosition = 0;
                   textScrollTimer = 0;
               }
               
               text.x = originalTextX + textScrollPosition;
               text.clipRect.x = -textScrollPosition;
           }
       }
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            isPressed = true;
        }
        
        if (isPressed && (FlxG.mouse.justReleased || FlxG.mouse.overlaps(this))) {
            if (onClick != null) onClick();
            isPressed = false;
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