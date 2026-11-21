# Installation et lancement dans Pharo

1. Installer Pharo 12 ou 13 depuis le site officiel de Pharo.
2. Ouvrir une image Pharo.
3. Ouvrir un Playground.
4. Si Microdown n'est pas disponible, exécuter :

```smalltalk
Metacello new
    baseline: 'Microdown';
    repository: 'github://pillar-markup/Microdown:v2.9.3/src';
    load: #('All').
```

5. Charger le projet depuis GitHub après avoir créé le dépôt :

```smalltalk
Metacello new
    baseline: 'Documentor';
    repository: 'github://<GITHUB_USER>/Documentor/src';
    load.
```

6. Vérifier que les packages `Documentor` et `Documentor-Tests` sont chargés.
7. Ouvrir Test Runner, sélectionner `Documentor-Tests`, cliquer sur **Run Selected**.
8. Dans un Playground, exécuter :

```smalltalk
(Documentor on: OrderedCollection) report
```

on Remplace `GITHUB_USER` par le vrai nom du compte GitHub. Le dépôt distant
n'est pas créé automatiquement par ce dossier : il faut le créer sur GitHub
et pousser les fichiers avec Git ou Iceberg.
