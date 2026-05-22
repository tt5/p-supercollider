
Safety.setLimit(0.6);

NetAddr.langPort;
s.quit
s.boot
s.volume.gui
s.freeAll
s.scope

t = TempoClock(210/60).permanent_(true);

(
~test = Pbind(
  \instrument, \kick,
	\midinote, Pdefn(\key1, Pseq([40,40,40,40,40,40,40,40], inf)),
	\amp, Pseq([0.9,0.9,0.9,0.9], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	\dur, Pseq([2, Rest(0), 2, Rest(0), 2, Rest(0), 2, Rest(0)], inf)
);
)
~test = Pfin(inf, ~test).play(t)
~test.stop()

(
OSCdef(key: \oscKey1, func: {|msg|
	Pdefn(\key1, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	"hi".postln;
	TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/key1");
)

(
OSCdef(key: \oscKey2, func: {|msg|
	Pdefn(\rhy, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	"hi".postln;
	TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/key2");
)

OSCFunc.trace(false, true);


b = NetAddr("127.0.0.1", 57121)

b.sendMsg("/sc", "hello from supercollider")

(
Pdefn(\key1, Pseq([40,40,40,40,40,40,40,40], inf));
)
(
Pdefn(\key1, Pseq([60,60,60,60,60,60,60,60], inf));
)
(
Pdefn(\key1, Pseq([61,61,61,61,61,61,61,61], inf));
)

(
SynthDef(\kick, { |out = 0|
    var p, a1, a2, a3, a4, sig, env, freq;
    //p = Impulse.ar(2!2);
	p = WhiteNoise.ar(1!2);
	a1 = SinOsc.ar(\freq.ir(200), 0, PulseDivider.ar(p,1));
	a2 = SinOsc.ar(\freq.ir(200)*\freq.ir(200)/(a1), pi, Decay2.ar(PulseDivider.ar(a1,2), 1, 0.2));
	a1 = SinOsc.ar(\freq.ir(200), 0, PulseDivider.ar(a2,\freq.ir(200)+a2));
	a2 = SinOsc.ar(\freq.ir(200), pi, Decay2.ar(PulseDivider.ar(a1,4), 0.02, 0.3));
	a3 = Fold.ar(a2, -0.6-abs(a1*a1),0.6+abs(a1*a1))* 0.9;
	a2 = Latch.ar(a2, a3);
	sig = CompanderD.ar(a2,
		thresh: 0.90,
		slopeBelow: 0.5,
        slopeAbove: 1,
        clampTime:  0.01,
        relaxTime:  0.2
    ) * 0.9;
	  env = Env.adsr(
    \atk.ir(0.02),
    \dec.ir(0.25),
    \slev.ir(0.5),
    \rel.ir(0.2);
  ).kr(2, \gate.kr(1));

	sig = sig * env;
	//Out.ar(out, sig * 0.005)
	Out.ar(out, sig * 0.08)
}).add;
)