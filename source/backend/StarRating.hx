package backend;

import backend.Song;
import sys.thread.Thread;
import sys.thread.Mutex;
import sys.thread.EventLoop;
import haxe.ds.Map;

typedef RaSection = {
    var mustHitSection:Bool;
    var sectionNotes:Array<Array<Float>>;
}

typedef RaNote = {
    var time:Float;
    var lane:Int;
    var duration:Float;
    var isSlide:Bool;
}

class StarRating {
    private var playerNotes:Array<RaNote> = [];
    private var songSpeed:Float = 1.0;
    private var timingWindows = { perfect: 45, great: 90, good: 135 };

    // 优化后的权重分配
    private static final WEIGHTS:Map<String, Float> = [
        "density" => 0.4, //密度
        "strain" => 0.4, //应变
        "pattern" => 0.1, //模式复杂度（排列，交互手运用）
        "sliderComplexity" => 0.05, //长条难度
        "handBalance" => 0.05 //手部平衡
    ];

    public function new() {}

    public function calculateFullDifficulty(songData:SwagSong):{rating:String, stars:Float} {
        processNotes(songData.notes);
        if (playerNotes.length < 5) return { rating: "Easy", stars: 0.0 };

        playerNotes.sort((a, b) -> Math.round(a.time - b.time));
        this.songSpeed = songData.speed;

        var metrics = calculateAllMetrics();
        var rawDiff = combineMetrics(metrics);

        return getDifficultyRating(rawDiff);
    }

    private function processNotes(sections:Array<RaSection>) {
        playerNotes = [];
        for (section in sections) {
            var isPlayer = section.mustHitSection;
            for (noteData in section.sectionNotes) {
                var lane = convertLane(Std.int(noteData[1]), isPlayer);
                if (lane == -1) continue;

                playerNotes.push({
                    time: noteData[0],
                    lane: lane,
                    duration: noteData[2],
                    isSlide: noteData[2] > 0
                });
            }
        }
    }

    inline private function convertLane(original:Int, isPlayer:Bool):Int {
        return if (isPlayer) {
            (original >= 0 && original <= 3) ? original : -1;
        } else {
            (original >= 4 && original <= 7) ? (original - 4) : -1;
        }
    }

    private function calculateAllMetrics():Map<String, Float> {
        return [
            "density" => calculateDensity(),
            "strain" => calculateStrain(),
            "pattern" => calculatePatternComplexity(),
            "sliderComplexity" => calculateSliderComplexity(),
            "handBalance" => calculateHandBalance()
        ];
    }

    private function combineMetrics(metrics:Map<String, Float>):Float {
        var rawDiff = 0.0;
        for (key in WEIGHTS.keys()) {
            rawDiff += metrics.get(key) * WEIGHTS.get(key);
        }
        return rawDiff;
    }

    //=== 核心指标计算 ===
    private function calculateDensity():Float {
        var totalTime = playerNotes[playerNotes.length - 1].time - playerNotes[0].time;
        var baseDensity = totalTime > 0 ? playerNotes.length / (totalTime / 1000) : 0;
        
        // 连击密度加成
        var maxComboDensity = 0.0;
        var currentCombo = 0;
        for (note in playerNotes) {
            currentCombo = note.isSlide ? 0 : currentCombo + 1;
            if (currentCombo > 20) {
                maxComboDensity = Math.max(maxComboDensity, currentCombo / 20.0);
            }
        }
        
        var speedFactor = Math.pow(songSpeed, 2.2);
        var adjustedDensity = baseDensity * (1 + maxComboDensity * 0.6) * speedFactor;
        return normalizeValue(adjustedDensity, 8, 80);
    }

    private function calculateStrain():Float {
        var strainPeaks = [];
        var currentStrain = 0.0;
        var prevTime = -9999.0;
        var decayRate = 0.82;
    
        for (note in playerNotes) {
            var timeDiff = note.time - prevTime;
            var decay = Math.pow(decayRate, timeDiff / 200);
            currentStrain = currentStrain * decay + 1.0;
            strainPeaks.push(currentStrain);
            prevTime = note.time;
        }
    
        // 修复排序函数
        strainPeaks.sort(function(a, b) {
            return a < b ? 1 : a > b ? -1 : 0;
        });
    
        var thresholdIndex = Math.floor(strainPeaks.length * 0.1);
        var threshold = strainPeaks[thresholdIndex];
        var topStrains = strainPeaks.filter(function(p) return p >= threshold);
        
        return normalizeValue(average(topStrains), 3.0, 35.0);
    }

    private function calculatePatternComplexity():Float {
        var patternMap = new Map<String, Int>();
        for (i in 1...playerNotes.length) {
            var deltaLane = playerNotes[i].lane - playerNotes[i-1].lane;
            var pattern = '${Math.abs(deltaLane)}';
            patternMap[pattern] = (patternMap.exists(pattern) ? patternMap[pattern] + 1 : 1);
        }

        var entropy = 0.0;
        var total = playerNotes.length - 1;
        for (count in patternMap) {
            var p = count / total;
            entropy -= p * Math.log(p);
        }
        return normalizeValue(entropy, 0.8, 5.0);
    }

    private function calculateSliderComplexity():Float {
        var totalDuration = 0.0;
        var sliderCount = 0;
        for (note in playerNotes) {
            if (note.isSlide) {
                totalDuration += note.duration;
                sliderCount++;
            }
        }
        var complexity = sliderCount * Math.log(totalDuration / 500 + 1); // 标准化时间单位
        return normalizeValue(complexity, 0, 180);
    }

    private function calculateHandBalance():Float {
        var leftCount = 0;
        var rightCount = 0;
        for (note in playerNotes) {
            if (note.lane < 2) leftCount++ else rightCount++;
        }
        var imbalance = Math.abs(leftCount - rightCount) / playerNotes.length;
        return 1 - normalizeValue(imbalance, 0, 0.4);
    }

    //=== 工具方法 ===
    private function normalizeValue(value:Float, min:Float, max:Float):Float {
        var clamped = (value - min) / (max - min);
        return Math.pow(Math.max(0, Math.min(1, clamped)), 0.7);
    }

    private function average(arr:Array<Float>):Float {
        if (arr == null || arr.length == 0) return 0.0;
        var sum = 0.0;
        for (v in arr) sum += v;
        return sum / arr.length;
    }

    private function getDifficultyRating(raw:Float):{rating:String, stars:Float} {
        // 非线性映射曲线
        var stars = Math.min(Math.pow(raw, 1.4) * 7.2, 10.0);
        stars = Math.round(stars * 10) / 10;

        return if (stars < 2.0) {
            { rating: "Easy", stars: stars };
        } else if (stars < 4.0) {
            { rating: "Normal", stars: stars };
        } else if (stars < 6.0) {
            { rating: "Hard", stars: stars };
        } else if (stars < 8.0) {
            { rating: "Insane", stars: stars };
        } else if (stars < 9.5) {
            { rating: "Expert", stars: stars };
        } else {
            { rating: "God", stars: stars };
        }
    }
}