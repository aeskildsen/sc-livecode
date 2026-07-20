(
~beep = Pbind(
	\instrument, \noisy,
	\dur, Pseq([
		Rest(1/4),
		Pwrand([
			Rest(1/4),
			Pseq(1/8!2)
	], [0.8, 0.2].normalizeSum)], inf),
	\degree, Prand([0, 4, -2], inf),
	\octave, 6,
	\drive, 1,
	\legato, 0.5,
))
~beep.play(0);

(~kick = Pbind(
	\type, \oneshot,
	\buf, b.kick1,
	\db, -10
))
~kick.play(0)

(~bass = Pmono(\moogy,
	\degree, Pseq([-2, 0, 1, 4], inf),
	\dur, 1/16,
	\glide, 0.005,
	\octave, [3, 4],
))
~bass.play(0)

p.stop(8)