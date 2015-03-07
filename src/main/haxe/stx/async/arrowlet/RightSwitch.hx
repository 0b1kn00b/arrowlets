package stx.async.arrowlet;

import tink.core.Future;

import stx.async.ifs.Arrowlet in IArrowlet;

import tink.core.Either;

import stx.types.*;
using stx.async.Arrowlet;

class RightSwitch<A,B,C,D> implements IArrowlet<Either<A,B>,Either<A,D>>{
  public var fst : Arrowlet<B,Either<A,D>>;

  public function new(fst){
    this.fst = fst;
  }
  public function apply(i:Either<A,B>):Future<Either<A,D>>{
    return switch (i){
      case      Left(l)      : 
        var trg = Future.trigger();
            trg.trigger(Left(l));
            trg.asFuture();
      case      Right(r)     : 
        fst.apply(r);
    }
  }
}