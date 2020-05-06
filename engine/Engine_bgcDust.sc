/*
 * made by bgc
 *
 */

Engine_bgcDust : CroneEngine {
    var dustSynth;

    *new {
        arg context,
            callback;
        ^super.new(context, callback);
    }

    alloc {

        SynthDef.new(\dusts,
        {
            | out, rate = 1, amp = 0.5|
            var eng;
            eng = Dust2.ar(rate);

            Out.ar(out, LeakDC.ar(eng * amp))
        }).add;

        context.server.sync;

        dustSynth = Synth(\dusts, [\out, context.out_b.index]);

        this.addCommand(\setRate, "f", { arg msg;
            var val = msg[1].asFloat;
            dustSynth.set(\rate, val);
        });

        this.addCommand(\setAmp, "f", { arg msg;
            var val = msg[1].asFloat;
            dustSynth.set(\amp, val);
        });
    }

    free {
        dustSynth.free;
    }
}