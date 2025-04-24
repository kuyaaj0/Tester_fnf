package backend;

import backend.Song;

class StarRating {
    // 配置参数
    static final TARGET_LANES = [4,5,6,7]; // 只处理这些轨道
    static final BASE_WEIGHT:Float = 0.42;
    static final CHORD_MULTIPLIER:Float = 1.35;
    static final SUSTAIN_FACTOR:Float = 0.018;
    var chartData:SwagSong = null;
    var filteredNotes:Array<NoteData> = [];

    public function calculateFromJSON(chart:SwagSong):Float {
        chartData = chart;
        for (section in chartData.notes) {
            if (section.sectionNotes == null) continue;
                
            var baseTime = calculateSectionTime(section);
            for (rawNote in section.sectionNotes) {
                var originalLane = Std.int(rawNote[1]);
                
                if (TARGET_LANES.contains(originalLane)) {
                    var mappedLane = originalLane - 4; // 映射到0-3
                    filteredNotes.push({
                        time: baseTime + rawNote[0],
                        lane: mappedLane,
                        originalLane: originalLane,
                        sustain: rawNote[2],
                        isChord: false
                    });
                }
            }
        }
        detectPatterns(filteredNotes);
        return calculateStrain(filteredNotes);
    }

    // 时间计算（考虑mustHitSection）
    function calculateSectionTime(section:Dynamic):Float {
        var beats = section.lengthInSteps / 4;
        return (beats * (60000 / chartData.bpm)) * (section.mustHitSection ? 1 : 0);
    }

    function detectPatterns(notes:Array<NoteData>) {
        var timeMap = new Map<Float, Array<Int>>();
        
        // 和弦检测（仅限4-7轨道）
        for (note in notes) {
            if (!timeMap.exists(note.time)) {
                timeMap.set(note.time, []);
            }
            timeMap.get(note.time).push(note.originalLane);
            
            // 同一时间不同轨道即为和弦
            note.isChord = timeMap.get(note.time).length > 1;
        }

        // 连打检测（仅限同一轨道）
        for (i in 1...notes.length) {
            var prev = notes[i-1];
            var curr = notes[i];
            if (curr.time - prev.time < 150 && curr.lane == prev.lane) {
                curr.isJack = true;
                prev.isJack = true;
            }
        }
    }

    function calculateStrain(notes:Array<NoteData>):Float {
        notes.sort((a, b) -> a.time < b.time ? -1 : 1);
        
        var strain:Float = 0;
        var peak:Float = 0;
        var lastTime:Float = -9999;

        for (note in notes) {
            var delta = note.time - lastTime;
            
            // 应变衰减（基于时间间隔）
            strain *= Math.pow(0.92, delta / 1000);
            
            // 基础值计算
            var value = BASE_WEIGHT;
            value += note.sustain * SUSTAIN_FACTOR;
            
            // 和弦加成
            if (note.isChord) value *= CHORD_MULTIPLIER;
            
            // 连打加成
            if (note.isJack) value *= 1.3;

            strain += value;
            peak = Math.max(peak, strain);
            lastTime = note.time;
        }

        return Math.round(peak * 100) / 1000 * 2.5; // 最终星级转换
    }
}

typedef NoteData = {
    time:Float,         // 绝对时间（毫秒）
    lane:Int,           // 映射后的0-3
    originalLane:Int,   // 原始4-7
    sustain:Float,      // 长按时长
    isChord:Bool,       // 是否和弦
    ?isJack:Bool        // 是否连打
}
