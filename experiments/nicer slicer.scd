(
// Turn this into a snippet as well
~slicer = Pbind(
	\type, \slice,
	\buf, Prand([b.loop0], inf),
	\numSlices, 16,
	\slice, Pseq((0..15).scramble, inf),
	\slice, Pshunc((0..7) + 8, 16, 4).stutter(Pwhite(1, 4).asStream).repeat,
	\dur, 1/16,
	\pan, Pgauss(0, 0.2),
	\drive, 0.9,
)
)

~slicer[1] = \filter -> {|in| CombL.ar(in, 1, [LFNoise2.kr(0.1!2).exprange(0.05, 0.4)], 20)};
~slicer[2] = \filter -> {|in| RLPF.ar(in, SinOsc.kr(0.05).exprange(200, 4000), LFTri.kr(0.02).exprange(0.05, 0.3)) };
~slicer.xset(\wet1, 0.5);
~slicer.xset(\wet2, 0.5);
~slicer.fadeTime_(2)

~slicer.play(o.misc)

~slicer[0] = { Env.perc(releaseTime: 10).kr * WhiteNoise.ar(0.1!2) }

p.stop(4)

