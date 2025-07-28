package objects.state.relaxState.optionType;

class IntType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    var label:String;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var helpInt:Int;
    var maxValue:Int;
    var minValue:Int;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', min:Int, max:Int)
    {
        super(X * 177.5, Y * 77.5);
        
        label = labels;
        helpInt = Reflect.getProperty(ClientPrefs.data, label);
        helpInt = Std.int(Math.max(min, Math.min(max, helpInt)));
        
        maxValue = max;
        minValue = min;
        
        background = new Rect(X * 177.5, Y * 77.5, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X * 177.5 + 10, Y * 77.5 + 10, 295, Language.get(labels, 'relax'));
        labelText.setFormat(Paths.font("montserrat.ttf"), 28, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * 177.5 + 10, 110 + Y * 67.5, 295, Std.string(helpInt));
        nowChoose.setFormat(Paths.font("montserrat.ttf"), 25, FlxColor.WHITE, LEFT);
        add(nowChoose);
    }
    
    var saveX = 0;
    var saveY = 0;
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    
        if (FlxG.mouse.justPressed)
        {
            saveX = FlxG.mouse.x;
            saveY = FlxG.mouse.y;
        }
    
        if (FlxG.mouse.pressed && canPress)
        {
            if ((Math.abs(FlxG.mouse.x - saveX) > 5) || (Math.abs(FlxG.mouse.y - saveY) > 5))
            {
                canPress = false;
            }
        }
    
        if (FlxG.mouse.justReleased && canPress)
        {
            var localX = FlxG.mouse.getScreenPosition().x - this.x;
            var isLeftSide = localX < background.width / 2;
            
            if (isLeftSide)
            {
                helpInt--;
            }else{
                helpInt++;
            }
    
            helpInt = Std.int(Math.max(minValue, Math.min(maxValue, helpInt)));
            updateDisplay();
        }
    
        if (FlxG.mouse.justReleased)
        {
            canPress = true;
        }
    }
    
    function updateDisplay()
    {
        var text = Std.string(helpInt);
        if (helpInt == minValue) text = 'Min: ' + text;
        else if (helpInt == maxValue) text = 'Max: ' + text;
        
        nowChoose.text = text;
        Reflect.setProperty(ClientPrefs.data, label, helpInt);
    }
}