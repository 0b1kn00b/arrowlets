package stx.async.types;

import stx.types.Sink;
import stx.types.Block;
import tink.core.Callback;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
typedef Arrowlet<I,O> = I -> Sink<O> -> Block;