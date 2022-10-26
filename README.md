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

- [Subject](https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932) são tanto observable quanto subscribe
- Ele recebe o evento  .next e cada vez que isto ocorre emite ao subscribe
- Existe 4 subjects no artigo acima, Variable esta depreciado, recomendado  uso do BehaviorRelay

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

### Filters operators
- Existem vários filters operators um deles e o elementAt
- Ideia e capturar o elemento pelo seu índice no exemplo abaixo o índice 2
- Ira printar 2,porque e o segundo índice

```swift
element.element(at: 2).subscribe(onNext:{value in
	print(value)
})

element.onNext("5")
element.onNext("2")
element.onNext("3")

```

## 
- Filter usa um predicate idêntico ao paradigma funcional, quando for verdadeiro essa condição retorna os valores
- Abaixo ira printar apenas elementos pares

```swift
Observable.of(1,25,17,34,4,6,8).filter{ $0 % 2 == 0 }.subscribe(onNext:{
	print($0)
}).disposed(by: disposed)

```

##
- Skip tem objetivo de pular elementos
- Abaixo ira pular os 3 primeiros
- Skip while ira pular enquanto for verdadeiro a condição, quando se tornar falsa para de pular
- No exemplo abaixo o skipe while ira pular a partir do 5, consequentemente não ira printar o 5,7,4
- Skip until ira aguardar ocorrer um trigger, apos isto ira printar os valores a partir desse trigger, então no exemplo abaixo ira printar o C e D

```swift
//skip
Observable.of("A","B","C","D","G").skip(3).subscribe(onNext:{
	print($0)
}).disposed(by: disposed)


//skip while

Observable.of(2,2,4,5,7,4).skip(while: {
	$0 % 2 == 0
}).subscribe(onNext:{
	print($0)
}).disposed(by: disposed

//skip until
let skipUntil = PublishSubject<String>()
let trigger = PublishSubject<String>()

skipUntil.skip(until: trigger).subscribe(onNext:{
	print($0)
})

skipUntil.onNext("A")
skipUntil.onNext("C")
skipUntil.onNext("D")

trigger.onNext("C")

skipUntil.onNext("C")
skipUntil.onNext("D")

```
##
- Take ele pega primeiros elementos baseado na quantidade colocada
- No exemplo abaixo o take ira pegar os 3 primeiros
- Take while ira pegar os verdadeiros conforme o predicate, neste precisa  condições  estiver no início da sequência se estiver no meio da  não ira refletir
- Take until tudo abaixo do trigger não sera refletido, no caso abaixo o valor 8 não sera printado

```swift

//take
Observable.of(12,3,45,6)
  .take(3)
  .subscribe(onNext:{
    print($0)
  })

//take while
Observable.of(5,9,12,34,5,7,6,8)
  .take(while: {
    return $0 % 2 != 0
  })
  .subscribe(onNext:{
    print($0)
  })

//take until
let takeSubject = PublishSubject<String>()
let triggerTake = PublishSubject<String>()

takeSubject.take(until: triggerTake).subscribe(onNext:{
	print($0)
}).disposed(by: disposed)


takeSubject.onNext("3")
takeSubject.onNext("5")

triggerTake.onNext("x")

takeSubject.onNext("8")

```

## Operadores  de transformação 
- Alguns dos operadores são flatmap,flatmap latest, map e  array
- Flatmap, em geral, aplica um closrue para cada Observable emitindo e retornando um Observable. Ele se inscreve internamente em cada um desses observáveis e mescla-os,  finalmente retorna um  matriz plana
- Preciso usar operador BehaviorRelay para representar a variável 
- Flatmap Latest e similar ao Flatmap a diferença esta por conta que observable acontece apos o último  onNext, se tentar atualizar  um valor depois  sera ignorado



```swift

//flatmap

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


student.onNext(maria)
maria.score.accept(50)


student.onNext(pedro)
maria.score.accept(33)


// flatmap latest
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


// Carlos nao ira atualizar apenas bia ,pois este e o comportamento do flatmap latest,apenas um observable 
flatMapLatest.onNext(bia)
carlos.score.accept(10)



```






