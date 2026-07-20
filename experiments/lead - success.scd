

n.motiv = Pmono(\moog, \degree, Pseq([0, 2, 4], 4), \dur, 1/16);
n.break = Pn(Rest(2), 1);
~moog = Psym(Pseq([\motiv, \break], 2), a);


// This below in a simplified form may be a good snippet candidate?
(
f = (
	test: Pmono(\moog,
		\degree, Pser([-3, -2, 2, 1, 4, 7, -4, 0, 3, -7].scramble, Pwhite(4, 32).asStream),
		\dur, Pn(1/4, 1)++ Pwrand([1/8, 1/16, Pseq([1/12], Prand([3, 6]))], [4, 4, 0.5].normalizeSum, inf),
		\rel, Pexprand(1.5, 4),
		\ctranspose, Pif(Pfunc{0.1.coin}, 12, 0),
		\mtranspose, Pwhite(-4, 7).stutter(inf),
		\fgain, 1,
		\foctave, 5,
		\amp, Pexprand(0.4, 0.5),
	),
	rest: Pn(Rest(1), Pwhite(5, 14).asStream),
);
~moog = Psym(Pseq([\test, \rest], inf), f);
)

~moog2 = Pbindf(f.test, \octave, 3);


