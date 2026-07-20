VSTPlugin.search(s, "/usr/lib64/vst3/")

// Cmd + .
(
SynthDef.new(\vsti, { arg out = 0;
    // VST instruments usually don't have inputs
    Out.ar(out, VSTPlugin.ar(nil, 2));
}).add;
)


// create Synth with VST instrument
~vsti = VSTPluginController(Synth(\vsti));
// open plugin
~vsti.browse;
~vsti.open("sfizz")
~vsti.open("/usr/lib64/vst3/sfizz.vst3")

// show gui
~vsti.editor;

// play the instrument with a \vst_midi Pbind
(
~p = Pbind(
    \type, \vst_midi,
    \vst, ~vsti, // the VSTPluginController instance
    \midicmd, \noteOn, // the default, can be omitted
    \chan, 0, // MIDI channel (default: 0)
    \midinote, Pseq(#[0, 2, 4, 7], inf) + Pwhite(-12, 12).stutter(Pwhite(4, 16)) + 60,
    \dur, Prand(#[0.125, 0.25, 0.5], inf),
    \legato, Pexprand(0.5, 1.0, inf),
    \amp, Pexprand(0.5, 1.0, inf)
).play(quant: 1);
)
~p.stop;

// change programs
~vsti.program_(1);

~vsti.info.printPrograms
~vsti.savePreset("upright")
~vsti.gui

// jitlib

~piano = \vst -> { VSTPlugin.ar(nil, 2) }
~piano.play(2)
v = VSTPluginNodeProxyController(~piano)
VSTPlugin.search(s, ['/usr/lib64/vst3'])
v.open("sfizz")
v.name
v.browse
v.editor
v.savePreset("clarinet")
v.loadPreset("uprightPiano")
(
Pdef(\test, Pbind(
	\type, \vst_midi,
	\vst, v.glock,
	\degree, Pwhite(-14, 14),
	\amp, 0.5,
	\dur, Pexprand(0.1, 2),
	\legato, 1
)).play;
)
Pdef(\test).stop
~flute = \vstDef -> \vsti;
u = VSTPluginNodeProxyController(~flute);
~flute.play
u.loadPreset("clarinet")
u.open("sfizz", verbose: true)
u.info.presets
u.browse
u.editor
~glock.play;
VSTPlugin.search

/*
fizz presets:
- uprightPiano
- glock
- flute
- clarinet */

v.piano.browse;
v.clarinet.browse;
v.glock.browse;
v.loadPresets.value;

