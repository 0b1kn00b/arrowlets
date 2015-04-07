package stx.async.arrowlet;

import tink.core.Future;

import stx.async.ifs.Arrowlet in IArrowlet;

import tink.core.Either;

import stx.types.*;
using stx.async.Arrowlet;

abstract RightSwitch<A,B,C,D>(Arrowlet<Either<A,B>,Either<A,D>>) from Arrowlet<Either<A,B>,Either<A,D>> to Arrowlet<Either<A,B>,Either<A,D>>{
  public function new(arw:Arrowlet<B,Either<A,D>>){
    this = Arrowlet.fromCallbackWithNoCanceller(function (i:Either<A,B>,cont:Sink<Either<A,D>>){
      switch (i){
        case      Left(l)      : cont(Left(l));
        case      Right(r)     : arw(r,cont);
      }
    });
  }
  
}