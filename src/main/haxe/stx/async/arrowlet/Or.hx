package stx.async.arrowlet;

import tink.core.Future;
import tink.core.Either in EEither;
import stx.types.*;

using stx.async.Arrowlet;

class Or<L, R, R0> extends Combinator<L,R0,R,R0,EEither<L,R>,R0>{
	override public function apply(i: EEither<L,R>):Future<R0>{
		return switch (i) {
			case Left(v) 	: fst.apply(v);
			case Right(v)	: snd.apply(v);
		}
	}
}