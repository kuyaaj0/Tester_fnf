package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplay extends FlxSpriteGroup
{
    var analyzer:SpectralAnalyzer;

    public var snd:FlxSound;
    var _height:Int;
    var line:Int;

    public function new(snd:FlxSound = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor)
    {
      super(X, Y);
  
      this.snd = snd;
      this.line = line;

      for (i in 0...line)
      {
        var newLine = new FlxSprite().makeGraphic(Std.int(Width / line - gap), 1, Color);
        newLine.x = (Width / line) * i;
        add(newLine);
      }
      _height = Height;

      var displayBars = 3 * Math.ceil(line / 3);
        @:privateAccess
        if (snd != null) 
        {
            analyzer = new SpectralAnalyzer(
                snd._channel.__audioSource,
                displayBars,
                1,
                5
            );
            analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
        }
    }

    public var stopUpdate:Bool = false;
    var saveTime:Float = 0;    
    var getValues:Array<funkin.vis.dsp.Bar>;
    
    override function update(elapsed:Float)
    {
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

    function addAnalyzer(snd:FlxSound) {
      @:privateAccess
      if (snd != null && analyzer == null) 
      {
        analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
        analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;       
      }
    }
    
    function updateLine(elapsed:Float) {
        if (getValues == null) return;
        
        final totalBars = getValues.length;
        final third = Math.floor(line / 3);
        
        for (i in 0...members.length)
        {
            var dataIndex:Int = i;
            if (i < third)
            {
                dataIndex = Std.int(i * (totalBars / 3) / third);
            }
            else if (i < 2 * third)
            {
                final highStart = totalBars - Std.int(totalBars / 3);
                dataIndex = highStart + Std.int((i - third) * (totalBars / 3) / third);
            }
            else
            {
                final midStart = Std.int(totalBars / 3);
                dataIndex = midStart + Std.int((i - 2 * third) * (totalBars / 3) / third);
            }

            dataIndex = Std.int(FlxMath.bound(dataIndex, 0, totalBars - 1));
            
            var animFrame:Int = Math.round(getValues[dataIndex].value * _height);
            animFrame = Math.round(animFrame * FlxG.sound.volume);
            
            members[i].scale.y = FlxMath.lerp(animFrame, members[i].scale.y, Math.exp(-elapsed * 16));
            if (members[i].scale.y < _height / 40) members[i].scale.y = _height / 40;
            members[i].y = this.y - members[i].scale.y / 2;
        }
    }

    public function changeAnalyzer(snd:FlxSound) 
    {
      @:privateAccess
      analyzer.changeSnd(snd._channel.__audioSource);

      stopUpdate = false;
    }

    public function clearUpdate() {
      for (i in 0...members.length)
      {
        members[i].scale.y = _height / 40;
        members[i].y = this.y -members[i].scale.y / 2;
      }
    }
}
