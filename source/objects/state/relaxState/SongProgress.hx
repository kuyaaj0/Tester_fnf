package objects.state.relaxState;
//?
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

class SongProgress extends FlxSpriteGroup
{
    public var background:FlxSprite;
    public var progressBar:FlxSprite;
    public var scrubber:FlxSprite;
    public var timeText:FlxText;
    
    public var xPos:Float = 0;
    public var yPos:Float = 0;
    public var width:Float = 300;
    public var height:Float = 10;
    
    public var scrubberRadius:Float = 8;
    
    public var currentTime:Float = 0;
    public var totalTime:Float = 0;
    
    public var dragging:Bool = false;
    public var hovered:Bool = false;
    
    public var onSeek:Float->Void = null;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 300, height:Float = 10) 
    {
        super();
        
        this.xPos = x;
        this.yPos = y;
        this.width = width;
        this.height = height;

        background = new FlxSprite(x, y);
        background.makeGraphic(Std.int(width), Std.int(height), FlxColor.GRAY);
        background.alpha = 0.6;
        add(background);
        
        progressBar = new FlxSprite(x, y);
        progressBar.makeGraphic(1, Std.int(height), FlxColor.WHITE);
        add(progressBar);
        
        scrubber = new FlxSprite(x, y + height/2);
        scrubber.makeGraphic(Std.int(scrubberRadius * 2), Std.int(scrubberRadius * 2), FlxColor.TRANSPARENT);
        scrubber.antialiasing = true;
        FlxSpriteUtil.drawCircle(scrubber, scrubberRadius, scrubberRadius, scrubberRadius, FlxColor.WHITE);
        add(scrubber);
        
        timeText = new FlxText(x, y + height + 5, width, "0:00 / 0:00", 12);
        timeText.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, CENTER);
        add(timeText);
        
        FlxMouseEventManager.add(background, null, onMouseDown, onMouseOver, onMouseOut);
        FlxMouseEventManager.add(scrubber, null, onMouseDown, onMouseOver, onMouseOut);
    }
    
    public function updateProgress(current:Float, total:Float):Void
    {
        currentTime = current;
        totalTime = total;
        
        if (totalTime <= 0) return;
        
        var progressRatio:Float = currentTime / totalTime;
        progressRatio = FlxMath.bound(progressRatio, 0, 1);
        
        progressBar.scale.x = width * progressRatio;
        progressBar.updateHitbox();
        
        if (!dragging)
        {
            scrubber.x = xPos + (width * progressRatio) - scrubberRadius;
            
            FlxTween.cancelTweensOf(scrubber);
            FlxTween.tween(scrubber, {x: xPos + (width * progressRatio) - scrubberRadius}, 0.2, {ease: FlxEase.quadOut});
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
        updateScrubberPosition(FlxG.mouse.getScreenPosition().x);
    }
    
    private function onMouseOver(sprite:FlxSprite):Void
    {
        hovered = true;
        FlxTween.cancelTweensOf(scrubber);
        scrubber.scale.set(1.2, 1.2);
    }
    
    private function onMouseOut(sprite:FlxSprite):Void
    {
        hovered = false;
        if (!dragging)
        {
            scrubber.scale.set(1.0, 1.0);
        }
    }
    
    private function updateScrubberPosition(mouseX:Float):Void
    {
        if (!dragging) return;
        
        var newX:Float = mouseX - xPos;
        newX = FlxMath.bound(newX, 0, width);
        
        scrubber.x = xPos + newX - scrubberRadius;
        
        var progressRatio:Float = newX / width;
        progressBar.scale.x = width * progressRatio;
        progressBar.updateHitbox();
        
        timeText.text = formatTime(totalTime * progressRatio) + " / " + formatTime(totalTime);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (dragging && FlxG.mouse.pressed)
        {
            updateScrubberPosition(FlxG.mouse.getScreenPosition().x);
        }
        else if (dragging && !FlxG.mouse.pressed)
        {
            dragging = false;
            scrubber.scale.set(hovered ? 1.2 : 1.0, hovered ? 1.2 : 1.0);
            
            if (onSeek != null)
            {
                var progressRatio:Float = (scrubber.x + scrubberRadius - xPos) / width;
                onSeek(totalTime * progressRatio);
            }
        }
    }
    
    public function setColors(background:FlxColor, progress:FlxColor, scrubber:FlxColor, text:FlxColor):Void
    {
        this.background.color = background;
        this.progressBar.color = progress;
        FlxSpriteUtil.drawCircle(this.scrubber, scrubberRadius, scrubberRadius, scrubberRadius, scrubber);
        this.timeText.color = text;
    }
    
    override public function destroy():Void
    {
        FlxMouseEventManager.remove(background);
        FlxMouseEventManager.remove(scrubber);
        super.destroy();
    }
}
