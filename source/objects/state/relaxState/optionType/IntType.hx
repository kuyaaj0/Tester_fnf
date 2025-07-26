package objects.state.relaxState.optionType;

class IntType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;

    public function new(X:Int = 0, Y:Int = 0, label:String = 'test', max:Int, min:Int){
        background = new Rect(X, Y, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X + 10, Y + 10, 295, Language.get(labels, 'relax'));
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 35, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(labelText.x, labelText.y + labelText.height + 10, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font("montserrat.ttf"), 30, FlxColor.WHITE, LEFT);
        add(nowChoose);
    }
}