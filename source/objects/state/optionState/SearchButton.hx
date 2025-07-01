package objects.state.optionState;

class SearchButton extends FlxSpriteGroup
{
	var bg:RoundRect;
	var search:PsychUIInputText;
	var tapText:FlxText;
	var itemDis:FlxText;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0)
	{
		super(X, Y);

        var round = height / 5;
		bg = new RoundRect(0, 0, width, height, round, LEFT_UP, 0x000000);
		add(bg);

		search = new PsychUIInputText(round, 0, Std.int(width - round * 2), '', Std.int(height / 2));
		search.bg.visible = false;
		search.behindText.alpha = 0;
		search.textObj.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		search.textObj.antialiasing = ClientPrefs.data.antialiasing;
		search.textObj.color = FlxColor.WHITE;
		search.caret.color = 0x727E7E7E;
        search.y += (bg.height - search.height) / 2;
		search.onChange = function(old:String, cur:String)
		{
			if (cur == '')
				tapText.visible = true;
			else
				tapText.visible = false;
		}
		add(search);

		tapText = new FlxText(round, 0, 0, Language.get('tapToSearch', 'fp'), Std.int(height / 2));
		tapText.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		tapText.antialiasing = ClientPrefs.data.antialiasing;
		tapText.alpha = 0.6;
        tapText.y += (bg.height - tapText.height) / 2;
		add(tapText);
	}

	override function update(e:Float)
	{
		super.update(e);
	}
}