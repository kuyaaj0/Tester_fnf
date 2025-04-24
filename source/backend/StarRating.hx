package backend;

import backend.Song;

class StarRating {
    static final BASE_WEIGHT:Float = 0.42;
    static final CHORD_MULTIPLIER:Float = 1.35;
    static final SUSTAIN_FACTOR:Float = 0.018;
    
    var chartData:SwagSong = null;
    var filteredNotes:Array<NoteData> = [];

    public function new() {}
    
    public function calculateFromJSON(chart:SwagSong):Float {
        chartData = chart;
        for (section in chartData.notes) {
            if (section.sectionNotes == null) continue;
            
            var baseTime = calculateSectionTime(section);
            var playerLaneStart = section.mustHitSection ? 0 : 4;
            var playerLaneEnd = section.mustHitSection ? 3 : 7;

            for (rawNote in section.sectionNotes) {
                var originalLane = Std.int(rawNote[1]);
                if (originalLane >= playerLaneStart && originalLane <= playerLaneEnd) {
                    var mappedLane = section.mustHitSection ? originalLane : originalLane - 4;
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

    function calculateSectionTime(section:Dynamic):Float {
        var beats = section.lengthInSteps / 4;
        return beats * (60000 / chartData.bpm);
    }

    function detectPatterns(notes:Array<NoteData>) {
        var timeMap = new haxe.ds.BalancedTree<Float, Array<Int>>();
        for (note in notes) {
            if (!timeMap.exists(note.time)) {
                timeMap.set(note.time, []);
            }
            timeMap.get(note.time).push(note.originalLane);
            note.isChord = timeMap.get(note.time).length > 1;
        }

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
            strain *= Math.pow(0.92, delta / 1000);
            var value = BASE_WEIGHT;
            value += note.sustain * SUSTAIN_FACTOR;
            if (note.isChord) value *= CHORD_MULTIPLIER;
            if (note.isJack) value *= 1.3;
            strain += value;
            peak = Math.max(peak, strain);
            lastTime = note.time;
        }
        return Math.round(peak * 100) / 1000 * 2.5;
    }
}

typedef NoteData = {
    time:Float,
    lane:Int,
    originalLane:Int,
    sustain:Float,
    isChord:Bool,
    ?isJack:Bool
}
