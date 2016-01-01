package stx.async.data;

import tink.CoreApi;

import stx.async.Arrowlet;

enum Bounce<T>{
  Call(arw:Arrowlet<Noise,Bounce<T>>);
  Done(v:T);
}
