// Code for "Overtones and the Missing Fundmental", 
// published 15 Jan 2019 at The Humming of the Strings.


// The following code creates the basic instrument used to generate 
// overtones. It takes as parameters the frequence of the fundamental, 
// and the particular overtone you want to generate, with "over = 0" 
// corresponding to the fundamental, "over = 1" corresponding to the 
// first overtone, and so on. Note that it is perfectly valid to have 
// fractional overtones. 
//
// The instrument is a simple sine wave, multiplied by a percussive 
// envelope with a short attack and relatively long release. The 
// amplitude of the note and the rate of decay are functions of the 
// "over" parameter, with higher overtones having lower amplitude 
// and decaying more quickly.

(
SynthDef.new(\overtone, {
	arg freq = 400, atk = 0.1, rel = 5, out = 0, 
	    mul = 0.25, over = 0;
	var sig, env;
	sig = SinOsc.ar(freq * (over + 1));
	env = EnvGen.kr(Env.perc(atk, rel, 1, -4.0 * 
		(over+5)/5), doneAction: 2);
	sig = sig * env * mul * pow(0.75, over);
	Out.ar(out, sig!2);
}).add;
)

// The following code creates a function which takes in a fundamental 
// frequency (defaulted to 165 Hz) and a list of overtones and then simultaneously 
// plays our instrument on all of those overtones.

(
~overtones = {
	arg overs, fund = 165;
	Pbind(
	\instrument, \overtone,
	\freq, Pseq([fund], 1),
	\over, overs
).play;
};
)

// Pure sine wave

~overtones.value([0]);

// Missing fundamental illusion.

~overtones.value((0..10));
~overtones.value((1..10));
~overtones.value((2..10));
~overtones.value((3..10));
~overtones.value((4..10));
~overtones.value((5..10));
~overtones.value((6..10));

// Compare the following two sounds. The second sounds much higher and yet has a lower frequency
// than any of the constituents of the first.

~overtones.value((4..100));
~overtones.value([2]);

// Interesting things happen to the tone of a sound when we only hear every other 
// overtone, or every third, etc.

~overtones.value((0..100));      // Every overtone
~overtones.value((0,2..100));    // Every other overtone
~overtones.value((0,3..100));    // Every third overtone
~overtones.value((0,4..100));    // Every fourth overtone
~overtones.value((0,5..100));    // Every fifth overtone
~overtones.value((0,10..100));   // Every tenth overtone

// Particular non-standard overtones can be integral to the sounds of 
// particular instruments. For example, bells typically have an overtone 
// of 2.4 times the fundamental frequency, which corresponds to a minor 
// third above the octave.
// 
// The first sound below is simply the fundamental and the first three overtones 
// and doesn't sound particularly bell-like.
// The second is exactly the same with the sole exception that it includes 
// the overtone at 2.4 times the fundamental frequency and suddenly sounds 
// quite bell-like. It is amazing how much this single change affects the 
// overall complexion of the sound!

~overtones.value([0,1,2,3]);
s.record;
s.stopRecording;
~overtones.value([0,1,1.4,2,3]);
