package states;

import flixel.util.FlxSpriteUtil;
import flixel.addons.transition.FlxTransitionableState;
import haxe.Json;
import haxe.ds.ArraySort;
import sys.thread.Thread;
import sys.thread.Mutex;
import openfl.system.System;
import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.diffCalc.DiffCalc;
import backend.Replay;
import backend.diffCalc.StarRating;
import objects.HealthIcon;
import objects.state.freeplayState.*;
import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import substates.ErrorSubState;
import states.MainMenuState;
import states.PlayState;
import states.LoadingState;
import states.editors.ChartingState;
import options.OptionsState;

class FreeplayState extends MusicBeatState
{
	static public var instance:FreeplayState;

	public static var vocals:FlxSound = null;


	override function create()
	{
		super.create();

		instance = this;

		#if !mobile
		FlxG.mouse.visible = true;
		#end

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		/*
		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);

			WeekData.setDirectoryFromWeek(leWeek);
			
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				var muscan:String = song[3];
				if (song[3] == null)
					muscan = 'N/A';
				var charter:Array<String> = song[4];
				if (song[4] == null)
					charter = ['N/A', 'N/A', 'N/A'];
				addSong(song[0], i, song[1], muscan, charter, colors);
			}
		}

		Mods.loadTopMod();

		for (i in 0...songs.length)
		{
			Mods.currentModDirectory = songs[i].folder;

			var songRect:SongRect = new SongRect(660, 50 + i * 100, songs[i].songName, songs[i].songCharacter, songs[i].musican, songs[i].color);
			add(songRect);
			songRect.member = i;
			grpSongs.push(songRect);

			if (i == curSelected)
				songRect.lerpPosX = songRect.posX;
		}*/

		WeekData.setDirectoryFromWeek();
	}

	public static function destroyFreeplayVocals() {
		
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Array<Int> = [0, 0, 0];
	public var folder:String = "";
	public var lastDifficulty:String = null;
	public var bg:Dynamic;
	public var searchnum:Int = 0;
	public var musican:String = 'N/A';
	public var charter:Array<String> = ['N/A', 'N/A', 'N/A'];

	public function new(song:String, week:Int, songCharacter:String, musican:String, charter:Array<String>, color:Array<Int>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		this.bg = Paths.image('menuDesat', null, false);
		this.searchnum = 0;
		this.musican = musican;
		this.charter = charter;
		if (this.folder == null)
			this.folder = '';
	}
}
