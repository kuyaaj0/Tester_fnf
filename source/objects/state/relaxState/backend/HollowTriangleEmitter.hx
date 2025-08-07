package objects.state.relaxState.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;

class HollowTriangleEmitter extends FlxTypedGroup<FlxSprite>
{
    // 发射控制
    public var emissionRate:Float = 1; // 发射频率
    var emissionTimer:Float = 0;
    
    var minTriangleSize:Int = 100;  // 最小尺寸
    var maxTriangleSize:Int = 400;  // 最大尺寸
    var minSpeed:Int = 5;         // 最小速度
    var maxSpeed:Int = 10;         // 最大速度
    
    // 对象池
    var poolSize:Int = 100;
    var trianglePool:Array<FlxSprite> = [];
    
    public var externalSpeedFactor:Float = 0;
    
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
        triangle.makeGraphic(maxTriangleSize * 3, maxTriangleSize * 3, FlxColor.TRANSPARENT, true);
        triangle.offset.set(maxTriangleSize * 1.5, maxTriangleSize * 1.5); // 中心点对齐
        add(triangle);
        return triangle;
    }
    
    public function spawnTriangle():Void
    {
        var triangle = getAvailableTriangle();
        if (triangle == null) return;
        
        var size = FlxG.random.int(minTriangleSize, maxTriangleSize);
        
        triangle.x = FlxG.random.float(0, FlxG.width);
        triangle.y = FlxG.height + size; 

        triangle.velocity.y = -FlxG.random.int(minSpeed, maxSpeed);
        triangle.velocity.x = 0;
        
        drawSolidTriangle(triangle, size);
        
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
    
    function drawSolidTriangle(sprite:FlxSprite, size:Float):Void
    {
        sprite.pixels.fillRect(sprite.pixels.rect, FlxColor.TRANSPARENT);
        
        var centerX = sprite.width / 2;
        var centerY = sprite.height / 2;
        
        var vertices = [
            FlxPoint.get(centerX, centerY - size/2),     // 顶点
            FlxPoint.get(centerX - size/2, centerY + size/2), // 左下
            FlxPoint.get(centerX + size/2, centerY + size/2)  // 右下
        ];
        
        FlxSpriteUtil.drawPolygon(
            sprite,
            vertices,
            FlxColor.BLACK,
            {
                thickness: 3,
                color: FlxColor.BLACK,
                pixelHinting: true
            }
        );
        
        for (point in vertices) point.put();
        
        sprite.dirty = true;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        emissionRate = emissionRate * externalSpeedFactor / 50;
        
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
                triangle.y += (triangle.velocity.y - externalSpeedFactor * 100) * elapsed;
                
                if (triangle.y + triangle.height < 0)
                {
                    triangle.kill();
                }
            }
        }
    }
    
    public function setParams(
        rate:Float = 5, 
        minS:Int = 40, maxS:Int = 80, 
        minSpd:Int = 30, maxSpd:Int = 60
    ):Void
    {
        emissionRate = rate;
        minTriangleSize = minS;
        maxTriangleSize = maxS;
        minSpeed = minSpd;
        maxSpeed = maxSpd;
    }
}