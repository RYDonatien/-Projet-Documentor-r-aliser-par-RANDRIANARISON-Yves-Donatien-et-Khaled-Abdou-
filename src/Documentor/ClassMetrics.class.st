Class {
    #name : #ClassMetrics,
    #superclass : #Object,
    #instVars : [ 'targetClass', 'longMethodNameThreshold' ],
    #category : #Documentor
}

{ #category : #'instance creation' }
ClassMetrics class >> on: aClass [
    ^ self new
        targetClass: aClass;
        yourself
]

{ #category : #initialization }
ClassMetrics >> initialize [
    super initialize.
    longMethodNameThreshold := 25
]

{ #category : #accessing }
ClassMetrics >> targetClass: aClass [
    targetClass := aClass
]

{ #category : #accessing }
ClassMetrics >> longMethodNameThreshold [
    ^ longMethodNameThreshold
]

{ #category : #accessing }
ClassMetrics >> longMethodNameThreshold: anInteger [
    longMethodNameThreshold := anInteger
]

{ #category : #metrics }
ClassMetrics >> depthOfInheritance [
    ^ targetClass allSuperclasses size
]

{ #category : #metrics }
ClassMetrics >> inheritedFieldsCount [
    ^ targetClass allSuperclasses
        inject: 0
        into: [ :total :each | total + each instVarNames size ]
]

{ #category : #metrics }
ClassMetrics >> definedFieldsCount [
    ^ targetClass instVarNames size
]

{ #category : #metrics }
ClassMetrics >> definedMethods [
    ^ targetClass methodDict values asOrderedCollection
]

{ #category : #metrics }
ClassMetrics >> definedMethodsCount [
    ^ self definedMethods size
]

{ #category : #metrics }
ClassMetrics >> inheritedSelectors [
    ^ (targetClass allSuperclasses
        inject: Set new
        into: [ :selectors :each |
            selectors addAll: each selectors.
            selectors ])
        difference: targetClass selectors asSet
]

{ #category : #metrics }
ClassMetrics >> inheritedMethodsCount [
    ^ self inheritedSelectors size
]

{ #category : #metrics }
ClassMetrics >> superSendingMethods [
    ^ self definedMethods select: [ :method |
        (DocumentorASTVisitor analyze: method) sendsSuper ]
]

{ #category : #metrics }
ClassMetrics >> longMethodNames [
    ^ targetClass selectors
        select: [ :selector |
            selector asString size > longMethodNameThreshold ]
        thenCollect: [ :selector | selector ]
]

{ #category : #metrics }
ClassMetrics >> methodsWithoutInstanceVariableAccess [
    ^ self definedMethods
        select: [ :method |
            (DocumentorASTVisitor analyze: method) accessesInstanceVariables not ]
        thenCollect: [ :method | method selector ]
]

{ #category : #metrics }
ClassMetrics >> methodsWithoutSelfOrInstanceVariableAccess [
    ^ self definedMethods
        select: [ :method |
            | analysis |
            analysis := DocumentorASTVisitor analyze: method.
            analysis accessesSelf not
                and: [ analysis accessesInstanceVariables not ] ]
        thenCollect: [ :method | method selector ]
]

{ #category : #metrics }
ClassMetrics >> complexityByMethod [
    ^ self definedMethods
        inject: Dictionary new
        into: [ :dictionary :method |
            dictionary
                at: method selector
                put: (DocumentorASTVisitor analyze: method) cyclomaticComplexity.
            dictionary ]
]

{ #category : #metrics }
ClassMetrics >> totalCyclomaticComplexity [
    ^ self complexityByMethod values sum
]
