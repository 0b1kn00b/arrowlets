package stx.async.arrowlet;

import tink.core.Either in EEither;
import stx.types.*;

using stx.async.Arrowlet;

abstract Or<L, R, R0>(Arrowlet<EEither<L,R>, R0>) from Arrowlet<EEither<L,R>, R0> to Arrowlet<EEither<L,R>, R0>{
	public function new(l:Arrowlet<L,R0>, r:Arrowlet<R,R0>) {
		this = new Arrowlet(
			inline function (?i: EEither<L,R>, cont: R0->Void): Void {
				switch (i) {
					case Left(v) 	: l.withInput(v,cont);
					case Right(v)	: r.withInput(v,cont);
				}
			}
		);
	}
}