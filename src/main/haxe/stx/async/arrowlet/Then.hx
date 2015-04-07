package stx.async.arrowlet;

import tink.core.Future;
import stx.types.*;

using stx.async.Arrowlet;


abstract Then<A,B,C>(Arrowlet<A,C>) from Arrowlet<A,C> to Arrowlet<A,C>{
	public function new(fst:Arrowlet<A,B>,snd:Arrowlet<B,C>){
		this = function(v:A,cont:C->Void){
			var cn0,cn1 = null;
			cn0 = fst(v,
				function(b:B){
					cn1 = snd(b,cont);
				}
			);
			return function(){
				if(cn0!=null){
					cn0();
				}
				if(cn1!=null){
					cn1();
				}
			}
		}
	}
}