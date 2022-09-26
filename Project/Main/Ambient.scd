(

NetAddr("127.0.0.1",57120);

SynthDef(\airportAmb, {
	arg hz=440,amp=0.5, outBus = 0, effectBus, direct = 0.9,cutoff=200;
	var note=hz.cpsmidi;
	var snd,snd2,intro, output;

	// these notes are directly from Eno's Music for Airports
	// each phrase is one line, and played through
	var airports=[
		[5,7,4,2,0,12,7,5,7,4,2,0],
		[5,7,4,2,0,12,4,7,5,0],
		[-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
		[7,7,2,4,4,4,2,0,7,0,0],
	];
	// these are some chords I made up that sound nice with it
	var planes=[
		[0,4,7,12],
		[4,7,11,16],
		[-3,0,4,7],
		[-3,0,5,9],
	];

	// setup the note change variables
	var seq,seqnote,notepulse,noterate;
	var planeseq,planenotes,planeenv,planenotechange;
	// piano stuff
	var noise, string, delaytime, lpf, noise_env,pianosnd,pianosnd2, damp_mul,pianohz,noise_hz;
	var noise_attack=0.002, noise_decay=0.06,
	tune_up = 1.0005, tune_down = 0.9996, string_decay=6.0,
	lpf_ratio=2.0, lpf_rq = 4.0, hpf_hz = 40, damp=0, damp_time=0.1;

	// chord and note changes (random)
	planenotechange=Dust.kr(1/30)+Impulse.kr(0);
	planeenv=1-EnvGen.kr(Env.perc(3,10,0.9),planenotechange);
	planenotes=Demand.kr(TDelay.kr(planenotechange,3),0,Dxrand(planes,inf));
	notepulse=1;
	noterate=TChoose.kr(Dust.kr(notepulse)+Impulse.kr(0),[0.02,0.05,1,2,0.5,0.25,2]/2)*Rand(0.78,1.32);
	notepulse=Impulse.kr(noterate);
	seq=Demand.kr(Dust.kr(0.1)+Impulse.kr(0),0,Dxrand(airports,inf));
	seqnote=Demand.kr(notepulse,0,Dseq(seq,inf));
	// bass note
	snd=SinOsc.ar((note-24).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.05,0.15));
	snd=snd+SinOsc.ar((note-12).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.001,0.05));
	// chords
	snd=snd+(planeenv*Mix.ar(Array.fill(8,{arg i;
		var snd;
		snd=SawDPW.ar((note+planenotes[i%4]+Select.kr(DC.kr(i%4)<1,[24.neg,36.neg])).midicps,mul:0.9);
		snd=LPF.ar(snd,LinExp.kr(SinOsc.kr(rrand(1/30,1/10),rrand(0,2*pi)),-1,1,hz,hz*5));
		snd=DelayC.ar(snd, rrand(0.01,0.03), LFNoise1.kr(Rand(5,10),0.01,0.02)/15 );
		Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7
	})));
	snd=MoogLadder.ar(snd.tanh,LinExp.kr(VarLag.kr(LFNoise0.kr(1/6),6,warp:\sine),-1,1,hz*2,hz*60));
	snd=snd+(0.55*DynKlank.ar(`[[(note+planenotes[0]).midicps, (note+planenotes[1]).midicps, (note+planenotes[2]).midicps, (note+planenotes[3]).midicps], nil, [1, 1, 1, 1]], PinkNoise.ar([0.004, 0.004])));

	// piano sound from https://github.com/catfact/zebra/blob/master/lib/Engine_DreadMoon.sc#L20-L41
	noise_hz=VarLag.kr(LFNoise0.kr(1/10),10).range(2000,5000);
	pianohz=A2K.kr((note+seqnote-12).midicps);
	noise_env = Decay2.ar(Impulse.ar(noterate));
	noise = LFNoise2.ar(noise_hz) * noise_env;
	damp_mul = LagUD.ar(K2A.ar(1.0 - damp), 0, damp_time);
	delaytime = 1.0 / (pianohz * [tune_up, tune_down]);
	string = Mix.new(CombL.ar(noise, delaytime, delaytime, string_decay * damp_mul));
	pianosnd = RLPF.ar(string, lpf_ratio * pianohz, lpf_rq) * amp;
	pianosnd = HPF.ar(pianosnd, hpf_hz);

	// polyperc sound
	pianosnd2=(
		EnvGen.ar(Env.perc(release:4),notepulse)*
		MoogFF.ar(Pulse.ar((note+seqnote).midicps,mul:1.0),(note).midicps*1.5)
	);

	// mix between polyperc and piano sound randomly
	snd=snd+SelectX.ar(SinOsc.kr(LFNoise0.kr(0.1).range(0.01,0.1)).range(0.1,0.9),[pianosnd*0.3,pianosnd2]);
	snd=LPF.ar(snd,(note+36).midicps);
	snd=HPF.ar(snd,120);
	snd=snd*EnvGen.ar(Env.new([0,0,1],[0.5,3]));
	snd=FreeVerb.ar(snd,0.45,2.0,0.5);
	snd2=snd;

	// reverb
	snd2 = DelayN.ar(snd2, 0.03, 0.03);
	snd2 = CombN.ar(snd2, 0.1, {Rand(0.01,0.099)}!32, 4);
	snd2 = SplayAz.ar(2, snd2);
	snd2 = LPF.ar(snd2, 1500);
	5.do{snd2 = AllpassN.ar(snd2, 0.1, {Rand(0.01,0.099)}!2, 3)};

	//Low pass
	output = (snd2*0.1+snd)*amp;
	output = LPF.ar(output,cutoff);

	//extra reverb
	output = FreeVerb2.ar(output,output, 1, 0.9, 0);

	// final output
	// this will be our main output
	Out.ar(outBus, output * direct);
    // this will be our effects output
    Out.ar(effectBus, output * (1 - direct));
}).add;

//Distortion effect

SynthDef(\distortion, {arg amp = 0, smooth=0.5, outBus = 0,mul=0.00, inBus;
	var input;
	input = In.ar(inBus, 1);
	//input = CrossoverDistortion.ar(input, amp: amp, smooth: 0.5, mul: mul, add: 0);
	input = InsideOut.ar(input,mul);
	Out.ar(outBus,[input,input]);
}).add;

SynthDef(\pinkNoise, { arg outBus = 0, mul = 0.02;
    var trig=1, seq, freq, signal,env, dur = 2.5;
	env = EnvGen.kr(Env.new([1, 1, 0], [dur-0.02, dur]), doneAction:2);
    trig = Impulse.kr(10);
	seq = Drand([0.4,0.5,0.6,0.7,0.8,0.9], inf);
    freq = Demand.kr(trig, 0, seq);
	signal = PinkNoise.ar  * LFPulse.kr(freq,0) * mul;
	signal = InsideOut.ar(signal,0.015) * env;
	Out.ar(outBus, [signal,signal]); // maybe pan it!
}).add;


SynthDef(\bell, {
	|fs=1, t60=1, pitchy=1, amp=0.4, gate=1|
	var sig, exciter;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:fs*pitchy);
	sig = FreeVerb.ar(sig,0.8,0.8,0) * amp;
	DetectSilence.ar(sig, 0.001, 2, doneAction:2);
	//sig = InsideOut.ar(sig,0.02);
	Out.ar(0, sig!2);
}).add;


b = Bus.audio(s,2); // this will be our effects bus

// Start the AmbientSynth and distortion effect bus
x = Synth.new("distortion", [\inBus, b]);
y = Synth.before(x, "airportAmb", [\effectBus, b]);


// OSC Receiver from the world state
OSCdef('OSCreceiver',
	{
		arg msg;
		var unawareness, activity;

		unawareness=msg[1];
		activity=msg[2];

		unawareness = unawareness*0.02;
		activity = 500 * (activity + 0.2);

		x.set(\mul, unawareness);
		y.set(\cutoff, activity);

		//unawareness.postln;
		//activity.postln;
	},
	"/supercollider/note_effect");

// OSC Receiver from the news interaction
OSCdef('OSCreceiver2',
	{
		arg msg;
		if ( msg[1] == 1,
			{ Pbind(
					\instrument, \bell,
					\fs, Pseq( [66], 1).midicps,
					\t60, 0.5,
					\pitchy, 2,
					\dur, 0.15
				).play;}    // false function
		);
		if ( msg[1] == -1,
			{ z = Synth(\pinkNoise); }
		);
	},
	"/supercollider/notification");

)

// Play the pink Noise when a fake news is selected
z = Synth(\pinkNoise);

// Play a sound when selecting a real news
(
Pbind(
	\instrument, \bell,
	\fs, Pseq( [66], 1).midicps,
	\t60, 0.5,
	\pitchy, 2,
	\dur, 0.15
).play;
)


// Controls to interact with the music
x.set(\mul, 0.01); // map this beween 0 and 0.02
y.set(\direct,1);
y.set(\cutoff, 200); // controls the LPF cutoff
z.set(\mul, 0.02); // map this also between 0 and 0.02 maybe a little more



