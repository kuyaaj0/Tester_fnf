package objects.state.relaxState;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class ButtonSprite extends FlxSprite
{
   /**
    * 创建一个梯形按钮
    * @param X 按钮X坐标
    * @param Y 按钮Y坐标
    * @param width 按钮宽度
    * @param height 按钮高度
    * @param shortSide 短边长度
    * @param direction 梯形方向
    */
    public function new(X:Float = 0, Y:Float = 0, width:Int = 100, height:Int = 50, shortSide:Int = 50, direction:String = "right")
    {
        super(X, Y);
        
        // 创建透明背景
        makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        
        // 计算斜边斜率
        var slope = (width - shortSide) / height;
        // 逐行绘制
        for (y in 0...height) {
            var startX:Int = 0;
            var endX:Int = width;
            
            if (direction == "right") {
                endX = Std.int(width - slope * y);
                startX = 0;
            } else if (direction == "left") {
                startX = Std.int(slope * y);
                endX = width;
            }
            
            for (x in startX...endX) {
                pixels.setPixel32(x, y, 0xFF24232C);
            }
        }
    }
}