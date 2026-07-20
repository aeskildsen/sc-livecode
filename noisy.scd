(
SynthDef(\noisy, {
	arg out = 0, amp = 0.2, pan = 0,
	atk = 0.010, rel = 0.100, gate = 1;
	var sig;
	sig = WhiteNoise.ar;
	//sig = Ringz.ar(Impulse.ar(1), 440);
	sig = Resonz.ar(sig * 0.1, 440, 0.5);
	sig = sig * Env.adsr(atk, releaseTime: rel).kr(2, gate);
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;
)

(
~noise = \noisy;
~noise.play(o.main);
)
~noise.stop

x = Synth(\noisy)
x.set(\gate, 0)


~test = { DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }
~test = { Ringz.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], ) }
~test.play(o.lead)


~noise[0] = { WhiteNoise.ar(1 ! 2) * 0.01 }
~noise[1] = \filter -> { |in| in * Env.perc(releaseTime: 0.02).kr(0, Impulse.kr(40)) }
~noise[2] = \filter -> { |in| Ringz.ar(in, 440) }
~test.clear
// Af støj er du kommet...
(
~noise = {
	var sig = WhiteNoise.ar(1 ! 2) * 0.1,
	trig = Impulse.kr(LFSaw.kr(0.5).exprange(2, 10)),
	freq = TExpRand.kr(100, 4000, trig);
	sig = sig * Env.linen(0.01, 0.1, 0.05).kr(0, trig);
	sig = Ringz.ar(sig, freq, TExpRand.kr(0.1, 0.5, trig));
	sig = LPF.ar(sig, freq * 2) * 0.25;
}
)
~noise[1] = \filter -> {|in| CombL.ar(in, 0.5, [0.5, 0.2], 1) }
~noise.set(\wet1, 0.9)

~noise.play(0)
(
~kick = Pbind(
	\type, \oneshot,
	\buf, b.kick2,
	\db, Pseq([-2, -6 ! 3].flat, inf),
	\drive, 0.5,
)
)
~kick.play(0)
~kick.stop(8)
~noise.stop(8)
ProxyMixer(p)