SynthDef(\noisy, {
	arg out = 0, amp = 0.2, pan = 0, drive = 0,
	atk = 0.01, rel = 0.01, gate = 1, freq = 1000;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = WhiteNoise.ar(0.1 ! 2);
	sig = DynKlank.ar(`[
		[
			freq,
			freq * 0.3.midicps,
			freq * Rand(22.0, 26.0).midicps,
			freq * Rand(34.0, 37.0).midicps
		] * LFNoise1.kr(0.25!4).bipolar(0.5).midiratio,
		[1, 0.8, 3.6, 1.4],
		[1, 1, 1, 1]
	], sig);
	sig = (sig * drive.linexp(0,1,1,50)).tanh;
	sig = sig * env;
	Out.ar(out, Balance2.ar(sig[0], sig[1], pan, amp));
}).add;

