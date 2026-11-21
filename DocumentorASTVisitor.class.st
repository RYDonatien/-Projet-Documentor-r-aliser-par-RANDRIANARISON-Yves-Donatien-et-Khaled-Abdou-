Class {
    #name : #DocumentorASTVisitor,
    #superclass : #OCProgramNodeVisitor,
    #instVars : [ 'accessesInstanceVariables', 'accessesSelf', 'sendsSuper', 'cyclomaticComplexity' ],
    #category : #Documentor
}

{ #category : #'instance creation' }
DocumentorASTVisitor class >> analyze: aCompiledMethod [
    | visitor |
    visitor := self new.
    aCompiledMethod ast acceptVisitor: visitor.
    ^ visitor
]

{ #category : #initialization }
DocumentorASTVisitor >> initialize [
    super initialize.
    accessesInstanceVariables := false.
    accessesSelf := false.
    sendsSuper := false.
    cyclomaticComplexity := 1
]

{ #category : #accessing }
DocumentorASTVisitor >> accessesInstanceVariables [
    ^ accessesInstanceVariables
]

{ #category : #accessing }
DocumentorASTVisitor >> accessesSelf [
    ^ accessesSelf
]

{ #category : #accessing }
DocumentorASTVisitor >> sendsSuper [
    ^ sendsSuper
]

{ #category : #accessing }
DocumentorASTVisitor >> cyclomaticComplexity [
    ^ cyclomaticComplexity
]

{ #category : #visiting }
DocumentorASTVisitor >> visitMessageNode: aNode [
    | selector receiver |
    selector := aNode selector.
    receiver := aNode receiver.
    receiver isSuperVariable ifTrue: [ sendsSuper := true ].
    (#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue: whileTrue whileFalse and: or:)
        includes: selector)
        ifTrue: [ cyclomaticComplexity := cyclomaticComplexity + 1 ].
    ^ super visitMessageNode: aNode
]

{ #category : #visiting }
DocumentorASTVisitor >> visitVariableNode: aNode [
    aNode isInstanceVariable ifTrue: [ accessesInstanceVariables := true ].
    aNode isSelfVariable ifTrue: [ accessesSelf := true ].
    ^ super visitVariableNode: aNode
]
