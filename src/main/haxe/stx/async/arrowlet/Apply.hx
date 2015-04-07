package stx.async.arrowlet;

import tink.core.Future;
using stx.Tuples;

import stx.async.ifs.Arrowlet in IArrowlet;

using stx.async.Arrowlet;

import stx.types.*;
import stx.Tuples;

typedef AAIn<I,O> 			= Tuple2<Arrowlet<I,O>,I>;
typedef TApply<I,O> 		= Arrowlet<AAIn<I,O>,O>;

@:callable abstract Apply<I,O>(Arrowlet<AAIn<I,O>,O>) from Arrowlet<AAIn<I,O>,O> to Arrowlet<AAIn<I,O>,O>{
	public function new(){
    this = Arrowlet.fromCallbackWithNoCanceller(
      function(v:Tuple2<Arrowlet<I,O>,I>,cont:Sink<O>){
        v.fst()(v.snd(),cont);
      }
    );
	}
}