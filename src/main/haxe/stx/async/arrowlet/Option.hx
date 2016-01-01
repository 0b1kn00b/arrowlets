package stx.async.arrowlet;

import tink.core.Future;
import haxe.ds.Option in EOption;
using stx.Tuple;
import stx.types.*;


using stx.async.Arrowlet;
using stx.Pointwise;


import stx.async.arrowlet.types.Option in TOption;

@:callable abstract Option<I,O>(TOption<I,O>) from TOption<I,O> to TOption<I,O>{
  public function new(arw:Arrowlet<I,O>){
    this = Arrowlet.fromCallbackWithNoCanceller(function(v:EOption<I>,cont:Sink<EOption<O>>){
      switch (v) {
        case Some(v) : arw.then(Some)(v,cont);
        case None    : cont(None);
      }
    });
  }
}
