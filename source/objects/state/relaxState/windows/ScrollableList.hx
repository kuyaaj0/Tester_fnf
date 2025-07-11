package objects.state.relaxState.windows;

class ScrollableList {
    //这个类只适用于ListButtons --MaoPou
    public var items:Array<ListButtons>;
    public var scrollY:Float = 0;
    public var targetScrollY:Float = 0;
    public var minScrollY:Float = 0;
    public var maxScrollY:Float = 0;
    public var isDragging:Bool = false;
    public var dragStartY:Float = 0;
    public var velocity:Float = 0;
    public var lastY:Float = 0;
    
    public function new() {
        items = [];
    }
    
    public function update(elapsed:Float):Void {
        // 惯性滑动
        if (!isDragging) {
            velocity *= 0.9; // 摩擦力
            targetScrollY += velocity;
            
            // 边界检查
            if (targetScrollY > maxScrollY) {
                targetScrollY = maxScrollY;
                velocity = 0;
            } else if (targetScrollY < minScrollY) {
                targetScrollY = minScrollY;
                velocity = 0;
            }
            
            // 平滑滚动
            scrollY += (targetScrollY - scrollY) * 0.2;
        }
        
        // 更新按钮位置
        for (i in 0...items.length) {
            var button = items[i];
            button.y = 120 + i * 45 + scrollY;
            button.allowChoose = !isDragging;
        }
    }
    
    public function handleInput():Void {
        var mouseY = FlxG.mouse.y;
        
        if (FlxG.mouse.justPressed) {
            isDragging = true;
            dragStartY = mouseY;
            lastY = mouseY;
            velocity = 0;
        }
        
        if (FlxG.mouse.pressed && isDragging) {
            var deltaY = mouseY - lastY;
            scrollY += deltaY;
            targetScrollY = scrollY;
            lastY = mouseY;
            velocity = deltaY;
        }
        
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
    }
}