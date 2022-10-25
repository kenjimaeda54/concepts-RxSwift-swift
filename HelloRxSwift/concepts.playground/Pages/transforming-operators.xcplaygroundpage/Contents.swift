//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

let disposed = DisposeBag()

print(" Converter array")
//converter em array
Observable.of(1,23,445,34)
	.toArray().subscribe({
		print($0)
	}).disposed(by: disposed)

print("\n Map")
//map operator
Observable.of(2,4,6,7,8)
	.map {
		return $0 * 2
	}.subscribe(onNext: {
		print($0)
	})

print("\n Flat Map")
//flat operator
//Em geral, o que o flatMap faz é aplicar um closure para cada Observable emitido e retornar um Observable. Ele se inscreve internamente em cada um desses observáveis, mescla-os e, finalmente, resulta em uma matriz plana.

//precisa o score ser do tipo BehaviorRelay ou Variable
//porque vou aplicar um observable neste valor
struct Student  {
   var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 10))
let maria = Student(score: BehaviorRelay(value: 20))

let student = PublishSubject<Student>()

student.asObservable().flatMap {
	$0.score.asObservable()
}.subscribe(onNext: {
	print($0)
}).disposed(by: disposed)

student.onNext(maria)
maria.score.accept(30)

student.onNext(john)
john.score.accept(40)






