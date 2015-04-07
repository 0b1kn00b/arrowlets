package stx.async.arrowlet;

import haxe.ds.Option;
import tink.core.Future;
import stx.types.*;
import stx.types.Tuple2;
import stx.Tuples;

import stx.async.ifs.Arrowlet in IArrowlet;

using stx.async.Arrowlet;
using stx.Tuples;

abstract Either<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(l:Arrowlet<I,O>,r:Arrowlet<I,O>){
		this = function(v:I,cont:Sink<O>){
			var out 	= None;
			var c0 : Block, c1 : Block = null;
			c0  = l(v,
				function(x){
					if(out == None){
						out = Some(v);
					}
					if(c1!=null){
						c1();
					}
				}
			);
			c1  = r(v,
				function(x){
					if(out == None){
						out = Some(v);
					}
					if(c0!=null){
						c0();
					}
				}
			);
			return function(){
				if(c0!=null){
					c0();
				}
				if(c1!=null){
					c1();
				}
			}
		};
	}
}