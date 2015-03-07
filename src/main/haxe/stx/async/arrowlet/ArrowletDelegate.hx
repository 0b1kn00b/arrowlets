package stx.async.arrowlet;

import tink.core.Future;
import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

class ArrowletDelegate<I,O> implements IArrowlet<I,O>{
  public var arrowlet : Arrowlet<I,O>;
  public function new(arrowlet:Arrowlet<I,O>){
    this.arrowlet = arrowlet;
  }
  public function apply(v:I):Future<O>{
    return arrowlet.apply(v);
  }
}