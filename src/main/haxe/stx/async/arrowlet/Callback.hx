package stx.async.arrowlet;

import tink.core.Noise;
import stx.types.*;
import stx.async.Arrowlet;

abstract ObserverArrowlet(Arrowlet<Noise,Noise>) from Arrowlet<Noise,Noise> {
  @:from static public function fromFunction0<V>(fn:(Void->Void)->Void):ObserverArrowlet{
    return new Arrowlet(
      function(?i:Noise,cont:Noise->Void){
        var done = false;
        fn(
          function(){
            if(!done){
              cont(i);
              done = true;
            }
          }
        );
      }
    );
  }
  public function new(?v){
    this = v;
  }
}
abstract CallbackArrowlet<V>(Arrowlet<Noise,V>) from Arrowlet<Noise,V> to Arrowlet<Noise,V>{
  @:from static public function fromFunction0<V>(fn:(V->Void)->Void):CallbackArrowlet<V>{
    return new Arrowlet(
      function(?i:Noise,cont:V->Void){
        var done = false;
        fn(
          function(v:V){
            if(!done){
              cont(v);
              done = true;
            }
          }
        );
      }
    );
  }
  public function new(?v){
    this = v;
  }
}