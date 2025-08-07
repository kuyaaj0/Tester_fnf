package objects.state.relaxState;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
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
    public var barHeight:Float = 4;
    
    public var handleSize:Float = 10;
    
    public var currentTime:Float = 0;
    public var totalTime:Float = 0;
    
    public var dragging:Bool = false;
    public var hovered:Bool = false;
    
    public var onSeek:Float->Void = null;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 300, height:Float = 4) 
    {
        super(x, y);
        
        this.barX = 0;
        this.barY = 0;
        this.barWidth = width;
        this.barHeight = height;

        // 背景横线
        bgBar = new FlxSprite(barX, barY);
        bgBar.makeGraphic(Std.int(barWidth), Std.int(barHeight), FlxColor.GRAY);
        bgBar.alpha = 0.6;
        add(bgBar);
        
        // 进度条
        progressBar = new FlxSprite(barX, barY);
        progressBar.makeGraphic(1, Std.int(barHeight), FlxColor.CYAN);
        add(progressBar);
        
        // 拖动球(居中)
        handle = new FlxSprite(barX, barY - handleSize/2 + barHeight/2);
        handle.makeGraphic(Std.int(handleSize * 2), Std.int(handleSize * 2), FlxColor.TRANSPARENT);
        handle.antialiasing = true;
        FlxSpriteUtil.drawCircle(handle, handleSize, handleSize, handleSize, FlxColor.WHITE);
        add(handle);
        
        // 时间文本(左上角)
        timeText = new FlxText(barX, barY - 25, barWidth, "0:00 / 0:00", 16);
        timeText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
        add(timeText);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        // 鼠标悬停检测
        var mouseX = FlxG.mouse.getScreenPosition(camera).x - this.x;
        var mouseY = FlxG.mouse.getScreenPosition(camera).y - this.y;
        
        hovered = FlxG.mouse.overlaps(handle) || FlxG.mouse.overlaps(bgBar);
        
        // 拖动处理
        if (FlxG.mouse.justPressed && hovered)
        {
            dragging = true;
            updateHandlePosition(mouseX);
        }
        
        if (dragging)
        {
            if (FlxG.mouse.pressed)
            {
                updateHandlePosition(mouseX);
            }
            else
            {
                dragging = false;
                if (onSeek != null)
                {
                    var progressRatio:Float = (handle.x + handleSize - barX) / barWidth;
                    onSeek(totalTime * progressRatio);
                }
            }
        }
        
        // 悬停效果
        handle.scale.set(hovered || dragging ? 1.2 : 1.0, hovered || dragging ? 1.2 : 1.0);
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
    
    private function updateHandlePosition(mouseX:Float):Void
    {
        var newX:Float = mouseX - barX;
        newX = FlxMath.bound(newX, 0, barWidth);
        
        handle.x = barX + newX - handleSize;
        
        var progressRatio:Float = newX / barWidth;
        progressBar.scale.x = barWidth * progressRatio;
        progressBar.updateHitbox();
        
        timeText.text = formatTime(totalTime * progressRatio) + " / " + formatTime(totalTime);
    }
    
    public function setColors(bgColor:FlxColor, progressColor:FlxColor, handleColor:FlxColor, textColor:FlxColor):Void
    {
        this.bgBar.color = bgColor;
        this.progressBar.color = progressColor;
        FlxSpriteUtil.drawCircle(this.handle, handleSize, handleSize, handleSize, handleColor);
        this.timeText.color = textColor;
    }
}