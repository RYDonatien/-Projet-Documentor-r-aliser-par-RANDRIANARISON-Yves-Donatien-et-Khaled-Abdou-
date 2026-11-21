Class {
    #name : #DocMethod,
    #superclass : #Object,
    #category : #Documentor
}

{ #category : #accessing }
DocMethod class >> firstCommentOf: aCompiledMethod [
    | comments |
    comments := aCompiledMethod ast comments.
    comments isEmpty ifTrue: [ ^ '' ].
    ^ comments first contents
]

{ #category : #accessing }
DocMethod class >> firstCommentOf: aCompiledMethod ifNotEmpty: aBlock [
    | comment |
    comment := self firstCommentOf: aCompiledMethod.
    comment isEmpty ifFalse: [ aBlock value: comment ].
    ^ comment
]
