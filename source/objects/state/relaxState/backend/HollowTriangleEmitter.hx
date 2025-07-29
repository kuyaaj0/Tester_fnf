package objects.state.relaxState.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class HollowTriangleEmitter extends FlxTypedGroup<FlxSprite>
{
    // 发射控制
    public var emissionRate:Float = 10; // 每秒发射数量
    var emissionTimer:Float = 0;
    
    // 三角形属性
    var minSize:Int = 20;  // 最小尺寸
    var maxSize:Int = 50;  // 最大尺寸
    var minSpeed:Int = 80; // 最小速度
    var maxSpeed:Int = 150;// 最大速度
    
    // 对象池
    var poolSize:Int = 100;
    var trianglePool:Array<FlxSprite> = [];
    
    public var externalSpeedFactor:Float = 1.0;
    
    public function new() 
    {
        super();
        initializePool();
    }
    
    function initializePool():Void
    {
        for (i in 0...poolSize)
        {
            var triangle = createTriangle();
            triangle.kill();
            trianglePool.push(triangle);
        }
    }
    
    function createTriangle():FlxSprite
    {
        var triangle = new FlxSprite();
        triangle.makeGraphic(maxSize * 2, maxSize * 2, FlxColor.TRANSPARENT, true);
        triangle.offset.set(maxSize, maxSize);
        add(triangle);
        return triangle;
    }
    
    public function spawnTriangle():Void
    {
        var triangle = getAvailableTriangle();
        if (triangle == null) return;
        
        var size = FlxG.random.int(minSize, maxSize);
        
        triangle.x = FlxG.random.float(-size, FlxG.width + size);
        triangle.y = FlxG.height + size;
        
        triangle.velocity.y = -FlxG.random.int(minSpeed, maxSpeed);
        triangle.velocity.x = FlxG.random.float(-20, 20);
        
        drawTriangle(triangle, size);
        
        triangle.revive();
    }
    
    function getAvailableTriangle():FlxSprite
    {
        for (triangle in trianglePool)
            if (!triangle.exists)
                return triangle;
                
        // 如果池子用尽，创建新三角形（但应该不会发生，因为update会回收）
        var newTriangle = createTriangle();
        trianglePool.push(newTriangle);
        return newTriangle;
    }
    
    function drawTriangle(sprite:FlxSprite, size:Float):Void
    {
        // 清除之前内容
        sprite.pixels.fillRect(sprite.pixels.rect, FlxColor.TRANSPARENT);
        
        // 在精灵中心绘制三角形
        var centerX = sprite.width / 2;
        var centerY = sprite.height / 2;
        
        FlxSpriteUtil.drawTriangle(
            sprite,
            centerX, centerY - size/2,    // 顶点
            centerX - size/2, centerY + size/2, // 左下角
            centerX + size/2, centerY + size/2, // 右下角
            FlxColor.TRANSPARENT, // 透明填充
            {
                thickness: 2, 
                color: FlxColor.CYAN, // 青色边框
                pixelHinting: true
            }
        );
        
        sprite.dirty = true;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        emissionTimer += elapsed;
        while (emissionTimer > 1 / emissionRate)
        {
            emissionTimer -= 1 / emissionRate;
            spawnTriangle();
        }
        
        for (triangle in members)
        {
            if (triangle.exists)
            {
                triangle.y += triangle.velocity.y * elapsed * externalSpeedFactor;
                triangle.x += triangle.velocity.x * elapsed;
                
                triangle.angle += triangle.velocity.x * 0.2;

                if (triangle.y + triangle.height < 0 || 
                    triangle.x + triangle.width < 0 || 
                    triangle.x > FlxG.width)
                {
                    triangle.kill();
                }
            }
        }
    }
    
    public function setParams(
        rate:Float = 10, 
        minS:Int = 20, maxS:Int = 50, 
        minSpd:Int = 80, maxSpd:Int = 150
    ):Void
    {
        emissionRate = rate;
        minSize = minS;
        maxSize = maxS;
        minSpeed = minSpd;
        maxSpeed = maxSpd;
    }
}