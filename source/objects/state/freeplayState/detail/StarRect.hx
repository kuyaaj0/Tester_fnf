package objects.state.freeplayState.detail;

class StarRect extends FlxSpriteGroup{
    public var bg:Rect;
    public var text:FlxText;

    public function new(x:Float, y:Float, width:Float, height:Float){
        super(x, y);

        bg = new Rect(0, 0, width, height, height, height, 0xffffff);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

        text = new FlxText(0, 0, 0, '0.99', Std.int(height * 0.25));
		text.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.6), 0x242A2E, CENTER, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        text.borderStyle = NONE;
		text.antialiasing = ClientPrefs.data.antialiasing;
		text.x = (bg.width - text.width) / 2;
		text.y = (bg.height - text.height) / 2;
		add(text);
    }
}