// En algoritme jeg holder meget af

(
n.piano = Pbind(
	\type, \vst_midi,
	\vst, v.piano,
	\scale, Scale.major,
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
		).stutter(4) * 1.5,
		Prand([Rest(1), Rest(1.5)]),
	], inf),
	\lag, Pgauss(0.5, 0.2).stutter(5),
	\legato, Pexprand(2.1, 2.8),
);

Pdef(\piano, Pbindf(n.piano, \octave, 5)).play;
Pdef(\piano_deep, Pbindf(n.piano, \octave, 4)).play;
)

Pdef(\piano).play;

~piano.play(o.main)

~piano[1] = \filter -> {|in| CombL.ar(in, 1, [0.75, 0.6], 10)}; ~piano.set(\wet1, 0.4);

~piano[2] = \filter -> {|in| HPF.ar(in, XLine.kr(20, 3000, 60))};
~piano.set(\wet2, 1);
~piano.stop(4)

~kick = Pbind(\type, \oneshot, \buf, b.kick0, \amp, Pgauss(0.4, 0.01));
~kick.play(o.kick);

(
~hihat = Pbind(
	\type, \oneshot,
	\buf, b.hat0,
	\dur, Pbjorklund2(Prand([7, 9, 11], inf), 16) / 16,
	\dur, Pxsum(Array.rand(8, 0.05, 0.25), 1, 16).repeat,
	\amp, Pgauss(0.2, 0.01),
	//\rate, Pgauss(-0.125, 0.01)
);
~hihat.play(o.hihat);
)

(
~bass = Pbind(
	\type, \bass,
	\dur, Pif(Pfunc{0.9.coin},
		1/8,
		1/4
	) * 0.5,
	//\dur, Pxsum(Array.rand(8, 0.05, 0.25), 1, 16).repeat,
	\rel, 0.5,
	\degree, Pshunc((-2..7), 8, 4).stutter(4).repeat,
)
)

~bass[1] = \filter ->  {|in| (in * 50).distort * 0.08 }

~bass.play(o.bass);

p.stop(4);

~lfo = { SinOsc.kr(0.1).range(3, 5) }

(
g = (
	main: Pmono(\moog,
		\degree, Pser([-2, 0, 1, 2, 7, 3].scramble, Pwhite(4, 32).asStream),
		\dur, Pn(1/4, 1) ++ Prand([1/8,  1/4, 1/16], inf),
		\cutoffOct, ~lfo,
		\mtranspose, Pif(
			Pfunc{0.9.coin},
			0, Prand([-5, 7])
		).trace,
		\fgain, 0.8,
	)
);
~lead = Psym(
	Pseq([\phrases, \rest], inf),
	(
	phrases: Prand([
		g.main,
		Pbindf(g.main, \stretch, 6),
	]),
	rest: Pn(Rest(1), Pwhite(2, 9).asStream),
));
)
~lead.stop(2)
~lead.clear
~lead.play(o.lead);

~bass.stop(16);
~hihat.stop(8);

~lead.stop(4);

(
~slicer = Pbind(
	\type, \slice,
	\buf, b.loop0,
	\numSlices, 16,
	\dur, 1/16,
	\slice, Pshunc((0..15), 8, 4).repeat.stutter(Pwhite(1, 4).asStream),
	\pan, Prand([-0.4, 0.4] * 2, inf),
	\drive, 1,
)
)
~bass.stop(16)
~kick.stop(16)

~slicer.play(o.misc)
(
~slicer[1] = \filter -> {|in|CombL.ar(in, 1, [
	SinOsc.kr(0.1).exprange(0.02, 0.8),
	SinOsc.kr(0.15).exprange(0.027, 0.4)], 10)};

)

~slicer[0] = { PinkNoise.ar(1 ! 2) * Env.perc(0.1, 30).ar }

p.end