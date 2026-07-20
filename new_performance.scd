(
n.piano = Pbind(
	\type, \vst_midi,
	\vst, v.piano,
	\degree, Pseries(
		// Starttone: Vælges tilfældigt i intervallet a-e (diatonisk)
		start: Pwhite(-2, 2).asStream,
		// Intervalbevægelse: Sekund, kvart, eller sekst
		step: Prand([1, 3, 5], inf).stutter(5).asStream,
		// 4 toner pr. motiv
		length: 5
	).repeat,
	\amp, Pgauss(0.5, 0.02),
	\dur, Pseq([
		Pwrand(
			[1/4, 3/8, 1/2],
			[10, 10].normalizeSum,
		).stutter(4) * 2,
		Prand([Rest(1), Rest(1.5)]),
	], inf),
	\lag, Pgauss(0.5, 0.2).stutter(5),
	\legato, Pexprand(2.1, 2.8),
);

Pdef(\piano, Pbindf(n.piano)).play;
Pdef(\leftHand, Pbindf(n.piano, \octave, 4)).play;
Pdef(\uhhmHand, Pbindf(n.piano, \octave, 5, \mtranspose, 4)).play;
)

~piano.play(o.main);

~piano[1] = \filter -> {|in| CombL.ar(in, 1, [0.4, 0.5], 12)}; ~piano.set(\wet1, 0.4);
~piano[2] = \filter -> {|in| HPF.ar(in, XLine.kr(20, 1000, 45))};
~piano.stop(4)


~noise =

~kick = Pbind(\type, \oneshot, \buf, b.kick0, \amp, 0.2, \pan, 0, \dur, 1/4);
~kick.play(o.main)
~kick.stop(4)
p.stop(4)
(
~hihat = Pbind(
	\type, \oneshot,
	\buf, b.hihat0,
	\dur, Pbjorklund2(Prand([7, 9, 11], inf).asStream, 16) / 16,
	\amp, Pgauss(0.1, 0.01),
	\rate, Pgauss(1, 0.02),
	\lag, Pgauss(0.1, 0.005)
);
)
~hihat.play(o.hat);
~hihat.stop(16)
(
~bass = Pbind(
	\type, \bass,
	\dur, 1/8,
	\degree, Pshunc((-1..3), 4, 8).stutter(4).repeat,
)
)
~bass[1] = \filter -> {|in| (in*50).distort * 0.09}
~bass.play(o.bass)
~bass.stop(4)

(
g = (
	main: Pmono(\moog,
		\degree, Pser([-2, 0, 1, 2, 3, 5, 6, -3].scramble, Pwhite(7, 32).asStream),
		\dur, Pn(1/4, 1) ++ Prand([1/8,  1/4, 1/2], inf) * 0.5,
		\pan, Pwhite(-0.25, 0.25),
	)
);
~lead = Psym(
	Pseq([\phrases, \rest], inf),
	(
	phrases: Prand([
		g.main,
		Pbindf(g.main, \stretch, 2),
	]),
	rest: Pn(Rest(1), 8),
));
)

~lead.play(o.lead);
~lead.stop(16)

(
~slicer = Pbind(
	\type, \slice,
	\buf, b.loop0,
	\numSlices, 16,
	\dur, 1/16,
	\slice, Pseq((0..15).scramble, inf),
	\pan, Pwhite(-0.8, 0.8),
	\drive, 0.2,
	\cutoff, Pexprand(2000, 8000),
	\rq, Pexprand(0.3, 0.8),
);
)

~slicer.play(o.perc);
~slicer.clear
~slicer[1] =
~kick[1] = \filter -> {|in| CombL.ar(in, 1, SinOsc.ar(0.1).exprange(0.1, 0.8), 15)};

~kick[0] = { Env.perc(releaseTime: 25).kr
	* PinkNoise.ar(0.2 ! 2) }

p.stop(2)


(
~hihat = Pbind(
	\type, \oneshot,
	\buf, b.hihat0,
	\dur, Pxsum([0.05, 0.234, 0.336], 1, 4).repeat,
	\amp, 0.2,
	\rate, Pgauss(0.7, 0.1).stutter(4),
);
)
~hihat.play(o.hihat);

~moog = Pbind(\instrument, \moog, \degree, Pshunc([-1, 0, 1, 2, 3, 4, 5], 4, 4).repeat);
~moog.play(o.main);
