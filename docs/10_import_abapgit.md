# Import abapGit des objets RAP

## Objectif

Le dossier `abapgit/` contient une serialisation abapGit des objets RAP generes depuis `src/btp_rap`. La racine du depot contient `.abapgit.xml` avec:

- `STARTING_FOLDER` = `/abapgit/`
- `FOLDER_LOGIC` = `FULL`

Lors du lien du repository dans ADT, abapGit doit donc analyser `abapgit/` et detecter les objets ABAP.

## URL a utiliser

```text
https://github.com/khalidh/ZFLIGHT-ECC.git
```

## Parametres abapGit

- Package cible: `ZFLIGHT_ECC` ou un package dedie `ZFLIGHT_RAP`.
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

Les behavior definitions actuelles utilisent `with draft` et referencent des draft tables `zfl_d_*`.

Si l'activation bloque sur ces objets, il faut soit:

- generer les draft tables dans ADT/BTP avec la structure attendue par RAP;
- ou retirer temporairement le draft des behavior definitions pour une premiere activation technique.

Le dossier `abapgit/` rend les objets detectables par abapGit. Il ne garantit pas que toutes les dependances fonctionnelles RAP soient deja completes.
