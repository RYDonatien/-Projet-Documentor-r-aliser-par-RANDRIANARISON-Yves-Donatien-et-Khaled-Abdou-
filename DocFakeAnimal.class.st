Class {
    #name : #DocFakeAnimal,
    #superclass : #Object,
    #instVars : [ 'name', 'age' ],
    #category : #'Documentor-Tests-Fixtures'
}

{ #category : #accessing }
DocFakeAnimal >> name [
    "Returns the animal name."
    ^ name
]

{ #category : #accessing }
DocFakeAnimal >> age [
    ^ age
]

{ #category : #printing }
DocFakeAnimal >> describe [
    "Describes this animal."
    ^ name
]

{ #category : #examples }
DocFakeAnimal >> conditionalExample: aBoolean [
    aBoolean ifTrue: [ ^ self describe ].
    ^ 'unknown'
]

{ #category : #examples }
DocFakeAnimal >> pureCalculation: aNumber [
    ^ aNumber + 10
]
