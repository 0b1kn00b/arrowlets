package stx.async.arrowlet;

import tink.core.Future;
import stx.types.*;
import stx.types.Tuple2;
import stx.Tuples;


using stx.async.Arrowlet;
using stx.Tuples;

abstract Either<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(a:Arrowlet<I,O>,b:Arrowlet<I,O>){	
		this = new Arrowlet(
			inline function(?i:I,cnt : O->Void){
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
								cnt(o);
							}
						}.tupled();

				a_0 = new FutureTrigger();
				a.withInput(i,
					function(x){
						a_0.trigger(x);
					}
				);
				b_0 = new FutureTrigger();
				b.withInput(i,
					function(x){
						b_0.trigger(x);
					}
				);

				a_1 = a_0.asFuture().map(function(x) return tuple2(a_0.asFuture(),x));
				a_1.handle(handler);
				b_1 = b_0.asFuture().map(function(x) return tuple2(b_0.asFuture(),x));
				b_1.handle(handler);
			}
		);
	}
}