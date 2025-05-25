package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplay extends FlxSpriteGroup
{
    var analyzer:SpectralAnalyzer;

    public var snd:FlxSound;
    var _height:Int;
    var line:Int;

    var octaveBands:Array<{ minFreq:Float, maxFreq:Float }> = [];
    var bandBins:Array<Array<Int>> = [];
    var sampleRate:Int = 44100;
    var fftSize:Int = 1024;

    public function new(snd:FlxSound = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor)
    {
        super(X, Y);
        this.snd = snd;
        this.line = line;
        _height = Height;

        generateBands(line);
        initBandBins(sampleRate, fftSize);

        for (i in 0...line) {
            var newLine = new FlxSprite().makeGraphic(Std.int(Width / line - gap), 1, Color);
            newLine.x = (Width / line) * i;
            add(newLine);
        }

        @:privateAccess
        if (snd != null) {
            analyzer = new SpectralAnalyzer(snd._channel.__audioSource, fftSize, 1, 5);
            analyzer.fftN = fftSize;
        }
    }

    public function adjustLine(newLine:Int, width:Int, gap:Int, color:FlxColor) {
        this.line = newLine;
        
        generateBands(line);
        initBandBins(sampleRate, fftSize);
        
        clear();
        for (i in 0...line) {
            var newLine = new FlxSprite().makeGraphic(Std.int(width / line - gap), 1, color);
            newLine.x = (width / line) * i;
            add(newLine);
        }
    }

    // 新增：生成频段定义
    function generateBands(bandCount:Int) {
        octaveBands = [];
        var minFreq = 20.0;
        var maxFreq = 20000.0;
        var ratio = Math.pow(maxFreq / minFreq, 1.0 / bandCount);
        
        for (i in 0...bandCount) {
            var center = minFreq * Math.pow(ratio, i);
            var bw = center * (ratio - 1);
            octaveBands.push({
                minFreq: center - bw / 2,
                maxFreq: center + bw / 2
            });
        }
    }
    
    function initBandBins(sampleRate:Int, fftSize:Int) {
        bandBins = [];
        for (band in octaveBands) {
            var bins = [];
            var minBin = Math.floor(band.minFreq * fftSize / sampleRate);
            var maxBin = Math.ceil(band.maxFreq * fftSize / sampleRate);
            for (i in minBin...maxBin) {
                if (i >= 0 && i < fftSize / 2) {
                    bins.push(i);
                }
            }
            bandBins.push(bins);
        }
    }

    // 修改后的更新逻辑
    function updateLine(elapsed:Float) {
        if (getValues == null || bandBins.length != line) return;

        for (i in 0...line) {
            var sum = 0.0;
            var bins = bandBins[i];
            
            if (bins.length > 0) {
                for (bin in bins) {
                    sum += getValues[bin].value;
                }
                sum /= bins.length;
            }

            var dBValue = 20 * Math.log10(sum + 1e-5);
            var normalizedValue = (dBValue - (-80)) / (0 - (-80)); // 归一化到[-80dB, 0dB]

            var animFrame = Math.round(normalizedValue * _height * FlxG.sound.volume);
            members[i].scale.y = FlxMath.lerp(animFrame, members[i].scale.y, Math.exp(-elapsed * 16));
            members[i].scale.y = Math.max(members[i].scale.y, _height / 40);
            members[i].y = this.y - members[i].scale.y / 2;
        }
    }

    public var stopUpdate:Bool = false;
    var saveTime:Float = 0;    
    var getValues:Array<funkin.vis.dsp.Bar>;
    
    override function update(elapsed:Float) {
        if (stopUpdate) return;
        
        if (saveTime < ClientPrefs.data.audioDisplayUpdate) {
            saveTime += (elapsed * 1000);
            updateLine(elapsed);
            return;
        } else {
            saveTime = 0;
        }

        getValues = analyzer.getLevels();
        updateLine(elapsed);
        super.update(elapsed);
    }

    public function changeAnalyzer(snd:FlxSound) {
        @:privateAccess
        analyzer.changeSnd(snd._channel.__audioSource);
        stopUpdate = false;
        
        initBandBins(sampleRate, fftSize);
    }

    public function clearUpdate() {
        for (i in 0...members.length) {
            members[i].scale.y = _height / 40;
            members[i].y = this.y - members[i].scale.y / 2;
        }
    }
}
