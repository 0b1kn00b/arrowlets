package stx.async.arrowlet.types;

import stx.Upshot in CUpshot;
import stx.async.Arrowlet;

typedef Upshot<I,O> = Arrowlet<CUpshot<I>,CUpshot<O>>;
typedef RootUpshot<I,O> = stx.async.types.Arrowlet<stx.types.Upshot<I>,stx.types.Upshot<O>>;
typedef Upshot1<I,O> = stx.async.types.Arrowlet<stx.Upshot<I>,stx.Upshot<O>>;