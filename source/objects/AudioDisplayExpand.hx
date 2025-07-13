package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplayExpand extends AudioDisplay
{
    // 存储多个分析器
    private var analyzers:Array<SpectralAnalyzer> = [];
    
    public function new(sounds:Array<FlxSound> = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = false)
    {
        // 调用父类构造函数，传入第一个有效音频或null
        super(getFirstValidSound(sounds), X, Y, Width, Height, line, gap, Color, symmetry);
        
        // 延迟初始化分析器（等待音频加载）
        FlxG.signals.postUpdate.addOnce(() -> {
            if (sounds != null) {
                for (sound in sounds) {
                    addSoundAnalyzer(sound, line);
                }
            }
        });
    }

    // 辅助方法：获取第一个有效的音频
    static function getFirstValidSound(sounds:Array<FlxSound>):FlxSound 
    {
        if (sounds == null) return null;
        for (sound in sounds) {
            if (isSoundValid(sound)) return sound;
        }
        return null;
    }

    // 辅助方法：检查音频是否有效
    static function isSoundValid(sound:FlxSound):Bool 
    {
        if (sound == null) return false;
        @:privateAccess
        return sound._channel != null && sound._channel.__audioSource != null;
    }

    // 添加单个音频分析器
    function addSoundAnalyzer(sound:FlxSound, line:Int):Void 
    {
        if (!isSoundValid(sound)) return;
        
        @:privateAccess
        var analyzer = new SpectralAnalyzer(
            sound._channel.__audioSource, 
            Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 
            1, 
            5
        );
        analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
        analyzers.push(analyzer);
    }

    override function update(elapsed:Float)
    {
        if (stopUpdate) return;

        if (saveTime < ClientPrefs.data.audioDisplayUpdate)
        {
            saveTime += elapsed * 1000;
            updateLine(elapsed);
            return;
        }
        saveTime = 0;

        // 计算所有分析器的平均值
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
                        if (i < currentValues.length) combinedValues[i].value += currentValues[i].value;
                    }
                }
            }
            
            if (combinedValues != null)
            {
                for (value in combinedValues) value.value /= analyzers.length;
                getValues = combinedValues;
            }
        }
        
        updateLine(elapsed);
        super.update(elapsed);
    }

    // 更新音频分析方法（兼容单个和多个音频）
    public function changeAnalyzers(sounds:Array<FlxSound>):Void
    {
        analyzers = [];
        if (sounds != null) 
        {
            for (sound in sounds) 
            {
                addSoundAnalyzer(sound, line);
            }
            snd = getFirstValidSound(sounds); // 更新父类的当前音频引用
        }
        stopUpdate = false;
    }

    // 保持对父类方法的兼容
    override public function changeAnalyzer(sound:FlxSound):Void
    {
        changeAnalyzers(sound != null ? [sound] : null);
    }
}

class AudioCircleDisplayExpand extends AudioCircleDisplay
{
    private var analyzers:Array<SpectralAnalyzer> = [];
    
    public function new(sounds:Array<FlxSound> = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, Radius:Float = 50, symmetry:Bool = true, Number:Int = 3)
    {
        // 调用父类构造函数
        super(getFirstValidSound(sounds), X, Y, Width, Height, line, gap, Color, Radius, symmetry, Number);
        
        // 延迟初始化分析器
        FlxG.signals.postUpdate.addOnce(() -> {
            if (sounds != null) {
                for (sound in sounds) {
                    addSoundAnalyzer(sound, line);
                }
            }
        });
    }

    static function getFirstValidSound(sounds:Array<FlxSound>):FlxSound {
        if (sounds == null) return null;
        for (sound in sounds) {
            @:privateAccess
            if (sound._channel?.__audioSource != null) return sound;
        }
        return null;
    }

    function addSoundAnalyzer(sound:FlxSound, line:Int):Void {
        @:privateAccess
        if (sound._channel?.__audioSource == null) return;
        
        var analyzer = new SpectralAnalyzer(
            sound._channel.__audioSource,
            Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))),
            1,
            5
        );
        analyzer.fftN = 1024 * ClientPrefs.data.audioDisplayQuality;
        analyzers.push(analyzer);
    }

    override function update(elapsed:Float) {
        if (stopUpdate) return;

        if (saveTime < ClientPrefs.data.audioDisplayUpdate) {
            saveTime += elapsed * 1000;
            updateLine(elapsed);
            return;
        }
        saveTime = 0;

        // 多音频频谱平均计算
        if (analyzers.length > 0) {
            var combinedValues = analyzers[0].getLevels().copy();
            for (i in 1...analyzers.length) {
                var values = analyzers[i].getLevels();
                for (j in 0...combinedValues.length) {
                    if (j < values.length) combinedValues[j].value += values[j].value;
                }
            }
            for (value in combinedValues) value.value /= analyzers.length;
            getValues = combinedValues;
        }
        
        updateLine(elapsed);
        super.update(elapsed);
    }

    public function changeAnalyzers(sounds:Array<FlxSound>):Void {
        analyzers = [];
        if (sounds != null) {
            for (sound in sounds) {
                addSoundAnalyzer(sound, line);
            }
            snd = getFirstValidSound(sounds);
        }
        stopUpdate = false;
    }

    override public function changeAnalyzer(sound:FlxSound):Void {
        changeAnalyzers(sound != null ? [sound] : null);
    }
}