package stx.async.arrowlet.types;

import tink.core.Either in EEither;
import stx.async.Arrowlet;

typedef LeftChoice<B,C,D> = Arrowlet<EEither<B,D>,EEither<C,D>>