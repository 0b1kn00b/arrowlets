package stx.async.arrowlet.types;

import tink.core.Either in EEither;
import stx.async.Arrowlet;

typedef RightChoice<B,C,D> = Arrowlet<EEither<D,B>,EEither<D,C>>