package;

using Lambda;

class Test{
  static function main(){
    CompileTime.importPackage("test");

    var a = new utest.Runner();
    utest.ui.Report.create(a);
    var arr : Array<Dynamic> = [
      #if (js && !nodejs)
        //new stx.async.arrowlet.js.JQueryEventTest()
      #end
    ];
    arr.iter(
      function(x){
        a.addCase(x);
      }
    );
    a.run();
   /* var _ = function(x:Dynamic) {trace(x); return x;}
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
        ft.trigger(10);  */
  }
}
