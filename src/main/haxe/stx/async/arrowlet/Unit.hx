package stx.async.arrowlet;

import tink.core.Future;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

class Unit<I> implements IArrowlet<I,I>{
  public function new(){

  }
  public function apply(v:I):Future<I>{
    var ft = Future.trigger();
        ft.trigger(v);
    return ft.asFuture();
  }

}