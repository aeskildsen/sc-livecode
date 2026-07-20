s.boot

(
SynthDef(\fm2,{
	arg freq=500, mRatio=1, cRatio=1, index=1, iScale=5,
	atk=0.1, rel=0.9, cAtk=4, cRel=(-4), dur=1, legato=1,
	pan=0, out=0, amp=0.2;
	var car, mod, env, iEnv, mod2;
	iEnv = Env.new(
		[index, index * iScale, index],
		[atk, rel],
		[cAtk, cRel]
	).kr(timeScale: dur*legato);
	env = Env.perc(atk, rel, curve: [cAtk, cRel]).kr(2, timeScale: dur*legato);
	mod2 = SinOsc.ar(freq/10, mul: freq/10 * iEnv);
	mod = SinOsc.ar(freq * mRatio + mod2, mul: freq *mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env;
	Out.ar(out, Pan2.ar(car, pan, amp));
}).add;
)

(
SynthDef(\fm,{
	arg freq = 400, index = 1, modRatio = 1,
	amp = 0.2, release = 1,
	out = 0, pan = 0;
	var car, mod, env, indexEnv;
	env = Env.perc(releaseTime: release).kr(2);
	indexEnv = Env.perc(0.001, release/10).kr.pow(2.5) * 25;
	mod = SinOsc.ar(freq * modRatio) * freq * index * modRatio * indexEnv;
	//mod = 0;
	car = SinOsc.ar(freq + mod) * env * amp;
	Out.ar(out, Pan2.ar(car, pan, amp));
}).add;
)

TempoClock.tempo = 2
Pbindef(\z, \instrument, \fm, \octave, 4, \index, 1, \release, 1).play
(
Pbindef(\mel,
	\instrument, \fm,
	\degree, Pbrown(-7, 14, 3),
	\dur, Pseq([
		Pwrand([1/16, 1/8, 1/4], [0.7, 0.2, 0.1], Pwhite(2, 18).asStream),
		Prand([Rest(1/2), Rest(3/4), Rest(1/4)])
	], inf),
	\out, 2,
	\amp, 0.2,
).play;
)
Pbindef(\mel).stop
2.pow((2..3))