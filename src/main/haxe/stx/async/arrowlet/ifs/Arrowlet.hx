package stx.async.arrowlet.ifs;

import tink.core.Future;
import stx.ifs.Apply;

interface Arrowlet<I,O> extends Apply<I,Future<O>>{
  
}