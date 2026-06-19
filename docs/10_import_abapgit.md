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

1. Tables et definitions DDLS `ZF2_*`.
2. CDS interface `ZF2_I_*`.
3. CDS projection `ZF2_C_*`.
4. Behavior definitions `ZF2_I_*` et projections `ZF2_C_*`.
5. Classes `ZF2_BP_*` et helpers `ZF2_CL_*`.
6. Services `ZF2_UI_*` et `ZF2_API_*`.
7. Service bindings OData V4 a creer dans ADT:
   - `ZF2_UI_FLIGHT_MANAGE_O4`
   - `ZF2_UI_BOOKING_MANAGE_O4`
   - `ZF2_API_FLIGHT_BOOKING_O4`
8. Metadata extensions `ZF2_C_*_UI`.
9. DCL `ZF2_RAP_ACCESS`.

## Point d'attention

Les tables persistantes `ZF2_*` sont serialisees comme objets abapGit `TABL`. Si un import precedent a cree des objets inactifs `DDLS ZFL_*` ou `DDLS ZF2_*`, il faut les supprimer avant de relancer le pull, car ces anciens objets ne sont pas les tables attendues.

Si ADT affiche l'erreur `Gerez et sauvegardez les options techniques pour ZF2_*`, ouvrir la table indiquee et sauvegarder les options techniques suivantes:

- Classe de donnees: `APPL0`.
- Categorie de taille: `0`.
- Buffering: `Not allowed` / `N`.

Cette correction peut apparaitre table par table pendant l'activation (`ZF2_BOOKING`, puis `ZF2_CARRIER`, etc.) lorsque des objets ont deja ete crees partiellement dans le systeme. Si le package ne contient pas de travail local a conserver, le plus propre est de supprimer les objets `ZFL_*` et `ZF2_*` inactifs puis de refaire un pull abapGit depuis GitHub.

Les behavior definitions actuelles utilisent `with draft` et referencent des draft tables `zfl_d_*`.

Si l'activation bloque sur ces objets, il faut soit:

- generer les draft tables dans ADT/BTP avec la structure attendue par RAP;
- ou retirer temporairement le draft des behavior definitions pour une premiere activation technique.

Le dossier `abapgit/` rend les objets detectables par abapGit. Il ne garantit pas que toutes les dependances fonctionnelles RAP soient deja completes.

Les service bindings sont a creer et publier dans ADT apres activation des service definitions. Voir `src/btp_rap/services/service_bindings.md` pour les noms, types et controles attendus.
