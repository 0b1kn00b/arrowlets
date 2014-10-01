package stx.async.arrowlet;

import stx.types.Tuple2;
import tink.core.Future;
import stx.Tuples;

using stx.Tuples;
import stx.types.*;
using stx.async.Arrowlet;

typedef ArrowletPair<A,B,C,D> = Arrowlet<Tuple2<A,C>,Tuple2<B,D>>; 

class Pair<A,B,C,D>	extends Combinator<A,B,C,D,Tuple2<A,C>,Tuple2<B,D>>{
//(ArrowletPair<A,B,C,D>) from ArrowletPair<A,B,C,D> to ArrowletPair<A,B,C,D>{
	override public function apply(i : Tuple2<A,C>):Future<Tuple2<B,D>>{
		var otrg = Future.trigger();

		var ol : Option<B> 	= null;
		var or : Option<D> 	= null;

		var merge 	=
			function(l:B,r:D){
				otrg.trigger( tuple2(l,r) );
			}
		var check 	=
			function(){
				if (((ol!=null) && (or!=null))){
					merge(Options.valOrC(ol,null),Options.valOrC(or,null));
				}
			}
		var hl 		= 
			function(v:B){
				ol = v == null ? None : Some(v);
				check();
			}
		var hr 		=
			function(v:D){
				or = v == null ? None : Some(v);
				check();
			}
		fst.apply(i.fst()).handle(hl);
		snd.apply(i.snd()).handle(hr);

		return otrg.asFuture();
	}
}