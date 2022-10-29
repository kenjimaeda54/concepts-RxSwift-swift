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
//junta duas obeservable

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



print("\n combine least")
//merge
//merge vai juntar dois observadores a diferença em relação concat
//que  baseia na chegada para criar as sequências
//abaixo vai imprimir na ordem colocada os números

let leftCombine = PublishSubject<Int>()
let rightCombine = PublishSubject<Int>()

//vai printar conforme o retorno do results
// left / right
let disposebleCombine = Observable.combineLatest(leftCombine,rightCombine) { left, right in
	"\(left) / \(right)"
}

disposebleCombine.subscribe(onNext:{
	print($0)
}).disposed(by: disposed)

leftCombine.onNext(20)
leftCombine.onNext(30)
rightCombine.onNext(20)
rightCombine.onNext(17)
rightCombine.onNext(13)



print("\n withLatestFrom")
//vai caputurar o  utlimo elmento de uma seguencia  a partir de um trigger

let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let disposebleLastestFrom = button.withLatestFrom(textField)

disposebleLastestFrom.subscribe(onNext:{
	print($0)
})

//vai printar apenas caderno pois e ultimo valor
textField.onNext("banana")
textField.onNext("pera")
textField.onNext("caderno")

button.onNext(())


print("\n reduce")
//http://equinocios.com/swift/2017/03/13/Introducao-e-casos-de-uso-Map-Filter-e-Reduce/
//reduce segue mesmo conceito que Javascript

let collectionReduce = Observable.of(12,34,56,7)

collectionReduce.reduce(0) { value,oldValue in
	  value + oldValue
}.subscribe(onNext: {
	print($0)
}).disposed(by: disposed)


print("\n scan")
//scan e parecido com reduce a diferenca que vai mostrar os valores a cada soma
//ou seja primeiro mostra 12,depois 12 + 34, depois 12 + 34 + 56
//https://developer.apple.com/documentation/combine/fail/scan(_:_:)

let collectionScan = Observable.of(12,34,56,7)

collectionScan.scan(0) {
	$0 + $1
}.subscribe(onNext:{
	print($0)
})
