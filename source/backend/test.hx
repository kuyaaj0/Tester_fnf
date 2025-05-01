package backend;

import backend.Song;

// 定义更清晰的数据结构
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

    // 新增参数：参考 osu!mania 的权重分配
    private static final WEIGHTS = {
        density: 0.3,
        strain: 0.3,
        pattern: 0.2,
        sliderComplexity: 0.1,
        handBalance: 0.1
    };

    public function new() {}

    public function calculateFullDifficulty(songData:SwagSong):{rating:String, stars:Float} {
        processNotes(songData.notes);
        if (playerNotes.length < 5) return { rating: "Easy", stars: 0.0 };

        playerNotes.sort((a, b) -> Math.round(a.time - b.time));
        this.songSpeed = songData.speed;

        // 使用更模块化的指标计算
        var metrics = calculateAllMetrics();
        var rawDiff = combineMetrics(metrics);

        return getDifficultyRating(rawDiff);
    }

    //--- 核心优化点 ---
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
        for (key => weight in WEIGHTS) {
            rawDiff += metrics.get(key) * weight;
        }
        return rawDiff;
    }
    //--- 指标计算优化 ---

    // 1. 密度计算：引入速度非线性影响（参考 osu!mania）
    private function calculateDensity():Float {
        var totalTime = playerNotes[playerNotes.length - 1].time - playerNotes[0].time;
        var baseDensity = totalTime > 0 ? playerNotes.length / (totalTime / 1000) : 0;
        var speedFactor = Math.pow(songSpeed, 1.5); // 速度影响更显著
        return normalizeValue(baseDensity * speedFactor, 3, 15);
    }

    // 2. 应变计算：使用分段的指数衰减模型（类似 osu!mania 的 strain peaks）
    private function calculateStrain():Float {
        var strainPeaks = [];
        var currentStrain = 0.0;
        var prevTime = -9999.0;

        for (note in playerNotes) {
            var decay = Math.pow(0.9, (note.time - prevTime) / 1000); // 每秒衰减 10%
            currentStrain = currentStrain * decay + 1.0;
            strainPeaks.push(currentStrain);
            prevTime = note.time;
        }

        strainPeaks.sort((a, b) -> b - a); // 取最高 20% 的应变峰
        var topStrains = strainPeaks.slice(0, Math.floor(strainPeaks.length * 0.2));
        return normalizeValue(average(topStrains), 1.5, 8.0);
    }

    // 3. 模式复杂度：使用相邻两音符的相对位置（减少计算量）
    private function calculatePatternComplexity():Float {
        var patternMap = new Map<String, Int>();
        for (i in 1...playerNotes.length) {
            var deltaLane = playerNotes[i].lane - playerNotes[i-1].lane;
            var pattern = '${deltaLane.abs()}'; // 如 "1", "2" 等
            patternMap.exists(pattern) ? patternMap[pattern]++ : patternMap[pattern] = 1;
        }

        var entropy = 0.0; // 使用信息熵衡量复杂度
        var total = playerNotes.length - 1;
        for (count in patternMap) {
            var p = count / total;
            entropy -= p * Math.log(p);
        }
        return normalizeValue(entropy, 0.5, 2.5);
    }

    // 4. 新增：滑动音符复杂度
    private function calculateSliderComplexity():Float {
        var totalDuration = 0.0;
        var sliderCount = 0;
        for (note in playerNotes) {
            if (note.isSlide) {
                totalDuration += note.duration;
                sliderCount++;
            }
        }
        var complexity = sliderCount * Math.log(totalDuration + 1);
        return normalizeValue(complexity, 0, 50);
    }

    // 5. 手部平衡：优化为左右手按键量差异（类似 osu!mania 的 Balance）
    private function calculateHandBalance():Float {
        var leftCount = 0;
        var rightCount = 0;
        for (note in playerNotes) {
            if (note.lane < 2) leftCount++ else rightCount++;
        }
        var imbalance = Math.abs(leftCount - rightCount) / playerNotes.length;
        return 1 - normalizeValue(imbalance, 0, 0.5); // 越平衡得分越高
    }

    //--- 工具方法优化 ---
    private function normalizeValue(value:Float, min:Float, max:Float):Float {
        var clamped = (value - min) / (max - min);
        return Math.pow(Math.max(0, Math.min(1, clamped)), 0.8); // 更平缓的曲线
    }

    private function getDifficultyRating(raw:Float):{rating:String, stars:Float} {
        // 调整星级公式，更接近 osu!mania 的 SS-S 分级
        var stars = Math.min(raw * 2.2, 10.0); // 最大 10 星
        stars = Math.round(stars * 10) / 10;

        return if (stars < 2.0) {
            { rating: "Easy", stars: stars };
        } else if (stars < 3.5) {
            { rating: "Normal", stars: stars };
        } else if (stars < 5.0) {
            { rating: "Hard", stars: stars };
        } else if (stars < 6.5) {
            { rating: "Insane", stars: stars };
        } else if (stars < 8.0) {
            { rating: "Expert", stars: stars };
        } else {
            { rating: "God", stars: stars };
        }
    }
}