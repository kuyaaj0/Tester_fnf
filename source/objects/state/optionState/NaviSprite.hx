package objects.state.optionState;

class NaviSprite extends FlxSpriteGroup
{
    var filePath:String = 'menuExtend/OptionsState/icons/';

    public var optionSort:Int;
    public var isModsAdd:Bool = false;
    public var onForce:Bool = false;

    public var background:RoundRect;
    public var icon:FlxSprite;
    public var textDis:FlxText;

    ///////////////////////////////////////////////////////////////////////////////

    public function new(X:Float, Y:Float, width:Float, height:Float, name:String, sort:Int, modsAdd:Bool = false) {
        super(X, Y);
        optionSort = sort;

        background = new RoundRect(0, 0, width, height, LEFT_CENTER);
        background.alpha = 0.000001;
        add(background);

        icon = new FlxSprite().loadGraphic(Paths.image(filePath + name));
        icon.setGraphicSize(Std.int(height * 0.8));
        icon.updateHitbox();
        icon.antialiasing = ClientPrefs.data.antialiasing;
        icon.color = EngineSet.mainColor;
        icon.x += height * 0.1;
        icon.y += height * 0.1;
        add(icon);

        textDis = new FlxText(0, 0, 0, name, Std.int(height * 0.3));
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.3), EngineSet.mainColor, LEFT, FlxTextBorderStyle.OUTLINE, 0xA1000000);
        textDis.borderSize = 0;
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        textDis.x += height * (0.8 + 0.1);
        textDis.y += height * 0.5 - textDis * 0.5;
		add(textDis);
    }
}