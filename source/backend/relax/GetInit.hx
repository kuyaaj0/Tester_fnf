package backend.relax;

import sys.FileSystem;
import sys.io.File;

import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;

import haxe.Json;

typedef SongInfo = {
	name: String, 							// 歌曲名称
	sound: Array<FlxSoundAsset>, 			// 音频资源
	background: Array<FlxGraphicAsset>, 	// 背景图像
	record: Array<FlxGraphicAsset>, 		// 唱片图像
    lyrics: String,                         // 歌词
	bpm: Float, 							// 每分钟节拍数
	writer: String 							// 作曲家
};

typedef SongLists = {
	name: String,
	list: Array<SongInfo>
};

typedef SongLyrics = {
    font: String,
    lyrics: Array<Dynamic>
};

class GetInit
{
    static var listArray:Array<String> = [];
    static public function getListNum():Int{
        var listNum:Int = 0;
        listArray = [];
        if (!FileSystem.exists('assets/shared/playlists/')){
            FileSystem.createDirectory('assets/shared/playlists/');
            return listNum;
        }
          
        var contents:Array<String> = FileSystem.readDirectory("assets/shared/playlists/");
        if (contents.length == 0) 
            return listNum;
            
        for (item in contents){
            var listFile:String = 'assets/shared/playlists/' + item + '/List.json';
            if(FileSystem.exists(listFile))
                listNum++;
                listArray.push(File.getContent(listFile));
        }
        return listNum;
    }
    
    static public function getList(ListNum:Int):SongLists{
        if (getListNum() > 0) {
            if(ListNum < 0) ListNum = listArray.length - 1;
            if(ListNum > listArray.length - 1) ListNum = 0;
            try{
                var data:Dynamic = Json.parse(listArray[ListNum]);
                var lists:SongLists = {
                    name: data.name,
                    list: data.list
                };
                return lists;
            }catch(e:Dynamic){
                return {
                    name: 'Parsing failed!',
                    list: []
                };
            }
        }else{
            return {
                name: 'No Found!',
                list: []
            };
        }
    }
    
    static public function getAllListName():Map<Int, String> {
        var allName = new Map<Int, String>();
        var listCount = getListNum();
        
        for (i in 0...listCount) {
            var list = getList(i);
            allName.set(i, list.name);
        }
        
        return allName;
    }
    
    static public function getAllSongs():SongLists{
        var AllListSong:Array<SongInfo> = [];
        var listID:Int = getListNum() - 1;
        var listss:SongLists;
        if (getListNum() > 0) {
            for (i in 0...listID){
                var allList = getList(i).list;
                for (ii in allList){
                    AllListSong.push(ii);
                }
            }
            listss = {
                name: 'All Songs',
                list: AllListSong
            }
        }else{
            listss = {
                name: 'All Songs',
                list: []
            }
        }
        return listss;
    }
    
    static public var songLyricsMap:Map<Int, String>;

    static public function getSongLyrics(songInfo:SongInfo):Array<Dynamic>{
        songLyricsMap = new Map();
        var LyricsDatas:Array<Dynamic> = [];
        
        var lyricsPath:String = "assets/shared/" + songInfo.lyrics;
        
        if(FileSystem.exists(lyricsPath)){
            var content:String = File.getContent(lyricsPath);
                
            var lyricsData:SongLyrics = Json.parse(content);
                
            for (lyricEntry in lyricsData.lyrics) {
                var timestamp:Int = Std.int(lyricEntry[0]);
                var text:String = lyricEntry[1];
                songLyricsMap.set(timestamp, text);
            }
            
            LyricsDatas = [songLyricsMap, lyricsData.font];
        }
        
        return LyricsDatas;
    }
}