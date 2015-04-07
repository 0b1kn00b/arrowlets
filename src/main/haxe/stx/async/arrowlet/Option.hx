package stx.async.arrowlet;

import tink.core.Future;
import haxe.ds.Option in EOption;
import stx.Tuples;
import stx.types.*;

using stx.Compose;
using stx.Options;
using stx.async.Arrowlet;

using stx.Tuples;
using stx.Functions;

import stx.async.ifs.Arrowlet in IArrowlet;

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