package stx.async.ifs;

import tink.core.Future;
import stx.ifs.Apply;
import stx.ifs.Immix;

interface Arrowlet<I,O> extends Apply<I,Future<O>>{
  
}