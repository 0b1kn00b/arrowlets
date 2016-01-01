package stx.async.arrowlet;

import tink.CoreApi;

/*
import stx.types.Free;
import stx.types.*;
*/
using stx.Tuple;
using stx.async.Arrowlet;
using stx.async.arrowlet.Repeat;
using stx.Pointwise;


import stx.async.arrowlet.types.Repeat in TRepeat;

abstract Repeat<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(arw:TRepeat<I,O>){
		this = function(v:I,cont:Sink<O>){
			var cancelled = false;
			function rec(o){
				if(!cancelled){
					switch (o) {
						case Left(rv) : arw(rv,cast rec#if (flash || js).trampoline()#end);
						case Right(dn) : cont(dn);
					}
				}
			}
			arw(v,rec);
			return function(){
				cancelled = true;
			}
		}
	}
	static public function collect<I,O,Z>(arw:Arrowlet<I,O>,selector:O->Bool,fold:Z->O->Z,init:Z):Arrowlet<I,Z>{
		var op = init;
		return arw.tie(
			function(i:I,o:O){
				return switch (selector(o)) {
					case true 	: op = fold(op,o); 		Left(i);
					case false  : 										Right(op);
				}
			}.tupled()
		).repeat();
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
}
