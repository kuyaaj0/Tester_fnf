package backend.data;

import objects.screen.Data.DataGet;

class EngineSet
{
    static public var mainColor:FlxColor = 0x96B5FF;
    static public var minorColor:FlxColor = 0xFF90DC;

    static public function FPSfix(data:Float):Float {
        return data * 60 / DataGet.currentFPS;
    }
}

