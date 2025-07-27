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

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', max:Int, min:Int){
        super(X * 355, Y * 155);
        
        label = labels;
        
        helpInt = Reflect.getProperty(ClientPrefs.data, label);
        helpInt = Std.int(Math.max(min, Math.min(max, helpInt)));
        
        maxValue = max;
        minValue = min;
        
        background = new Rect(X * 177.5, Y * 77.5, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(background.x + 10, background.y + 10, 295, Language.get(labels, 'relax'));
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 28, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(labelText.x, 110 + Y * 67.5, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font("montserrat.ttf"), 25, FlxColor.WHITE, LEFT);
        add(nowChoose);
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
            updateData();
        }
        
        if(FlxG.mouse.justReleased){
            canPress = true;
        }
    }
    
    function updateData(){
        var localX = FlxG.mouse.x - this.x;
        var buttonWidth = background.width;
            
        if (localX < buttonWidth / 2) {
            helpInt --;
        } else {
            helpInt ++;
        }
        
        helpInt = Std.int(Math.max(minValue, Math.min(maxValue, helpInt)));
        
        var text:String = '';
        
        if (helpInt == minValue) text = 'Min: ' + Std.string(helpInt);
        else if(helpInt == maxValue) text = 'Max: ' + Std.string(helpInt);
            
        nowChoose.text = text;
        Reflect.setProperty(ClientPrefs.data, label, helpInt);
    }
}