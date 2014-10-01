package stx.async.arrowlet;

import tink.core.Future;
import stx.types.*;
import stx.types.Tuple2;
import stx.Tuples;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

using stx.async.Arrowlet;
using stx.Tuples;

class Either<I,O> extends Combinator<I,O,I,O,I,O>{
	override public function apply(v:I):Future<O>{
		var out = Future.trigger();
		var done = false;
		var a_0 : FutureTrigger<O>	= null;
		var b_0 : FutureTrigger<O>	= null;

		var a_1 : Future<Tuple2<Future<O>,O>>= null;
		var b_1 : Future<Tuple2<Future<O>,O>>= null;

		var handler 
			= function(f:Future<O>,o:O):Void{
					if(!done){
						done = true;
						//trace('either done');
						out.trigger(o);
					}
				}.tupled();

		a_0 = new FutureTrigger();
		fst.withInput(v,
			function(x){
				a_0.trigger(x);
			}
		);
		b_0 = new FutureTrigger();
		snd.withInput(v,
			function(x){
				b_0.trigger(x);
			}
		);

		a_1 = a_0.asFuture().map(function(x) return tuple2(a_0.asFuture(),x));
		a_1.handle(handler);
		b_1 = b_0.asFuture().map(function(x) return tuple2(b_0.asFuture(),x));
		b_1.handle(handler);

		return out;
	}
}