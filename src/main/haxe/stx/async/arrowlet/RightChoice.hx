package stx.async.arrowlet;

import tink.core.Either in EEither;
import stx.Tuples;
import stx.types.*;
using stx.async.Arrowlet;

typedef ArrowletRightChoice<B,C,D> = Arrowlet<EEither<D,B>,EEither<D,C>>;

abstract RightChoice<B,C,D>(ArrowletRightChoice<B,C,D>) from ArrowletRightChoice<B,C,D> to ArrowletRightChoice<B,C,D>{
	public function new(a:Arrowlet<B,C>){
		this = new Arrowlet(
			function (?i:EEither<D,B>, cont: EEither<D,C>->Void){
				switch (i) {
					case Right(v) 	:
						new Apply().withInput( tuple2(a,v) ,
							function(x){
								cont( Right(x) );
							}
						);
					case Left(v) :
						cont( Left(v) );
				}
			}
		);
	}
	@:to public inline function asArrowlet():Arrowlet<EEither<D,B>,EEither<D,C>>{
		return this;
	}
}