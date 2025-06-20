package objects.state.optionState;

class TipButton extends FlxSpriteGroup
{
    public var background:RoundRect;
    public var textDis:AlphaText;

    public function new(X:Float, Y:Float, width:Float, height:Float) {
        super(X, Y);

        background = new RoundRect(0, 0, width, height, height / 5, LEFT_UP, EngineSet.mainColor);
        background.alpha = 0.3;
        background.mainX = X;
        background.mainY = Y;
        add(background);

        textDis = new AlphaText(0, 0, 0, 'text', Std.int(height * 0.7), width);
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.7), EngineSet.mainColor, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        textDis.y += background.height / 2 - textDis.height / 2;
        textDis.mainX = X;
        textDis.mainY = Y + textDis.y;
		add(textDis);
    }

    public function changeText(newText:String, ?time = 0.6) {
        textDis.changeText(newText, time * 1.25);
        var newWidth = textDis.minorText.width;
        background.changeWidth(newWidth, time, 'expoInOut');
        var newHeight = textDis.minorText.height;
        background.changeHeight(newHeight, time, 'expoInOut');
    }
}