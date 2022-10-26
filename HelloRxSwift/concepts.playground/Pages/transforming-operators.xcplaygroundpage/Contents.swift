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

let maria = Student(score: BehaviorRelay(value: 10))
let pedro = Student(score: BehaviorRelay(value: 20))

let student = PublishSubject<Student>()

student.asObservable().flatMap {
	$0.score.asObservable()
}.subscribe(onNext: {
	print($0)
})

//repara qeu maria e pedro sao variaveis de uma struct
//essa variavel precisa ser do tipo BehaviorRelay
student.onNext(maria)
maria.score.accept(50)


student.onNext(pedro)
maria.score.accept(33)

print("\n Flat Map Latest")
//flat latest operator

struct Student2 {
	var score: BehaviorRelay<Int>
}

let carlos =  Student2(score: BehaviorRelay(value: 30))
let bia =  Student2(score: BehaviorRelay(value: 20))

let flatMapLatest = PublishSubject<Student2>()

flatMapLatest.asObserver().flatMapLatest {
	$0.score.asObservable()
}.subscribe(onNext: {
	print($0)
})

flatMapLatest.onNext(carlos)
carlos.score.accept(60)

//não sera atualizado Carlos, flatp map latest e similar
//ao flat map a diferençá  realizara observable so  no último onNext  ou seja agora e variavel bia
flatMapLatest.onNext(bia)
carlos.score.accept(10)











