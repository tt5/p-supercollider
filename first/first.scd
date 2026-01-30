Quarks.install("SafetyNet")
Safety.all;
Safety.setLimit(0.5);

s.quit
s.boot

// Turn down volume first!
x1 = { [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] };
x2 = { [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;
x1p = x1.play;
x2p = x2.play;
x1p.free;
x2.release(1);

// s-enter
// c-.

(
//some
//somemore
)

// c-enter

~globalvar = \symbol

// s-c-d

// function
(
~fn = {
  arg arg1 = 1, arg2 = 1;
}
)

~fn.value(2);
~fn.(2, 2);
~fn.(arg2: 2, arg1: 2);

// ar audio rate (use this)
// kr control rate
// initialization rate

(
x = {
  var sig;
  sig = SinOsc.ar(freq.kr(440), 0, \amp.kr(0.2), 0) ! 2;
}.play;
)

x.set(\freq, 60.midicps, \amp, 0.2);

x.release(1);

1000.cpsmidi

0.dbamp;
-6.dbamp;
-12.dbamp;

(
x = {
  var sig, mod;
  mod = SinOsc.kr(0.25, 3pi/2).exprange(0.02,0.4); // 0.25 times per s
  sig = PinkNoise.ar(0.3 ! 2);
}.play
)
