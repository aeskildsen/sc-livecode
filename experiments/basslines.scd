~kick = Pbind(\type, \oneshot, \buf, b.kick0, \amp, Pgauss(0.4, 0.005))
(
~hihat = Pbind(\type, \oneshot, \buf, b.hat0, \amp, Pgauss(0.5, 0.002),
	\dur, Pbjorklund2(Prand((9,11..13), inf), 16) / 16,
	//\dur, Pxsum([1/12, 1/6], 0.5, 8).repeat,
	//\dur, 1/8,
	\pan, 0,
	\cutoff, Pexprand(5000, 8000),
	\db, Pgauss(-10, 0.5),
	\rate, Pgauss(1, 0.1),
)
)
~kick.play(o.kick);
~hihat.play(o.hat)

(
~bass = Pbind(
	\type, \bass,
	\dur, 1/8,
	\dur, Pif(
		Pfunc{0.7.coin},
		1/8,
		Rest(1/8) * 4
	),
	\degree, Pshunc((-1..5), 8, 8).repeat,
	\pan, 0,
)
)
~bass.play(o.bass)
~bass.stop(8)
~bass.end

(
g = (
	main: Pmono(\moog,
		\degree, Pser([-2, 0, 1, 2, 3, 4, 5].scramble, Pwhite(24, 32).asStream),
		\lfo2osc, 0.1,
		\mtranspose, Pif(Pfunc{0.7.coin}, 0, 5),
		\octave, 5,
		\dur, Pn(1/2, 1) ++ Prand([1/8,  1/16, 1/16], inf),
	)
);
~lead = Psym(
	Pseq([\phrases, \rest], inf),
	(
		phrases: Prand([
			g.main,
			Pbindf(g.main, \octave, 6),
		]),
		rest: Pn(Rest(1), Pwhite(4, 12).asStream),
));
)

~lead.play(o.lead);
~lead.stop(16)
~lead.end

p.stop(4)
p.end

Event.addParentType(\note, n.defaults.put(\ctranspose, 2));


(
~noise = Pbind(
	\instrument, \noisy,
	\dur, Pseq([
		Rest(1/8) * 4,
		Pif(Pfunc{0.5.coin},
			Rest(1/8) * 4,
			1/8
		)
	]),
	\legato, 0.25,
	\pan, Prand([-0.5, 0.5], inf),
	\cutoff, Pexprand(2000, 6000),
)
)

~noise.play(o.perc)
~bass.stop(8)

p.end

~hihat.stop(4); ~noise.stop(4);

(
~slicer = Pbind(
	\type, \slice,
	\buf, b.loop0,
	\numSlices, 16,
	\dur, 1/16,
	\rate, Pwhite(-2, 2),
	\slice, Pshuf((0..15), 8, 4).repeat,
	\pan, Pgauss(0, 0.1),
	\lag, Pgauss(0, 0.02),
	\drive, Pexprand(0.5, 1),
)
)

~slicer[1] = \filter -> {|in| CombL.ar(in, 1, [0.3, 0.5], 8);}; ~slicer.set(\wet1, 0.4)

~slicer.play(o.perc)
~slicer.clear
~kick.play

~slicer.stop(4)
~kick.stop(4)
~glock.stop(4)

