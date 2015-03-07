package stx.async.arrowlet;

import tink.core.Future;
import stx.async.ifs.Arrowlet in IArrowlet;

class Combinator<A,B,C,D,I,O> implements IArrowlet<I,O>{
  public var fst : Arrowlet<A,B>;
  public var snd : Arrowlet<C,D>;
  
  public function new(fst,snd){
    this.fst = fst;
    this.snd = snd;
  }
  public function apply(v:I):Future<O>{
    return null;
  }
}