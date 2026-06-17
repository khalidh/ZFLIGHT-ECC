# Modele de donnees detaille

## Relations principales

```text
ZSCARR 1---n ZSPFLI 1---n ZSFLIGHT 1---n ZSBOOK n---1 ZSCUSTOM
                         |
                         +---n ZSORDER 1---n ZSORDER_ITEM
                                      |
                                      +---n ZSINVOICE 1---n ZSINVOICE_ITEM
                                                   |
                                                   +---n ZSPAYMENT

ZSBOOK / ZSORDER / ZSINVOICE / ZSPAYMENT 1---n ZSSTATUS_HIST
ZSCUSTOM 1---n ZSADDR
ZSORDER_ITEM 1---n ZSPRICING
```

## Tables principales

### ZSCARR - Compagnies

Cle: `MANDT`, `CARRID`.

Champs:

- `CARRID`: code compagnie, type `ZFL_CARRID`.
- `CARRNAME`: nom compagnie.
- `CURRCODE`: devise.
- `URL`: site web.
- `ERDAT`, `ERNAM`, `AEDAT`, `AENAM`.

### ZSPFLI - Connexions

Cle: `MANDT`, `CARRID`, `CONNID`.

Champs:

- `COUNTRYFR`, `CITYFROM`, `AIRPFROM`.
- `COUNTRYTO`, `CITYTO`, `AIRPTO`.
- `FLTIME`, `DEPTIME`, `ARRTIME`, `DISTANCE`, `DISTID`.

### ZSFLIGHT - Vols

Cle: `MANDT`, `CARRID`, `CONNID`, `FLDATE`.

Champs:

- `PRICE`, `CURRENCY`.
- `PLANETYPE`.
- `SEATSMAX`, `SEATSOCC`.
- `STATUS`: `OPEN`, `CLOSED`, `CANCELLED`, `FLOWN`.

### ZSCUSTOM - Clients

Cle: `MANDT`, `CUSTOMID`.

Champs:

- `NAME_FIRST`, `NAME_LAST`, `EMAIL`, `PHONE`.
- `COUNTRY`, `LANGU`, `VIP_FLAG`.
- Audit fields.

### ZSBOOK - Reservations

Cle: `MANDT`, `BOOKID`.

Index unique conseille: `CARRID`, `CONNID`, `FLDATE`, `CUSTOMID`, `BOOKDATE`.

Champs:

- `CUSTOMID`, `CARRID`, `CONNID`, `FLDATE`.
- `BOOKDATE`, `STATUS`.
- `SEAT_CLASS`: `ECO`, `BUS`, `FST`.
- `BASE_AMOUNT`, `TAX_AMOUNT`, `TOTAL_AMOUNT`, `CURRENCY`.
- `CANCEL_REASON`.

## Extension SD simplifiee

### ZSORDER

Entete commande liee a une reservation.

Cle: `MANDT`, `ORDERID`.

Champs importants: `BOOKID`, `CUSTOMID`, `DOC_DATE`, `STATUS`, `NET_AMOUNT`, `TAX_AMOUNT`, `GROSS_AMOUNT`, `CURRENCY`.

### ZSORDER_ITEM

Postes commande.

Cle: `MANDT`, `ORDERID`, `ITEMNO`.

Champs importants: `MATERIAL`, `DESCRIPTION`, `QTY`, `UOM`, `NET_PRICE`, `NET_VALUE`, `TAX_VALUE`, `GROSS_VALUE`.

### ZSINVOICE / ZSINVOICE_ITEM

Facturation de commande.

Statuts facture: `OPEN`, `PAID`, `CANCELLED`.

### ZSPRICING

Conditions tarifaires:

- `PR00`: prix de base.
- `DISC`: remise.
- `TAXE`: taxe.
- `FUEL`: surcharge carburant.

### ZSPAYMENT

Paiements avec mode, reference externe, montant et statut.

### ZSSTATUS_HIST

Historique generique:

- `OBJECT_TYPE`: `BOOKING`, `ORDER`, `INVOICE`, `PAYMENT`.
- `OBJECT_ID`.
- `OLD_STATUS`, `NEW_STATUS`.
- `CHANGED_AT`, `CHANGED_BY`, `REASON`.

## Index utiles

- `ZSFLIGHT~Z01`: `CARRID`, `CONNID`, `FLDATE`, `STATUS`.
- `ZSFLIGHT~Z02`: `FLDATE`, `STATUS`.
- `ZSBOOK~Z01`: `CUSTOMID`, `BOOKDATE`.
- `ZSBOOK~Z02`: `CARRID`, `CONNID`, `FLDATE`, `STATUS`.
- `ZSORDER~Z01`: `BOOKID`.
- `ZSINVOICE~Z01`: `ORDERID`, `STATUS`.
- `ZSPAYMENT~Z01`: `INVOICEID`, `STATUS`.
- `ZSSTATUS_HIST~Z01`: `OBJECT_TYPE`, `OBJECT_ID`, `CHANGED_AT`.

