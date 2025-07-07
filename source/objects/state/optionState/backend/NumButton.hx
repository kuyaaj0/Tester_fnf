package objects.state.optionState.backend;

import openfl.display.Shape;
import openfl.display.BitmapData;

class NumButton extends FlxSpriteGroup {

    var follow:Option;

    var innerX:Float; //该摁键在option的x
    var innerY:Float; //该摁键在option的y

    var deleteButton:FlxSprite;
    var addButton:FlxSprite;
	

    public function new(X:Float, Y:Float, width:Float, height:Float, follow:Option) {
        super(X, Y);

        this.follow = follow;
        innerX = X;
        innerY = Y;

        deleteButton = new FlxSprite();
        deleteButton.loadGraphic(createButton(height * 0.75, 0xFF6363, '-'));
        deleteButton.antialiasing = ClientPrefs.data.antialiasing;
        deleteButton.y += (height - deleteButton.height) / 2;
        add(deleteButton);

        addButton = new FlxSprite();
        addButton.loadGraphic(createButton(height * 0.75, 0x63FF75, '+'));
        addButton.antialiasing = ClientPrefs.data.antialiasing;
        addButton.x += width - addButton.width;
        addButton.y += (height - addButton.height) / 2;
        add(addButton);
    }
    
    private function createButton(size:Float, color:Int, symbol:String) {
        // 绘制按钮背景
        var button = new Shape();
        button.graphics.beginFill(color);
        button.graphics.drawRoundRect(0, 0, size, size, size / 4, size / 4);
        button.graphics.endFill();
        
        // 绘制符号
        button.graphics.lineStyle(3, 0xffffff); // 白色线条，3像素粗
        
        if (symbol == "+") {
            // 绘制加号：横线
            button.graphics.moveTo(size * 0.2, size * 0.5);
            button.graphics.lineTo(size * 0.8, size * 0.5);
            // 绘制加号：竖线
            button.graphics.moveTo(size * 0.5, size * 0.2);
            button.graphics.lineTo(size * 0.5, size * 0.8);
        } else if (symbol == "-") {
            // 绘制减号：横线
            button.graphics.moveTo(size * 0.2, size * 0.5);
            button.graphics.lineTo(size * 0.8, size * 0.5);
        }
        var bitmap:BitmapData = new BitmapData(Std.int(size), Std.int(size), true, 0);
		bitmap.draw(button);
		return bitmap;
    }
}