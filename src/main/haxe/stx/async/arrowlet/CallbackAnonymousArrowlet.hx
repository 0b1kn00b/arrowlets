package stx.async.arrowlet;

import tink.core.Future;
import tink.core.Callback;
import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

class CallbackAnonymousArrowlet<I,O> implements IArrowlet<I,O>{
  public function new(apply:I->(O->Void)->Void){
    this._apply = apply;
  }
  private dynamic function _apply(v:I,cont:O->Void):Void{
    
  }
  public function apply(v:I):Future<O>{
    var tr = Future.trigger();

    var ft = tr.asFuture();
      this._apply(v,
        function(x:O){
          tr.trigger(x);
        }
      );
    return ft;
  }
}