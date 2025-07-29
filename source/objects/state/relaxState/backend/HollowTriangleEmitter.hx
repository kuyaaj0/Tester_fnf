package objects.state.relaxState.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class HollowTriangleEmitter extends FlxTypedGroup<FlxSprite>
{
    // 发射控制
    public var emissionRate:Float = 10; // 每秒发射数量
    var emissionTimer:Float = 0;
    
    // 三角形属性
    var minTriangleSize:Int = 20;  // 最小尺寸
    var maxTriangleSize:Int = 50;  // 最大尺寸
    var minSpeed:Int = 80; // 最小速度
    var maxSpeed:Int = 150;// 最大速度
    
    // 对象池
    var poolSize:Int = 100;
    var trianglePool:Array<FlxSprite> = [];
    
    // 外部影响因子
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
        triangle.makeGraphic(maxTriangleSize * 2, maxTriangleSize * 2, FlxColor.TRANSPARENT, true);
        triangle.offset.set(maxTriangleSize, maxTriangleSize); // 中心点对齐
        add(triangle);
        return triangle;
    }
    
    public function spawnTriangle():Void
    {
        var triangle = getAvailableTriangle();
        if (triangle == null) return;
        
        var size = FlxG.random.int(minTriangleSize, maxTriangleSize);
        
        // 设置初始位置
        triangle.x = FlxG.random.float(-size, FlxG.width + size);
        triangle.y = FlxG.height + size;
        
        // 设置速度
        triangle.velocity.y = -FlxG.random.int(minSpeed, maxSpeed);
        triangle.velocity.x = FlxG.random.float(-20, 20);
        
        // 绘制三角形
        drawTriangle(triangle, size);
        
        triangle.revive();
    }
    
    function getAvailableTriangle():FlxSprite
    {
        for (triangle in trianglePool)
            if (!triangle.exists)
                return triangle;
                
        var newTriangle = createTriangle();
        trianglePool.push(newTriangle);
        return newTriangle;
    }
    
    function drawTriangle(sprite:FlxSprite, size:Float):Void
    {
        // 清除之前内容
        sprite.pixels.fillRect(sprite.pixels.rect, FlxColor.TRANSPARENT);
        
        // 使用新版FlxSpriteUtil.drawPolygon
        var vertices = [
            FlxPoint.get(sprite.width/2, sprite.height/2 - size/2),    // 顶点
            FlxPoint.get(sprite.width/2 - size/2, sprite.height/2 + size/2), // 左下
            FlxPoint.get(sprite.width/2 + size/2, sprite.height/2 + size/2)  // 右下
        ];
        
        FlxSpriteUtil.drawPolygon(
            sprite,
            vertices,
            FlxColor.TRANSPARENT, // 填充色
            {
                thickness: 2, 
                color: FlxColor.CYAN,
                pixelHinting: true
            }
        );
        
        // 释放顶点内存
        for (point in vertices) point.put();
        
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
        minTriangleSize = minS;
        maxTriangleSize = maxS;
        minSpeed = minSpd;
        maxSpeed = maxSpd;
    }
}