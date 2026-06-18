# Import abapGit des objets RAP

## Objectif

Le dossier `abapgit/` contient une serialisation abapGit des objets RAP generes depuis `src/btp_rap`. La racine du depot contient `.abapgit.xml` avec:

- `MASTER_LANGUAGE` = `F`
- `STARTING_FOLDER` = `/abapgit/`
- `FOLDER_LOGIC` = `FULL`

Lors du lien du repository dans ADT, abapGit doit donc analyser `abapgit/` et detecter les objets ABAP.

## URL a utiliser

```text
https://github.com/khalidh/ZFLIGHT-ECC.git
```

## Parametres abapGit

- Package cible: `ZFLIGHT-ECC2`.
- Branch: `refs/heads/main`.
- Folder logic: `FULL`.

## Ordre d'activation attendu

1. Tables et definitions DDLS `ZFL_*`.
2. CDS interface `ZI_*`.
3. CDS projection `ZC_*`.
4. Behavior definitions `ZI_*` et `ZC_*`.
5. Classes `ZBP_*` et helpers `ZCL_*`.
6. Services `ZUI_*` et `ZAPI_*`.
7. Metadata extensions `ZC_*_UI`.
8. DCL `ZFLIGHT_RAP_ACCESS`.

## Point d'attention

Les tables persistantes `ZFL_*` sont serialisees comme objets abapGit `TABL`. Si un import precedent a cree des objets inactifs `DDLS ZFL_*`, il faut les supprimer avant de relancer le pull, car ces anciens objets ne sont pas les tables attendues.

Si ADT affiche l'erreur `Gerez et sauvegardez les options techniques pour ZFL_*`, ouvrir la table indiquee et sauvegarder les options techniques suivantes:

- Classe de donnees: `APPL0`.
- Categorie de taille: `0`.
- Buffering: `Not allowed` / `N`.

Cette correction peut apparaitre table par table pendant l'activation (`ZFL_BOOKING`, puis `ZFL_CARRIER`, etc.) lorsque des objets ont deja ete crees partiellement dans le systeme. Si le package ne contient pas de travail local a conserver, le plus propre est de supprimer les objets `ZFL_*` inactifs puis de refaire un pull abapGit depuis GitHub.

Les behavior definitions actuelles utilisent `with draft` et referencent des draft tables `zfl_d_*`.

Si l'activation bloque sur ces objets, il faut soit:

- generer les draft tables dans ADT/BTP avec la structure attendue par RAP;
- ou retirer temporairement le draft des behavior definitions pour une premiere activation technique.

Le dossier `abapgit/` rend les objets detectables par abapGit. Il ne garantit pas que toutes les dependances fonctionnelles RAP soient deja completes.
