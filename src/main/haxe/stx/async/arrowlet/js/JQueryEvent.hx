package stx.async.arrowlet.js;

import stx.async.arrowlet.AnonymousArrowlet;
using stx.async.Arrowlet;
import stx.types.Tuple2;
import js.JQuery.JqEvent;
import js.JQuery in TJQuery;

abstract JQueryEvent(Arrowlet<String,JqEvent>) from Arrowlet<String,JqEvent> to Arrowlet<String,JqEvent>{
  public function new(j:TJQuery){
    this = new AnonymousArrowlet(
      function withInput(?i: String, cont : JqEvent -> Void){
        var cancel    = null;
        var listener  =
          function(x:JqEvent){
            //trace('call: $event');
            cont(x);
          };
        j.one(
          i,
          listener
        );
      }
    );
  }
}
