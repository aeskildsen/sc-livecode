Routine{
	// load the six wavetables containing oscillator waveforms to the server
	s.waitForBoot({

		var path = PathName(thisProcess.nowExecutingPath).pathOnly;
		var wfbufs = [
			"AKWF_rAsymSqu_01.scwtable", // triangle
			"weirdTriSaw2.scwtable", // weird triangle/saw combination
			"AKWF_saw_0018.scwtable", // saw
			"AKWF_squ_0001.scwtable", // square
			"AKWF_squ_0027.scwtable", // wide pulse
			"AKWF_squ_0047.scwtable", // narrow pulse
		].collect{ |file| Buffer.read(s, path +/+ "wavetables" +/+ file).bufnum };

		0.5.wait;
		s.sync;

		// the SynthDef
		SynthDef(\moogy, {
			arg freq = 440,	amp = 0.2,
			out = 0, pan = 0, glide = 0.05,
			tune = 5,
			// envelope settings
			atk = 0.05, dec = 0.1, sus = 0.6, rel = 1, gate = 1,
			// filter settings
			cutoffOct = 3, fcontourOct = 1, fgain = 0.1,
			fatk = 0.05, fdec = 0.1, fsus = 1, frel = 0.5,
			// lfo settings
			lfoType = 0, lfoRate = 1, lfo2osc = 0, lfo2filt = 0,
			noiseAmp = 0;
			var sources, mix, env, filter, filterEnv, output, cutoff, lfo, lagTime = 0.05;

			lfo = Osc.ar(Select.kr(lfoType, wfbufs), lfoRate.lag(lagTime));

			freq = freq.lag(glide) * LFNoise1.kr(0.02).bipolar(0.05).midiratio;

			env = Env.adsr(atk, dec, sus, rel).kr(2, gate);

			sources = 3.collect{
				arg num;
				var key = \osc ++ num;
				var oscAmp = NamedControl((key ++ \amp).asSymbol, 1 - (0.25 * num));
				var waveformBuf = Select.kr(
					NamedControl((key ++ \type).asSymbol, [2, 2, 4].at(num)),
					wfbufs
				);
				var oscFreq = freq *
				// detune, in cents
				(tune * num * 0.005).midiratio *
				// octave
				2.pow(NamedControl((key ++ \oct).asSymbol, 0)) *
				// lfo modulation
				lfo.unipolar(lfo2osc).midiratio;
				Osc.ar(waveformBuf, oscFreq, Rand(0, 0.5pi)) * oscAmp;
			};

			mix = sources.sum + PinkNoise.ar(noiseAmp);

			filterEnv = Env.adsr(fatk, fdec, fsus, frel).kr(0, gate);

			cutoff = freq * 2.pow(cutoffOct.lag(lagTime))
			* 2.pow(filterEnv * fcontourOct)
			* (lfo * lfo2filt).midiratio;

			filter = MoogFF.ar(mix, cutoff.clip(20, 20000), fgain.clip(0, 4));

			filter = LeakDC.ar(filter);

			Out.ar(out, Pan2.ar(filter * env, pan, amp.lag(lagTime)));
		}).add;

	});

	Event.addEventType(\moog, {
		~instrument = \moogy;
		~type = \note;
		currentEnvironment.play;
	});
}.play;
