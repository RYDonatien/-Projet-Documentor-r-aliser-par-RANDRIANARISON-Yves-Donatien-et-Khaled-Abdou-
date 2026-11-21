Class {
    #name : #DocumentorTest,
    #superclass : #TestCase,
    #category : #'Documentor-Tests'
}

{ #category : #tests }
DocumentorTest >> testMinimalReportContainsClassName [
    self assert: ((Documentor on: DocFakeDog) reportMinimal includesSubstring: 'DocFakeDog')
]

{ #category : #tests }
DocumentorTest >> testMinimalReportContainsSuperclass [
    self assert: ((Documentor on: DocFakeDog) reportMinimal includesSubstring: 'DocFakeAnimal')
]

{ #category : #tests }
DocumentorTest >> testMinimalReportContainsField [
    self assert: ((Documentor on: DocFakeDog) reportMinimal includesSubstring: 'breed')
]

{ #category : #tests }
DocumentorTest >> testReportContainsClassComment [
    self assert: ((Documentor on: DocFakeDog) report includesSubstring: 'Describes the dog')
]

{ #category : #tests }
DocumentorTest >> testReportContainsMethods [
    self assert: ((Documentor on: DocFakeDog) report includesSubstring: 'describe')
]

{ #category : #tests }
DocumentorTest >> testReportIsRepeatable [
    | documentor first second |
    documentor := Documentor on: DocFakeDog.
    first := documentor report.
    second := documentor report.
    self assert: first equals: second
]
