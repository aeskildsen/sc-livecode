// Start the system
"init.scd".loadRelative;

// VSTPlugins
v.piano.browse;
v.glock.browse;
v.loadPresets.value;


// Event types
\oneshot
\slice    // remember \numSlices
\vst_midi // use v.piano (for instance) with the key \vst
\bass

// SynthDefs
\noisy
\moog
\oneshot
\slice
\vsti

// Snippets
:pianointro
:pdefvst
:leads
:slicer
:hihat
:bass

