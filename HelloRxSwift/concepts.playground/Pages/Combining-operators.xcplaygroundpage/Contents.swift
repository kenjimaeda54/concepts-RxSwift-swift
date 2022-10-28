//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

let disposed = DisposeBag()

 
//startWith
//insere um elemento no início da sequência
let seguenceNumber = Observable.of(3,4,5).startWith(1)

seguenceNumber.subscribe(onNext: {
	print($0)
}).disposed(by: disposed)

print("\n concat")
//concat
//junta duas sequencias

let concat1 = Observable.of(1,2,3,4)
let concat2 = Observable.of(6,7,8,9)
let togetherConcat = Observable.concat([concat1,concat2])

togetherConcat.subscribe(onNext: {
	print($0)
}).disposed(by: disposed)

print("\n merge")
//merge
//merge vai juntar dois observadores a diferença em relação concat
//que  baseia na chegada para criar as sequências
//abaixo vai imprimir na ordem colocada os números

let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let observableMerge =  Observable.of(left.asObservable(),right.asObservable())

let mergeLeftRight = observableMerge.merge()

mergeLeftRight.subscribe(onNext:{
	print($0)
})

left.onNext(1)
left.onNext(3)
left.onNext(4)
right.onNext(1)
right.onNext(99)
left.onNext(111)
right.onNext(23)










