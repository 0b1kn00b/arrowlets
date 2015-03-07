package stx.async.arrowlet.types;

import stx.async.Arrowlet;
import stx.types.Tuple2;

typedef State<S,A> = Arrowlet<S,Tuple2<A,S>>;