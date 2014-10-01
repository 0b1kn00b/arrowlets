package stx.async.arrowlet;

import tink.core.Future;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

class FunctionArrowlet<I,O> implements IArrowlet<I,O>{
  public var fst : I -> O;

  public function new(fst){
    this.fst = fst;
  }
  public function apply(v:I):Future<O>{
    var trg = Future.trigger();
        trg.trigger(fst(v));
    return trg.asFuture();
  }
}