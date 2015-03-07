package stx.async.arrowlet;

import tink.core.Future;

import stx.types.Free;
import stx.types.*;

using stx.Tuples;
using stx.async.Arrowlet;
using stx.async.arrowlet.Repeat;
using stx.Compose;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

typedef RepeatType<I,O> = Arrowlet<I,Free<I,O>>;

class Repeat<I,O> implements IArrowlet<I,O>{
	public var fst : Arrowlet<I,Free<I,O>>;
	public function new(fst){
		this.fst = fst;
	}
	public function apply(v:I):Future<O>{
		var ft = Future.trigger();
		function withRes(res: Free<I, O> ) {
			switch (res) {
				case Cont(rv): fst.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Done(dv): ft.trigger(dv);
			}
		}
		fst.apply(v);
		return ft;
	}
}
class Repeats{
	#if (neko || php || cpp || java || cs)
	static public function trampoline<I>(f:I->Void){
		return function(x:I):Void{
			f(x);
		}
	}
	#else
	static public function trampoline<I>(f:I->Void){
		return function(x:I):Void{
				haxe.Timer.delay( 
					function() { 
						f(x);
					},10
				);
			}
	}
	#end

	static public function collect<I,O,Z>(arw:Arrowlet<I,O>,selector:O->Bool,fold:Z->O->Z,init:Z):Arrowlet<I,Z>{
		var op = init;
		return arw.tie(
			function(i:I,o:O){
				return switch (selector(o)) {
					case true 	: op = fold(op,o); 		Cont(i);
					case false  : 										Done(op);
				}
			}.tupled()
		).repeat();
	}
}