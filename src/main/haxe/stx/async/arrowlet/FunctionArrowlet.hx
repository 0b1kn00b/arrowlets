package stx.async.arrowlet;

import stx.data.*;
import tink.core.Callback;

abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(fn){
    this = Arrowlet.fromCallbackWithNoCanceller(function(v:I,cont:Sink<O>){
      cont(fn(v));
      return function(){};
    });
  }
}
