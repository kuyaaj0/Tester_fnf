package objects.state.relaxState;

import backend.relax.GetInit;
import backend.relax.GetInit.SongInfo;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

import sys.FileSystem;
import sys.io.File;

class SongLyric extends FlxSpriteGroup
{
    public var getL:Array<Dynamic> = [];
    public var Lyrics:Map<Int, String> = new Map<Int, String>();
    public var font:String = "";
    public var NowLyrics:FlxText;
    
    public var fontSize:Int = 24;
    public var textColor:FlxColor = FlxColor.WHITE;
    
    public function new(songInfo:SongInfo, X:Float = 0, Y:Float = 0)
    {
        super(X, Y);
        
        NowLyrics = new FlxText(0, 0, 0, "", fontSize);
        NowLyrics.setFormat(null, fontSize, textColor, CENTER);
        add(NowLyrics);
        
        LoadLyrics(songInfo);
    }

    public function LoadLyrics(songInfo:SongInfo)
    {
        getL = GetInit.getSongLyrics(songInfo);
        if(getL[0] == null || getL[1] == null) return;
        
        Lyrics = getL[1];
        font = getL[0];
        
        if(font != null && font != "" && FileSystem.exists(font)) {
            if(customFont != null) {
                NowLyrics.setFormat(font, fontSize, textColor, CENTER);
            }
        }
    }
    
    var lastLyrics:String = "";

    public function updateNowLyrics(nowTime:Int = 0):String{
        if (Lyrics.get(nowTime) != null && lastLyrics != Lyrics.get(nowTime)){
            lastLyrics != Lyrics.get(nowTime);
            NowLyrics.text = Lyrics.get(nowTime);
            return Lyrics.get(nowTime);
        }
    }
}