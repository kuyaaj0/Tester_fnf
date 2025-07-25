package objects.state.freeplayState;

class SearchButton extends FlxSpriteGroup
{
	var bg:Rect;
	var search:PsychUIInputText;
	var tapText:FlxText;
	var itemDis:FlxText;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0)
	{
		super(X, Y);

		bg = new Rect(0, 0, width, height, 25, 25, 0x000000);
		add(bg);

		search = new PsychUIInputText(5, 5, Std.int(width - 10), '', 30);
		search.bg.visible = false;
		search.behindText.alpha = 0;
		search.textObj.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		search.textObj.antialiasing = ClientPrefs.data.antialiasing;
		search.textObj.color = FlxColor.WHITE;
		search.caret.color = 0x727E7E7E;
		search.onChange = function(old:String, cur:String)
		{
			if (cur == '')
				tapText.visible = true;
			else
				tapText.visible = false;
			FreeplayState.instance.updateSearch(cur);
			itemDis.text = Std.string(FreeplayState.instance.songs.length) + Language.get('mapsFound', 'fp');
		}
		add(search);

		tapText = new FlxText(5, 5, 0, Language.get('tapToSearch', 'fp'), 30);
		tapText.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		tapText.antialiasing = ClientPrefs.data.antialiasing;
		tapText.alpha = 0.6;
		add(tapText);

		itemDis = new FlxText(5, 5 + tapText.height, 0, Std.string(FreeplayState.instance.songs.length) + Language.get('mapsFound', 'fp'), 18);
		itemDis.color = 0xFF52F9;
		itemDis.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		itemDis.antialiasing = ClientPrefs.data.antialiasing;
		add(itemDis);
	}

	override function update(e:Float)
	{
		super.update(e);
		search.ignoreCheck = FreeplayState.instance.ignoreCheck;
		if (FreeplayState.instance.ignoreCheck)
			return;
	}
}
