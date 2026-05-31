
Safety.setLimit(0.6);

(
"hi".postln;
thisProcess.platform.recordingsDir
)

s.quit
s.boot
s.volume.gui
s.freeAll
s.scope
thisProcess.platform.recordingsDir

t = TempoClock(210/60).permanent_(true);

(
~one = Pbind(
  \instrument, \kick,
	\midinote, Pdefn(\key1, Pseq([30,30,30,30,30,30,30,30], inf)),
	\amp, Pseq([0.9,0.9,0.9,0.9], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	//\dur, Pseq([8, Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0)], inf)
	\dur, Pdefn(\rhy1, Pseq([8, Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0)], inf))

);


~two = Pbind(
  \instrument, \kick,
	\midinote, Pdefn(\key2, Pseq([34,34,34,34,34,34,34,34], inf)),
	\amp, Pseq([0.9,0.9,0.9,0.9], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	//\dur, Pseq([4, Rest(0), Rest(0), Rest(0), 4, Rest(0), Rest(0), Rest(0)], inf)
		\dur, Pdefn(\rhy1, Pseq([8, Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0)], inf))

	//\dur, Pdef(\rhy1, Pseq([1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1], inf))

);



~three = Pbind(
  \instrument, \kick,
	\midinote, Pdefn(\key3, Pseq([37,37,37,37,37,37,37,37], inf)),
	\amp, Pseq([0.9,0.9,0.9,0.9], inf),
	\atk, Pfunc({ arg ev; ev.amp/2}),
	\dec, Pfunc({ arg ev; ev.amp}),
  \legato, 1,
	//\dur, Pseq([4, Rest(0), Rest(0), Rest(0), 4, Rest(0), Rest(0), Rest(0)], inf)
		\dur, Pdefn(\rhy1, Pseq([8, Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0)], inf))

);
)


~test = Pfin(inf, ~test).play(t)
~test.stop()

~phrase1 = Pseq([Pfin(inf, ~one), Pfin(inf, ~two)], 1).play(t)

(
~phrase1 = Ppar([
	Ppar([Pfin(8, ~one), Pfin(8, ~two), Pfin(8, ~three)], 1),
	//Pseq([Pfin(3*16, ~bass)], 2),
	//Pseq([Pfin(3*16, ~kick)], 2),
],inf).play(t)
)

(
OSCdef(key: \oscKey1, func: {|msg|
	Pdefn(\key1, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	//TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/key1");


OSCdef(key: \oscKey2, func: {|msg|
	Pdefn(\key2, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	//TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/key2");


OSCdef(key: \oscKey3, func: {|msg|
	Pdefn(\key3, Pseq([msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]], inf));
	//TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/key3");

OSCdef(key: \oscKey4, func: {|msg|
	var a = [msg[1],msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]];
	a.replace(0, Rest(0));

	Pdefn(\rhy1, Pseq([
		if(a[0]==0){Rest(0)}{a[0]},
		if(a[1]==0){Rest(0)}{a[1]},
		if(a[2]==0){Rest(0)}{a[2]},
		if(a[3]==0){Rest(0)}{a[3]},
		if(a[4]==0){Rest(0)}{a[4]},
		if(a[5]==0){Rest(0)}{a[5]},
		if(a[6]==0){Rest(0)}{a[6]},
		if(a[7]==0){Rest(0)}{a[7]}
	], inf));
	a.postln;
	TempoClock.default.elapsedBeats.roundUp(1).postln
}, path: "/rhy1");
)

OSCFunc.trace(false, true);


b = NetAddr("127.0.0.1", 57121)

b.sendMsg("/sc", "hello from supercollider")

(
Pdefn(\rhy1, Pseq([1, 1, 1, 1, 1, 1, 1, 1], inf));
)
(
Pdefn(\rhy1, Pseq([8, Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0), Rest(0)], inf));
)

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
	freq = \freq.ir(200);
    //p = Impulse.ar(2!2);
	p = WhiteNoise.ar(1!2);
	a1 = SinOsc.ar(freq, 0, PulseDivider.ar(p,1));
	a2 = SinOsc.ar(freq*freq/(a1), pi, Decay2.ar(PulseDivider.ar(a1,2), 1, 0.2));
	a1 = SinOsc.ar(freq, 0, PulseDivider.ar(a2,freq+a2));
	a2 = SinOsc.ar(freq, pi, Decay2.ar(PulseDivider.ar(a1,4), 0.02, 0.3));
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