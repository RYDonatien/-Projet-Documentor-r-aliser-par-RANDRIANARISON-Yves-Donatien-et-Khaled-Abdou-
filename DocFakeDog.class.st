Class {
    #name : #DocFakeDog,
    #superclass : #DocFakeAnimal,
    #instVars : [ 'breed' ],
    #category : #'Documentor-Tests-Fixtures'
}

{ #category : #accessing }
DocFakeDog >> breed [
    "Returns the breed."
    ^ breed
]

{ #category : #printing }
DocFakeDog >> describe [
    "Describes the dog, including its breed."
    ^ super describe
]

{ #category : #examples }
DocFakeDog >> aVeryLongMethodSelectorDesignedForTesting [
    ^ breed
]
