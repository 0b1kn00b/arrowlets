package stx.async.arrowlet;

import tink.core.Future;
import haxe.ds.Option in EOption;
import stx.Tuples;
import stx.types.*;

using stx.Options;
using stx.async.Arrowlet;
using stx.Compose;
using stx.Tuples;
using stx.Functions;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

typedef ArrowletOption<I,O> = Arrowlet<EOption<I>,EOption<O>>

class Option<I,O> implements IArrowlet<EOption<I>,EOption<O>>{
  public var fst : Arrowlet<I,O>;
  public function new(fst){
    this.fst = fst;
  }
	@:noUsing static public function unit<I>():Option<I,I>{
		return new Option(Arrowlet.unit());
	}
  @:noUsing static public function pure<I,O>(arw:Arrowlet<I,O>):Option<I,O>{
    return new Option(arw);
  }
	public function apply(v:EOption<I>):Future<EOption<O>>{
    return switch (v) {
			case Some(v) : fst.then(Some).apply(v);
      case None 	 : 
        var trg = Future.trigger();
        trg.trigger(None);
        trg.asFuture();
		}
	}
}