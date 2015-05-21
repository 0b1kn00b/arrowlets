package stx.async.ifs;

import tink.core.Callback;

import stx.ifs.Immix;

interface Arrowlet<I,O>{
  public function apply(v:I):Callback<O>;
}