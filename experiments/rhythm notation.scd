var noteValues = (
	$m: 8,   // maxima
	$l: 4,   // long
	$d: 2,   // double note
	$w: 1,   // whole note
	$h: 1/2, // half note
	$q: 1/4, // quarter note
	$e: 1/8, // eighth note
	$s: 1/16,// sixteenth note
	$t: 1/32,// thirty-second note
	$x: 1/64,// sixty-fourth note
);

// Set up language prepocessor
// rhythm notation with rests, dotting, and ties
this.preProcessor = { |code|
	var string = code;


	// note values
	string.findRegexp("dur'[\\l\\u\\. -]*'")
	.collect{ |in|
		var match = in[1],
		outArr = match.copyRange(4, match.size-2) // extract content (between ''s)
		// find and process substrings like "q", "e.", "W", "h-s", "d-q.-s"
		.findRegexp("[\\l\\u]\\.{0,3}(-+?[\\l\\u]\\.{0,3})*")
		.reject{ |x,i| i.odd }
		.collect{ |in|
			var subString = in[1];
			var dur = subString.findRegexp("[\\l\\u]\\.{0,3}").collect{ |in|
				var item = in[1];
				// calculate duration based on letter and dotting
				noteValues[item.first.toLower] * 2.pow(Array.series(item.size).neg).sum;
			}.sum;
			if (subString.first.isLower, {dur * 4}, {Rest(dur * 4)});
		};
		// replace with the generated array
		string = string.replace(match, outArr);
	};

	// return the manipulated string
	string;
};

// Example usage
(
Pdef(\x,
	Pbind(
		\dur, Pseq(dur'q q e e E e. e.', inf),
		\degree, Pshuf((0..7), inf),
	)
).play
)

