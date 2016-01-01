package stx.async.arrowlet.js;

using stx.async.Arrowlet;
using stx.Tuple;

#if (!nodejs && js)
import js.JQuery.JqEvent;
import js.JQuery in TJQuery;


abstract JQueryEvent(Arrowlet<String,JqEvent>) from Arrowlet<String,JqEvent> to Arrowlet<String,JqEvent>{
  public function new(j:TJQuery){
    this =
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
        return function(){};
      }
  }
}
#end
