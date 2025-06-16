package states;

import backend.WeekData;
import backend.Highscore;

import states.TitleState;

#if mobile
import mobile.states.CopyState;
import mobile.backend.SUtil;
#end

#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end

#if android
import backend.device.AppData;
import states.PirateState;
#end

import flixel.input.gamepad.FlxGamepad;
import openfl.Assets;

import lime.app.Application;

class InitState extends MusicBeatState {
    var skipVideo:FlxText;
    public static var updateVersion:String = '';
    public static var ignoreCopy:Bool = false;

    override public function create():Void
	{
		Paths.clearStoredMemory();

        #if mobile
		if (AppData.getVersionName() != Application.current.meta.get('version')
			|| AppData.getAppName() != Application.current.meta.get('file')
			|| (AppData.getPackageName() != Application.current.meta.get('packageName')
				&& AppData.getPackageName() != Application.current.meta.get('packageName') + 'Backup1' // 共存
				&& AppData.getPackageName() != Application.current.meta.get('packageName') + 'Backup2' // 共存
				&& AppData.getPackageName() != 'com.antutu.ABenchMark' // 超频测试 安兔兔
				&& AppData.getPackageName() != 'com.ludashi.benchmark' // 超频测试 鲁大师
			))
			FlxG.switchState(new PirateState());
		

		// 检查assets/version.txt存不存在且里面保存的上一个版本号与当前的版本号一不一致，如果不一致或不存在，强制启动copy。
		if (!FileSystem.exists(Paths.getSharedPath('version.txt')))
		{
			try sys.io.File.saveContent(Paths.getSharedPath('version.txt'), 'now version: ' + Std.string(states.MainMenuState.novaFlareEngineVersion));
            #if !ios
			FlxG.switchState(new CopyState(true));
            #else
            SUtil.showPopUp("Please manually extract Assets to 'My iPhone/NovaFlare Engine'\n请手动把Assets解压到“我的IPhone/NovaFlare Engine”","hey!");
            #end
			return;
		}else{
			if (sys.io.File.getContent(Paths.getSharedPath('version.txt')) != 'now version: ' + Std.string(states.MainMenuState.novaFlareEngineVersion))
			{
				try sys.io.File.saveContent(Paths.getSharedPath('version.txt'), 'now version: ' + Std.string(states.MainMenuState.novaFlareEngineVersion));
				#if !ios
			    FlxG.switchState(new CopyState(true));
                #else
                SUtil.showPopUp("Please manually extract Assets to 'My iPhone/NovaFlare Engine'\n请手动把Assets解压到“我的IPhone/NovaFlare Engine”","hey!");
                #end
				return;
			}
		}

        if (ClientPrefs.data.filesCheck)
		{
			if (!CopyState.checkExistingFiles() && !ignoreCopy)
			{
				// ClientPrefs.data.filesCheck = false;
				ClientPrefs.saveSettings();
				FlxG.switchState(new CopyState());
				return;
			}
		}
		#end

        #if CHECK_FOR_UPDATES
	    if (ClientPrefs.data.checkForUpdates)
	    {
		    try
		    {
			    trace('checking for update');
			    var http = new haxe.Http("https://raw.githubusercontent.com/NovaFlare-Engine-Concentration/FNF-NovaFlare-Engine/refs/heads/main/gitVersion.txt");

			    http.onData = function(data:String)
			    {
				    updateVersion = data.split('\n')[0].trim();
				    var curVersion:Float = MainMenuState.novaFlareEngineDataVersion;
				    trace('version online: ' + data.split('\n')[0].trim() + ', your version: ' + MainMenuState.novaFlareEngineVersion);
				    if (Std.parseFloat(updateVersion) > curVersion)
				    {
					    trace('versions arent matching!');
				    }
			    }

			    http.onError = function(error)
			    {
			    	trace('error: $error');
			    }

			    http.request();
		    }
	    }
	    #end

        Language.resetData();

        #if LUA_ALLOWED
	        #if (android && EXTERNAL || MEDIA)
	            try{
	        #end
		    Mods.pushGlobalMods();
	        #if (android && EXTERNAL || MEDIA)
	            }
	            catch (e:Dynamic)
	            {
		            SUtil.showPopUp("permission is not obtained, restart the application", "Error!");
		            Sys.exit(1);
	            }
	        #end
	    #end
        Mods.loadTopMod();
        Highscore.load();

        startCutscenesIn();
    }

    override function update(elapsed:Float)
	{
        var pressedEnter:Bool = (FlxG.keys.justPressed.ENTER);

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		#if android
		if (videoBool)
		{
			pressedEnter = false;
			if (FlxG.android.justReleased.BACK)
				pressedEnter = true;
		}
		#end

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

        if(pressedEnter){
            startIntro();
        }
    }

    function startCutscenesIn()
	{
		if (!ClientPrefs.data.skipTitleVideo)
			#if VIDEOS_ALLOWED
			startVideo('menuExtend/titleIntro');
			#else
			startIntro();
			#end
		else
			startIntro();
	}


    #if VIDEOS_ALLOWED
	var video:FlxVideoSprite;
	var videoBool:Bool = false;

	function startVideo(name:String)
	{
		skipVideo = new FlxText(0, FlxG.height - 26, 0, "Press " + #if android "Back on your Phone " #else "Enter " #end + "to skip", 18);
		skipVideo.setFormat(Assets.getFont("assets/fonts/montserrat.ttf").fontName, 18);
		skipVideo.alpha = 0;
		skipVideo.alignment = CENTER;
		skipVideo.screenCenter(X);
		skipVideo.scrollFactor.set();
		skipVideo.antialiasing = ClientPrefs.data.antialiasing;

		#if VIDEOS_ALLOWED
		var filepath:String = Paths.video(name);
		#if sys
		if (!FileSystem.exists(filepath))
		#else
		if (!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			videoEnd();
			return;
		}

		video = new FlxVideoSprite(0, 0);
		video.antialiasing = true;
		video.bitmap.onFormatSetup.add(function():Void
		{
			if (video.bitmap != null && video.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);

				video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
				video.updateHitbox();
				video.screenCenter();
			}
		});
		video.bitmap.onEndReached.add(video.destroy);
		add(video);
		video.load(filepath);
		video.play();
		videoBool = true;

		video.bitmap.onEndReached.add(function()
		{
			videoEnd();
		});

	    showText();
	    #else
	    FlxG.log.warn('Platform not supported!');
	    videoEnd();
	    return;
	    #end
    }

    function startIntro()
	{
        FlxG.switchState(new TitleState());
    }

    function videoEnd()
    {
	    skipVideo.visible = false;
	    if (video != null)
	    	video.stop();
	        video.visible = false;
	        startIntro();
	        videoBool = false;
	        trace("end");
    }

    function showText()
    {
        add(skipVideo);
        FlxTween.tween(skipVideo, {alpha: 1}, 1, {ease: FlxEase.quadIn});
        FlxTween.tween(skipVideo, {alpha: 0}, 1, {ease: FlxEase.quadIn, startDelay: 4});
    }
    #end
}