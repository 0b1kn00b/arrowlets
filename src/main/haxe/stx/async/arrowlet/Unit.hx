package stx.async.arrowlet;

import stx.data.*;
import tink.core.Future;

abstract Unit<I>(Arrowlet<I,I>) from Arrowlet<I,I> to Arrowlet<I,I>{
  public function new(){
    this = function(v:I,cont:Sink<I>){
      cont(v);
      return function(){}
    }
  }
}
