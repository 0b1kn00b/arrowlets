package stx.async;

using tink.CoreApi;

import stx.async.data.Bounce as TBounce;

abstract Bounce<T>(TBounce<T>) from TBounce<T> to TBounce<T>{
  public function new(self){
    this = self;
  }
  public function trampoline():Future<T>{
    var trg = Future.trigger();

    var handler = null;
        handler = function(bounce:Bounce<T>){
          switch(bounce){
            case Call(arw):
              arw(Noise,handler);
            case Done(r):
              trg.trigger(r);
          }
        }
    handler(this);
    
    return trg;
  }
}
