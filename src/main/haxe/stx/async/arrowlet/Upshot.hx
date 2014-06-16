package stx.async.arrowlet;

import stx.types.Tuple2;
import stx.types.Fault;
import tink.core.Error;

import stx.types.*;

import tink.core.Error;
import stx.Compare.*;

import stx.Upshot;
import stx.Tuples;
import stx.Eithers;

using stx.async.Arrowlet;

import stx.types.Upshot in CUpshot;

typedef ArrowletUpshot<I,O> = Arrowlet<CUpshot<I>,CUpshot<O>>

abstract Upshot<I,O>(ArrowletUpshot<I,O>) from ArrowletUpshot<I,O> to ArrowletUpshot<I,O>{
  static public function outcome<I,O>(?v:ArrowletUpshot<I,O>):Upshot<I,O>{
    return new Upshot(v);
  }
  static public function unit<I,O>():Upshot<I,O>{
    return new Upshot();
  }
  public function new(?v:ArrowletUpshot<I,O>){
    this = ntnl().apply(v) ? v : 
    function(x){
        return cast( x == null ? Failure(Error.withData('input should not be null',NullError)) : x);
    } 
  }
}
class Upshots{
  static public function attempt<I,O,N>(arw0:ArrowletUpshot<I,O>,arw1:Arrowlet<O,CUpshot<N>>):Upshot<I,N>{
    return arw0.then(
      function(x,cont){
        return switch (x) {
          case Success(x) : arw1.withInput(x,cont);
          case Failure(x) : cont(Failure(x));
        }        
      }
    );
  }
  static public function edit<I,O,N>(arw0:ArrowletUpshot<I,O>,arw1:Arrowlet<O,N>):Upshot<I,N>{
    return arw0.then(
      function(x,cont){
        switch (x) {
          case Success(v) : arw1.withInput(v,
            function(x){
              cont(Success(x));
            }
          );
          case Failure(v) : cont(Failure(v));
        }
      }
    );
  }
  static public function split<I,O,N>(arw0:ArrowletUpshot<I,O>,arw1:Upshot<I,N>):Upshot<I,Tuple2<O,N>>{
    return arw0.split(arw1).then(
      function(tp,cont){
        switch (tp) {
          case tuple2(Success(v),Failure(v1)) : cont(Failure(v1));
          case tuple2(Failure(v),Success(v1)) : cont(Failure(v));
          case tuple2(Failure(v),Failure(v1)) : cont(Failure(Error.withData('Errors',ErrorStack([v,v1]))));
          case tuple2(Success(v),Success(v1)) : cont(Success(tuple2(v,v1)));
        }
      }
    );
  }
  static public function imply<I,O>(arw0:ArrowletUpshot<I,O>,v:I){
    return arw0.apply(Success(v));
  }
}