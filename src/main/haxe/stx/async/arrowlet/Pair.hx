package stx.async.arrowlet;

import haxe.ds.Option;
using stx.Options;
import stx.types.Tuple2;
import tink.core.Future;
import stx.Tuples;

using stx.Tuples;
import stx.types.*;
using stx.async.Arrowlet;

import stx.async.arrowlet.types.Pair in TPair;

abstract Pair<A,B,C,D>(Arrowlet<Tuple2<A,C>,Tuple2<B,D>>) from Arrowlet<Tuple2<A,C>,Tuple2<B,D>> to Arrowlet<Tuple2<A,C>,Tuple2<B,D>>{
  public function new(fst:Arrowlet<A,B>,snd:Arrowlet<C,D>){
    this = function(t:Tuple2<A,C>,cont:Tuple2<B,D>->Void){
    	var cancelled = false;
    	var a :Option<B> = None;
    	var b :Option<D> = None;
    	function ready():Bool{
    		return (a != None) && (b != None);
    	}
    	function go(){
    		if(ready() && !cancelled){
    			cont(a.zip(b).ensure());
    		}
    	}
    	fst(t.fst(),
    		function(x){
    			a = Some(x);
    			go();
    		}
    	);
    	snd(t.snd(),
    		function(x){
    			b = Some(x);
    			go();
    		}
    	);
    	return function(){
    		cancelled = true;
    	}
    };
  }
}
/*class Pair<A,B,C,D>	extends Combinator<A,B,C,D,Tuple2<A,C>,Tuple2<B,D>>{
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
}*/