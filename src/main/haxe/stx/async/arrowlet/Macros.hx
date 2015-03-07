package stx.async.arrowlet;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;


class Macros{
	static public macro function task<I,O>(fn:ExprOf<I->(O->Void)->Void>,ipt:ExprOf<I>):Task<I,O>{
    return 
  }
}