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
    private var color:FlxColor;
    public var externalSpeedFactor:Float = 1.0;
    public var targetCamera:FlxCamera;
    public var followCamera:Bool = true;
    private var time:Float = 0;
    private var variationSpeed:Float;
    private var worldX:Float = 0;
    private var worldY:Float = 0;

    public function new(?camera:FlxCamera) 
    {
        super();
        this.targetCamera = camera != null ? camera : FlxG.camera;
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
        
        var vertices = new Array<Float>();
        vertices.push(drawX + size/2); vertices.push(drawY);      // 顶点
        vertices.push(drawX); vertices.push(drawY + size);        // 左下角
        vertices.push(drawX + size); vertices.push(drawY + size); // 右下角
        
        var graphic = FlxSpriteUtil.makeGraphic(this, 
            Std.int(size + 2), 
            Std.int(size + 2), 
            FlxColor.TRANSPARENT, 
            true);
        
        FlxSpriteUtil.drawPolygon(graphic, vertices, color, { thickness: 2 });
    }
}