package objects.state.optionState;

//左边的导航摁键

class NaviSprite extends FlxSpriteGroup
{
    var filePath:String = 'menuExtend/OptionsState/icons/';

    public var optionSort:Int;
    public var isModsAdd:Bool = false;

    public var background:Rect;
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

        background = new Rect(0, 0, width, height, height / 5, height / 5, EngineSet.mainColor, 0.0000001);
        add(background);

        specRect = new Rect(0, 0, 5, height * 0.5, 5, 5, EngineSet.mainColor);
        specRect.x += height * 0.25;
        specRect.y += height * 0.25;
		specRect.alpha = 1;
		specRect.scale.y = 1;
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

        var mouse = OptionsState.instance.mouseEvent;

		onFocus = mouse.overlaps(this);

		if (onFocus) {
            if (background.alpha < 0.2) background.alpha += EngineSet.FPSfix(0.015);

            if (mouse.justPressed) {
                
            }

            if (mouse.pressed) {
                onChoose = true;
                if (this.scale.x > 0.9)
                    this.scale.x = this.scale.y -= ((this.scale.x - 0.9) * (this.scale.x - 0.9) * 0.75);
            }

            if (mouse.justReleased) {
                OptionsState.instance.changeCata(optionSort);
            }
        } else {
            if (background.alpha > 0) background.alpha -= EngineSet.FPSfix(0.015);
        }

        if (!mouse.pressed)
        {
            if (this.scale.x < 1)
                this.scale.x = this.scale.y += ((1 - this.scale.x) * (1 - this.scale.x) * 0.75);
        }
	}
}