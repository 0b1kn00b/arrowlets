package stx.async.arrowlet;

import tink.core.Future;

import stx.types.Free;
import stx.types.*;

using stx.Tuples;
using stx.async.Arrowlet;
using stx.async.arrowlet.Repeat;
using stx.Compose;

import stx.async.ifs.Arrowlet in IArrowlet;

import stx.async.arrowlet.types.Repeat in TRepeat;

abstract Repeat<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(arw:TRepeat<I,O>){
		this = function(v:I,cont:Sink<O>){
			var cancelled = false;
			arw(v,
				function rec(o){
					if(!cancelled){
						switch (o) {
							case Cont(rv) : arw(rv,cast rec#if (flash || js).trampoline()#end);
							case Done(dn) : cont(dn);
						}
					}
				}
			);
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
					case true 	: op = fold(op,o); 		Cont(i);
					case false  : 										Done(op);
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