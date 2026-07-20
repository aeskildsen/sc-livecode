~piano.play(o.main);
~glock.play(o.main);

(
Pdef(\glock, Ppar(Pbind(
	\type, \vst_midi,
	\vst, v.glock,
	\degree, (Pseries(0, Pwhite(-6, 7).asStream, 5)).repeat,
	\octave, 6,
	\amp, 0.5,
	\dur, Pseq([
		Pwrand([1/8, Pn(1/16, Prand([2,4])), Pn(1/12, 6)], [7, 3, 1].normalizeSum, Pwhite(3, 5).asStream),
		Prand(r.longRests * 4)
	], inf),
)!3, inf)).play;
)

~glock[1] = \filter -> { |in| CombL.ar(in, 0.5, [0.34, 0.25], 10) }
~glock[2] = \filter -> { |in| LPF.ar(in, 6000) }
~glock.set(\wet1, 0.35)
~glock.fadeTime_(2)
~glock.end(8)

Pdef(\glock).stop

(
~noise = Pbind(
	\instrument, \noisy,
	\dur, Pseq([
		Rest(1/4),
		Pwrand([
			Pseq([Rest(1/8), 1/8]),
			1/4,
			Rest(1/4)
		], [1, 1, 10].normalizeSum),
	], inf),
	\sustain, 1/8,
)
)
~noise.play(o.perc)

~kick = Pbind(\instrument, \kick)
~kick.play(o.kick)
