package stx.async;

using stx.async.Arrowlet;
import tink.core.Future;

class Futures{
  static public function then<A,B>(ft:Future<A>,then:Arrowlet<A,B>):Future<B>{
    return ft.flatMap(
      function(x:A){
        return then.apply(x);
      }
    );
  }
}