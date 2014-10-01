package stx.async.arrowlet;

import stx.types.Tuple2;
import haxe.ds.Option in EOption;
import tink.core.Future;
using stx.Tuples;
using stx.async.Arrowlet;

import tink.core.Error;
import tink.core.Noise;

class Action extends ArrowletDelegate<Noise,EOption<Error>>{
  @:noUsing static public function unit():Action{
    return new Action(function(x:Noise,cb:EOption<Error>->Void){
      cb(None);
    });
  }
  static public function fromFuture(ft:Future<EOption<Error>>):Action{
    return new Action(function(x:Noise,cb:EOption<Error>->Void){
      ft.handle(cb);
    });
  }
  public function then(a2:Arrowlet<Noise,EOption<Error>>):Action{
    var arw : Arrowlet<EOption<Error>,EOption<Error>> = 
      function(x:EOption<Error>,cb:EOption<Error>->Void){
        switch (x) {
          case None     : a2.withInput(Noise,cb);
          case Some(e)  : cb(Some(e));
        }
      }
    return new Action(Arrowlets.then(this,arw));
  }
  public function and(a2:Arrowlet<Noise,EOption<Error>>):Action{
    return new Action(Arrowlets.then(this.split(a2),
    function(tp:Tuple2<EOption<Error>,EOption<Error>>,cont:EOption<Error>->Void){
      cont(switch ([tp.fst(),tp.snd()]) {
        case [Some(e0),Some(e1)]  : Some(Errors.append(e0,e1));
        case [Some(e0),None]      : Some(e0);
        case [None,Some(e1)]      : Some(e1);
        case [None,None]          : None;
      });
    }));
  }
  public function or(a2:Arrowlet<Noise,EOption<Error>>):Action{
    return new Action(Arrowlets.then(this,
      function(e:EOption<Error>,cb){
        switch (e) {
          case Some(e) : a2.withInput(Noise,cb);
          case None    : cb(None);
        }
      }
    ));
  }
}