package stx.async.arrowlet.types;

import tink.CoreApi;
import stx.async.Arrowlet;

typedef Repeat<I,O> = Arrowlet<I,tink.core.Either<I,O>>;
