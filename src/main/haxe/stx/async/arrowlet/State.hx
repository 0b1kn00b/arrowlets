package stx.async.arrowlet;

import stx.types.Tuple2;
using stx.Compose;


import stx.types.*;

import stx.Tuples.Tuples2.*;

using stx.Tuples;
using stx.async.Arrowlet;


using stx.async.arrowlet.State;

typedef ArrowletState<S,A> = Arrowlet<S,Tuple2<A,S>>;

class States<S,A>{
  @:noUsing static public function pure<S,A>(a:A):ArrowletState<S,A>{
    return function(s:S):Tuple2<A,S>{
      return tuple2(a,s);
    }
  }
  static public function change<S,A>(arw0:ArrowletState<S,A>,arw1:Arrowlet<Tuple2<A,S>,S>):ArrowletState<S,A>{
    return arw0.fan().then(arw1.second())
      .then(
        function(l:Tuple2<A,S>,r:S){
          return tuple2(l.fst(),r);
        }.tupled()
      );
  }
  static public function access<S,A,B>(arw0:ArrowletState<S,A>,arw1:Arrowlet<Tuple2<A,S>,B>):ArrowletState<S,B>{
    return arw0.join(arw1)
      .then(
        function(l:Tuple2<A,S>,r:B){
          return tuple2(r,l.snd());
        }.tupled()
      );
  }
  static public function put<S,A,B>(arw0:ArrowletState<S,A>,v:S):ArrowletState<S,A>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.fst(),v);
      }
    );
  }
  static public function ret<S,A>(arw0:ArrowletState<S,A>):ArrowletState<S,S>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.snd(),tp.snd());
      }
    );
  }
  static public function request<S,A>(arw0:ArrowletState<S,A>):Arrowlet<S,A>{
    return arw0.then(
      function(t:Tuple2<A,S>){
        return fst(t);
      }
    );
  }
  static public function resolve<S,A>(arw0:ArrowletState<S,A>){
    return arw0.then(
      function(t:Tuple2<A,S>){
        return snd(t);
      }
    );
  }
  static public function breakout<S,A>(arw:ArrowletState<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Tuple2<A,S>):A{
        return x.fst();
      }
    );
  }
}