package stx.async.arrowlet;

import tink.core.Future;

import stx.Tuples;
import tink.core.Either in EEither;
import stx.types.*;
import stx.types.Tuple2;
using stx.async.Arrowlet;

import stx.async.arrowlet.ifs.Arrowlet in IArrowlet;

typedef ArrowletLeftChoice<B,C,D> = Arrowlet<EEither<B,D>,EEither<C,D>>

class LeftChoice<B,C,D> implements IArrowlet<EEither<B,D>,EEither<C,D>>{
	public var fst : Arrowlet<B,C>;
	public function new(fst){
		this.fst = fst;
	}
	public function apply(i: EEither<B,D>):Future<EEither<C,D>>{
		return switch (i) {
			case Left(v) 	:
				new Apply().then(Left).apply(tuple2(fst,v));
			case Right(v) :
			 	var trg = Future.trigger();
				trg.trigger(Right(v));
				return trg.asFuture();
		}
	}
}