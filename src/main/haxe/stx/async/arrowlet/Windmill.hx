package stx.async.arrowlet;

import stx.types.Chunk;
import stx.types.Tuple2;
import tink.core.Noise;
import tink.core.Error;
import stx.types.*;

import stx.Compare.*;

import stx.Tuples.*;
import tink.core.Error;
import stx.async.Vouch;
import stx.async.arrowlet.types.State in TState;
import stx.async.arrowlet.types.Windmill in TWindmill;

import stx.async.arrowlet.types.State in TState;
import stx.async.arrowlet.State in StateArrowlets;

using stx.Options;
using stx.async.Arrowlet;
using stx.Compose;
using stx.Tuples;

using stx.Chunk;


abstract Windmill<S,A>(TWindmill<S,A>) from TWindmill<S,A> to TWindmill<S,A>{ 
  static public function pure<S,A>(a:A):Windmill<S,A>{
    return function(s:S,cont:Tuple2<Chunk<A>,S>->Void):Void{
      cont(tuple2(Val(a),s));
    }
  }
}
class Windmills{
  static public function correct<S,A>(arw:Arrowlet<Error,A>):Arrowlet<Tuple2<Chunk<A>,S>,Tuple2<Chunk<A>,S>>{
    return function(tp:Tuple2<Chunk<A>,S>,cont:Tuple2<Chunk<A>,S>->Void):Void{
      switch(tp){
        case tuple2(Val(a),s)      : cont(tuple2(Val(a),s));
        case tuple2(Nil,s)         : cont(tuple2(Nil,s));
        case tuple2(End(e),s)      : arw.withInput(e,
          function(v:A){
            cont(tuple2(Val(v),s));
          }
        );
      }
    }
  }
  static public function resume<S,A>(arw:Arrowlet<Noise,A>):Arrowlet<Tuple2<Chunk<A>,S>,Tuple2<Chunk<A>,S>>{
    return function(tp:Tuple2<Chunk<A>,S>,cont:Tuple2<Chunk<A>,S>->Void):Void{
      switch (tp) {
        case tuple2(Val(v),s) : cont(tuple2(Val(v),s));
        case tuple2(End(e),s) : cont(tuple2(End(e),s));
        case tuple2(Nil,s)    : arw.withInput(Noise,
          function(a:A){
            cont(tuple2(Val(a),s));
          }
        );
      }
    }
  }
  static public function access<S,A,B>(arw:Arrowlet<A,Chunk<B>>):Arrowlet<Tuple2<Chunk<A>,S>,Tuple2<Chunk<B>,S>>{
    return function(tp:Tuple2<Chunk<A>,S>,cont:Tuple2<Chunk<B>,S>->Void):Void{
      switch (tp) {
        case tuple2(Val(v),s) : arw.withInput(v,
          function(chk:Chunk<B>){
            cont(tuple2(chk,s));
          }
        );
        case tuple2(End(e),s) : cont(tuple2(End(e),s));
        case tuple2(Nil,s)    : cont(tuple2(Nil,s));
      }
    }
  }
  static public function manage<S,A,B>(arw:Arrowlet<A,B>):Arrowlet<Tuple2<Chunk<A>,S>,Tuple2<Chunk<B>,S>>{
    return function(chk:Tuple2<Chunk<A>,S>,cont):Void{
      switch(chk){
        case tuple2(Val(v),s) : arw.withInput(v,
          function(v){
            cont(tuple2(Val(v),s));
          }
        );
        case tuple2(End(e),s) : cont(tuple2(End(e),s));
        case tuple2(Nil,s)    : cont(tuple2(Nil,s));
      }
    }
  }
  static public function change<S,A>(arw0:TWindmill<S,A>,arw1:Arrowlet<Tuple2<A,S>,S>):TWindmill<S,A>{
    return function(s:S,cont:Tuple2<Chunk<A>,S>->Void):Void{
      arw0.withInput(s,
        function(tp:Tuple2<Chunk<A>,S>){
          switch (tp) {
            case tuple2(Val(a),s)   : arw1.withInput(tuple2(a,s),
              function(s0:S){
                cont(tuple2(Val(a),s0));
              }
            );
            case tuple2(Nil,s)      : cont(tuple2(Nil,s));
            case tuple2(End(e),s)   : cont(tuple2(End(e),s));
          }
        }
      );
    }
  }
  static public function attempt<S,A,B>(arw0:TWindmill<S,A>,arw1:Arrowlet<Tuple2<A,S>,Chunk<B>>):TWindmill<S,B>{
    return function(s:S,cont:Tuple2<Chunk<B>,S>->Void):Void{
      arw0.withInput(s,
        function(tp:Tuple2<Chunk<A>,S>){
          switch (tp) {
            case tuple2(Val(a),s)   : arw1.withInput(tuple2(a,s),
              function(b:Chunk<B>){
                cont(tuple2(b,s));
              }
            );
            case tuple2(Nil,s)      : cont(tuple2(Nil,s));
            case tuple2(End(e),s)   : cont(tuple2(End(e),s));
          }
        }
      );
    }
  }
}