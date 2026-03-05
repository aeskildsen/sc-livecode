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

