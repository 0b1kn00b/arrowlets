package stx.async.arrowlet.types;

import stx.async.Arrowlet;
import haxe.ds.Option in EOption;

typedef Option<I,O> = Arrowlet<EOption<I>,EOption<O>>