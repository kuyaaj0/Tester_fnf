package objects.state.relaxState.optionType;

class FloatType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;

    public function new(X:Int = 0, Y:Int = 0, lable:String = 'test', max:Int, min:Int, bit:Int){
        background = new Rect(X, Y, 300, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(5, 5, 295, label);
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, LEFT);
        add(labelText);
    }
}