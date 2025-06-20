package objects.state.optionState;

class NaviSprite extends FlxSpriteGroup
{
    var filePath:String = 'menuExtend/OptionsState/icons/';

    public var optionSort:Int;
    public var isModsAdd:Bool = false;

    public var background:RoundRect;
    public var icon:FlxSprite;
    public var textDis:FlxText;
    var specRect:Rect;

    var mainWidth:Float;
    var mainHeight:Float;

    ///////////////////////////////////////////////////////////////////////////////

    public function new(X:Float, Y:Float, width:Float, height:Float, name:String, sort:Int, modsAdd:Bool = false) {
        super(X, Y);
        optionSort = sort;

        mainWidth = width;
        mainHeight = height;

        background = new RoundRect(0, 0, width, height, height / 5, LEFT_CENTER, EngineSet.mainColor);
        background.alpha = 0.000001;
        background.mainX = X;
        background.mainY = Y;
        add(background);

        specRect = new Rect(0, 0, 5, height * 0.5, 5, 5, EngineSet.mainColor);
        specRect.x += height * 0.25;
        specRect.y += height * 0.25;
		specRect.alpha = 0;
		specRect.scale.y = 0;
		specRect.antialiasing = ClientPrefs.data.antialiasing;
		add(specRect);

        icon = new FlxSprite().loadGraphic(Paths.image(filePath + name));
        icon.setGraphicSize(Std.int(height * 0.8));
        icon.updateHitbox();
        icon.antialiasing = ClientPrefs.data.antialiasing;
        icon.color = EngineSet.mainColor;
        icon.x += height * 0.15;
        icon.y += height * 0.1;
        add(icon);

        textDis = new FlxText(0, 0, 0, name, Std.int(height * 0.15));
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.25), EngineSet.mainColor, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        textDis.borderStyle = NONE;
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        textDis.x += height * (0.8 + 0.15 + 0.25);
        textDis.y += height * 0.5 - textDis.height * 0.5;
		add(textDis);
    }

    public var onFocus:Bool = false;
    public var onPress:Bool = false;
    public var onChoose:Bool = false;
    override function update(elapsed:Float)
	{
		super.update(elapsed);

		onFocus = FlxG.mouse.overlaps(this);

		if (onFocus) {
            if (background.alpha < 0.2) background.alpha += EngineSet.FPSfix(0.015 * elapsed);

            if (FlxG.mouse.justPressed) {
                
            }
            if (FlxG.mouse.pressed) {
                onChoose = true;
            }
        } else {
            if (background.alpha > 0) background.alpha -= EngineSet.FPSfix(0.015 * elapsed);
        }
	}
}