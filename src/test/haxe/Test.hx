package;

using stx.async.Futures;
import tink.core.Future;
using stx.Tuples;

using stx.async.Arrowlet;

import stx.async.arrowlet.Either;
import stx.async.arrowlet.LeftChoice;
import stx.async.arrowlet.Option;
import stx.async.arrowlet.Or;
import stx.async.arrowlet.Pair;
import stx.async.arrowlet.Repeat;
import stx.async.arrowlet.RightChoice;
import stx.async.arrowlet.State;
import stx.async.arrowlet.Then;
import stx.async.arrowlet.Upshot;
import stx.async.arrowlet.Windmill;

import stx.async.arrowlet.Action;

class Test{
  static function main(){
    var _ = function(x:Dynamic) {trace(x); return x;}
    var a = function(x:Int) return x * 2;
    var b = function(x:Int) return x + 1;

    _.then(a).then(b).join(
      function(x){
        trace(x);
        return x + 3;
      }
    ).then(
      function(x,y){
        return x + y;
      }.tupled()
    ).tie(
      function(x,y){
        trace(x);
        //x == 10
        return x + y;
      }.tupled()
    ).pair(
      function(x){
        return x * 3;
      }
    ).apply(tuple2(10,3)).handle(_);

    var ft = Future.trigger();
        ft.asFuture().then(
          function(x:Int,cont:Int->Void){
            cont(x*3);
          }
        ).handle(
          function(x){
            trace(x);
          }
        );
        ft.trigger(10);
      
  }
}