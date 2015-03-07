package stx.async;

import tink.core.Error;
import stx.Errors;

using stx.Arrays;

import haxe.ds.Option;

import tink.core.Future;
import tink.core.Error;

import stx.types.Tuple3;
import stx.types.Tuple2;

using stx.Tuples;


class Task<I,O> implements stx.async.arrowlets.ifs.Arrowlet<I,O> implements stx.ifs.Reply<Future<Option<Error>>>{
	public function new(){
		this.errors = [];
	}
	public var input  : I;
	public var output : O;
	public var errors : Array<Error>;

	public function reply():Future<Option<Error>>{
		var ft = Future.trigger();

		apply(input).handle(
			function(x){
				output = x;
				if (errors.length > 0){
					ft.trigger(Some(errors.foldLeft1(Errors.append)))
				}else{
					ft.trigger(None);
				}
			}
		);
	}
	public function fault(v:Error){
		this.errors.push(v);
	} 
	public function apply(v:I):Future<O>{
		var ft : Future.trigger();
		fault(new Error(400,'Abstract implementation called.'));
			ft.trigger(null);
		return ft;
	}
}