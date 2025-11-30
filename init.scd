// Live coding setup
{
	Server.killAll;

	s.options
	.numOutputBusChannels_(16)
	.numInputBusChannels_(0);

	v = ();

	// Default event modification for musical duration notation (1/4 == 1 beat)
	Event.addParentType(\note, (stretch: 4, dur: 0.25));
	Event.addParentType(\set, (stretch: 4, dur: 0.25));
	Event.addParentType(\monoSet, (stretch: 4, dur: 0.25));

	// ProxySpace config
	p = ProxySpace.push(s)
	.quant_(8)
	.fadeTime_(0.1)
	.makeTempoClock(122/60);

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

	// For Heckler: Submit every evaluated block over OSC to Python server
	l = NetAddr("localhost", 5005);
	this.preProcessor = { |code| l.sendMsg('/code', code); code; };

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
}.value;
