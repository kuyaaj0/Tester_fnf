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

        textDis = new AlphaText(0, 0, width, 'text', Std.int(height * 0.3), width);
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.4), EngineSet.mainColor, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        textDis.x += background.mainRound;
        textDis.mainX = X + background.mainRound;
        textDis.mainY = Y;
		add(textDis);
    }

    public function changeText(newText:String, ?time = 0.6) {
        textDis.changeText(newText, time * 1.25);
        var newWidth = textDis.minorText.textField.textWidth + background.mainRound * 2;
        background.changeWidth(newWidth, time, 'expoInOut');
        var newHeight = textDis.minorText.textField.textHeight;
        background.changeHeight(newHeight, time, 'expoInOut');
    }
}