package stx.async.arrowlet;

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
    return arw0.then(arw1.fromRight());
  }
  static public function edit<I,O,N>(arw0:ArrowletUpshot<I,O>,arw1:Arrowlet<O,N>):Upshot<I,N>{
    return arw0.then(arw1.right());
  }
  static public function split<I,O,N>(arw0:ArrowletUpshot<I,O>,arw1:Upshot<I,N>):Upshot<I,Tuple2<O,N>>{
    return arw0.split(arw1).then(Eithers.unzip);
  }
  static public function imply<I,O>(arw0:ArrowletUpshot<I,O>,v:I){
    return arw0.apply(Right(v));
  }
}