Class {
    #name : #Documentor,
    #superclass : #Object,
    #instVars : [ 'targetClass', 'builder' ],
    #category : #Documentor
}

{ #category : #'instance creation' }
Documentor class >> on: aClass [
    ^ self new
        targetClass: aClass;
        yourself
]

{ #category : #accessing }
Documentor >> targetClass [
    ^ targetClass
]

{ #category : #accessing }
Documentor >> targetClass: aClass [
    targetClass := aClass
]

{ #category : #generating }
Documentor >> report [
    builder := MicMicrodownTextualBuilder new.
    self
        reportClassName;
        reportInheritance;
        reportFields;
        reportPackage;
        reportDefaultSections;
        reportMetricsSections;
        reportLinterSections.
    ^ builder contents
]

{ #category : #generating }
Documentor >> reportMinimal [
    builder := MicMicrodownTextualBuilder new.
    self reportClassName.
    self reportInheritance.
    self reportFields.
    self reportPackage.
    ^ builder contents
]

{ #category : #generating }
Documentor >> reportMetrics [
    builder := MicMicrodownTextualBuilder new.
    self reportClassName.
    self reportMetricsSections.
    ^ builder contents
]

{ #category : #generating }
Documentor >> reportLinter [
    builder := MicMicrodownTextualBuilder new.
    self reportClassName.
    self reportLinterSections.
    ^ builder contents
]

{ #category : #private }
Documentor >> reportClassName [
    builder header: targetClass name asString withLevel: 1
]

{ #category : #private }
Documentor >> reportInheritance [
    builder paragraph: 'Superclass'.
    targetClass superclass
        ifNil: [ builder paragraph: 'No superclass' ]
        ifNotNil: [ :aClass | builder paragraph: aClass name asString ]
]

{ #category : #private }
Documentor >> reportFields [
    builder header: 'Fields declared in this class' withLevel: 2.
    targetClass instVarNames do: [ :fieldName |
        builder paragraph: fieldName asString ].
    targetClass instVarNames isEmpty
        ifTrue: [ builder paragraph: 'No fields declared' ]
]

{ #category : #private }
Documentor >> reportPackage [
    builder paragraph: 'Package'.
    targetClass package
        ifNil: [ builder paragraph: 'Unpackaged class' ]
        ifNotNil: [ :aPackage | builder paragraph: aPackage name asString ]
]

{ #category : #private }
Documentor >> reportDefaultSections [
    self reportClassComment.
    self reportHierarchy.
    self reportMethods
]

{ #category : #private }
Documentor >> reportClassComment [
    | classComment firstParagraph |
    builder header: 'Class comment' withLevel: 2.
    classComment := targetClass comment.
    classComment isEmpty
        ifTrue: [ builder paragraph: 'No class comment' ]
        ifFalse: [
            firstParagraph := self firstParagraphOf: classComment.
            builder paragraph: firstParagraph ]
]

{ #category : #private }
Documentor >> firstParagraphOf: aComment [
    | document paragraph |
    document := MicrodownParser parse: aComment.
    paragraph := document children
        detect: [ :each | each isKindOf: MicParagraphBlock ]
        ifNone: [ nil ].
    ^ paragraph
        ifNil: [ aComment ]
        ifNotNil: [ paragraph text ]
]

{ #category : #private }
Documentor >> reportHierarchy [
    builder header: 'Class hierarchy' withLevel: 2.
    (targetClass allSuperclasses reversed, { targetClass }) do: [ :each |
        builder paragraph: each name asString ].
    (targetClass subclasses asSortedCollection: [ :left :right |
        left name asString < right name asString ]) do: [ :each |
            builder paragraph: each name asString ]
]

{ #category : #private }
Documentor >> reportMethods [
    | methods |
    builder header: 'Methods defined in this class' withLevel: 2.
    methods := targetClass methodDict values asSortedCollection: [ :left :right |
        left selector asString < right selector asString ].
    methods do: [ :method |
        builder paragraph: method selector asString.
        DocMethod firstCommentOf: method ifNotEmpty: [ :comment |
            builder paragraph: comment ] ].
    methods isEmpty ifTrue: [ builder paragraph: 'No local methods' ]
]

{ #category : #private }
Documentor >> reportMetricsSections [
    | metrics |
    metrics := ClassMetrics on: targetClass.
    builder header: 'Class metrics' withLevel: 2.
    builder paragraph: 'Depth of inheritance'.
    builder paragraph: metrics depthOfInheritance asString.
    builder paragraph: 'Inherited fields'.
    builder paragraph: metrics inheritedFieldsCount asString.
    builder paragraph: 'Fields defined in this class'.
    builder paragraph: metrics definedFieldsCount asString.
    builder paragraph: 'Methods defined in this class'.
    builder paragraph: metrics definedMethodsCount asString.
    builder paragraph: 'Inherited methods'.
    builder paragraph: metrics inheritedMethodsCount asString.
    builder paragraph: 'Methods invoking super'.
    builder paragraph: metrics superSendingMethods size asString.
    builder paragraph: 'Long method names'.
    metrics longMethodNames do: [ :selector |
        builder paragraph: selector asString ].
    metrics longMethodNames isEmpty
        ifTrue: [ builder paragraph: 'None' ]
]

{ #category : #private }
Documentor >> reportLinterSections [
    | metrics |
    metrics := ClassMetrics on: targetClass.
    builder header: 'Mini Linter' withLevel: 2.
    builder paragraph: 'Methods without direct instance-variable access'.
    metrics methodsWithoutInstanceVariableAccess do: [ :selector |
        builder paragraph: selector asString ].
    metrics methodsWithoutInstanceVariableAccess isEmpty
        ifTrue: [ builder paragraph: 'None' ].
    builder paragraph: 'Methods without self or instance-variable access'.
    metrics methodsWithoutSelfOrInstanceVariableAccess do: [ :selector |
        builder paragraph: selector asString ].
    metrics methodsWithoutSelfOrInstanceVariableAccess isEmpty
        ifTrue: [ builder paragraph: 'None' ].
    builder paragraph: 'Cyclomatic complexity by method'.
    metrics complexityByMethod keys asSortedCollection do: [ :selector |
        builder paragraph: selector asString.
        builder paragraph: (metrics complexityByMethod at: selector) asString ].
    builder paragraph: 'Total cyclomatic complexity'.
    builder paragraph: metrics totalCyclomaticComplexity asString
]
