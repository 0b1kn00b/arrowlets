package stx.async.arrowlet.types;

import stx.types.Free;
import stx.async.Arrowlet;

typedef Repeat<I,O> = Arrowlet<I,Free<I,O>>;