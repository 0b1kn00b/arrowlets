package stx.async.arrowlet;

import tink.core.Callback;
import tink.core.Future;
import stx.async.ifs.Arrowlet in IArrowlet;

class ArrowletDelegate<I,O> implements IArrowlet<I,O>{
  public var arrowlet : Arrowlet<I,O>;
  public function new(arrowlet:Arrowlet<I,O>){
    this.arrowlet = arrowlet;
  }
  public function apply(v:I,cb:Callback<O>){
    arrowlet(v,cb);
  }
}