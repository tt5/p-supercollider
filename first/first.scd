Quarks.install("SafetyNet")
Safety.all;
Safety.setLimit(0.5);

s.volume.gui

s.quit
s.boot
s.freeAll

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

// https://gist.github.com/nhthn/56168191c3cf2d1dcf9f124d0693a335

(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0.001, 0.3, curve: -8).ar.linexp(0, 1, 30, 400));
	snd = snd + (SinOsc.ar(XLine.ar(4000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8000, 0.5) * 3.dbamp * Env.perc(0.01, 0.03).ar);
	snd = snd * Env.perc(0.001, 0.2, curve: -1).ar(Done.freeSelf);
	snd = snd * 5.dbamp;
	snd = snd.tanh;
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(Env.perc(0.001, 0.05, curve: -8).ar.linexp(0, 1, 230, 1000) * [1, 2.3]);
	snd = (snd * [0, -15].dbamp).sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2100, 0.2) * 3.dbamp * Env.perc(0.05, 0.23).ar);
	snd = snd + HPF.ar((snd * 3.dbamp).tanh, 100);
	snd = snd * Env.perc(0.001, 0.12, curve: -1).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).play;
)

(
SynthDef(\glitch, {
	var snd, seed, randomValue, random;
	seed = \seed.kr(0);
	randomValue = seed;
	random = {
		randomValue = Hasher.kr(randomValue);
		randomValue;
	};
	snd = SinOsc.ar(random.().linexp(-1, 1, 100, 8000) * XLine.kr(2, 1, 0.01));
	snd = snd * (1 + SinOsc.ar(random.().linexp(-1, 1, 100, 8000)));
	snd = BPF.ar(snd, random.().linexp(-1, 1, 100, 8000) * ([1, -1] * 12 * random.()).midiratio, 0.1) * 10.dbamp;
	snd = snd.sum;
	snd = (snd * 20.dbamp).tanh;
	snd = Latch.ar(snd, Impulse.ar(random.().linexp(-1, 1, 1000, 16e3)));
	snd = snd * Env.perc(0.001, random.().linexp(-1, 1, 0.01, 0.2), curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).play;
)


SynthDef(\pluck, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq) * Env.perc(0.001, 0.3).ar * 1000;
	snd = SinOsc.ar(freq + snd);
	snd = snd + SinOsc.ar(freq);
	snd = LPF.ar(snd, XLine.kr(8000, 4000, 0.1));
	snd = snd * Env.perc(0.001, 0.3, curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pulse.ar(freq, 0.7);
	snd = snd + SinOsc.ar(freq / 2);
	snd = LPF.ar(snd, XLine.kr(8000, 1000, 0.4));
	snd = snd * 2.dbamp;
	snd = snd * Env.perc(0.001, 0.3, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	OffsetOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\freqShift, {
	var snd, up, down;
	snd = LocalIn.ar(1);
	snd = snd + (PinkNoise.ar * -20.dbamp);
	up = snd;
	up = FreqShift.ar(up, LFNoise2.kr(3) * 10);
	up = BPF.ar(up, LFNoise2.kr(3).linexp(-1, 1, 100, 4000) * (12 * [-1, 1] * LFNoise2.kr(3)).midiratio, 0.1).sum;
	up = LeakDC.ar(up).tanh;
	down = snd;
	down = FreqShift.ar(down, LFNoise2.kr(3) * 10);
	down = CombC.ar(snd, 0.1, 1 / LFNoise2.kr(0.3).linexp(-1, 1, 10, 500), 0.01);
	down = LeakDC.ar(down).tanh;
	snd = up + down;
	LocalOut.ar(snd);
	snd = snd * \amp.kr(-20.dbamp);
	snd = snd * Env.asr(0, 1, 1).ar(Done.none, \gate.kr(1));
	snd = GVerb.ar(snd, revtime: 1);
	snd = snd * Env.asr(0, 1, 3).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;


