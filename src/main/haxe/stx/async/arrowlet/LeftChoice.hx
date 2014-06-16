package stx.async.arrowlet;

import stx.Tuples;
import tink.core.Either in EEither;
import stx.types.*;
import stx.types.Tuple2;
using stx.async.Arrowlet;

typedef ArrowletLeftChoice<B,C,D> = Arrowlet<EEither<B,D>,EEither<C,D>>
abstract LeftChoice<B,C,D>(ArrowletLeftChoice<B,C,D>) from ArrowletLeftChoice<B,C,D> to ArrowletLeftChoice<B,C,D>{

	public function new(a:Arrowlet<B,C>){
		return new Arrowlet(
			inline function(?i: EEither<B,D>, cont: EEither<C,D>->Void){
				switch (i) {
					case Left(v) 	:
						new Apply().withInput( tuple2(a,v) ,
							function(x){
								cont( Left(x) );
							}
						);
					case Right(v) :
						cont( Right(v) );
				}
			}
		);
	}
}