package objects.state.relaxState.backend;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.Graphics;

class HollowTriangleEmitter extends FlxBasic
{
    public var triangles:FlxTypedGroup<HollowTriangle>;
    private var spawnTimer:Float = 0;
    private var spawnInterval:Float = 0.3;
    public var externalSpeedFactor:Float = 1.0;
    public var targetCamera:FlxCamera;
    public var followCamera:Bool = true;

    public function new(?camera:FlxCamera, followCamera:Bool = true) 
    {
        super();
        this.targetCamera = camera != null ? camera : FlxG.camera;
        this.followCamera = followCamera;
        triangles = new FlxTypedGroup<HollowTriangle>();
        for (i in 0...10) spawnTriangle();
    }
    
    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);
        spawnTimer += elapsed;
        if (spawnTimer >= spawnInterval)
        {
            spawnTimer = 0;
            spawnTriangle();
            spawnInterval = FlxG.random.float(0.1, 0.5);
        }
        triangles.forEachAlive(function(triangle:HollowTriangle) {
            triangle.externalSpeedFactor = this.externalSpeedFactor;
            triangle.followCamera = this.followCamera;
            if (triangle.y < -triangle.size * 2) triangle.kill();
        });
    }
    
    private function spawnTriangle():Void
    {
        var triangle = triangles.recycle(HollowTriangle);
        if (triangle == null) triangle = new HollowTriangle(targetCamera);
        triangle.init(
            FlxG.random.float(0, FlxG.width - 50),
            FlxG.height + FlxG.random.float(20, 100),
            FlxG.random.float(15, 60),
            FlxG.random.float(50, 200)
        );
        triangle.externalSpeedFactor = this.externalSpeedFactor;
        triangle.followCamera = this.followCamera;
        triangles.add(triangle);
    }
    
    override public function draw():Void 
    {
        super.draw();
        triangles.draw();
    }
    
    public function setCamera(camera:FlxCamera, follow:Bool = true):Void
    {
        this.targetCamera = camera;
        this.followCamera = follow;
        triangles.forEachAlive(function(triangle:HollowTriangle) {
            triangle.targetCamera = camera;
            triangle.followCamera = follow;
        });
    }
}

class HollowTriangle extends FlxBasic
{
    public var x:Float;
    public var y:Float;
    public var size:Float;
    private var baseSpeed:Float;
    private var speedVariation:Float = 0;
    public var color:FlxColor;
    public var externalSpeedFactor:Float = 1.0;
    public var targetCamera:FlxCamera;
    public var followCamera:Bool = true;
    private var time:Float = 0;
    private var variationSpeed:Float;
    private var worldX:Float = 0;
    private var worldY:Float = 0;

    // 用于绘制的临时精灵
    private var drawSprite:FlxSprite;

    public function new(?camera:FlxCamera) 
    {
        super();
        this.targetCamera = camera != null ? camera : FlxG.camera;
        
        // 创建用于绘制的精灵
        drawSprite = new FlxSprite();
        drawSprite.makeGraphic(1, 1, FlxColor.TRANSPARENT, true);
    }

    public function init(x:Float, y:Float, size:Float, baseSpeed:Float):Void
    {
        this.x = x;
        this.y = y;
        this.size = size;
        this.baseSpeed = baseSpeed;
        this.worldX = x;
        this.worldY = y;
        
        color = FlxColor.fromRGB(
            Std.int(FlxG.random.float(100, 255)),
            Std.int(FlxG.random.float(100, 255)),
            Std.int(FlxG.random.float(100, 255))
        );
        
        variationSpeed = FlxG.random.float(0.5, 2.0);
        alive = true;
        exists = true;
        visible = true;
    }

    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);
        time += elapsed;
        speedVariation = Math.sin(time * variationSpeed) * baseSpeed * 0.3;
        worldY -= (baseSpeed + speedVariation) * externalSpeedFactor * elapsed;
        
        if (followCamera)
        {
            x = worldX;
            y = worldY;
        }
        else
        {
            y -= (baseSpeed + speedVariation) * externalSpeedFactor * elapsed;
            worldX = x;
            worldY = y;
        }
    }

    override public function draw():Void 
    {
        super.draw();
        
        var drawX:Float = x;
        var drawY:Float = y;
        
        if (!followCamera && targetCamera != null)
        {
            drawX = x - targetCamera.scroll.x;
            drawY = y - targetCamera.scroll.y;
        }
        
        drawSprite.x = drawX;
        drawSprite.y = drawY;
        drawSprite.scale.set(size, size);
        
        // 清除之前的绘制
        drawSprite.pixels.fillRect(drawSprite.pixels.rect, FlxColor.TRANSPARENT);
        
        // 绘制空心三角形
        var vertices = [
            FlxPoint.get(0.5, 0),    // 顶点
            FlxPoint.get(0, 1),      // 左下角
            FlxPoint.get(1, 1)       // 右下角
        ];
        
        FlxSpriteUtil.drawPolygon(drawSprite, vertices, color, { thickness: 2 });

        for (point in vertices) {
            point.put();
        }
        
        // 绘制到屏幕上
        drawSprite.draw();
    }

    override public function destroy():Void 
    {
        if (drawSprite != null) {
            drawSprite.destroy();
            drawSprite = null;
        }
        super.destroy();
    }
}