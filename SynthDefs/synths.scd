SynthDef(\kick, {
    arg pan = 0, amp = 0.2, out = 0, rel = 0.2, cutoff = 8000,
    clickFreq = 500, clickRq = 0.4, clickAmp = 0.5, bodyDelay = 0.005,
    bodyStart = 350, bodyEnd = 50, bodyAmp = 1, bodyTime = 0.045;

    var clickEnv = Env.perc(0.001, 0.02, clickAmp).ar;
    var click = BPF.ar(WhiteNoise.ar, clickFreq, clickRq) * clickEnv;

    var bodyEnv = Env.perc(0.0001, rel, bodyAmp, \lin).delay(bodyDelay).ar(doneAction: 2);
    var body = SinOsc.ar(XLine.ar(bodyStart, bodyEnd, bodyTime)) * bodyEnv;

    var sig = (body + click).tanh;

    sig = LPF.ar(sig, cutoff);
    sig = Pan2.ar(sig, pan, amp);
    Out.ar(out, sig);
}).add;

SynthDef(\snare,{
    arg pan = 0, amp = 0.1, out = 0,
    body = 0, harmonics = 0, click = 0,
    highNoise = 0, lowNoise = 0;

    var sig = [
        // Resonansrum
        SinOsc.ar([180, 330]).sum
        * EnvGen.ar( Env.perc(0.03, 0.2))
        * (body - 3).dbamp,

        // Overtoner
        LFTri.ar([286, 335] *
          EnvGen.ar(Env.new([1, 1.5, 1], [0.01, 0.09], \sine))
        ).sum * EnvGen.ar(Env.perc(0.01, Rand(0.09, 0.11)))
         * (harmonics + 2).dbamp,

        // Klik
        LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000)
        * EnvGen.ar(Env.linen(0.001, 0.01, 0.001))
        * click.dbamp,

        // Seiding
        HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3),300)
        * EnvGen.ar(
          Env.perc(0.05, Rand(0.16, 0.19)).delay(0.01),
          doneAction: Done.freeSelf)
        * (highNoise - 8).dbamp,

        // Dyb støj
        LPF.ar(HPF.ar(WhiteNoise.ar, 230),500)
        * EnvGen.ar(Env.perc(0.1, Rand(0.09, 0.11)))
        * (lowNoise-5).dbamp
      ].sum;

    sig = (sig * 1.5).tanh;  // Distortion/komprimering
  Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;
