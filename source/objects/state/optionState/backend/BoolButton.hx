package objects.state.optionState.backend;

class BoolButton extends FlxSpriteGroup {
    var bg:Rect;
    var dis:FlxSprite;

    var follow:Option;

    var innerX:Float; //该摁键在option的x
    var innerY:Float; //该摁键在option的y

    public function new(X:Float, Y:Float, width:Float, height:Float, follow:Option) {
        super(X, Y);

        this.follow = follow;
        innerX = X;
        innerY = Y;

        bg = new Rect(0, 0, width, height, width / 20, width / 20, 0xFF6363, 0.8);
        add(bg);

        dis = new Rect(2, 2, width / 2 - 4, height - 4, width / 20, width / 20, 0xFFFFFF, 0.8);
        add(dis);

        if (follow.defaultValue == true) {
            bg.color = 0x63FF75;
            dis.x += width / 2 - 1;
        }
    }

    public var allowUpdate:Bool = true;
    override function update(elapsed:Float) {
        super.update(elapsed);
        
        if (!allowUpdate) return;
        
        var mouse = FlxG.mouse;

        var inputAllow:Bool = true;
        
        if (inputAllow) {
            // Check if mouse is over the button
            if (mouse.overlaps(bg)) {
                // Mouse released
                if (mouse.justReleased) {
                    // Check if mouse is on left or right side
                    var localX = mouse.getScreenPosition().x - this.x;
                    var isRightSide = localX > bg.width / 2;
                    
                    // Change value based on mouse position
                    change(isRightSide);
                }
            }
        }
    }

    var moveTween:FlxTween;
    function change(data:Bool) {
        // Only proceed if value is actually changing
        if (follow.defaultValue == data) return;
        
        follow.defaultValue = data;
        
        if (moveTween != null) moveTween.cancel();
        var targetX = data ? bg.width / 2 + 1 : 2;
        moveTween = FlxTween.tween(dis, { x: follow.followX + follow.innerX + innerX + targetX}, 0.2, { ease: FlxEase.quadOut });
        
        // Tween the background color
        var targetColor = data ? 0x63FF75 : 0xFF6363;
        //FlxTween.color(bg, 0.2, bg.color, targetColor, { ease: FlxEase.quadOut });
        bg.color = targetColor;  //为什么几把不能用tween
        
        if (follow.onChange != null) follow.onChange();
    }
}