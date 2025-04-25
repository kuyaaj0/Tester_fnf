package backend;

import backend.Song;

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

    public function new() {}

    public function calculateFullDifficulty(songData:SwagSong):{rating:String, stars:Float} {
        processNotes(songData.notes);
        if (playerNotes.length < 5) return { rating: "Easy", stars: 0.0 };

        playerNotes.sort((a, b) -> Math.round(a.time - b.time));
        this.songSpeed = songData.speed;

        var metrics = {
            density: calculateDensity(),
            strain: calculateStrain(),
            pattern: calculatePatternComplexity(),
            rest: calculateRestDifficulty(),
            comboPressure: calculateComboPressure(),
            handAlternate: calculateHandAlternate()
        };

        var rawDiff = (metrics.density * 0.25) 
                    + (metrics.strain * 0.25)
                    + (metrics.pattern * 0.15)
                    + (metrics.rest * 0.15)
                    + (metrics.comboPressure * 0.1)
                    + (metrics.handAlternate * 0.1);

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

    private function convertLane(original:Int, isPlayer:Bool):Int {
        return if (isPlayer) {
            (original >= 0 && original <= 3) ? original : -1;
        } else {
            (original >= 4 && original <= 7) ? (original - 4) : -1;
        }
    }

    private function calculateDensity():Float {
        var totalTime = playerNotes[playerNotes.length - 1].time - playerNotes[0].time;
        var baseDensity = totalTime > 0 ? playerNotes.length / (totalTime / 1000) : 0;
        return normalizeValue(baseDensity * Math.log(songSpeed + 1), 2, 12);
    }

    private function calculateStrain():Float {
        var strain = 0.0;
        var prevTime = -9999.0;

        for (i in 0...playerNotes.length) {
            var interval = playerNotes[i].time - prevTime;
            if (interval > 0 && interval < timingWindows.great) {
                strain += 1 + (timingWindows.great - interval) / timingWindows.great;
            }
            prevTime = playerNotes[i].time;
        }

        return normalizeValue(strain, playerNotes.length * 0.2, playerNotes.length * 1.5);
    }

    private function calculatePatternComplexity():Float {
        var patterns = new Map<String,Int>();
        for (i in 2...playerNotes.length) {
            var pattern = '${playerNotes[i-2].lane}-${playerNotes[i-1].lane}-${playerNotes[i].lane}';
            patterns.exists(pattern) ? patterns[pattern]++ : patterns[pattern] = 1;
        }

        var complexity = 0;
        for (count in patterns) if (count > 2) complexity += count;
        return normalizeValue(complexity, 0, playerNotes.length * 0.4);
    }

    private function calculateRestDifficulty():Float {
        var rests = [];
        var totalRest = 0.0;
        for (i in 1...playerNotes.length) {
            var gap = playerNotes[i].time - playerNotes[i-1].time;
            if (gap > 1000) {
                rests.push(gap);
                totalRest += gap;
            }
        }

        var avgRest = rests.length > 0 ? totalRest / rests.length : 0;
        var score = Math.log(rests.length + 1) * (avgRest / 1000);
        return normalizeValue(score, 0, 6);
    }

    private function calculateComboPressure():Float {
        var pressure = 0;
        var combo = 0;
        for (note in playerNotes) {
            combo = note.isSlide ? 0 : combo + 1;
            if (combo > 16) pressure += Math.floor(Math.log(combo));
        }
        return normalizeValue(pressure, 0, playerNotes.length * 0.3);
    }

    private function calculateHandAlternate():Float {
        var switches = 0;
        var lastHand = -1;
        for (note in playerNotes) {
            var hand = note.lane < 2 ? 0 : 1;
            if (hand != lastHand) {
                switches++;
                lastHand = hand;
            }
        }
        return normalizeValue(switches, playerNotes.length * 0.3, playerNotes.length * 0.8);
    }

    private function normalizeValue(value:Float, min:Float, max:Float):Float {
        var normalized = (value - min) / (max - min);
        return Math.pow(Math.max(0, Math.min(1, normalized)), 1.5);
    }

    private function getDifficultyRating(raw:Float):{rating:String, stars:Float} {
        var stars = Math.min(Math.pow(raw, 1.2) * 7.5, 9.0);
        stars = Math.round(stars * 10) / 10;

        return if (stars < 2.0) {
            { rating: "Easy", stars: stars };
        } else if (stars < 2.7) {
            { rating: "Normal", stars: stars };
        } else if (stars < 4.0) {
            { rating: "Hard", stars: stars };
        } else if (stars < 5.3) {
            { rating: "Insane", stars: stars };
        } else if (stars < 6.5) {
            { rating: "Expert", stars: stars };
        } else {
            { rating: "God", stars: stars };
        }
    }
}
