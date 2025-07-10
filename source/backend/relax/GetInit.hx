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
	backendVideo: FlxGraphicAsset, 			// 背景视频
	bpm: Float, 							// 每分钟节拍数
	writer: String 							// 作曲家
};

typedef SongLists = {
	name: String,
	list: Array<SongInfo>
};

class GetInit
{
    static var listArray:Array<String> = [];
    static public function getListNum():Int{
        var listNum:Int = 0;
        listArray = [];
        if (!FileSystem.exists('assets/shared/Playlists/')){
            FileSystem.createDirectory('assets/shared/Playlists/');
            return listNum;
        }
          
        var contents:Array<String> = FileSystem.readDirectory("assets/shared/Playlists/");
        if (contents.length == 0) 
            return listNum;
            
        for (item in contents){
            var listFile:String = 'assets/shared/Playlists/' + item + '/List.json';
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
    
    static public function getAllListName():Array<String>{
        var AllName:Array<String> = [];
        var helpInt:Int = getListNum - 1;
        for(i in 0...helpInt){
            AllName.push(getList(i).name);
        }
        return AllName;
    }
    
    static public function getAllSongs():SongLists{
        var AllListSong:Array<SongInfo> = [];
        var listID:Int = getListNum() - 1;
        if (getListNum() > 0) {
            for (i in 0...listID){
                var allList = getList(i).list;
                for (ii in allList){
                    AllListSong.push(ii);
                }
            }
            var listss:SongLists = {
                name: 'All Songs',
                list: AllListSong
            }
        }else{
            var listss:SongLists = {
                name: 'All Songs',
                list: []
            }
        }
        return listss;
    }
}