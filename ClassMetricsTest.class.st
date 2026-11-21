Class {
    #name : #ClassMetricsTest,
    #superclass : #TestCase,
    #category : #'Documentor-Tests'
}

{ #category : #tests }
ClassMetricsTest >> testInheritanceDepth [
    self assert: (ClassMetrics on: DocFakeDog) depthOfInheritance
        equals: (DocFakeDog allSuperclasses size)
]

{ #category : #tests }
ClassMetricsTest >> testDefinedFields [
    self assert: (ClassMetrics on: DocFakeDog) definedFieldsCount equals: 1
]

{ #category : #tests }
ClassMetricsTest >> testInheritedFields [
    | expected |
    expected := DocFakeDog superclass instVarNames size
        + (DocFakeDog superclass allSuperclasses
            inject: 0
            into: [ :sum :each | sum + each instVarNames size ]).
    self assert: (ClassMetrics on: DocFakeDog) inheritedFieldsCount
        equals: expected
]

{ #category : #tests }
ClassMetricsTest >> testDefinedMethods [
    self assert: (ClassMetrics on: DocFakeDog) definedMethodsCount
        equals: DocFakeDog methodDict size
]

{ #category : #tests }
ClassMetricsTest >> testDetectsSuperSendingMethod [
    self assert: ((ClassMetrics on: DocFakeDog) superSendingMethods
        anySatisfy: [ :method | method selector = #describe ])
]

{ #category : #tests }
ClassMetricsTest >> testDetectsLongSelector [
    self assert: ((ClassMetrics on: DocFakeDog) longMethodNames
        includes: #aVeryLongMethodSelectorDesignedForTesting)
]

{ #category : #tests }
ClassMetricsTest >> testCyclomaticComplexityHasBaseOne [
    | complexity |
    complexity := (ClassMetrics on: DocFakeAnimal) complexityByMethod
        at: #pureCalculation:.
    self assert: complexity equals: 1
]

{ #category : #tests }
ClassMetricsTest >> testConditionalIncreasesComplexity [
    | complexity |
    complexity := (ClassMetrics on: DocFakeAnimal) complexityByMethod
        at: #conditionalExample:.
    self assert: complexity equals: 2
]
