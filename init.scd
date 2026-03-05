// Live coding setup
{
	// Misc namespace for non-NodeProxy objects
	n = ();
	n.defaults = (stretch: 4, dur: 0.25, scale: Scale.minorPentatonic, root: 2);

	// Default event modification for musical duration notation (1/4 == 1 beat)
	Event.addParentType(\note, n.defaults);
	Event.addParentType(\set, n.defaults);
	Event.addParentType(\monoSet, n.defaults);
	/*Event.addParentType(\rest, (stretch: 4));
	Event.addParentType(\silent, (stretch: 4));*/

	// Server config
	Server.killAll;

	s.options
	.numOutputBusChannels_(16)
	.numInputBusChannels_(0);

	// Namespace for vst plugin controllers
	v = ();

	// ProxySpace and Pdef config
	ProxySpace.clearAll;
	p = ProxySpace.push(s)
	.quant_(8)
	.fadeTime_(0.1)
	.makeTempoClock(122/60);

	Pdef.defaultQuant_(8);

	// Server start
	s.waitForBoot({
		var rootFolder = PathName(thisProcess.nowExecutingPath).pathOnly;

		Buffer.freeAll;

		// Load SynthDefs
		PathName(rootFolder +/+ "SynthDefs").files.do({|f| f.fullPath.load});

		// Load samples
		b = ();
		PathName(rootFolder +/+ "samples").files.do({
			arg file;
			var key = file.fileName.split($_).first.asSymbol;
			b.put(key, Buffer.read(s, file.fullPath));
		});

		/*s.scope(numChannels: 2, bufsize: 2048, zoom: 2)
		.yZoom_(4).style_(1).size_(400)
		.window.alwaysOnTop_(true);*/
	});


	// Output bus numbers
	o = (
		lead: 0,
		main: 2,
		bass: 4,
		kick: 6,
		snare: 8,
		hat: 10,
		perc: 12,
		misc: 14
	);

	// Predefined rest arrays
	r = (
		long: [
			Rest(1),
			Rest(1/2),
			Rest(3/4),
			Rest(3/2),
			Rest(5/4),
		],
		short: [
			Rest(1/4),
			Rest(1/8),
			Rest(1/16)
		]
	);

	// For Heckler: Submit every evaluated block over OSC to Python server
	l = NetAddr("localhost", 5005);
	this.preProcessor = { |code| l.sendMsg('/code', code); code; };

	"".postln;
	"Global variables:
    o - Dictionary of output bus numbers
	v - Dictionary of VSTPluginControllers
	p - ProxySpace
	b - Dictionary of Buffers
	n - Misc namespace for non-NodeProxy objects
	r - Dict with array of Rests (long, short)
	m - Reserved for ProxyMixer".post;
	"".postln;

}.value;
