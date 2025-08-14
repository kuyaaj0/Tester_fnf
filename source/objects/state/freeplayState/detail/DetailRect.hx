package objects.state.freeplayState.detail;

class DetailRect extends FlxSpriteGroup{
    public var bg1:FlxSprite;
    public var bg2:FlxSprite;
    public var bg3:FlxSprite;

    public function new(x, y){
        super(x, y);
        bg1 = new FlxSprite(0).loadGraphic(Paths.image(FreeplayState.filePath + 'detailsBG1'));
        bg1.alpha = 0.6;
		bg1.antialiasing = ClientPrefs.data.antialiasing;
		add(bg1);

        bg2 = new FlxSprite(0).loadGraphic(Paths.image(FreeplayState.filePath + 'detailsBG2'));
        bg2.y += bg1.height - bg2.height;
        bg2.alpha = 0.4;
		bg2.antialiasing = ClientPrefs.data.antialiasing;
		add(bg2);

        bg3 = new FlxSprite(0).loadGraphic(Paths.image(FreeplayState.filePath + 'detailsBG3'));
        bg3.y += bg1.height - bg3.height;
        bg3.alpha = 0.6;
		bg3.antialiasing = ClientPrefs.data.antialiasing;
		add(bg3);
    }
}