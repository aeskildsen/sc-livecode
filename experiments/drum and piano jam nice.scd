~piano.play(o.main)

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

Pdef(\pianoL, Pbindf(n.piano, \octave, 4));
Pdef(\pianoR, Pbindf(n.piano, \mtranspose, 2));
)

~piano.set(\wet1, 0.5);
~piano[1] = \filter -> {|in| Splay.ar(CombL.ar(in, 2, [2, 0.45, 0.8, 0.99, 1.5, 0.4,  0.6], 25)) };
~piano.stop(16)
Pdef(\pianoL).play;
Pdef(\pianoR).play;

// Af støj er du kommet...
~noise = { PinkNoise.ar(0.1 ! 2) }
~noise[1] = \filter -> { |in| LPF.ar(in, LFNoise2.kr(0.25).exprange(1000, 1500)) }
~noise.set(\wet1, 0.8)
~noise.xset(\wet2, 0.9)
~noise.stop(16)
(
~noise[2] = \filter -> { |in|
	// var trig = Impulse.kr(p.clock.tempo * 2),
	var trig = Dust.kr(p.clock.tempo * 4),
	env = Env.perc(releaseTime: 0.1).kr(0, trig);
	Ringz.ar(in, TExpRand.kr(200, 800, trig), 0.2) * env * 0.1;
};
)
~noise.play(o.misc)
~noise.fadeTime_(2)

~kick = Pbind(\type, \oneshot, \buf, b.kick0, \amp, Pgauss(0.4, 0.005))
(
~hihat = Pbind(\type, \oneshot, \buf, b.hat0, \amp, Pgauss(0.5, 0.002),
	\dur, Pbjorklund2(9, 16) / 16,
)
)
~kick.play(o.kick); ~hihat.play(o.hat)

//Note: Add default variation in lagtime to oneshot
(
~moog = PmonoArtic(\moog,
	\degree, Pseq([-2, 0, 2, 4, 8, \r].flat, inf),
	\legato, Pwhite(0.7, 2).trace,
	\dur, Pseq([Prand([1/8, 1/16], Pwhite(3, 25).asStream)], inf),
	\octave, 6,
	\dur, Pif(Pfunc({|e|e.legato < 1}), 1.5, Pkey(\dur)),
)
)
~moog.stop
~moog.play(o.lead)
(
~bass = Pbind(
	\type, \moog,
	\octave, [3, 4],
	\degree, Pseq([-2, -3, -2, -5], inf).stutter(4),
	\dur, 1/8,
	\amp, 0.1,
	\foct, Pexprand(2, 4)
)
)
~bass.play(o.bass)
p.stop(16)
~bass.end


~moog2.play(o.misc)
p.stop(4)