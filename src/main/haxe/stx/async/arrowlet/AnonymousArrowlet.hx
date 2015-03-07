package stx.async.arrowlet;

import tink.core.Future;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

class AnonymousArrowlet<I,O> implements IArrowlet<I,O>{
  public var method : I -> (O->Void) -> Void;
  public function new(method){
    this.method = method;
  }
  public function apply(v:I):Future<O>{
    var trg = Future.trigger();
        method(
          v,
          function(o){
            trg.trigger(o);
          }
        );
    return trg.asFuture();
  }
}