import UIKit
import RxSwift
import Foundation
import RxCocoa

//observale e parecido com seguence
//seguence em swift maneira de acessar elementos seguenciais
//exemplo for in, map
//https://developer.apple.com/documentation/swift/sequence

//subscribe e parecido com makeIterator()
//https://developer.apple.com/documentation/swift/collection/makeiterator()-85cyw
//ideia e retornar um inteirador sobre o elemento da colecao


//criando observable apenas com um elemento
let observable1 = Observable.just(1)

//criando observable para varios elementos
let observable2 = Observable.of(1,2,3)
let observable3 = Observable.of([1,2,3])

//criando observable para um array de elementos
let observable4 = Observable.from([1,2,3,4])

//vai printar cada elemento
observable4.subscribe {
	if let element = $0.element {
		print(element,"observable4",$0)
	}
}

//usando o onNext
//aqui printa sem o next
observable4.subscribe(onNext: { element in
	 print(element)
})


//vai printar um array
observable3.subscribe {
	if let element = $0.element {
		print(element,"observable3")
	}
}


//disposed
//maneira de evitar memoria leak

let disposed = DisposeBag()

Observable.of(1,2,34,5).subscribe{ element in
	print( element)
}.disposed(by: disposed)

//outra maneira de usar disposed
let obersvable8 = Observable.from([12,3,45])
let disposed1 = obersvable8.subscribe{ element in
	print(element )
}
disposed1.dispose()

//Plubish Subject

let  subject = PublishSubject<String>()

//subject vai acionar cada novo onNext
//onNext precisa estar abaixo do subscribe
subject.subscribe{ event in
	print(event,"subject")
}
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

//tudo abaixo sera ignorado por causa do dispose
subject.dispose()

//quando possuir onCompleted tudo abaixo sera ignorado
//vai aparecer completed subject
subject.onCompleted()
subject.onNext("5")

//Behavior Subject
//identico ao Publish Object
//diferenca que precisa de um valor inicial

let behavior = BehaviorSubject(value: "initial value")

behavior.subscribe { event in
   print(event)
}

//replay subject trabalha na quantidade que inserimos no
//buffersize ou seja neste caso sera dois eventos
//sem os utilmos tem prioridade
let replay = ReplaySubject<String>.create(bufferSize: 2)


replay.onNext("1")
replay.onNext("2")
replay.onNext("3")

//vai printar 2 e 3
replay.subscribe {event in
	
	print(event,"replay")
}


//BehaviorRealy
//parecido com variaveis


let behavior1 = BehaviorRelay(value: "1")

//so posso alterar valor com accepet
behavior1.accept("2")

behavior1.asObservable()
	.subscribe {event in
		print(event,"BehaviorRelay")
		
}

let behavior2 = BehaviorRelay(value: ["item 2"])

var value = behavior2.value

value.append("item 10")
value.append("item 11")

behavior2.accept(value)

behavior2.asObservable()
	.subscribe { event in
		print(event)
		
	}































