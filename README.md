# Concepts RxSwift
Conceitos RxSwift



## Motivação
Aprender os principais recursos do RxSwfit



## Feature
- Obersable e subscribe
- Esses conceitos são fundamentais no RxSwift
- [Observable](https://developer.apple.com/documentation/swift/sequence) são similares aos elementos sequencias, exemplo for in,map
- Com observable podemos criar sequencias, existe possibilidade de criar com apenas um elemento,vários  e array 
- [Subscribe](https://developer.apple.com/documentation/swift/collection/makeiterator()-85cyw) e similar ao makeIterator()
- Com subscribe consigo inteirar nosso observable
- Para cancelar qualquer observable posso utilizar disposed




```swift

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




let disposed = DisposeBag()

Observable.of(1,2,34,5).subscribe{ element in
	print( element)
}.disposed(by: disposed)


let obersvable8 = Observable.from([12,3,45])
let disposed1 = obersvable8.subscribe{ element in
	print(element )
}
disposed1.dispose()

```

## 

- [Subject] (https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932) são tanto observable quanto subscribe
- Ele recebe o evento  .next e cada vez que isto ocorre emite ao subscribe
- Existe 4 subjects no artigo acima, Variable esta depreciado, recomendado  uso do BehaviorSubject

</br>

- Publish Subject, inicia vazio e somente emite novos eventos ao subscribe
- onNext precisa necessariamente esta abaixo do subscribe
- Cada onNext e printado  novo valor no event

```swift
let  subject = PublishSubject<String>()


subject.subscribe{ event in
	print(event,"subject")
}

subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

```


</br>


- Behavior Subject similar ao Publish Subject a diferença que inicia com um valor e emite o evento assim que iniciado


```swift


let behavior = BehaviorSubject(value: "initial value")

//se houver um novo onNext aqui o valor e printando no event

behavior.subscribe { event in
   print(event)
}


```

</br>

- Rplay Subject trabalha com conceito de buffersize, ele ira emitir evento conforme a quantidade inserida no bufferSize
- No exemplo abaixo iniciei com 2, ou seja,  nos dois últimos onNext e printado o valor
- Abaixo ira printar o onNext 3 e 2, pois são os dois utlimos next

```swift

let replay = ReplaySubject<String>.create(bufferSize: 2)


replay.onNext("1")
replay.onNext("2")
replay.onNext("3")

//vai printar 2 e 3
replay.subscribe {event in
	
	print(event,"replay")

```

</br>

- Behavior Realy e similar ao  Variable , diferença que e  imutável
- Varible esta depreciada e aconselhável utilizar Behavior Relay
- Ele preserva o valor atual e repete somente o último/inicial valor para os novos subescribe
- Para atualizar o  valor utilizo o accept



```swift

let behavior1 = BehaviorRelay(value: "1")

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




```











