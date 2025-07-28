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

    var leftHitbox:FlxSprite;
    var rightHitbox:FlxSprite;
    
    var BGwidth:Int = 233;
    var BGheight:Int = 100;
    
    var changeX:Int = 10;
    var changeY:Int = 10;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', min:Int, max:Int)
    {
        super(X * (BGwidth / 2) + changeX, Y * (BGheight / 2) + changeY);
        
        label = labels;
        helpInt = Reflect.getProperty(ClientPrefs.data, label);
        helpInt = Std.int(Math.max(min, Math.min(max, helpInt)));
        
        maxValue = max;
        minValue = min;

        background = new Rect(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth, BGheight, 20, 20, 0xFF403E4E);
        add(background);

        labelText = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth - 5, Language.get(labels, 'relax'));
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 17, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY + BGheight - 25, BGwidth - 5, Std.string(helpInt));
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 15, FlxColor.WHITE, LEFT);
        add(nowChoose);

        leftHitbox = new FlxSprite(X * (BGwidth / 2) + changeX, Y * (BGheight / 2) + changeY).makeGraphic(Std.int(BGwidth / 2), BGheight, FlxColor.TRANSPARENT);
        leftHitbox.alpha = 0;
        add(leftHitbox);

        rightHitbox = new FlxSprite(X * (BGwidth / 2) + changeX + 175, Y * (BGheight / 2) + changeY).makeGraphic(Std.int(BGwidth / 2), BGheight, FlxColor.TRANSPARENT);
        rightHitbox.alpha = 0;
        add(rightHitbox);
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
    
        if (FlxG.mouse.justReleased && canPress && FlxG.mouse.overlaps(this))
        {
            if (FlxG.mouse.overlaps(leftHitbox))
            {
                helpInt--;
            }
            else if (FlxG.mouse.overlaps(rightHitbox))
            {
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