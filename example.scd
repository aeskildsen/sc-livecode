// Start the system
"init.scd".loadRelative;

v.piano.browse;

v.clarinet.browse;

v.glock.browse;

v.loadPresets.value;


~glock.play(o.main)
~glock[1] = { |in| Splay.ar(CombL.ar(in, 0.2, CombL.ar(in, 0.5, (0.1, 0.15..0.5)), 3)) };
~glock[1] = \filter -> { |in| CombL.ar(in, 0.5, LFNoise2.ar(2).range(0.1, 0.5), 4) };
~glock[2] = \filter -> { |in| (in * 1000).tanh * 0.1 };
~glock.set(\wet1, 1)
~glock.set(\wet2, 1)

(
Pdef(\glock, Pbind(
	\type, \vst_midi,
	\vst, v.glock,
	\degree, Pseries(7, Pwhite(-14, 14).asStream, 14).repeat,
	\amp, Pexprand(0.5, 0.8),
	\dur, Prand([1, 1/2, Pn(1/6, 3), 1/8, Pn(1/32, 4)], inf),
)).play;
)

Pdef(\test).stop

p.stop
p.end
p.clock.tempo = 2
p.fadeTime = 0.01


~bass.clear
~bass.play(o.main);
~bass.stop(0);
(
~bass =	Pbind(
	\type, \moog,
	\octave, 3,
	\root, 5,
	\degree, Pseq([-2, 0, 1, 0], inf),
	\dur, 1/16,
	\legato, 0.1,
	\rel, 0.1,
	\pan, Pgauss(0, 0.1),
	\osc0type, 1, \osc1type, 0, \osc2type, 2,
	\fgain, 1.2,
	\foctave, 4,
	\amp, Pgauss(0.2, 0.005),
	\glide, 0.001,
	//\test, Pfunc({|e|e.postln})
);
)
(
~bass = Pmono(\moogy,
	\degree, Pseq([-2, 0, 2, 4, 5, 4, 1, 2 ].scramble, inf),
	\dur, 1/16,
	\octave, [3,4,5],
	\fgain, 1,
	\foctave, 3,
	\osc0type, 1, \osc1type, 2, \osc2type, 2,
	\osc0amp, 1, \osc1amp, 1, \osc2amp, 1,
	\glide, 0.01,
	\lag, 0,
	\db, Pseries(-10, -0.1, 100)
)
)

~kick.play(o.snare);
~kick.stop;
~kick = Pbind(\instrument, \kick, \dur, 1/4)

~sd = Pbind(\instrument, \snare, \dur, 1/2)


~test = Pbind(\legato, 0.1)
~test.play
~test.stop

~noise = {PinkNoise.ar * 0.1 ! 2}
~noise.stop

~noise.play(o.main)


~kick = Pbind(\type, \oneshot, \buf, b.kick2, \db, -10, \drive, 0.5, \transpose, Pseries(0,2, 8).repeat);

(
~beat = Pbind(
	\type, \slice,
	\buf,  b.loop1,
	\slice, Pseq(
		[0, 3, 0, 9, 10, 16].scramble + 1, inf
	).stutter(Pwhite(1, 6).asStream),
	\numSlices, 8 * 16,
	\rel, 0.001,
	\dur, 1/16,
	//\drive, 0.9,
	// \cutoff, Pgeom(100, 1.125, 32).repeat,
	//\cutoff, Pexprand(100, 4000),
	//\rq, Pexprand(0.01, 0.1),
	\db, -10,
	\pan, Pwhite(-0.8, 0.8),
);
~beat.play(o.perc)
)
-10.dbamp

(type: \slice, \buf: b.loop1, \numSlices: 4 * 16).play

~perc = Pbind(

)

~beat.play
b.loop1.play
~beat.stop(16)
~beat.clear



Event.addEventType(\test, { ("x was" + ~x.value).postln }, (x: { ~y + 1 }, y: 0));

(type: \test, y: 5, x: 10).play


