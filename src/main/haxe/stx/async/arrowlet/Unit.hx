package stx.async.arrowlet;

import stx.types.Sink;
import tink.core.Future;

import stx.async.ifs.Arrowlet in IArrowlet;

abstract Unit<I>(Arrowlet<I,I>) from Arrowlet<I,I> to Arrowlet<I,I>{
  public function new(){
    this = function(v:I,cont:Sink<I>){
      cont(v);
      return function(){}
    }
  }
}