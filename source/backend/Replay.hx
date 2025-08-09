package backend;

class Replay
{
	static public var mania:Int = 4; // 添加mania变量存储按键数量

	// 整个组>摁压类型>行数>时间 - 使用动态大小初始化
	static public var saveData:Array<Array<Array<Float>>> = [[for (i in 0...mania) []], [for (i in 0...mania) []]];
	static public var hitData:Array<Array<Array<Float>>> = [[for (i in 0...mania) []], [for (i in 0...mania) []]];

	static public var songName:String = '';
	static public var songScore:Int = 0;
	static public var songLength:Float = 0;
	static public var songHits:Int = 0;
	static public var songMisses:Int = 0;

	static public var ratingPercent:Float = 0;
	static public var ratingFC:String = '';
	static public var ratingName:String = '';

	static public var highestCombo:Int = 0;
	static public var NoteTime:Array<Float> = [];
	static public var NoteMs:Array<Float> = [];

	static public var songSpeed:Float = 0;
	static public var playbackRate:Float = 0;
	static public var healthGain:Float = 0;
	static public var healthLoss:Float = 0;
	static public var cpuControlled:Bool = false;
	static public var practiceMode:Bool = false;
	static public var instakillOnMiss:Bool = false;
	static public var opponent:Bool = false;
	static public var flipChart:Bool = false;
	static public var nowTime:String = '';

	/////////////////////////////////////////////

	static public function push(time:Float, type:Int, state:Int)
	{
		if (!PlayState.replayMode)
			try
			{
				if (type < mania) // 添加边界检查
					saveData[state][type].push(time);
			}
	}

	static var isPaused:Bool = false;
	static var checkArray:Array<Float> = []; // 改为动态数组

	static public function pauseCheck(time:Float, type:Int)
	{
		if (PlayState.replayMode)
			return;
		if (type < checkArray.length) // 边界检查
			checkArray[type] = time;
	}

	static public function keysCheck()
	{
		if (!PlayState.replayMode)
		{
			if (isPaused)
			{
				for (key in 0...mania) // 使用mania作为循环上限
				{
					if (key < checkArray.length && checkArray[key] != -9999)
					{
						if (!PlayState.instance.controls.pressed(PlayState.instance.keysArray[key]))
							push(checkArray[key], key, 1);
					}
				}

				// 重置为动态长度
				checkArray = [for (i in 0...mania) -9999];
				isPaused = false;
			}
		}
		else
		{
			for (type in 0...mania) // 使用mania作为循环上限
			{
				if (type < hitData[1].length && hitData[1][type].length > 0 && hitData[1][type][0] < Conductor.songPosition)
					holdCheck(type);
			}
		}
	}

	static var allowHit:Array<Bool> = []; // 改为动态数组

	static function holdCheck(type:Int)
	{
		if (type >= hitData[0].length || type >= hitData[1].length)
			return; // 边界检查

		if (hitData[0][type].length == 0 || hitData[1][type].length == 0)
			return;

		if (hitData[0][type][0] >= Conductor.songPosition)
		{
			PlayState.instance.keysCheck(type, Conductor.songPosition);
			if (type < allowHit.length && allowHit[type])
			{
				PlayState.instance.keyPressed(type, hitData[1][type][0]);
				allowHit[type] = false;
			}
		}
		else
		{
			PlayState.instance.keysCheck(type, Conductor.songPosition); // 长键多一帧的检测
			if (type < allowHit.length && allowHit[type])
			{
				PlayState.instance.keyPressed(type, hitData[1][type][0]); // 摁下松开时间如果太短导致没检测到
			}
			PlayState.instance.keyReleased(type);
			if (type < allowHit.length)
				allowHit[type] = true;
			hitData[0][type].splice(0, 1);
			hitData[1][type].splice(0, 1);
		}
	}

	static public function init()
	{
		// 使用mania初始化数组
		hitData = [[for (i in 0...mania) []], [for (i in 0...mania) []]];
		for (state in 0...2)
			for (type in 0...mania)
			{
				if (type < saveData[state].length)
				{
					for (hit in 0...saveData[state][type].length)
					{
						hitData[state][type].push(saveData[state][type][hit]);
					}
				}
			}

		// 使用mania初始化allowHit
		allowHit = [for (i in 0...mania) true];

		// 只能这么复制 --狐月影
	}

	static public function reset()
	{
		// 使用mania重置数组
		saveData = [[for (i in 0...mania) []], [for (i in 0...mania) []]];
		hitData = [[for (i in 0...mania) []], [for (i in 0...mania) []]];

		// 使用mania重置checkArray
		checkArray = [for (i in 0...mania) -9999];

		isPaused = false;
	} // 愚蠢但是有用 --狐月影

	static public function putDetails(putData:Array<Dynamic>)
	{
		songName = putData[0];
		songScore = putData[1];
		songLength = putData[2];
		songHits = putData[3];
		songMisses = putData[4];
		ratingPercent = putData[5];
		ratingFC = putData[6];
		ratingName = putData[7];
		highestCombo = putData[8];
		NoteTime = putData[9];
		NoteMs = putData[10];
		songSpeed = putData[11];
		playbackRate = putData[12];
		healthGain = putData[13];
		healthLoss = putData[14];
		cpuControlled = putData[15];
		practiceMode = putData[16];
		instakillOnMiss = putData[17];
		opponent = putData[18];
		flipChart = putData[19];
		nowTime = putData[20];

		// 如果提供了mania值则使用，否则保持默认值
		if (putData.length > 21)
			mania = putData[21];

		// 重置数组以适应新的mania值
		reset();
	} // 六百六十六 -狐月影
}