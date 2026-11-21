Class {
    #name : #BaselineOfDocumentor,
    #superclass : #BaselineOf,
    #category : #BaselineOfDocumentor
}

{ #category : #baselines }
BaselineOfDocumentor >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec
            package: 'Documentor';
            package: 'Documentor-Tests' with: [ spec requires: #('Documentor') ].
        spec
            group: 'Core' with: #('Documentor');
            group: 'Tests' with: #('Documentor-Tests');
            group: 'default' with: #('Documentor' 'Documentor-Tests') ]
]

{ #category : #accessing }
BaselineOfDocumentor >> projectClass [
    ^ MetacelloCypressBaselineProject
]
