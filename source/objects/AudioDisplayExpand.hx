package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplayExpand extends AudioDisplay.AudioDisplay
{
    // 存储多个声音和分析器
    private var soundArray:Array<FlxSound>;
    private var analyzers:Array<SpectralAnalyzer> = [];
    
    // 修改构造函数以接受声音数组
    public function new(snd:Array<FlxSound> = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = false)
    {
        // 调用父类构造函数，传入null或第一个声音
        super(snd != null && snd.length > 0 ? snd[0] : null, X, Y, Width, Height, line, gap, Color, symmetry);
        
        this.soundArray = snd;
        
        // 为每个声音创建分析器
        if (snd != null)
        {
            for (sound in snd)
            {
                @:privateAccess
                if (sound._channel != null && sound._channel.__audioSource != null)
                {
                    var analyzer = new SpectralAnalyzer(
                        sound._channel.__audioSource, 
                        Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                        1, 
                        5
                    );
                    analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
                    analyzers.push(analyzer);
                }
            }
        }
    }
    
    override function update(elapsed:Float)
    {
        if (stopUpdate)
            return;

        if (saveTime < ClientPrefs.data.audioDisplayUpdate)
        {
            saveTime += (elapsed * 1000);
            updateLine(elapsed);
            return;
        }
        else
        {
            saveTime = 0;
        }

        if (analyzers.length > 0)
        {
            var combinedValues:Array<funkin.vis.dsp.Bar> = null;
            
            for (analyzer in analyzers)
            {
                var currentValues = analyzer.getLevels();
                
                if (combinedValues == null)
                {
                    combinedValues = currentValues.copy();
                }
                else
                {
                    for (i in 0...combinedValues.length)
                    {
                        if (i < currentValues.length)
                        {
                            combinedValues[i].value += currentValues[i].value;
                        }
                    }
                }
            }
            
            // 计算平均值
            if (combinedValues != null)
            {
                for (value in combinedValues)
                {
                    value.value /= analyzers.length;
                }
                getValues = combinedValues;
            }
        }
        
        updateLine(elapsed);
        super.update(elapsed);
    }
    
    override public function changeAnalyzer(snd:FlxSound)
    {
        analyzers = [];
        
        @:privateAccess
        if (snd != null && snd._channel != null && snd._channel.__audioSource != null)
        {
            var analyzer = new SpectralAnalyzer(
                snd._channel.__audioSource, 
                Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                1, 
                5
            );
            analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
            analyzers.push(analyzer);
        }
        
        stopUpdate = false;
    }
    
    public function changeAnalyzers(sounds:Array<FlxSound>)
    {
        analyzers = [];
        soundArray = sounds;
        
        if (sounds != null)
        {
            for (sound in sounds)
            {
                @:privateAccess
                if (sound._channel != null && sound._channel.__audioSource != null)
                {
                    var analyzer = new SpectralAnalyzer(
                        sound._channel.__audioSource, 
                        Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                        1, 
                        5
                    );
                    analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
                    analyzers.push(analyzer);
                }
            }
        }
        
        stopUpdate = false;
    }
}

class AudioCircleDisplayExpand extends AudioDisplay.AudioCircleDisplay
{
    // 存储多个声音和分析器
    private var soundArray:Array<FlxSound>;
    private var analyzers:Array<SpectralAnalyzer> = [];
    
    // 修改构造函数以接受声音数组
    public function new(snd:Array<FlxSound> = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = false)
    {
        // 调用父类构造函数，传入null或第一个声音
        super(snd != null && snd.length > 0 ? snd[0] : null, X, Y, Width, Height, line, gap, Color, symmetry);
        
        this.soundArray = snd;
        
        // 为每个声音创建分析器
        if (snd != null)
        {
            for (sound in snd)
            {
                @:privateAccess
                if (sound._channel != null && sound._channel.__audioSource != null)
                {
                    var analyzer = new SpectralAnalyzer(
                        sound._channel.__audioSource, 
                        Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                        1, 
                        5
                    );
                    analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
                    analyzers.push(analyzer);
                }
            }
        }
    }
    
    override function update(elapsed:Float)
    {
        if (stopUpdate)
            return;

        if (saveTime < ClientPrefs.data.audioDisplayUpdate)
        {
            saveTime += (elapsed * 1000);
            updateLine(elapsed);
            return;
        }
        else
        {
            saveTime = 0;
        }

        if (analyzers.length > 0)
        {
            var combinedValues:Array<funkin.vis.dsp.Bar> = null;
            
            for (analyzer in analyzers)
            {
                var currentValues = analyzer.getLevels();
                
                if (combinedValues == null)
                {
                    combinedValues = currentValues.copy();
                }
                else
                {
                    for (i in 0...combinedValues.length)
                    {
                        if (i < currentValues.length)
                        {
                            combinedValues[i].value += currentValues[i].value;
                        }
                    }
                }
            }
            
            // 计算平均值
            if (combinedValues != null)
            {
                for (value in combinedValues)
                {
                    value.value /= analyzers.length;
                }
                getValues = combinedValues;
            }
        }
        
        updateLine(elapsed);
        super.update(elapsed);
    }
    
    override public function changeAnalyzer(snd:FlxSound)
    {
        analyzers = [];
        
        @:privateAccess
        if (snd != null && snd._channel != null && snd._channel.__audioSource != null)
        {
            var analyzer = new SpectralAnalyzer(
                snd._channel.__audioSource, 
                Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                1, 
                5
            );
            analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
            analyzers.push(analyzer);
        }
        
        stopUpdate = false;
    }
    
    public function changeAnalyzers(sounds:Array<FlxSound>)
    {
        analyzers = [];
        soundArray = sounds;
        
        if (sounds != null)
        {
            for (sound in sounds)
            {
                @:privateAccess
                if (sound._channel != null && sound._channel.__audioSource != null)
                {
                    var analyzer = new SpectralAnalyzer(
                        sound._channel.__audioSource, 
                        Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
                        1, 
                        5
                    );
                    analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
                    analyzers.push(analyzer);
                }
            }
        }
        
        stopUpdate = false;
    }
}