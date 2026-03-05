(
~slicer = Pbind(
	\type, \slice,
	\buf, b.loop0,
	\numSlices, 16,
	\dur, 1/16,
	\slice, Pseq((0..15), inf),
	\pan, 0,
	\drive, 0,
)
)