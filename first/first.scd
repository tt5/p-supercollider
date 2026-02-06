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

(
{
  var sig, env;
  sig = SinOsc.ar(440, mul: 0.1) ! 2;
  env = Line.kr(start: 1, end: 0.001, dur: 2, doneAction: 2);
  sig = sig * env;
}.play;
)

(
e = Env.new(
  levels: [0, 1, 0.1, 1, 0],
  times: [1, 0.1, 0.1, 2],
  curve: [2, 0, 0, -1]
).plot;
)

(
{
  var sig, env;
  sig = SinOsc.ar(440, mul: 0.1) ! 2;
  env = EnvGen.kr(
    Env.new(
      levels: [0, 1, 0.1, 1, 0],
      times: [1, 0.1, 0.1, 2],
      curve: [2, 0, 0, -1]
    ),
    doneAction: 2
  );
  sig = sig * env;
}.play;
)

(
envwithgate = {
  var sig, env;
  sig = SinOsc.ar(440, mul: 0.1) ! 2;
  env = EnvGen.kr(
    Env.new(
      levels: [0, 1, 0.1, 1, 0],
      times: [1, 0.1, 0.1, 2],
      curve: [2, 0, 0, -1]
      releaseNode: 3,
      loopNode: 1
    ),
    gate: \gate.kr(0),
    doneAction: 2
  );
  sig = sig * env;
}.play;
)

envwithgate.set(\gate, 1);
envwithgate.set(\gate, 0);

envwithgate = {
  var sig, env;
  sig = SinOsc.ar(440, mul: 0.1) ! 2;
  env = Env.new(
      levels: [0, 1, 0.1, 1, 0],
      times: [1, 0.1, 0.1, 2],
      curve: [2, 0, 0, -1]
  ).kr(2);
  sig = sig * env;
}.play;
)

envwithgatenotdone = {
  var sig, env;
  sig = SinOsc.ar(440, mul: 0.1) ! 2;
  env = Env.kr(
    Env.perc(0.001, 1),
    gate: \gate2.tr(0),
    doneAction: 0
  );
  sig = sig * env;
}.play;
)

envwithgatenotdone(\gate2, 1);

(
{
  var sig, freq;
  #freq = exprand(199, 2000) ! 5;
  freq = {exprand(200, 2000)} ! 5;
  sig = SinOsc.ar(freq, mul: 0.1);
  sig = Splay.ar(sig);
}.play
)

// Balance2

{LFDNoise3.ar(200)}.plot(0.2)

s.scope;
{LFDNoise3.kr(200)}.play

FreqScope.new;

//s.volume.gui;
s.makeGui;

(
x = {
  var sig, mod;
  mod = SinOsc.ar(\modfreq.kr(1), 3pi/2).exprange(80, 8000);
  sig = Saw.ar([40, 41], mul: 0.1);
  sig = LPF.ar(sig, mod);
}.play
)

(
SynthDef(\wobble, {
  var sig, mod;
  mod = SinOsc.ar(\modfreq.kr(1), 3pi/2).exprange(80, 8000);
  sig = Saw.ar([40, 41], mul: 0.1);
  sig = LPF.ar(sig, mod);
  Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\wobble);
// x.set(...)

