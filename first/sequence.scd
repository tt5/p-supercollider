
Safety.setLimit(0.5);

s.quit
s.boot
s.volume.gui

t = TempoClock(240/60).permanent_(true);

(
SynthDef(\tone, {
  var sig, env, freq;
  freq = \freq.ir(440);
	freq = freq * LFNoise1.ar(\dtnhz.ir(2) !5).bipolar(\dtn.ir(0.2)).midiratio;
  sig = Saw.ar(freq);
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

(
p = Pseq([60, 64, 68, 72], inf);

~q1 = p.asStream;
~q2 = p.asStream;
~q2 = p.asStream;
)

(
~one = Pbind(
  \instrument, \tone,
	\midinote, Pseq([~q1], inf),
	\amp, Pseq([0.8,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \atk, 0.1,
  \legato, 1,
	\dur, Pseq([     4,       Rest(0),      Rest(0) ,      Rest(0) ,
		Rest(1),      1 , 1, 1,
			Rest(1),      1 , 1, 1,
				Rest(1), Rest(1), Rest(1), Rest(1),
	], inf)
);
)

(
~two = Pbind(
  \instrument, \tone,
	\midinote, Pseq([~q2 + 4], inf),
	\amp, Pseq([0.8,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \atk, 0.1,
  \legato, 1,
	\dur, Pseq([     Rest(1),       1 ,      1 ,      1 ,
		4,      Rest(0) , Rest(0), Rest(0),
			Rest(1),      1 , 1, 1,
		Rest(1), Rest(1), Rest(1), Rest(1),
    ], inf)
);
)

(
~three = Pbind(
  \instrument, \tone,
	\midinote, Pseq([~q3 + 7], inf),
	\amp, Pseq([0.8,0.6,0.4,0.2], inf),
	\atk, Pfunc({ arg ev; ev.amp}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \atk, 0.1,
  \legato, 1,
	\dur, Pseq([     Rest(1),       1 ,      1 ,      1 ,
				Rest(1),      1 , 1, 1,
		4,      Rest(0) , Rest(0), Rest(0),
				Rest(1), Rest(1), Rest(1), Rest(1),
	], inf)
);
)

(
~test = Pbind(
  \instrument, \tone,
	\midinote, Pdefn(\key1, 60),
	\amp, Pseq([0.8,0.8,0.8,0.8], inf),
	\dec, Pfunc({ arg ev; ev.amp}),
  \atk, 0.1,
  \legato, 1,
	\dur, Pseq([1, Rest(1), 1, Rest(1), 1, Rest(1), 1, Rest(1)], inf)
);
)

(
Pdefn(\key1, 48);
)

~play1 = Pfin(2*8, ~one ).play(t)
~play1 = Pfin(2*8, ~two).play(t)
~test = Pfin(10*8, ~test).play(t)

~phrase1 = Pseq([Pfin(8, ~one), Pfin(8, ~two)], 1).play(t)
~phrase1 = Ppar([Pfin(16, ~one), Pfin(16, ~two), Pfin(16, ~three)], 2).play(t)

