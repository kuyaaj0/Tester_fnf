package backend;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
    public static var songTimes:Map<String, String> = new Map<String, String>();
	
    public static var songNoteHit:Map<String, Dynamic> = new Map<String, Dynamic>(); //Array<Array<Array<Float>>>
    public static var songDetails:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();

    
	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setTime(daSong, 'N/A');
		setRating(daSong, 0);
		setKeyHit(daSong,  [[[],[],[],[]],[[],[],[],[]]]);
		setDetails(daSong, []);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, diff:Int = 0, rating:Float = -1, songNoteHit:Array<Array<Array<Float>>>, details:Array<Dynamic>):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score || songRating.get(daSong) < rating) {
				setScore(daSong, score);
				setTime(daSong, Date.now().toString());
				if(rating >= 0) setRating(daSong, rating);
				setKeyHit(daSong, songNoteHit);
				setDetails(daSong, details);
			}
		} else {
			setScore(daSong, score);
			setTime(daSong, Date.now().toString());
			if(rating >= 0) setRating(daSong, rating);
			setKeyHit(daSong, songNoteHit);
			setDetails(daSong, details);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}
	
	static function setTime(song:String, time:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songTimes.set(song, time);
		FlxG.save.data.songTimes = songTimes;
		FlxG.save.flush();
	}

	static function setKeyHit(song:String, group:Array<Array<Array<Float>>>):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songNoteHit.set(song, group);
		FlxG.save.data.songNoteHit = songNoteHit;
		FlxG.save.flush();
	}
	
	static function setDetails(song:String, group:Array<Dynamic>):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songDetails.set(song, group);
		FlxG.save.data.songDetails = songDetails;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}
	
	public static function getTime(song:String, diff:Int):String
	{
		var daSong:String = formatSong(song, diff);
		if (!songTimes.exists(daSong)){
			setTime(daSong, 'N/A');			
        }
		return songTimes.get(daSong);
	}

	public static function getKeyHit(song:String, diff:Int):Dynamic
	{
		var daSong:String = formatSong(song, diff);
		if (!songNoteHit.exists(daSong)){
			setKeyHit(daSong, [[[],[],[],[]],[[],[],[],[]]]);
        }
		return songNoteHit.get(daSong);
	}
	
	public static function getDetails(song:String, diff:Int):Dynamic
	{
		var daSong:String = formatSong(song, diff);
		if (!songDetails.exists(daSong)){
			setDetails(daSong, []);
        }
		return songDetails.get(daSong);
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songTimes != null)
		{
			songTimes = FlxG.save.data.songTimes;
		}		
		if (FlxG.save.data.songNoteHit != null)
		{
			songNoteHit = FlxG.save.data.songNoteHit;
		}
		if (FlxG.save.data.songDetails != null)
		{
			songDetails = FlxG.save.data.songDetails;
		}
	}
}
