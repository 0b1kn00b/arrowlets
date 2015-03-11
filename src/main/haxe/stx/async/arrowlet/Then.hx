package stx.async.arrowlet;

import tink.core.Future;
import stx.types.*;

import stx.async.ifs.Arrowlet in IArrowlet;

using stx.async.Arrowlet;

class Then<A,B,C> extends Combinator<A,B,B,C,A,C>{
	public function new(fst:Arrowlet<A,B>,snd:Arrowlet<B,C>){
		super(fst,snd);
	}
	@:callable override public function apply(i: A): Future<C>{
		return fst.apply(i).flatMap(
			function(x){
				return snd.apply(x);
			}
		);
	}
}