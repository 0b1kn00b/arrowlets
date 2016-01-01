package stx.async.arrowlet.types;

import stx.Tuple;
import stx.async.Arrowlet;

typedef Pair<A,B,C,D> = Arrowlet<Tuple2<A,C>,Tuple2<B,D>>;
