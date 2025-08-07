package objects.state.relaxState;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxSpriteUtil;

class SongProgress extends FlxSpriteGroup
{
    public var bgBar:FlxSprite;
    public var progressBar:FlxSprite;
    public var handle:FlxSprite;
    public var timeText:FlxText;
    
    public var barX:Float = 0;
    public var barY:Float = 0;
    public var barWidth:Float = 300;
    public var barHeight:Float = 10;
    
    public var handleSize:Float = 8;
    
    public var currentTime:Float = 0;
    public var totalTime:Float = 0;
    
    public var dragging:Bool = false;
    public var hovered:Bool = false;
    
    public var onSeek:Float->Void = null;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 300, height:Float = 10) 
    {
        super();
        
        this.barX = x;
        this.barY = y;
        this.barWidth = width;
        this.barHeight = height;

        bgBar = new FlxSprite(x, y);
        bgBar.makeGraphic(Std.int(barWidth), Std.int(barHeight), FlxColor.GRAY);
        bgBar.alpha = 0.6;
        add(bgBar);
        
        progressBar = new FlxSprite(x, y);
        progressBar.makeGraphic(1, Std.int(barHeight), FlxColor.WHITE);
        add(progressBar);
        
        handle = new FlxSprite(x, y + barHeight/2);
        handle.makeGraphic(Std.int(handleSize * 2), Std.int(handleSize * 2), FlxColor.TRANSPARENT);
        handle.antialiasing = true;
        FlxSpriteUtil.drawCircle(handle, handleSize, handleSize, handleSize, FlxColor.WHITE);
        add(handle);
        
        timeText = new FlxText(x, y + barHeight + 5, barWidth, "0:00 / 0:00", 12);
        timeText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, CENTER);
        add(timeText);
        
        var mouseManager = new FlxMouseEventManager();
        mouseManager.add(bgBar, null, onMouseDown, onMouseOver, onMouseOut);
        mouseManager.add(handle, null, onMouseDown, onMouseOver, onMouseOut);
    }
    
    public function updateProgress(current:Float, total:Float):Void
    {
        currentTime = current;
        totalTime = total;
        
        if (totalTime <= 0) return;
        
        var progressRatio:Float = currentTime / totalTime;
        progressRatio = FlxMath.bound(progressRatio, 0, 1);
        
        progressBar.scale.x = barWidth * progressRatio;
        progressBar.updateHitbox();
        
        if (!dragging)
        {
            handle.x = barX + (barWidth * progressRatio) - handleSize;
        }
        
        timeText.text = formatTime(currentTime) + " / " + formatTime(totalTime);
    }
    
    private function formatTime(seconds:Float):String
    {
        var minutes:Int = Std.int(seconds / 60);
        var secs:Int = Std.int(seconds) % 60;
        return minutes + ":" + (secs < 10 ? "0" + secs : "" + secs);
    }
    
    private function onMouseDown(sprite:FlxSprite):Void
    {
        dragging = true;
        updateHandlePosition(FlxG.mouse.getScreenPosition().x);
    }
    
    private function onMouseOver(sprite:FlxSprite):Void
    {
        hovered = true;
        handle.scale.set(1.2, 1.2);
    }
    
    private function onMouseOut(sprite:FlxSprite):Void
    {
        hovered = false;
        if (!dragging)
        {
            handle.scale.set(1.0, 1.0);
        }
    }
    
    private function updateHandlePosition(mouseX:Float):Void
    {
        if (!dragging) return;
        
        var newX:Float = mouseX - barX;
        newX = FlxMath.bound(newX, 0, barWidth);
        
        handle.x = barX + newX - handleSize;
        
        var progressRatio:Float = newX / barWidth;
        progressBar.scale.x = barWidth * progressRatio;
        progressBar.updateHitbox();
        
        timeText.text = formatTime(totalTime * progressRatio) + " / " + formatTime(totalTime);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (dragging && FlxG.mouse.pressed)
        {
            updateHandlePosition(FlxG.mouse.getScreenPosition().x);
        }
        else if (dragging && !FlxG.mouse.pressed)
        {
            dragging = false;
            handle.scale.set(hovered ? 1.2 : 1.0, hovered ? 1.2 : 1.0);
            
            if (onSeek != null)
            {
                var progressRatio:Float = (handle.x + handleSize - barX) / barWidth;
                onSeek(totalTime * progressRatio);
            }
        }
    }
    
    public function setColors(bgColor:FlxColor, progressColor:FlxColor, handleColor:FlxColor, textColor:FlxColor):Void
    {
        this.bgBar.color = bgColor;
        this.progressBar.color = progressColor;
        FlxSpriteUtil.drawCircle(this.handle, handleSize, handleSize, handleSize, handleColor);
        this.timeText.color = textColor;
    }
}