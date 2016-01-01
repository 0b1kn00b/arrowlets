package stx.async.arrowlet.types;

import stx.async.Arrowlet;
import stx.Tuple;

typedef State<S,A> = Arrowlet<S,Tuple2<A,S>>;
