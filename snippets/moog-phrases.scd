(
g = (
	main: Pmono(\moog,
		\degree, Pser([-2, 0, 2], Pwhite(4, 32).asStream),
		\dur, Pn(1/4, 1) ++ Prand([1/8,  1/4], inf),
	)
);
~lead = Psym(
	Pseq([\phrases, \rest], inf),
	(
	phrases: Prand([
		g.main,
		Pbindf(g.main, \octave, 4),
	]),
	rest: Pn(Rest(1), 4),
));
)

~lead.play(o.lead);
