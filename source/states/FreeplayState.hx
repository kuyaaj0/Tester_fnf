package states;

import flixel.addons.transition.FlxTransitionableState;

import haxe.Json;
import haxe.ds.ArraySort;

import openfl.system.System;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.diffCalc.DiffCalc;
import backend.Replay;
import backend.diffCalc.StarRating;

import objects.state.freeplayState.*;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import substates.ErrorSubState;

import states.MainMenuState;
import states.PlayState;
import states.LoadingState;
import states.editors.ChartingState;
import options.OptionsState;

import sys.thread.Thread;
import sys.thread.Mutex;

class FreeplayState extends MusicBeatState
{
	var filePath:String = 'menuExtend/freeplayState/';

	static public var instance:FreeplayState;

	var songs:Array<SongMetadata> = [];

	public static var vocals:FlxSound = null;

	var background:ChangeSprite;
	var downBG:Rect;

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
				songs.push(new SongMetadata(song[0], i, song[1], muscan, charter, colors));
			}
		}

		Mods.loadTopMod();
	
		//////////////////////////////////////////////////////////////////////////////////////////

		background = new ChangeSprite(0, 0).load(Paths.image('menuDesat'));
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);

		var downBG = new Rect(0, FlxG.height - 50, FlxG.width, 50, 0, 0);
		downBG.color = 0x242A2E;
		add(downBG);

		//////////////////////////////////////////////////////////////////////////////////////////

		for (i in 0...songs.length)
		{
			Mods.currentModDirectory = songs[i].folder;

			
		}

		WeekData.setDirectoryFromWeek();
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
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
