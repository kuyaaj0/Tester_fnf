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

        textDis = new AlphaText(0, 0, 0, 'text', Std.int(height * 0.32));
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.32), EngineSet.mainColor, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        add(textDis);
        var fixX = (textDis.minorText.textField.textWidth - textDis.width) + background.mainRound;
        var fixY = (textDis.minorText.textField.textHeight - textDis.height) + background.mainRound;
        textDis.mainX = X + fixX;
        textDis.mainY = Y + fixY;

        textDis.mainText.fieldWidth = width - background.mainRound * 2;
        textDis.minorText.fieldWidth = width - background.mainRound * 2;
		
        textDis.changeText('init', 0);
    }

    public function changeText(newText:String, ?time = 0.4) {
        textDis.changeText(newText, time * 1.2);
        var newWidth = textDis.minorText.textField.textWidth + background.mainRound * 2;
        background.changeWidth(newWidth, time, 'expoInOut');
        var newHeight = textDis.minorText.textField.textHeight + background.mainRound;
        background.changeHeight(newHeight, time, 'expoInOut');
    }
}