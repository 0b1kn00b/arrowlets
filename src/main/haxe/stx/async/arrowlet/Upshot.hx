package stx.async.arrowlet;

import stx.data.Sink;
import tink.core.Callback;
using stx.Tuple;
import stx.types.Fault;
import tink.core.Error;

import stx.data.*;

import tink.core.Error;
import stx.Compare.*;

import stx.Upshot;
import stx.Eithers;

using stx.async.Arrowlet;

import stx.types.Upshot in CTUpshot;
import stx.Upshot in CUpshot;

import stx.async.arrowlet.types.Upshot in TUpshot;
import stx.async.arrowlet.types.Upshot.RootUpshot;
import stx.async.arrowlet.types.Upshot.Upshot1;

@:forward @:callable abstract Upshot<I,O>(TUpshot<I,O>) from TUpshot<I,O> to TUpshot<I,O> from RootUpshot<I,O> from Upshot1<I,O>{
  static public function outcome<I,O>(?v:TUpshot<I,O>):Upshot<I,O>{
    return new Upshot(v);
  }
  //@:from static inline public function fromArrowlet()
  @:from static inline public function fromCallbackWithNoCanceller<A,B>(fn:CTUpshot<A> -> Sink<CTUpshot<B>> -> Void):Upshot<A,B>{
    return new Upshot(Arrowlet.fromCallbackWithNoCanceller(function(i:CTUpshot<A>,cont:Sink<CTUpshot<B>>):Block{
      var cancelled = false;

      if(!cancelled){
        fn(i,
          function(o){
            if(!cancelled){
              cont(o);
            }
          }
        );
      }
      return function(){
        cancelled = true;
      }
    }));
  }
  public function new(v:TUpshot<I,O>){
    this = v;
  }
}
class Upshots{
  static public function attempt<I,O,N>(arw0:TUpshot<I,O>,arw1:Arrowlet<O,CUpshot<N>>):Upshot<I,N>{
    function arwN(x:CUpshot<O>,cont:Sink<CUpshot<N>>){
      switch (x) {
        case Success(x) : arw1(x,cont);
        case Failure(x) : cont(Failure(x));
      }
    }
    return arw0.then(arwN);
  }
  static public function edit<I,O,N>(arw0:TUpshot<I,O>,arw1:Arrowlet<O,N>):Upshot<I,N>{
    function arwN(x:CUpshot<O>,cont:Sink<CUpshot<N>>){
        switch (x) {
          case Success(v) : arw1(v,
            function(x){
              cont(Success(x));
            }
          );
          case Failure(v) : cont(Failure(v));
        }
      }
    return arw0.then(arwN);
  }
  static public function split<I,O,N>(arw0:TUpshot<I,O>,arw1:Upshot<I,N>):Upshot<I,Tuple2<O,N>>{
    return arw0.split(arw1).then(
      function(tp,cont:Sink<CUpshot<Tuple2<O,N>>>):Void{
        switch (tp) {
          case tuple2(Success(v),Failure(v1)) : cont(Failure(v1));
          case tuple2(Failure(v),Success(v1)) : cont(Failure(v));
          case tuple2(Failure(v),Failure(v1)) : cont(Failure(Error.withData('Errors',ErrorStack([v,v1]))));
          case tuple2(Success(v),Success(v1)) : cont(Success(tuple2(v,v1)));
        }
      }
    );
  }
  static public function imply<I,O>(arw0:TUpshot<I,O>,v:I){
    return arw0.apply(Success(v));
  }
}
