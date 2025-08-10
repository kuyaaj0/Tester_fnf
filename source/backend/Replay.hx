package backend;

import flixel.FlxBasic;

class Replay extends FlxBasic
{
	// 整个组>摁压类型>行数>时间
	public var hitData:Array<Array<Array<Float>>> = [[[], [], [], []], [[], [], [], []]];

	var follow:Dynamic; //跟随的state

	/////////////////////////////////////////////

	public function new(follow:Dynamic)
	{
		super();
		this.follow = follow;
	}

	public function push(time:Float, type:Int, state:Int)
	{
		if (!follow.replayMode)
			hitData[state][type].push(time);
	}

	var isPaused:Bool = false;
	var pauseArray:Array<Float> = [-9999, -9999, -9999, -9999];

	public function pauseCheck(time:Float, type:Int)
	{
		if (follow.replayMode)
			return;
		pauseArray[type] = time;
		isPaused = true;
	}

	public function keysCheck()
	{
		if (!follow.replayMode)
		{
			if (isPaused)
			{
				for (key in 0...4)
					if (!follow.controls.pressed(follow.keysArray[key]) && pauseArray[key] != -9999)
						push(pauseArray[key], key, 1);

				pauseArray = [-9999, -9999, -9999, -9999];
				isPaused = false;
			}
		}
		else
		{
			for (type in 0...mania) // 使用mania作为循环上限
			{
				if (hitData[1][type].length > 0 && hitData[1][type][0] <= Conductor.songPosition)
					holdCheck(type);
			}
		}
	}

	var allowHit:Array<Bool> = [true, true, true, true];

	function holdCheck(type:Int)
	{
		if (type >= hitData[0].length || type >= hitData[1].length)
			return; // 边界检查

		if (hitData[0][type].length == 0 || hitData[1][type].length == 0)
			return;

		if (hitData[0][type][0] >= Conductor.songPosition)
		{
			follow.keysCheck(type, Conductor.songPosition);
			if (allowHit[type])
			{
				follow.keyPressed(type, hitData[1][type][0]);
				allowHit[type] = false;
			}
		}
		else
		{
			follow.keysCheck(type, Conductor.songPosition);
			if (allowHit[type])
			{
				follow.keyPressed(type, hitData[1][type][0]);
			}
			follow.keyReleased(type);
			allowHit[type] = true;
			hitData[0][type].splice(0, 1);
			hitData[1][type].splice(0, 1);
		}
	}

	public function init()
	{
		// 使用mania初始化数组
		hitData = [[for (i in 0...mania) []], [for (i in 0...mania) []]];
		for (state in 0...2)
			for (type in 0...4)
				for (hit in 0...hitData[state][type].length)
				{
					hitData[state][type].push(hitData[state][type][hit]);
				}
			}

		// 使用mania初始化allowHit
		allowHit = [for (i in 0...mania) true];

		// 只能这么复制 --狐月影
	}

	public function reset()
	{
		hitData = [[[], [], [], []], [[], [], [], []]];
		pauseArray = [-9999, -9999, -9999, -9999];
		isPaused = false;
	}

	public function saveDetails(input:Array<Array<Dynamic>>)
	{
		ReplayData.put(input, hitData);
	}
}

class ReplayData {
	/**
		Array<Array<Dynamic>> = [
			[
				songName, songLength, Date.now().toString()
			],
			[
				songSpeed, playbackRate, healthGain, healthLoss,
				cpuControlled, practiceMode, instakillOnMiss, ClientPrefs.data.playOpponent, 
				ClientPrefs.data.flipChart,
			],
			[
				songScore, ratingPercent, ratingFC, songHits, highestCombo, songMisses
			],
			[
				NoteTime, NoteMs
			]
		];
	**/	

	static public var hitData:Array<Array<Array<Float>>> = [];
	static public var songData:Array<Array<Dynamic>> = [];

	static public function put(song:Array<Array<Dynamic>>, hit:Array<Array<Array<Float>>>) {
		songData = song;
		hitData = hit;
	}
}
