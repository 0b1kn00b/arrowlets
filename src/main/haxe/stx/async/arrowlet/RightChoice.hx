package stx.async.arrowlet;

import tink.core.Future;

import tink.core.Either in EEither;
using stx.Tuple;
import stx.data.*;
using stx.async.Arrowlet;


import stx.async.arrowlet.types.RightChoice in TRightChoice;

abstract RightChoice<B,C,D>(TRightChoice<B,C,D>) from TRightChoice<B,C,D> to TRightChoice<B,C,D>{

	public function new(arw){
		this = Arrowlet.fromCallbackWithNoCanceller(function(i:EEither<D,B>,cont:Sink<EEither<D,C>>){
			switch (i) {
				case Right(v) 	:
					new Apply().then(Right)(tuple2(arw,v),cont);
				case Left(v) :
					cont(Left(v));
			}
		});
	}
}
