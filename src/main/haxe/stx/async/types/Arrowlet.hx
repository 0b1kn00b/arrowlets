package stx.async.types;

import stx.types.Block;
import tink.core.Callback;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
typedef Arrowlet<I,O> = I -> (Tie<O> -> Block) -> Block;