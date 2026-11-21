# Documentor

Projet de Master 1 Génie Logiciel. Documentor est un petit outil écrit en Pharo
qui génère un rapport Microdown à partir d'une classe. Pour construire le
document, on passe par `MicMicrodownTextualBuilder` (titres, paragraphes, etc.)
au lieu de concaténer des chaînes à la main.

## Ce que fait l'outil

Le sujet est découpé en quatre versions :

- Version 1 (minimale) : nom de la classe, superclasse, variables d'instance et package.
- Version 2 (standard) : premier paragraphe du commentaire de classe, hiérarchie,
  méthodes locales avec le premier commentaire de chaque méthode.
- Version 3 (métriques) : profondeur d'héritage, nombre de champs et de méthodes
  (définis et hérités), méthodes qui envoient `super`, noms de méthodes trop longs.
- Version 4 (mini-linter) : méthodes qui n'accèdent à aucune variable d'instance,
  méthodes qui n'utilisent ni `self` ni variable d'instance, complexité
  cyclomatique par méthode et total pour la classe. Cette partie utilise un
  visiteur sur l'AST.

## Prérequis

- Pharo 12 ou plus récent.
- Microdown et le compilateur Opal (AST) dans l'image.

Si `MicMicrodownTextualBuilder` n'existe pas dans votre image, on peut charger Microdown :

```smalltalk
Metacello new
    baseline: 'Microdown';
    repository: 'github://pillar-markup/Microdown:v2.9.3/src';
    load: #('All').
```

## Installation

Une fois le dépôt poussé sur GitHub, il se charge avec Metacello (remplacer
`<GITHUB_USER>` par le nom d'utilisateur) :

```smalltalk
Metacello new
    baseline: 'Documentor';
    repository: 'github://<GITHUB_USER>/Documentor/src';
    load.
```

## Lancer les tests

Ouvrir Test Runner, choisir le package `Documentor-Tests` puis cliquer sur
Run Selected. On peut aussi l'ouvrir depuis un Playground :

```smalltalk
TestRunner open.
```

## Utilisation

```smalltalk
"Rapport complet"
(Documentor on: OrderedCollection) report.

"Version 1 seulement"
(Documentor on: OrderedCollection) reportMinimal.

"Métriques"
(Documentor on: OrderedCollection) reportMetrics.

"Mini-linter"
(Documentor on: OrderedCollection) reportLinter.
```

Le résultat est une chaîne en Microdown. Pour la sauvegarder dans un fichier :

```smalltalk
| microdown |
microdown := (Documentor on: OrderedCollection) report.
'Documentor-OrderedCollection.md' asFileReference
    writeStreamDo: [ :stream | stream nextPutAll: microdown ].
```

## Organisation du code

- `Documentor` : génère le rapport Microdown.
- `ClassMetrics` : calcule les métriques d'une classe.
- `DocMethod` : récupère le premier commentaire d'une méthode.
- `DocumentorASTVisitor` : parcourt l'AST pour détecter les accès et calculer la complexité.
- `DocFakeAnimal` et `DocFakeDog` : classes utilisées uniquement dans les tests.

On a séparé le calcul des métriques de l'affichage, et le visiteur AST ne dépend
pas du builder Microdown.

## Choix et définitions

- Profondeur d'héritage : nombre de superclasses (`allSuperclasses size`).
- Champs hérités : somme des champs déclarés dans les superclasses.
- Méthodes héritées : sélecteurs présents dans une superclasse et non redéfinis dans la classe.
- Nom de méthode trop long : plus de 25 caractères par défaut, le seuil peut être changé.
- Complexité cyclomatique : 1 + nombre d'envois conditionnels trouvés (`ifTrue:`,
  `ifFalse:` et leurs variantes à deux blocs, `whileTrue`, `whileFalse`, `and:`, `or:`).
  C'est une approximation, suffisante pour ce que demande le sujet.

## Remarque sur l'API AST

Le sujet ne dit pas quelle version de Pharo utiliser et les noms de l'API AST
changent un peu d'une version à l'autre. Ici on utilise `OCProgramNodeVisitor`,
`CompiledMethod>>ast` et les tests `isSuperVariable`, `isSelfVariable` et
`isInstanceVariable`. Si l'un de ces sélecteurs n'existe pas dans votre image,
il suffit d'adapter `DocumentorASTVisitor`, le reste du code n'est pas concerné.
