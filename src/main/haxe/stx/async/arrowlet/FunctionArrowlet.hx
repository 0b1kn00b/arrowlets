package stx.async.arrowlet;

import stx.async.types.Future;
import stx.types.Block;
import tink.core.Callback;

import stx.async.ifs.Arrowlet in IArrowlet;

class FunctionArrowlet<I,O> implements IArrowlet<I,O>{
  public var fst : I -> O;

  public function new(fst){
    this.fst = fst;
  }
  public function apply(v:I,ft:Callback<O>):Void{
    ft(fst(v));
  }
}