# Description des objets SAP

## Package

- Package recommande: `ZFLIGHT-ECC2`.
- Transportable, couche logicielle locale client.

## Inventaire des sources generees

| Type | Objet SAP | Source | Role |
|---|---|---|---|
| Documentation | `README` | `README.md` | Point d'entree du livrable |
| Documentation | Architecture | `docs/01_architecture_generale.md` | Couches, principes ECC, flux applicatifs |
| Documentation | Modele de donnees | `docs/02_modele_donnees.md` | Entites, relations et extension SD |
| Documentation | Objets SAP | `docs/03_objets_sap.md` | Inventaire technique des objets |
| Documentation | Installation | `docs/04_installation_ecc.md` | Guide de creation dans ECC/ADT |
| Documentation | Tests | `docs/05_guide_tests.md` | Tests fonctionnels et techniques |
| Documentation | Migration RAP | `docs/06_migration_btp_rap.md` | Cartographie ECC vers BTP/RAP |
| Documentation | Transactions/Dynpro | `docs/07_transactions_dynpro.md` | Transactions SE93 et ecrans SE51 |
| Documentation | Livrable par etape | `docs/08_livrable_etapes.md` | Couverture des 10 etapes demandees |
| DDIC | Specification DDIC | `src/abap/ddic/ZFLIGHT_DDIC_SPEC.md` | Tables, domaines, data elements, search helps |
| Message class | `ZFLIGHT_MSG` | `src/abap/messages/ZFLIGHT_MSG.txt` | Messages applicatifs |
| Autorisation | `Z_FLIGHT` | `src/abap/security/Z_FLIGHT_AUTH.md` | Objet et controles `AUTHORITY-CHECK` |
| Exception class | `ZCX_FLIGHT_ERROR` | `src/abap/classes/zcx_flight_error.abap` | Exception OO commune |
| Classe metier | `ZCL_FLIGHT_SERVICE` | `src/abap/classes/zcl_flight_service.abap` | Recherche, validation et capacite des vols |
| Classe metier | `ZCL_BOOKING_SERVICE` | `src/abap/classes/zcl_booking_service.abap` | Creation et annulation de reservations |
| Classe metier | `ZCL_CUSTOMER_SERVICE` | `src/abap/classes/zcl_customer_service.abap` | Lecture et controle client |
| Classe metier | `ZCL_PRICING_SERVICE` | `src/abap/classes/zcl_pricing_service.abap` | Conditions PR00, DISC, TAXE, FUEL |
| Classe metier | `ZCL_ORDER_SERVICE` | `src/abap/classes/zcl_order_service.abap` | Commandes extension SD |
| Classe metier | `ZCL_INVOICE_SERVICE` | `src/abap/classes/zcl_invoice_service.abap` | Facturation extension SD |
| Classe metier | `ZCL_PAYMENT_SERVICE` | `src/abap/classes/zcl_payment_service.abap` | Paiements extension SD |
| Function group | `ZFG_FLIGHT` | `src/abap/function_groups/zfg_flight.abap` | Facade RFC/FM pour vols et reservations |
| Module pool | `SAPMZFLIGHT` | `src/abap/module_pool/sapmzflight.abap` | Cockpit SAP GUI Dynpro |
| Report ALV | `ZFLIGHT_ALV_FLIGHTS` | `src/abap/reports/zflight_alv_flights.abap` | Liste ALV des vols |
| Report ALV | `ZFLIGHT_ALV_BOOKINGS` | `src/abap/reports/zflight_alv_bookings.abap` | Liste ALV des reservations |
| Report ALV | `ZFLIGHT_ALV_CUSTOMERS` | `src/abap/reports/zflight_alv_customers.abap` | Liste ALV des clients |
| Report demo | `ZFLIGHT_LOAD_DEMO_DATA` | `src/abap/reports/zflight_load_demo_data.abap` | Chargement des donnees de test |
| Report ALV | `ZORDER_ALV` | `src/abap/reports/zorder_alv.abap` | Liste ALV des commandes |
| Report ALV | `ZINVOICE_ALV` | `src/abap/reports/zinvoice_alv.abap` | Liste ALV des factures |
| Report ALV | `ZPAYMENT_ALV` | `src/abap/reports/zpayment_alv.abap` | Liste ALV des paiements |

