package stx.async.arrowlet;

using stx.Tuple;
using stx.Pointwise;

import stx.types.*;

import stx.async.arrowlet.types.State in TState;
import stx.async.arrowlet.*;

using stx.async.Arrowlet;


using stx.async.arrowlet.State;


class State<S,A>{
  @:noUsing static public function pure<S,A>(a:A):TState<S,A>{
    return new FunctionArrowlet(function(s:S):Tuple2<A,S>{
      return tuple2(a,s);
    });
  }
  static public function change<S,A>(arw0:TState<S,A>,arw1:Arrowlet<Tuple2<A,S>,S>):TState<S,A>{
    return arw0.fan().then(arw1.second())
      .then(
        function(l:Tuple2<A,S>,r:S){
          return tuple2(l.fst(),r);
        }.tupled()
      );
  }
  static public function access<S,A,B>(arw0:TState<S,A>,arw1:Arrowlet<Tuple2<A,S>,B>):TState<S,B>{
    return arw0.join(arw1)
      .then(
        function(l:Tuple2<A,S>,r:B){
          return tuple2(r,l.snd());
        }.tupled()
      );
  }
  static public function put<S,A,B>(arw0:TState<S,A>,v:S):TState<S,A>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.fst(),v);
      }
    );
  }
  static public function ret<S,A>(arw0:TState<S,A>):TState<S,S>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.snd(),tp.snd());
      }
    );
  }
  static public function request<S,A>(arw0:TState<S,A>):Arrowlet<S,A>{
    return arw0.then(
      function(t:Tuple2<A,S>){
        return Tuples2.fst(t);
      }
    );
  }
  static public function resolve<S,A>(arw0:TState<S,A>){
    return arw0.then(
      function(t:Tuple2<A,S>){
        return Tuples2.snd(t);
      }
    );
  }
  static public function breakout<S,A>(arw:TState<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Tuple2<A,S>):A{
        return x.fst();
      }
    );
  }

}
