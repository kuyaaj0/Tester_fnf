package backend;

import flixel.FlxBasic;

class Replay extends FlxBasic
{
	// 整个组>摁压类型>行数>时间
	public var hitData:Array<Array<Array<Float>>> = [[], []];
	public var currectKey:Int = 4; // 添加键位数变量

	var follow:Dynamic; //跟随的state

	/////////////////////////////////////////////

	public function new(follow:Dynamic)
	{
		super();
		this.follow = follow;
		// 初始化键位数
		if (follow.SONG != null) {
			currectKey = follow.SONG.mania + 1;
		}
	}

	public function push(time:Float, type:Int, state:Int)
	{
		if (!follow.replayMode && type < currectKey - 1)
			hitData[state][type].push(time);
	}

	var isPaused:Bool = false;
	var pauseArray:Array<Float> = [];
	public function pauseCheck(time:Float, type:Int)
	{
		if (follow.replayMode || type >= currectKey - 1)
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
				if (follow.instance.paused) return; //刚进入的时候此函数会输出一次，需要刚进入时禁止此函数调用
				for (key in 0...currectKey)
					if (key < pauseArray.length && !Controls.instance.pressed(follow.instance.keysArray[key]) && pauseArray[key] != -9999)
						push(pauseArray[key], key, 0);

				// 重置暂停数组
				for (i in 0...currectKey)
					pauseArray[i] = -9999;
				isPaused = false;
			}
		}
		else
		{
			for (type in 0...currectKey)
			{
				if (type < hitData[1].length && hitData[1][type].length > 0 && hitData[1][type][0] <= Conductor.songPosition)
					holdCheck(type);
			}
		}
	}

	var allowHit:Array<Bool> = [];

	function holdCheck(type:Int)
	{
		if (type >= hitData[0].length || type >= hitData[1].length)
			return;
			
		if (hitData[0][type][0] >= Conductor.songPosition)
		{
			follow.instance.keysCheck(type, Conductor.songPosition);
			if (allowHit[type])
			{
				follow.instance.keyPressed(type, hitData[1][type][0]);
				allowHit[type] = false;
			}
		}
		else
		{
			follow.instance.keysCheck(type, Conductor.songPosition);
			if (allowHit[type])
			{
				follow.instance.keyPressed(type, hitData[1][type][0]);
			}
			follow.instance.keyReleased(type);
			allowHit[type] = true;
			hitData[0][type].splice(0, 1);
			hitData[1][type].splice(0, 1);
		}
	}

	public function init()
	{
		// 只能这么复制 --狐月影
		hitData = [[], []];
		for (state in 0...2) {
			hitData[state] = [];
			for (type in 0...currectKey) {
				hitData[state][type] = [];
				for (hit in 0...hitData[state][type].length) {
					hitData[state][type].push(hitData[state][type][hit]);
				}
			}
		}
		
		// 初始化允许命中数组
		allowHit = [];
		for (i in 0...currectKey)
			allowHit.push(true);
	}

	public function reset()
	{
		// 根据键位数动态创建数据结构
		hitData = [[], []];
		for (state in 0...2) {
			hitData[state] = [];
			for (type in 0...currectKey) {
				hitData[state][type] = [];
			}
		}
		
		// 初始化暂停数组
		pauseArray = [];
		for (i in 0...currectKey)
			pauseArray.push(-9999);
		
		// 初始化允许命中数组
		allowHit = [];
		for (i in 0...currectKey)
			allowHit.push(true);
			
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