// Start the system
"init.scd".loadRelative;

// VSTPlugins
v.piano.browse;
v.clarinet.browse;
v.glock.browse;

v.loadPresets.value;

// Overview of global variables
o // Dictionary of outputs
v // Dictionary of VSTPluginControllers
m // ProxyMixer
p // ProxySpace
b // Dictionary of Buffers


// Event types
\oneshot
\moog
\slice    // remember \numSlices
\vst_midi // use v.piano (for instance) with the key \vst

// SynthDefs
\noisy
\moogy
\oneshot
\slice
\vsti

ProxyMixer(p)
