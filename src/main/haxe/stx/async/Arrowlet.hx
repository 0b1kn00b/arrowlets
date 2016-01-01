package stx.async;

import tink.CoreApi;

import stx.data.*;
import stx.core.Blocks.NIL in noop;

import stx.async.arrowlet.types.State in TState;
import tink.core.Callback;
import tink.core.Future;
import tink.core.Error;
using stx.Tuple;

import haxe.ds.Option in EOption;
import tink.core.Either in EEither;
import stx.types.*;

import stx.type.*;

/*
import stx.Eithers;
import stx.Options;
*/
import stx.async.types.Arrowlet in TArrowlet;

import stx.async.arrowlet.*;
import stx.async.arrowlet.Option;
import stx.async.arrowlet.State;
import stx.async.arrowlet.Either;


@:callable abstract Arrowlet<I,O>(TArrowlet<I,O>) from TArrowlet<I,O>{
  @doc("Externally accessible constructor.")
  static public inline function arw<A>():Arrowlet<A,A>{
    return unit();
  }
  @doc("Simple case, return the input.")
  @:noUsing static public function unit<A>():Arrowlet<A,A>{
    return new Unit();
  }
  @doc("Produces an arrow returning `v`.")
  @:noUsing static public function pure<A,B>(v:B):Arrowlet<A,B>{
    return Arrowlet.fromCallbackWithNoCanceller(function(a:A,cont:Sink<B>){
      cont(v);
    });
  }
  public function then<N>(r:Arrowlet<O,N>):Arrowlet<I,N>{
    return Arrowlets.then(this,r);
  }
  public function new(v:TArrowlet<I,O>){
    this  = v;
  }
  @:from static inline public function fromCallbackWithNoCanceller<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
    return new Arrowlet(function(i:A,cont:Sink<B>):Block{
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
    });
  }
  @:noCompletion @:from static inline public function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
    return new FunctionArrowlet(fn);
  }
  static public inline function toArrowlet<A,B>(fn:A->B):Arrowlet<A,B>{
    return fromFunction(fn);
  }
  @:from static inline public function fromEndo<A>(fn:A->A):Arrowlet<A,A>{
    return fromFunction(fn);
  }
  @:noCompletion @:from static inline public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    //trace('fromFunction2');
    return Arrowlet.fromCallbackWithNoCanceller(function(a:Tuple2<A,B>,b:Sink<C>){
      b(fn.tupled()(a));
    });
  }
  /*
  @:from static inline public function fromFunction3<A,B,C,D>(fn:A->B->C->D):Arrowlet<Tuple3<A,B,C>,D>{
    //trace('fromFunction3');
    return Arrowlet.fromCallbackWithNoCanceller(function(a:Tuple3<A,B,C>,b:Sink<D>){
      b(fn.tupled()(a));
    });
  }
  @:from static inline public function fromFunction4<A,B,C,D,E>(fn:A->B->C->D->E):Arrowlet<Tuple4<A,B,C,D>,E>{
    //trace('fromFunction4');
    return Arrowlet.fromCallbackWithNoCanceller(function(a:Tuple4<A,B,C,D>,b:Sink<E>){
      b(fn.tupled()(a));
    });
  }
  @:from static inline public function fromFunction5<A,B,C,D,E,F>(fn:A->B->C->D->E->F):Arrowlet<Tuple5<A,B,C,D,E>,F>{
    //trace('fromFunction5');
    return Arrowlet.fromCallbackWithNoCanceller(function(a:Tuple5<A,B,C,D,E>,b:Sink<F>){
      b(fn.tupled()(a));
    });
  }*/
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrowlet<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return Arrowlet.fromCallbackWithNoCanceller(function(a:A,b:Sink<Tuple2<B,A>>){
      b(fn(a));
    });
  }
}
class Arrowlets{
  static public function later<A,B>(arw:Arrowlet<A,B>,v:A):Arrowlet<Noise,B>{
    return function(n:Noise,cont){
      return arw(v,cont);
    }
  }
  static public function inject<A,B,C>(arw:Arrowlet<A,B>,v:C):Arrowlet<A,C>{
    return then(arw,
      function(b:B){
        return v;
      }
    );
  }
  static public inline function tap<I,O>(arw:Arrowlet<I,O>,fn:O->Void){
    return then(arw,
      Arrowlet.fromCallbackWithNoCanceller(function(i,cont){
        fn(i);
        cont(i);
      }
    ));
  }
  @doc("Arrowlet application primitive. Calls Arrowlet with `i` and places result in `cont`.")
  static public inline function withInput<I,O>(arw:Arrowlet<I,O>,i:I,cont:Sink<O>){
    arw(i,cont);
  }
  static public inline function apply<I,O>(arw:Arrowlet<I,O>,i:I):Future<O>{
    var trg       = new FutureTrigger();

    withInput(arw,i,
      function(x:O){
        trg.trigger(x);
      }
    );
    return trg.asFuture();
  }
  static public inline function runWith<I,O>(arw:Arrowlet<I,O>,i:I):Future<O>{
    return apply(arw,i);
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<A,B,C>(before:Arrowlet<A,B>, after:Arrowlet<B,C>):Arrowlet<A,C> {
    return new Then(before,after);
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  static public function first<A,B,C>(first:Arrowlet<A,B>):Arrowlet<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  static public function second<A,B,C>(second:Arrowlet<A,B>):Arrowlet<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrowlet.unit(), second);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with thesame input.")
  static public function split<A, B, C>(split_:Arrowlet<A, B>, _split:Arrowlet<A, C>):Arrowlet<A, Tuple2<B,C>> {
    return function(i:A, cont:Tuple2<B,C>->Void) : Void{
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
    };
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function pair<A,B,C,D>(pair_:Arrowlet<A,B>,_pair:Arrowlet<C,D>):Arrowlet<Tuple2<A,C>, Tuple2<B,D>> {
    return new stx.async.arrowlet.Pair(pair_,_pair);
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<A,B,C>(a:Arrowlet<A,Tuple2<B,C>>):Arrowlet<A,Tuple2<C,B>>{
    return then(a,Tuples2.swap);
  }
  @doc("Produces a Tuple2 output of any Arrowlet.")
  static public function fan<I,O>(a:Arrowlet<I,O>):Arrowlet<I,Tuple2<O,O>>{
    return then(a,
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  @doc("Pinches the input stage of an Arrowlet. `<I,I>` as `<I>`")
  static public function pinch<I,O1,O2>(a:Arrowlet<Tuple2<I,I>,Tuple2<O1,O2>>):Arrowlet<I,Tuple2<O1,O2>>{
    return then(fan(Arrowlet.unit()),a);
  }
  @doc("Produces an Arrowlet that runs the same Arrowlet on both sides of a Tuple2")
  static public function both<A,B>(a:Arrowlet<A,B>):Arrowlet<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  @doc("Casts the output of an Arrowlet to `type`.")
  static public function as<A,B,C>(a:Arrowlet<A,B>,type:Class<C>):Arrowlet<A,C>{
    return then(a, function(x:B):C { return cast x; } );
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function join<A,B,C>(joinl:Arrowlet<A,B>,joinr:Arrowlet<B,C>):Arrowlet<A,Tuple2<B,C>>{
    return then( joinl , split(Arrowlet.unit(),joinr) );
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function tie<A,B,C>(bindl:Arrowlet<A,B>,bindr:Arrowlet<Tuple2<A,B>,C>):Arrowlet<A,C>{
    return then( split(Arrowlet.unit(),bindl) , bindr );
  }
  @doc("Runs an Arrowlet until it returns Done(out).")
  static public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Arrowlet<I,O>{
    return new Repeat(a);
  }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<P1,P2,R0>(or_:Arrowlet<P1,R0>,_or:Arrowlet<P2,R0>):Arrowlet<EEither<P1,P2>,R0>{
    return new Or(or_, _or);
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  public static function left<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<EEither<B,D>,EEither<C,D>>{
    return new LeftChoice(arr);
  }
  @doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  public static function either<A,B>(a:Arrowlet<A,B>,b:Arrowlet<A,B>):Arrowlet<A,B>{
    return new Either(a,b);
  }
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  public static function right<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<EEither<D,B>,EEither<D,C>>{
    return new RightChoice(arr);
  }
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  public static function fromRight<A,B,C,D>(arr:Arrowlet<B,EEither<C,D>>):Arrowlet<EEither<C,B>,EEither<C,D>>{
    return new RightSwitch(arr);
  }
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Left.")
  public static function fromLeft<A,B,C,D>(arr:Arrowlet<A,EEither<C,D>>):Arrowlet<EEither<A,D>,EEither<C,D>>{
    return then(new LeftChoice(arr),
      function(e){
        return switch(e){
          case Left(Left(l))  : Left(l);
          case Left(Right(r)) : Right(r);
          case Right(r) : Right(r);
        }
      }
    );
  }
  @doc("Produces an Arrowlet that is applied if the input is Some.")
  public static function option<I,O>(a:Arrowlet<I,O>):Arrowlet<EOption<I>,EOption<O>>{
    return new Option(a);
  }
  @doc("Produces an Arrowlet that patches the output with `n`.")
  public static function exchange<I,O,N>(a:Arrowlet<I,O>,n:N):Arrowlet<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  @doc("Flattens the output of an Arrowlet where it is Option<Option<O>> ")
  static public function flatten<I,O>(arw:Arrowlet<EOption<I>,EOption<EOption<O>>>):Arrowlet<EOption<I>,EOption<O>>{
    return Arrowlets.then(arw,
      function(v){
        return switch(v){
          case Some(Some(v)) : Some(v);
          default: None;
        }
      }
    );
  }
  @doc("Takes an Arrowlet that produces an Option and returns one that takes an Option also.")
  static public function fromOption<I,O>(arw:Arrowlet<I,EOption<O>>):Arrowlet<EOption<I>,EOption<O>>{
    return flatten(option(arw));
  }
  @doc("Print the output of an Arrowlet")
  static public function printA<A,B>(a:Arrowlet<A,B>):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new Then( a, m );
  }
  @doc("Runs a `then` operation where the creation of the second arrow requires a function call to produce it.")
  static public function invoke<A,B,C>(a:Arrowlet<A,B>,b:Thunk<Arrowlet<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return tuple2(n,x);
      }
    );
  }
  @:noUsing static public function state<S,A>(a:Arrowlet<S,Tuple2<A,S>>):TState<S,A>{
    return a;
  }
  @doc("Returns an ApplyArrowlet.")
  @:noUsing static public function application<I,O>():Apply<I,O>{
    return new Apply();
  }
  #if (flash || js )
  static public function delay<A>(ms:Int):Arrowlet<A,A>{
    var out = function(i,cont){
    haxe.Timer.delay(
        function(){
          cont(i);
        },ms);
    }
    return out;
  }
  #end
}
class FutureArrows{
  static public function then<A,B>(ft:Future<A>,then:Arrowlet<A,B>):Future<B>{
    return ft.flatMap(
      function(x:A){
        var trg = Future.trigger();
            then(x,trg.trigger);
        return trg.asFuture();
      }
    );
  }
}
