// Start the
s.waitForBoot({
	SynthDef(\vsti, { arg out = 0;
		Out.ar(out, VSTPlugin.ar(nil, 2));
	}).add;
	VSTPlugin.search;

	"Initializing VST plugins.\nPlugins and presets must be loaded manually because opening sfizz doesn't work programmatically at the moment.".postln;"".postln;

	"For each of the following, run v.{name}.browse:\npiano, flute, and clarinet.".postln; "".postln;
	"Then run v.loadPresets.value;".postln;
	~piano = \vstDef -> \vsti;
	v.piano = VSTPluginNodeProxyController(~piano);

	~glock = \vstDef -> \vsti;
	v.glock = VSTPluginNodeProxyController(~glock);

	~clarinet = \vstDef -> \vsti;
	v.clarinet = VSTPluginNodeProxyController(~clarinet);

	v.loadPresets = {
		v.piano.loadPreset("uprightPiano");
		v.glock.loadPreset("glock");
		v.clarinet.loadPreset("clarinet");
	};
	"".postln;
	"Use with Pdef:".postln;
	"Pdef(\\test, Pbind(
    \\type, \\vst_midi,
	\\vst, v.piano,
)).play;".postln;
	nil;
})
