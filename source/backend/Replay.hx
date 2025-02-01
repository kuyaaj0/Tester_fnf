package backend;

class Replay
{
    //整个组>摁压类型>行数>时间
    static public var saveData:Array<Array<Array<Float>>> = [
        [
            [],
            [],
            [],
            []
        ],
        [   
            [],
            [],
            [],
            []
        ]
    ];

    static public var hitData:Array<Array<Array<Float>>> = [
        [
            [],
            [],
            [],
            []
        ],
        [   
            [],
            [],
            [],
            []
        ]
    ];
    
    static public var songName:String = '';    
    static public var songScore:Int = 0;
    static public var songLength:Float = 0;
    static public var songHits:Int = 0;
    static public var songMisses:Int = 0;
        
    static public var ratingPercent:Float = 0;
    static public var ratingFC:String = '';
    static public var ratingName:String = '';
    
    static public var highestCombo:Int = 0; 
    static public var NoteTime:Array<Float> = [];  
    static public var NoteMs:Array<Float> = [];
    
    
    /////////////////////////////////////////////

    static public function push(time:Float, type:Int, state:Int) 
    {
        if (!PlayState.replayMode) saveData[state][type].push(time);
    }
    
    static var isPaused:Bool = false;
    static var checkArray:Array<Float> = [-9999, -9999, -9999, -9999];
    static public function pauseCheck(time:Float, type:Int) 
    {
        if (PlayState.replayMode) return;
        checkArray[type] = time;
    }

    static public function keysCheck()
    {
        if (!PlayState.replayMode)
        {
            if (isPaused) {                
                for (key in 0...4)
                    if (!PlayState.instance.controls.pressed(PlayState.instance.keysArray[key]) && checkArray[key] != -9999)
                        push(checkArray[key], key, 1);
                
                checkArray = [-9999, -9999, -9999, -9999];
                isPaused = false;
            }
        } else {
            for (type in 0...4)
            {
                if (hitData[1][type].length > 0 && hitData[1][type][0] < Conductor.songPosition) holdCheck(type);
            }
        }
    }

    static var allowHit:Array<Bool> = [true, true, true, true];
    static function holdCheck(type:Int) {
        if (hitData[0][type][0] >= Conductor.songPosition) 
        {
            PlayState.instance.keysCheck(type, Conductor.songPosition);
            if (allowHit[type])
            {
                PlayState.instance.keyPressed(type, hitData[1][type][0]);
                allowHit[type] = false;
            }
        }
        else
        {
            PlayState.instance.keysCheck(type, Conductor.songPosition); //长键多一帧的检测
            if (allowHit[type]) {
                PlayState.instance.keyPressed(type, hitData[1][type][0]); //摁下松开时间如果太短导致没检测到
            }
            PlayState.instance.keyReleased(type);
            allowHit[type] = true;
            hitData[0][type].splice(0, 1);
            hitData[1][type].splice(0, 1);
        }
    }

    static public function init()
    {
        hitData = 
        [
            [
                [],
                [],
                [],
                []
            ],
            [   
                [],
                [],
                [],
                []
            ]
        ];
        for (state in 0...2)
            for (type in 0...4)
                for (hit in 0...saveData[state][type].length)
                {
                    hitData[state][type].push(saveData[state][type][hit]);
                }
        allowHit = [true, true, true, true];

        //只能这么复制 --狐月影
    }

    static public function reset() 
    {
        saveData = hitData = 
        [
            [
                [],
                [],
                [],
                []
            ],
            [   
                [],
                [],
                [],
                []
            ]
        ];
        checkArray = [-9999, -9999, -9999, -9999];
        isPaused = false;
    }   //愚蠢但是有用 --狐月影        
    
    static public function putDetails(putData:Array<Dynamic>)
    {
        songName = putData[0];
        songScore = putData[1];
        songLength = putData[2];
        songHits = putData[3];
        songMisses = putData[4];
        ratingPercent = putData[5];
        ratingFC = putData[6];
        ratingName = putData[7];
        highestCombo = putData[8];
        NoteTime = putData[9];
        NoteMs = putData[10];
    } //六百六十六 -狐月影
}