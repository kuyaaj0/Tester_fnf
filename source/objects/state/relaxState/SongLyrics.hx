package objects.state.relaxState;

import backend.relax.GetInit;
import backend.relax.GetInit.SongInfo;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.text.TextFormat;
import openfl.text.Font;
import openfl.utils.Assets;

class SongLyrics extends FlxSpriteGroup
{
    public var getL:Array<Dynamic> = [];
    public var Lyrics:Map<Int, String> = new Map<Int, String>();
    public var font:String = "";
    public var NowLyrics:FlxText;
    public var NextLyrics:FlxText;
    
    // 滚动相关变量
    private var currentTime:Float = 0;
    private var currentLyricTime:Int = -1;
    private var nextLyricTime:Int = -1;
    private var sortedTimes:Array<Int> = [];
    private var scrollTween:FlxTween;
    private var isScrolling:Bool = false;
    
    // 配置参数
    public var fontSize:Int = 24;
    public var textColor:FlxColor = FlxColor.WHITE;
    public var scrollDuration:Float = 0.5; // 滚动动画持续时间（秒）
    public var preScrollTime:Float = 0.5;  // 提前多少秒开始滚动
    
    public function new(X:Float = 0, Y:Float = 0, songInfo:SongInfo)
    {
        super(X, Y);
        
        // 创建当前歌词文本
        NowLyrics = new FlxText(0, 0, 0, "", fontSize);
        NowLyrics.setFormat(null, fontSize, textColor, CENTER);
        add(NowLyrics);
        
        // 创建下一句歌词文本（初始隐藏）
        NextLyrics = new FlxText(0, fontSize + 10, 0, "", fontSize);
        NextLyrics.setFormat(null, fontSize, textColor.getDarkened(0.3), CENTER);
        NextLyrics.alpha = 0.7;
        add(NextLyrics);
        
        // 加载歌词
        LoadLyrics(songInfo);
    }

    public function LoadLyrics(songInfo:SongInfo)
    {
        getL = GetInit.getSongLyrics(songInfo);
        if(getL[0] == null || getL[1] == null) return;
        
        Lyrics = getL[1];
        font = getL[0];
        
        // 如果有自定义字体，应用它
        if(font != null && font != "" && Assets.exists(font)) {
            var customFont = Assets.getFont(font);
            if(customFont != null) {
                NowLyrics.setFormat(font, fontSize, textColor, CENTER);
                NextLyrics.setFormat(font, fontSize, textColor.getDarkened(0.3), CENTER);
            }
        }
        
        // 创建排序的时间戳数组，用于查找下一句歌词
        sortedTimes = [for (time in Lyrics.keys()) time];
        sortedTimes.sort(function(a, b) return a - b);
    }

    public function updateNowLyrics(nowTime:Float = 0){
        currentTime = nowTime;
        
        // 找到当前时间对应的歌词
        var currentIndex:Int = -1;
        for (i in 0...sortedTimes.length) {
            if (sortedTimes[i] <= nowTime) {
                currentIndex = i;
            } else {
                break;
            }
        }
        
        // 如果找到了当前歌词
        if (currentIndex >= 0) {
            var currentLyricTimeStamp:Int = sortedTimes[currentIndex];
            
            // 如果是新的歌词，更新显示
            if (currentLyricTimeStamp != currentLyricTime) {
                // 停止之前的滚动动画
                if (scrollTween != null && !scrollTween.finished) {
                    scrollTween.cancel();
                }
                
                // 更新当前歌词
                currentLyricTime = currentLyricTimeStamp;
                NowLyrics.text = Lyrics.get(currentLyricTime);
                NowLyrics.x = (width - NowLyrics.width) / 2; // 居中显示
                NowLyrics.y = 0;
                
                // 更新下一句歌词（如果有）
                if (currentIndex < sortedTimes.length - 1) {
                    nextLyricTime = sortedTimes[currentIndex + 1];
                    NextLyrics.text = Lyrics.get(nextLyricTime);
                    NextLyrics.x = (width - NextLyrics.width) / 2; // 居中显示
                } else {
                    nextLyricTime = -1;
                    NextLyrics.text = "";
                }
                
                isScrolling = false;
            }
            
            // 如果有下一句歌词，检查是否应该开始滚动
            if (nextLyricTime > 0 && !isScrolling) {
                var timeToNext = nextLyricTime - nowTime;
                if (timeToNext <= preScrollTime) {
                    startScrollAnimation();
                }
            }
        }
    }
    
    private function startScrollAnimation():Void {
        isScrolling = true;
        
        // 计算目标Y位置（向上滚动）
        var targetY = -NowLyrics.height - 5;
        
        // 创建滚动动画
        scrollTween = FlxTween.tween(NowLyrics, {y: targetY, alpha: 0.3}, scrollDuration, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                // 动画完成后，将下一句歌词设为当前歌词
                NowLyrics.text = NextLyrics.text;
                NowLyrics.y = 0;
                NowLyrics.alpha = 1;
                NowLyrics.x = (width - NowLyrics.width) / 2;
                
                // 清空下一句歌词（会在下一次updateNowLyrics中更新）
                NextLyrics.text = "";
            }
        });
    }
}