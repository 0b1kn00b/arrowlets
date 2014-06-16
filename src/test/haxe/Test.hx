package;

using stx.Tuples;
using stx.async.Arrowlet;
using stx.async.arrowlet.Callback;
using stx.async.arrowlet.Either;
using stx.async.arrowlet.LeftChoice;
using stx.async.arrowlet.Option;
using stx.async.arrowlet.Or;
using stx.async.arrowlet.Pair;
using stx.async.arrowlet.Repeat;
using stx.async.arrowlet.RightChoice;
using stx.async.arrowlet.State;
using stx.async.arrowlet.Then;
using stx.async.arrowlet.Upshot;


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
  }
}