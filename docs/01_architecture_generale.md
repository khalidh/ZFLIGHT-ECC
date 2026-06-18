# Architecture generale

## Objectif

`ZFLIGHT-ECC2` est une application SAP GUI ECC classique de reservation aerienne. Elle couvre la gestion des compagnies, connexions, vols, clients, reservations, commandes simplifiees, factures, paiements, tarification et historique de statuts.

L'application est concue comme un developpement ECC pre-RAP: aucun CDS, RAP, OData, Fiori, BTP, ABAP Cloud ou AMDP.

## Couches

### Presentation SAP GUI

- Module Pool `SAPMZFLIGHT`, transaction `ZFLIGHT`.
- Reports ALV classiques:
  - `ZFLIGHT_ALV_FLIGHTS`
  - `ZFLIGHT_ALV_BOOKINGS`
  - `ZFLIGHT_ALV_CUSTOMERS`
  - `ZORDER_ALV`
  - `ZINVOICE_ALV`
  - `ZPAYMENT_ALV`
- ALV via `CL_GUI_ALV_GRID` quand un container SAP GUI est disponible.
- Variante WebGUI possible avec `REUSE_ALV_GRID_DISPLAY`.

### Services metier

Classes globales ABAP Objects:

- `ZCL_FLIGHT_SERVICE`: validation et acces vols.
- `ZCL_BOOKING_SERVICE`: creation, annulation, capacite, montant reservation.
- `ZCL_CUSTOMER_SERVICE`: clients.
- `ZCL_ORDER_SERVICE`: creation commande depuis reservation.
- `ZCL_PRICING_SERVICE`: moteur tarifaire simplifie SD.
- `ZCL_INVOICE_SERVICE`: creation facture.
- `ZCL_PAYMENT_SERVICE`: encaissement et cloture.

### API ECC classique

Function group `ZFG_FLIGHT`:

- `Z_FLIGHT_CREATE`
- `Z_FLIGHT_CHANGE`
- `Z_FLIGHT_DELETE`
- `Z_FLIGHT_GET`
- `Z_BOOKING_CREATE`
- `Z_BOOKING_CANCEL`
- `Z_BOOKING_GET`

Les function modules servent de facade procedural ECC pour reports, dynpro, RFC futur ou integration legacy.

### Persistance DDIC

Tables principales:

- `ZSCARR`: compagnies.
- `ZSPFLI`: connexions.
- `ZSFLIGHT`: vols.
- `ZSCUSTOM`: clients.
- `ZSBOOK`: reservations.

Extension SD:

- `ZSADDR`: adresses.
- `ZSORDER`: commandes.
- `ZSORDER_ITEM`: postes commande.
- `ZSINVOICE`: factures.
- `ZSINVOICE_ITEM`: postes facture.
- `ZSPRICING`: conditions tarifaires.
- `ZSPAYMENT`: paiements.
- `ZSSTATUS_HIST`: historique de statuts.

## Flux metier principal

1. Creation client ou selection client existant.
2. Recherche multicriteres des vols disponibles.
3. Creation reservation `NEW`.
4. Controle capacite et calcul montant.
5. Confirmation reservation `CONFIRMED`.
6. Creation commande `OPEN` puis `RELEASED`.
7. Creation facture `OPEN`.
8. Paiement facture `PAID`.
9. Cloture commande `CLOSED` et dossier.

Chaque changement de statut ecrit `ZSSTATUS_HIST`.

## Verrous et concurrence

- `EZSFLIGHT`: verrou sur vol avant creation ou annulation de reservation.
- `EZSBOOK`: verrou sur reservation avant modification.
- Les updates de capacite et les changements de statut sont effectues dans une unite logique avec `COMMIT WORK` controle par l'appelant.

## Autorisations

Objet `Z_FLIGHT` avec champ `ACTVT`:

- `01`: Create.
- `02`: Change.
- `03`: Display.
- `06`: Delete.

Tous les services publics appellent `AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD ...`.

## Messages

Classe `ZFLIGHT_MSG`:

- Messages fonctionnels pour validation, capacite, verrous, autorisations et erreurs techniques.
- Les services ABAP OO propagent aussi des exceptions OO.

## Integrations futures

Points d'extension prevus:

- IDoc pour reservation/commande.
- BAPI wrapper autour du function group.
- SOAP via enterprise service ECC.
- REST via ICF handler si necessaire.
- Import/export CSV via reports batch.
