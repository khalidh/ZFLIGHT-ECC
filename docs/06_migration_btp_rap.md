# Preparation migration SAP BTP RAP

## Cartographie ECC vers RAP

| Objet ECC | Cible RAP |
|---|---|
| Table transparente | Table persistante + CDS View Entity |
| Search Help | Value Help CDS |
| Foreign Key DDIC | Association CDS |
| Function Module | Behavior Implementation / Action RAP |
| Module Pool Dynpro | Fiori Elements Object Page |
| Report ALV | Fiori Elements List Report |
| Transaction SAP GUI | App Fiori Launchpad |
| Classe metier | Classe RAP / behavior pool helper |
| Message class | Message class reutilisable + RAP reported messages |
| Lock object | RAP locking / ETag / total lock |
| Number range SNRO | Numbering RAP managed/unmanaged |

## Lots de migration

1. Stabiliser le modele de donnees et les statuts.
2. Exposer les lectures via CDS View Entities.
3. Reprendre les validations dans classes reutilisables.
4. Creer BO RAP Reservation, Order, Invoice.
5. Remplacer ALV par List Reports.
6. Remplacer Dynpro par Object Pages.
7. Ajouter API OData V4 publiees.
8. Decommission progressif des transactions SAP GUI.

## Difficultes

- Verrous explicites ECC a transformer en modele RAP.
- Commits manuels a retirer des services appeles par RAP.
- Messages BAPIRET2/SY-MSG a convertir en `reported`.
- Dynpro PAI/PBO a reconcevoir en UI declarative.
- Search helps classiques a convertir en value helps CDS.

## Quick wins

- Garder les classes metier sans dependance SAP GUI.
- Eviter `COMMIT WORK` dans les classes bas niveau.
- Centraliser statuts et tarification.
- Documenter cles et associations des maintenant.

## Objets generes pour la cible BTP RAP

Les objets cible sont disponibles dans [src/btp_rap](../src/btp_rap).

### Tables persistantes

- `ZF2_CARRIER`
- `ZF2_CONNECTION`
- `ZF2_FLIGHT`
- `ZF2_CUSTOMER`
- `ZF2_BOOKING`
- `ZF2_ORDER`
- `ZF2_ORDER_ITEM`
- `ZF2_INVOICE`
- `ZF2_PAYMENT`
- `ZF2_STATUS_HIST`

### CDS et services

- Interface CDS `ZF2_I_*` dans `src/btp_rap/cds/interface`.
- Projection CDS `ZF2_C_*` dans `src/btp_rap/cds/projection`.
- Behavior definitions `ZF2_I_*` et projections `ZF2_C_*` dans `src/btp_rap/behavior`.
- Services OData V4 `ZF2_UI_FLIGHT_MANAGE`, `ZF2_UI_BOOKING_MANAGE`, `ZF2_API_FLIGHT_BOOKING`.

### UI, securite et tests

- Metadata extensions Fiori Elements dans `src/btp_rap/metadata`.
- DCL/IAM dans `src/btp_rap/auth`.
- Classes ABAP Cloud et behavior pools dans `src/btp_rap/classes`.
- Tests ABAP Unit et plan de test dans `src/btp_rap/tests`.
