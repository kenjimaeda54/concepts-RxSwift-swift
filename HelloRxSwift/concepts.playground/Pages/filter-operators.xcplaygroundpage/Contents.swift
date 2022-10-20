//: [Previous](@previous)

import UIKit
import RxSwift
import Foundation
import RxCocoa

var igoreSubject = PublishSubject<String>()
let disposed = DisposeBag()

igoreSubject.ignoreElements().subscribe { _ in
	
	print("completed")
	
}.disposed(by: disposed)
//nao vai printar nada porcausa do ignoreElements
igoreSubject.onNext("a")
igoreSubject.onNext("b")

//vai printar uma vez o completed
igoreSubject.onCompleted()

//element at
var element = PublishSubject<String>()

//vai printar 3 porque index comeca no zero
element.element(at: 2).subscribe(onNext:{value in
	print(value)
})

element.onNext("5")
element.onNext("2")
element.onNext("3")

print("\n","filter")
//filter
//ira printar apenas os pares
Observable.of(1,25,17,34,4,6,8).filter{ $0 % 2 == 0 }.subscribe(onNext:{
	print($0)
}).disposed(by: disposed)

//skip
print("\n","skipe")
//ira pular 3 primeiros, partir deles printar
Observable.of("A","B","C","D","G").skip(3).subscribe(onNext:{
	print($0)
}).disposed(by: disposed)

//skip while
print("\n","skip while")
//vai pular enquanto for verdadeiro,depois que se torna
//falso para de pular
Observable.of(2,2,4,5,7,4).skip(while: {
	$0 % 2 == 0
}).subscribe(onNext:{
	print($0)
}).disposed(by: disposed)

//skip until
print("\n","skip until")
//vai pular quando  nao for feito um trigger
let skipUntil = PublishSubject<String>()
let trigger = PublishSubject<String>()

skipUntil.skip(until: trigger).subscribe(onNext:{
	print($0)
})

skipUntil.onNext("A")
skipUntil.onNext("C")
skipUntil.onNext("D")

trigger.onNext("C")
//a partir daqui vai printar porcausa do trigger
skipUntil.onNext("C")
skipUntil.onNext("D")


//take
print("\n","take operator")
//vai printar 12,3,45
//take pega os primeiros elementos
Observable.of(12,3,45,6)
	.take(3)
	.subscribe(onNext:{
		print($0)
	})


//take while
print("\n","take while")
//vai printar 12,34
//take until, enquanto a condicao for verdadeiro vai printar
//precisa estar no comeco da seguencia
Observable.of(5,9,12,34,5,7,6,8)
	.take(while: {
		 return $0 % 2 != 0
	})
	.subscribe(onNext:{
		print($0)
	})

//take until
print("\n","take until")
let takeSubject = PublishSubject<String>()
let triggerTake = PublishSubject<String>()

//nao esqueca o disposed
takeSubject.take(until: triggerTake).subscribe(onNext:{
	print($0)
}).disposed(by: disposed)


takeSubject.onNext("3")
takeSubject.onNext("5")

triggerTake.onNext("x")

//tudo abaixo vai ser ignorado por causa do trigger

takeSubject.onNext("8")













