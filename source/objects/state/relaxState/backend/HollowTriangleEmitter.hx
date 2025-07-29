package objects.state.relaxState.backend;

import flixel.util.FlxSpriteUtil;

import substate.RelaxSubState;

class HollowTriangleEmitter extends FlxTypedGroup<FlxSprite> {
    var emissionRate:Float = 0.5; // 每几秒发射一个三角形
    var emissionTimer:Float = 0;  // 发射计时器
    var maxTriangles:Int = 100;   // 最大三角形数量
    
    // 三角形属性范围
    var minHeight:Int = 20;   // 最小高度
    var maxHeight:Int = 100;  // 最大高度
    var minSpeed:Int = 10;    // 最小速度
    var maxSpeed:Int = 20;    // 最大速度
    
    // 对象池
    var trianglePool:Array<FlxSprite> = [];
    
    public function new() {
        super();
        
        for (i in 0...maxTriangles) {
            var triangle = createTriangle();
            triangle.kill();
            trianglePool.push(triangle);
        }
    }
    
    function createTriangle():FlxSprite {
        var triangle = new FlxSprite();
        triangle.makeGraphic(1, 1, FlxColor.TRANSPARENT); // 创建透明图像
        
        triangle.x = 0;
        triangle.y = 0;
        triangle.visible = false;
        
        add(triangle);
        return triangle;
    }
    
    // 发射一个新三角形
    function spawnTriangle():Void {
        // 从对象池中找一个可用的三角形
        var triangle:FlxSprite = null;
        
        for (t in trianglePool) {
            if (!t.exists) {
                triangle = t;
                break;
            }
        }
        
        if (triangle == null) {
            triangle = createTriangle();
            trianglePool.push(triangle);
        }
        
        triangle.x = FlxG.random.int(0, 1280);
        var height = FlxG.random.int(minHeight, maxHeight);
        triangle.y = height + 720;
        triangle.visible = true;
        
        triangle.pixels.fillRect(triangle.pixels.rect, FlxColor.TRANSPARENT);
        
        // 绘制空心三角形
        FlxSpriteUtil.drawTriangle(
            triangle,
            triangle.x,
            triangle.y,
            height,
            FlxColor.TRANSPARENT,
            {
                thickness: 5,
                color: FlxColor.WHITE
            }
        );
        
        triangle.velocity.y = -FlxG.random.int(minSpeed, maxSpeed);
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        emissionTimer += elapsed;
        while (emissionTimer > 1/emissionRate) {
            emissionTimer -= 1/emissionRate;
            spawnTriangle(); // 发射新三角形
        }
        
        for (triangle in members) {
            if (triangle.exists) {
                triangle.y += triangle.velocity.y * elapsed;
                triangle.y -= RelaxSubState.instance.audio.amplitude * elapsed * 50;
                
                // 如果移出屏幕就回收
                if (triangle.y + triangle.height < 0) {
                    triangle.kill();
                }
            }
        }
    }
    
    public function setEmissionRate(rate:Float):Void {
        emissionRate = rate;
    }
}