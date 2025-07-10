package backend.relax;

import sys.FileSystem;
import sys.io.File;

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
        if (!FileSystem.exits('assets/shared/Playlists/')){
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
                listArray.push(listFile);
        }
        return listNum;
    }
    
    static public function getList(ListNum:Int):Dynamic{
        if (getListNum() > 0) {
            if(ListNum < 0) ListNum = listArray.length - 1;
            if(ListNum > listArray.length - 1) ListNum = 0;
            try{
                var data:Dynamic = Json.parse(listArray[ListNum]);
                return data;
            }catch{
                return {
                    name: 'Parsing failed!',
                    list: []
                };
            }
        }else{
            return {
                name: 'NoFound!',
                list: []
            };
        }
    }
}