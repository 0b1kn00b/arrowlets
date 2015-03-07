package stx.async.arrowlet;

import tink.core.Future;
using stx.Tuples;

import stx.async.ifs.Arrowlet in IArrowlet;

using stx.async.Arrowlet;

import stx.types.*;
import stx.Tuples;

typedef AAIn<I,O> 			= Tuple2<Arrowlet<I,O>,I>;
typedef TApply<I,O> 		= Arrowlet<AAIn<I,O>,O>;

class Apply<I,O> implements IArrowlet<AAIn<I,O>,O>{
	public function new(){

	}
	public function apply(v:Tuple2<Arrowlet<I,O>,I>):Future<O>{
		return v.fst().apply(v.snd());
	}
}