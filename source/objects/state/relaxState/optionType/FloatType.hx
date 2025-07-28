package objects.state.relaxState.optionType;

class FloatType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    var label:String;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var helpFloat:Float;
    var oneChange:Float;
    
    var maxValue:Float;
    var minValue:Float;
    
    var leftHitbox:FlxSprite;
    var rightHitbox:FlxSprite;
    
    var BGwidth:Int = 233;
    var BGheight:Int = 100;
    
    var changeX:Int = 10;
    var changeY:Int = 10;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', min:Float, max:Float, bit:Float = 0.1){
        super(X * (BGwidth / 2) + changeX, Y * (BGheight / 2) + changeY);
        
        label = labels;
        helpFloat = Reflect.getProperty(ClientPrefs.data, label);
        helpFloat = Math.max(min, Math.min(max, helpFloat));
        
        background = new Rect(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth, BGheight, 20, 20, 0xFF403E4E);
        add(background);

        labelText = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth - 5, Language.get(labels, 'relax'));
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 17, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY + BGheight - 25, BGwidth - 5, Std.string(helpFloat));
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 15, FlxColor.WHITE, LEFT);
        add(nowChoose);

        leftHitbox = new FlxSprite(X * (BGwidth / 2) + changeX, Y * (BGheight / 2)).makeGraphic(Std.int(BGwidth / 2), BGheight, FlxColor.TRANSPARENT);
        leftHitbox.alpha = 0;
        add(leftHitbox);

        rightHitbox = new FlxSprite(X * (BGwidth / 2) + changeX + 175, Y * (BGheight / 2)).makeGraphic(Std.int(BGwidth / 2), BGheight, FlxColor.TRANSPARENT);
        rightHitbox.alpha = 0;
        add(rightHitbox);
        
        oneChange = bit;
        
        maxValue = max;
        minValue = min;
    }
    
    var saveX = 0;
    var saveY = 0;
    
    override public function update(elapsed:Float){
        super.update(elapsed);
        
        if(FlxG.mouse.justPressed){
            saveX = FlxG.mouse.x;
            saveY = FlxG.mouse.y;
        }
        
        if(FlxG.mouse.pressed && canPress){
            if((saveX < FlxG.mouse.x - 5 || saveX > FlxG.mouse.x + 5) ||
              (saveY < FlxG.mouse.y - 5 || saveY > FlxG.mouse.y + 5)){
                canPress = false;
            }
        }
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            isPressed = true;
        }
        
        if (isPressed && FlxG.mouse.justReleased && canPress) {
            isPressed = false;
            updateData()
        }
        
        if (FlxG.mouse.justReleased && canPress && FlxG.mouse.overlaps(this))
        {
            if (FlxG.mouse.overlaps(leftHitbox))
            {
                helpFloat -= oneChange;
            }
            else if (FlxG.mouse.overlaps(rightHitbox))
            {
                helpFloat += oneChange;
            }
        }
        
        if(FlxG.mouse.justReleased){
            canPress = true;
        }
    }
    
    function updateData(){
        helpFloat = Math.max(minValue, Math.min(maxValue, helpFloat));
            
        var text:String = '';
        
        if (helpFloat == minValue) text = 'Min: ' + Std.string(helpFloat);
        else if(helpFloat == maxValue) text = 'Max: ' + Std.string(helpFloat);
            
        nowChoose.text = text;
        Reflect.setProperty(ClientPrefs.data, label, helpFloat);
    }
}