## DDIC

Les definitions detaillees sont dans [ZFLIGHT_DDIC_SPEC.md](../src/abap/ddic/ZFLIGHT_DDIC_SPEC.md).

Objets:

- Domaines et data elements pour toutes les cles et statuts.
- Tables transparentes `ZSCARR`, `ZSPFLI`, `ZSFLIGHT`, `ZSCUSTOM`, `ZSBOOK`.
- Extension SD `ZSADDR`, `ZSORDER`, `ZSORDER_ITEM`, `ZSINVOICE`, `ZSINVOICE_ITEM`, `ZSPRICING`, `ZSPAYMENT`, `ZSSTATUS_HIST`.
- Search helps sur compagnies, connexions, vols, clients, reservations, commandes, factures.
- Foreign keys avec controle a l'ecran quand pertinent.

## Number ranges

- `ZBOOKID`: reservation, intervalle `01`, externe non autorise, de `0000000001` a `9999999999`.
- `ZCUSTID`: client, intervalle `01`, externe non autorise.
- `ZORDERID`, `ZINV_ID`, `ZPAY_ID`: extension SD.

## Lock objects

- `EZSFLIGHT`: table primaire `ZSFLIGHT`, arguments `MANDT`, `CARRID`, `CONNID`, `FLDATE`.
- `EZSBOOK`: table primaire `ZSBOOK`, arguments `MANDT`, `BOOKID`.

## Messages

Classe `ZFLIGHT_MSG`:

- `001`: Action & non autorisee pour Z_FLIGHT.
- `002`: Vol & & & introuvable.
- `003`: Reservation & introuvable.
- `004`: Client & introuvable.
- `005`: Capacite insuffisante pour le vol & & &.
- `006`: Statut & incompatible avec action &.
- `007`: Verrou impossible sur objet &.
- `008`: Montant invalide.
- `009`: Creation & effectuee.
- `010`: Annulation & effectuee.
- `011`: Erreur technique &: &.

## Transactions

- `ZFLIGHT`: module pool `SAPMZFLIGHT`, ecran 0100.
- `ZFLIGHT_ALV`: report `ZFLIGHT_ALV_FLIGHTS`.
- `ZBOOKING`: report `ZFLIGHT_ALV_BOOKINGS`.
- `ZCUSTOMER`: report `ZFLIGHT_ALV_CUSTOMERS`.
- `ZORDER_ALV`, `ZINVOICE_ALV`, `ZPAYMENT_ALV` si souhaite en SE93.

## Classes ABAP OO

- `ZCX_FLIGHT_ERROR`: exception applicative.
- `ZCL_FLIGHT_SERVICE`: service vols.
- `ZCL_BOOKING_SERVICE`: service reservations.
- `ZCL_CUSTOMER_SERVICE`: service clients.
- `ZCL_PRICING_SERVICE`: moteur tarifaire simplifie.
- `ZCL_ORDER_SERVICE`: commandes extension SD.
- `ZCL_INVOICE_SERVICE`: factures extension SD.
- `ZCL_PAYMENT_SERVICE`: paiements extension SD.

## Function group et function modules

Function group `ZFG_FLIGHT`:

- `Z_FLIGHT_CREATE`
- `Z_FLIGHT_CHANGE`
- `Z_FLIGHT_DELETE`
- `Z_FLIGHT_GET`
- `Z_BOOKING_CREATE`
- `Z_BOOKING_CANCEL`
- `Z_BOOKING_GET`

## Programmes et reports

- `ZFLIGHT_ALV_FLIGHTS`: ALV vols.
- `ZFLIGHT_ALV_BOOKINGS`: ALV reservations.
- `ZFLIGHT_ALV_CUSTOMERS`: ALV clients.
- `ZFLIGHT_LOAD_DEMO_DATA`: donnees de demonstration.
- `ZORDER_ALV`: ALV commandes.
- `ZINVOICE_ALV`: ALV factures.
- `ZPAYMENT_ALV`: ALV paiements.
