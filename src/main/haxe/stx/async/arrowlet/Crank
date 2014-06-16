package stx.async.arrowlet;

import stx.Chunk;

import stx.Compare.*;

import stx.async.Future;
import stx.Tuples.*;
import stx.Order;
import stx.types.*;
import tink.core.Error;

import stx.async.arrowlet.State;

using stx.Upshot;
using stx.Tuples;

using stx.async.Arrowlet;

using stx.Reflects;
using stx.Options;
using stx.Compose;
using stx.Anys;
using stx.Arrays;
using stx.Eithers;
using stx.Tuples;
import stx.types.*;
using stx.Options;

using stx.Objects;
using stx.Types;


using stx.async.Arrowlet;
using stx.async.arrowlet.Crank;
using stx.Compose;
//using stx.Compose;

using stx.Chunk.Chunks;
import stx.async.Vouch;


typedef ArrowletCrank<I,O> = Arrowlet<Chunk<I>,Chunk<O>>;

abstract Crank<I,O>(ArrowletCrank<I,O>) from ArrowletCrank<I,O> to ArrowletCrank<I,O>{
  public function imply(v:I):Vouch<O>{
    return Cranks.imply(this,v);
  }
}
class Cranks{
  static public function imply<A,B>(arw:ArrowletCrank<A,B>,v:A):Vouch<B>{
    return arw.apply(Chunks.create(v));
  }
  static public function apply<A,B>(arw:ArrowletCrank<A,B>,v:Chunk<A>):Vouch<B>{
    return Arrowlets.apply(arw,v);
  }
  static public function correct<A>(arw:Arrowlet<Fail,A>):Arrowlet<Chunk<A>,Chunk<A>>{
    return function(chk:Chunk<A>,cont:Chunk<A>->Void){
      switch(chk){
        case Val(v) : cont(Val(v));
        case End(e) : arw.withInput(e,Val.then(cont));
        case Nil    : cont(Nil);
      }
    }
  }
  static public function resume<A>(arw:Arrowlet<Unit,A>):Arrowlet<Chunk<A>,Chunk<A>>{
    return function(chk:Chunk<A>,cont){
      switch(chk){
        case Val(v) : cont(Val(v));
        case End(e) : cont(End(e));
        case Nil    : arw.withInput(Unit,Val.then(cont));
      }
    }
  }
  static public function attempt<A,B>(arw:Arrowlet<A,Chunk<B>>):Arrowlet<Chunk<A>,Chunk<B>>{
    return function(chk:Chunk<A>,cont){
      switch(chk){
        case Val(v) : arw.withInput(v,cont);
        case End(e) : cont(End(e));
        case Nil    : cont(Nil);
      }
    } 
  }
  static public function editor<A,B>(arw:Arrowlet<A,B>):Arrowlet<Chunk<A>,Chunk<B>>{
    return function(chk:Chunk<A>,cont){
      switch(chk){
        case Val(v) : arw.withInput(v,Val.then(cont));
        case End(e) : cont(End(e));
        case Nil    : cont(Nil);
      }
    }
  }
  static public function execute<A>(arw:Arrowlet<Chunk<A>,Chunk<Bool>>,?err:Fail):Arrowlet<Chunk<A>,Chunk<A>>{
    err = err == null ? fail(IllegalOperationError('execution returned false')) : err;
    return function(chk:Chunk<A>,cont){
      arw.withInput(chk,
        function(chk0){
          switch(chk0){
            case Val(v)   : 
              if (v==true){
                cont(chk);
              }else{
                cont(End(err));
              }
            case End(e) : cont(End(e));
            case Nil    : cont(Nil);
          }
        }
      );
    }
  }
  static public function and<A>(arw0:Arrowlet<Chunk<A>,Chunk<Bool>>,arw1:Arrowlet<Chunk<A>,Chunk<Bool>>):Arrowlet<Chunk<A>,Chunk<Bool>>{
    var a = arw0.split(arw1).then(Chunks.zip.tupled());
    var b = a.then(stx.Bools.and.tupled().editor());
    return b;
  }
}