package stx.async.arrowlet;

using stx.async.Arrowlet;

class CallableTest{
  public function new(){
    
  }
  public function testForward(){
    var v : Arrowlet<Int,Int> = function(x) {return x;};
    v(3);
  }
}