Quarks.install("SafetyNet")
Safety.all;
Safety.setLimit(0.5);

s.quit
s.boot

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

// s-enter
// c-.