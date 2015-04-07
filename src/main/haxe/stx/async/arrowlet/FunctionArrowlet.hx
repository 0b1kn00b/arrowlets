package stx.async.arrowlet;

import stx.types.Sink;
import stx.async.types.Future;
import stx.types.Block;
import tink.core.Callback;

import stx.async.ifs.Arrowlet in IArrowlet;

abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(fn){
    this = Arrowlet.fromCallbackWithNoCanceller(function(v:I,cont:Sink<O>){
      cont(fn(v));
      return function(){};
    });
  }
}