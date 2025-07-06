package options.backend;

import flixel.FlxBasic;
import flixel.math.FlxMath;

class MouseMove extends FlxBasic
{
    public var allowUpdate:Bool;
    
    public var target:Float;
    public var moveLimit:Array<Float> = [];  //[min, max]
    public var mouseLimit:Array<Array<Float>> = [];   //[ X[min, max], Y[min, max] ]
    
    public var event:Dynamic->Void = null;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var isDragging:Bool = false;
    private var lastMouseY:Float = 0;
    private var velocity:Float = 0;
    private var velocityArray:Array<Float> = [];
    
    // 物理参数
    public var dragSensitivity:Float = 1.0;   // 拖动灵敏度
    public var deceleration:Float = 0.9;      // 减速系数 (0.9 - 0.99 效果较好)
    public var minVelocity:Float = 0.001;       // 最小速度阈值
    
    // 鼠标滚轮相关参数
    public var mouseWheelSensitivity:Float = 20.0; // 鼠标滚轮更改量的控制变量
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    public function new(tar:Float, moveData:Array<Float>, mouseData:Array<Array<Float>>, onClick:Dynamic->Void = null, needUpdate:Bool = true) {
        super();
        this.allowUpdate = needUpdate;
        
        this.target = tar; //好像确实没啥用，但是可以用来初始化数据 --狐月影
        this.moveLimit = moveData;
        this.mouseLimit = mouseData;
        
        
        this.event = onClick;
    }
    
    var moveCheck:Float = 0;
    override function update(elapsed:Float) {
        super.update(elapsed);
        
        if (!allowUpdate) return;
        
        var mouse = FlxG.mouse;

        var inputAllow:Bool = true;

        if (!(mouse.x > mouseLimit[0][0] && mouse.x < mouseLimit[0][1] && mouse.y > mouseLimit[1][0] && mouse.y < mouseLimit[1][1])) {
            if (isDragging) 
                endDrag();
            inputAllow = false;
        }
        
        if (inputAllow) {
            // 鼠标滚轮
            if (mouse.wheel!= 0) {
                velocity += mouse.wheel * mouseWheelSensitivity;
            }
            
            // 鼠标按下
            if (mouse.justPressed) {
                startDrag(mouse.y);
            }
            
            // 拖动中更新位置
            if (isDragging && mouse.pressed) {
                updateDrag(mouse.y);
            }
            // 鼠标释放时停止拖动
            else if (isDragging && mouse.justReleased) {
                endDrag();
            }
        }
        
        // 惯性滑动
        if (!isDragging && Math.abs(velocity) > minVelocity) {
            applyInertia(elapsed);
        }
        
        if (target < moveLimit[0]) target = FlxMath.lerp(moveLimit[0], target, Math.exp(-elapsed * 20));
        if (target > moveLimit[1]) target = FlxMath.lerp(moveLimit[1], target, Math.exp(-elapsed * 20));

        if (Math.abs(moveCheck - target) > 1)  moveCheck = target;
        else return;
        
        if (event!= null) {
            event(null);
        }
    }
    
    private function startDrag(startY:Float) {
        isDragging = true;
        lastMouseY = startY;
        velocity = 0;
    }
    
    private function updateDrag(currentY:Float) {
        var deltaY = currentY - lastMouseY;
        velocity = deltaY * dragSensitivity;
        target += velocity;
        lastMouseY = currentY;

        velocUpdate(velocity);
    }
    
    private function endDrag() {
        isDragging = false;
        velocityChange();
    }
    
    private function applyInertia(elapsed:Float) {
        velocity *= Math.pow(deceleration, elapsed * 60);
        target += velocity * elapsed * 60;
    }

    var dataCheck:Bool = true; //正数检测
    private function velocUpdate(data:Float) {
        if (data == 0) return; //都是0了加权个几把
        if (dataCheck) { //之前是正数
            if (data > 0) { //正数
                velocityArray.push(velocity);
                if (velocityArray.length > 11) velocityArray.shift();
            } else { //负数
                velocityArray = [];
                velocityArray.push(velocity);
                dataCheck = false;
            }
        } else { //之前是负数
            if (data < 0) { //负数
                velocityArray.push(velocity);
                if (velocityArray.length > 11) velocityArray.shift();
            } else { //正数
                velocityArray = [];
                velocityArray.push(velocity);
                dataCheck = true;
            }
        } 
    }

    private function velocityChange() {
        var arr = velocityArray;
        arr.sort(Reflect.compare);

        var delete:Int = Std.int(arr.length / 4);
        arr.splice(0, delete);
        arr.splice(arr.length - delete - 1, delete);

        var sum:Float = 0;
        for (num in arr) {
            sum += num;
        }
        sum = sum / arr.length;

        velocity = EngineSet.FPSfix(sum, true); //帧数平衡修复
    }
}