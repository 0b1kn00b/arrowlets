package stx.async.arrowlet;

import tink.core.Future;
import stx.types.Tuple2;
import tink.core.Either in EEither;
import stx.Tuples;
import stx.types.*;
using stx.async.Arrowlet;

import stx.async.ifs.Arrowlet in IArrowlet;

typedef ArrowletRightChoice<B,C,D> = Arrowlet<EEither<D,B>,EEither<D,C>>;

class RightChoice<B,C,D> implements IArrowlet<EEither<D,B>,EEither<D,C>>{
	public var fst : Arrowlet<B,C>;

	public function new(fst){
		this.fst = fst;
	}
	public function apply(i:EEither<D,B>):Future<EEither<D,C>>{
		return switch (i) {
			case Right(v) 	:
				new Apply().then(Right).apply(tuple2(fst,v));
			case Left(v) :
				var trg = Future.trigger();
						trg.trigger(Left(v));
				trg.asFuture();
		}
	}
}