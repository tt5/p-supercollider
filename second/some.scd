Safety.setLimit(0.6);

NetAddr.langPort;
s.quit
s.boot
s.volume.gui
s.freeAll

t = TempoClock(210/60).permanent_(true);

(
SynthDef(\tone, {
  var sig, env, freq, rev, delay;
  freq = \freq.ir(440);
	freq = freq * LFNoise1.ar(\dtnhz.ir(2) !2).bipolar(\dtn.ir(0.1)).midiratio;
	sig = PulseDPW.ar(freq, {Rand(0.6,0.6002)} !2, 0.5);

  sig = Splay.ar(sig);
  sig = RLPF.ar(sig, (freq * \harm.ir(3)).clip(20, 20000), \rq.ir(0.5));
  env = Env.adsr(
    \atk.ir(0.01),
    \dec.ir(0.25),
    \slev.ir(0.5),
    \rel.ir(0.5)
  ).kr(2, \gate.kr(1));
  sig = sig * env;
  sig = Balance2.ar(sig[0], sig[1], \pan.ir(0), \amp.ir(0.2));
	delay = CombL.ar(sig, 1, 1/3, 1);
  sig = sig.blend(delay, 0.5);
  rev = FreeVerb.ar(sig, 0.8, 0.7, 0.6);
  sig = sig.blend(rev, 0.3);
	Out.ar(\out.ir(0), sig);
}).add;
)

(
SynthDef(\bass, {
  var sig, env, freq;
  freq = \freq.ir(440);
	freq = freq * LFNoise1.ar(\dtnhz.ir(2) !5).bipolar(\dtn.ir(0.2)).midiratio;
	sig = VarSaw.ar(freq, {Rand(0.0,1.0)} !5, \wdt.ir(0.99));
  sig = Splay.ar(sig);
  sig = RLPF.ar(sig, (freq * \harm.ir(2)).clip(20, 20000), \rq.ir(0.5));
  env = Env.adsr(
    \atk.ir(0.01),
    \dec.ir(0.25),
    \slev.ir(0.5),
    \rel.ir(0.5)
  ).kr(2, \gate.kr(1));
  sig = sig * env;
  sig = Balance2.ar(sig[0], sig[1], \pan.ir(0), \amp.ir(0.2));
  Out.ar(\out.ir(0), sig);
}).add;
)

p = Pseq([Pseq([60], 16), Pseq([62], 16), Pseq([64], 16)], inf);

~q1 = p.asStream;
~q2 = p.asStream;
~q3 = p.asStream;
~q4 = p.asStream;
)

(
~one = Pbind(
	\instrument, \tone,
	\midinote, Pseq([~q1], inf),
	\amp, Pseq([0.7,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 0.9,
	\dur, Pseq([     4,       Rest(0),      Rest(0) ,      Rest(0) ,
		Rest(1),      2 , Rest(0), 1,
		Rest(1),      2 , Rest(0), 1,
				Rest(1), Rest(1), Rest(1), Rest(1),
	], inf)
);
)

(
~two = Pbind(
  \instrument, \tone,
	\midinote, Pseq([~q2 + 4], inf),
	\amp, Pseq([0.7,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 0.9,
	\dur, Pseq([     Rest(1),       2 ,      Rest(0) ,      1 ,
		4,      Rest(0) , Rest(0), Rest(0),
		Rest(1),      2 , Rest(0), 1,
		Rest(1), Rest(1), Rest(1), Rest(1),
    ], inf)
);
)

(
~three = Pbind(
  \instrument, \tone,
	\midinote, Pseq([~q3 + 7], inf),
	\amp, Pseq([0.7,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 0.9,
	\dur, Pseq([     Rest(1),       2 ,      Rest(0) ,      1 ,
		Rest(1),      2 , Rest(0), 1,
		3,      Rest(0) , Rest(0), Rest(1),
				Rest(1), Rest(1), Rest(1), Rest(1),
	], inf)
);
)

(
~bass = Pbind(
  \instrument, \bass,
	\midinote, Pseq([~q4 - 12], inf),
	\amp, Pseq([0.8,0.8,0.8,0.8], inf),
	\atk, Pfunc({ arg ev; ev.amp/4}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	\dur, Pseq([1, Rest(1), 1, Rest(1), 1, Rest(1), 1, Rest(1)], inf)
);
)

~play1 = Pfin(3*16, ~one).play(t)
~play1 = Pfin(3*16, ~two).play(t)
~play1 = Pfin(3*16, ~three).play(t)
~play1 = Pfin(2*8, ~bass).play(t)

~phrase1 = Pseq([Pfin(8, ~one), Pfin(8, ~two)], 1).play(t)

(
~phrase1 = Ppar([
	Ppar([Pfin(3*16, ~one), Pfin(3*16, ~two), Pfin(3*16, ~three)], 2),
	Pseq([Pfin(3*16, ~bass)], 2),
	Pseq([Pfin(3*16, ~kick)], 2),
],1).play(t)
)