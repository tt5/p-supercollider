
Safety.setLimit(0.5);

NetAddr.langPort;
s.quit
s.boot
s.volume.gui
s.freeAll

t = TempoClock(240/60).permanent_(true);

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

(
p = Pseq([Pseq([60], 16), Pseq([62], 16), Pseq([64], 16)], inf);

~q1 = p.asStream;
~q2 = p.asStream;
~q3 = p.asStream;
~q4 = p.asStream;
~q5 = p.asStream;

)

(
~one = Pbind(
	\instrument, \kick,
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
  \instrument, \kick,
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
  \instrument, \kick,
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


(
~test = Pbind(
  \instrument, \kick,
	\midinote, Pdefn(\key1, Pseq([40,40,40,40,40,40,40,40], inf)),
	\amp, Pseq([0.9,0.9,0.9,0.9], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	\dur, Pseq([4, Rest(0), Rest(0), Rest(0), Rest(1), Rest(1), Rest(2), Rest(0)], inf)
);
)
~test = Pfin(inf, ~test).play(t)

(
OSCdef(key: \myOscDef, func: {|msg|
	Pdefn(\key1, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	"hi".postln;
}, path: "/my_path");
)
OSCFunc.trace(false, true);

(
Pdefn(\key1, seq([0,0,0,0,0,0,0,0], inf));
)

~play1 = Pfin(3*16, ~one).play(t)
~play1 = Pfin(3*16, ~two).play(t)
~play1 = Pfin(3*16, ~three).play(t)
~play1 = Pfin(2*8, ~bass).play(t)



~phrase1 = Pseq([Pfin(8, ~one), Pfin(8, ~two)], 1).play(t)



(
SynthDef(\kick, { |out = 0|
    var p, a1, a2, a3, sig, env, freq;
    //p = Impulse.ar(2!2);
	p = WhiteNoise.ar(1!2);
	a1 = SinOsc.ar(1, 0, PulseDivider.ar(p,1));
	a2 = SinOsc.ar(12800, pi, Decay2.ar(PulseDivider.ar(a1,700), a1, 0.7));
	a1 = SinOsc.ar(\freq.ir(200)+a2, 0, PulseDivider.ar(a2,2));
	a2 = SinOsc.ar(\freq.ir(200)+a1, pi, Decay2.ar(PulseDivider.ar(a1,2), 0.02, 0.5));
	a3 = Fold.ar(a2, -0.1-a1*a1,0.1+a1*a1)* 0.9;
	sig = CompanderD.ar(a3,
		thresh: 0.9,
		slopeBelow: 0.5,
        slopeAbove: 1,
        clampTime:  0.01,
        relaxTime:  0.0001
    ) * 0.9;
	  env = Env.adsr(
    \atk.ir(0.02),
    \dec.ir(0.25),
    \slev.ir(0.5),
    \rel.ir(0.2);
  ).kr(2, \gate.kr(1));

	sig = sig * env;
	//Out.ar(out, sig * 0.005)
	Out.ar(out, sig * 0.5)
}).add;
)
s.scope

(
~kick = Pbind(
	\instrument, \kick,
	\midinote, Pseq([~q5 - 12], inf),
	\amp, Pseq([0.8,0.8,0.8,0.8], inf),
  \legato, 0.9,
	\dur, Pseq([     3,       Rest(0),      Rest(0) ,      Rest(1) ,
		3,      Rest(0) , Rest(0), Rest(1),
		3,      Rest(0) , Rest(0), Rest(1),
				Rest(1), Rest(1), Rest(1), Rest(1),
	], inf)
);
)
~play1 = Pfin(3*16, ~kick).play(t)

(
~phrase1 = Ppar([
	Ppar([Pfin(3*16, ~one), Pfin(3*16, ~two), Pfin(3*16, ~three)], 2),
	//Pseq([Pfin(3*16, ~bass)], 2),
	Pseq([Pfin(3*16, ~kick)], 2),
],1).play(t)
)