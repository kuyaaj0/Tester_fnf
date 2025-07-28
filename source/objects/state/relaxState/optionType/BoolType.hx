package objects.state.relaxState.optionType;

class BoolType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    var label:String;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var helpBool:Bool;
    
    var BGwidth:Int = 233;
    var BGheight:Int = 100;
    
    var changeX:Int = 10;
    var changeY:Int = 10;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test'){
        super(X * (BGwidth / 2) + changeX, Y * (BGheight / 2) + changeY);
        
        label = labels;
        helpBool = Reflect.getProperty(ClientPrefs.data, label);
        
        background = new Rect(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth, BGheight, 20, 20, 0xFF403E4E);
        add(background);

        labelText = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY, BGwidth - 5, Language.get(labels, 'relax'));
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 17, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * ((BGwidth + 10) / 2) + changeX, Y * ((BGheight + 10) / 2) + changeY + BGheight - 25, BGwidth - 5, Std.string(Reflect.getProperty(ClientPrefs.data, label)));
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 15, FlxColor.WHITE, LEFT);
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
        
        if(helpBool){
            background.color = FlxColor.interpolate(background.color, 0xFFB5B0DD, 0.3);
        }else{
            background.color = FlxColor.interpolate(background.color, 0xFF403E4E, 0.3);
        }
    }
    
    function updateData(){
        nowChoose.text = Std.string(!helpBool);
        Reflect.setProperty(ClientPrefs.data, label, !helpBool);
        
        helpBool = !helpBool;
    }
}