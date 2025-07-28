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

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', min:Float, max:Float, bit:Float = 0.1){
        super(X * 177.5, Y * 77.5);
        
        label = labels;
        helpFloat = Reflect.getProperty(ClientPrefs.data, label);
        helpFloat = Math.max(min, Math.min(max, helpFloat));
        
        background = new Rect(X * 177.5, Y * 77.5, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X * 177.5 + 10, Y * 77.5 + 10, 295, Language.get(labels, 'relax'));
        labelText.autoSize = true;
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 28, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * 177.5 + 10, 110 + Y * 67.5, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 25, FlxColor.WHITE, LEFT);
        add(nowChoose);
        
        leftHitbox = new FlxSprite(X * 177.5, Y * 77.5).makeGraphic(175, 150, FlxColor.TRANSPARENT);
        leftHitbox.alpha = 0;
        add(leftHitbox);

        rightHitbox = new FlxSprite(X * 177.5 + 175, Y * 77.5).makeGraphic(175, 150, FlxColor.TRANSPARENT);
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