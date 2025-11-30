SynthDef(\oneshotStereo, {
	arg amp = 0.2, out = 0, pan = 0,
	buf, cent = 0, rate = 1,
	drive = 0, lpf_cutoff = 20000, hpf_cutoff = 20;
	var freqScale = (cent*0.01).midiratio;
	var dur = BufDur.kr(buf) / rate.abs;
	var sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: rate * BufRateScale.kr(buf) * freqScale,
		loop: 1
	);
	sig = (sig* drive.linexp(0, 1, 1, 25)).tanh; // drive/distortion
	sig = sig * (1 - (drive * 0.5)).pow(2.5);

	sig = sig * Env.linen(0.001, dur - 0.002, 0.001).kr(doneAction: 2);

	sig = LPF.ar(sig, lpf_cutoff);
	sig = HPF.ar(sig, hpf_cutoff);
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\oneshotMono, {
	arg amp = 0.2, out = 0, pan = 0,
	buf, cent = 0, rate = 1,
	drive = 0, lpf_cutoff = 20000, hpf_cutoff = 20;
	var freqScale = (cent*0.01).midiratio;
	var dur = BufDur.kr(buf) / rate.abs;
	var sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: buf,
		rate: rate * BufRateScale.kr(buf) * freqScale,
		loop: 1
	);
	sig = (sig* drive.linexp(0, 1, 1, 25)).tanh; // drive/distortion
	sig = sig * (1 - (drive * 0.5)).pow(2.5);

	sig = sig * Env.linen(0.001, dur - 0.002, 0.001).kr(doneAction: 2);

	sig = LPF.ar(sig, lpf_cutoff);
	sig = HPF.ar(sig, hpf_cutoff);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Event.addEventType(\oneshot, {
	~instrument = \oneshotStereo;
	~dur = 0.25;
	~type = \note;
	currentEnvironment.play;
});

SynthDef(\sliceStereo, {
	arg buf, slice = 0, numSlices = 16,
	atk = 0.002, rel = 0.010,
	transpose = 0, direction = 1,
	drive = 0, cutoff = 20000, rq = 1,
	amp = 0.2, out = 0, pan = 0;

	var startPos = (slice % numSlices) / numSlices;

	var duration = BufDur.kr(buf) / numSlices;
	var sustainTime = duration - atk - (rel * 0.5);

	var env = EnvGen.kr(
		Env.linen(atk, sustainTime, rel),
		doneAction: Done.freeSelf
	);

	var sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.kr(buf) * transpose.midiratio * direction.sign,
		startPos: BufFrames.kr(buf) * startPos
	);

	sig = (sig * drive.linexp(0, 1, 1, 100)).tanh;
	sig = sig * drive.lincurve(0, 1, 1, 0.1, -2);
	sig = RLPF.ar(sig, cutoff.clip(20, 20000), rq.clip(0.0001, 1));
	sig = Compander.ar(sig, sig, 0.1, 1.0, 0.25, 0.01, 0.01) * 10.dbamp;

	sig = Balance2.ar(sig[0], sig[1], pan, amp) * env;
	Out.ar(out, sig);
}).add;

Event.addEventType(\slice, {
	~instrument = \sliceStereo;
	~type = \note;
	currentEnvironment.play;
},(
	dur: 1/16,
	numSlices: 16,
));


SynthDef(\collage, {
    arg amp = 0.2, out = 0, pan = 0,
    transpose = 0, startPos = 0, direction = 1,
    buf, loop = 1, t_reset = 1,
    drive = 0, cutoff = 20000, rq = 1,
    atk = 0.005, sus = 1, rel = 0.2, gate = 1;
    var env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
    var sig = PlayBuf.ar(
        numChannels: 1,
        bufnum: buf,
        rate: transpose.midiratio * BufRateScale.kr(buf) * direction.sign,
        trigger: t_reset,
        startPos: startPos.linlin(0, 1, 0, BufFrames.kr(buf) - 2),
        loop: loop
    );
    sig = (sig * drive.linexp(0, 1, 1, 100)).tanh; // drive/distortion
    sig = RLPF.ar(sig, cutoff, rq) * env;
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;

Event.addEventType(\sample, {
	~instrument = \collage;
	~dur = 0.25;
	~type = \note;
	currentEnvironment.play;
});


