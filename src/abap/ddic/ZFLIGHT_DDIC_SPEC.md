# Specification DDIC ZFLIGHT_ECC

## Domaines

| Domaine | Type | Longueur | Valeurs |
|---|---:|---:|---|
| ZFL_CARRID | CHAR | 3 | Code compagnie |
| ZFL_CONNID | NUMC | 4 | Connexion |
| ZFL_BOOKID | NUMC | 10 | Reservation |
| ZFL_CUSTOMID | NUMC | 10 | Client |
| ZFL_ORDERID | NUMC | 10 | Commande |
| ZFL_INVOICEID | NUMC | 10 | Facture |
| ZFL_PAYMENTID | NUMC | 10 | Paiement |
| ZFL_STATUS_BOOK | CHAR | 10 | NEW, CONFIRMED, CANCELLED, FLOWN |
| ZFL_STATUS_ORDER | CHAR | 10 | OPEN, RELEASED, INVOICED, CLOSED |
| ZFL_STATUS_INV | CHAR | 10 | OPEN, PAID, CANCELLED |
| ZFL_SEAT_CLASS | CHAR | 3 | ECO, BUS, FST |
| ZFL_COND_TYPE | CHAR | 4 | PR00, DISC, TAXE, FUEL |
| ZFL_AMOUNT | CURR | 15,2 | Montants |
| ZFL_QUANTITY | QUAN | 13,3 | Quantites |

## Data elements

Creer un data element par domaine avec libelles courts/moyens/longs, par exemple:

- `ZDE_CARRID`: Compagnie.
- `ZDE_CONNID`: Connexion.
- `ZDE_BOOKID`: Reservation.
- `ZDE_CUSTOMID`: Client.
- `ZDE_BOOK_STATUS`: Statut reservation.
- `ZDE_TOTAL_AMOUNT`: Montant total.

## Tables et champs

### ZSCARR

```text
MANDT       MANDT          key
CARRID      ZDE_CARRID     key
CARRNAME    CHAR40
CURRCODE    WAERS
URL         CHAR255
ERDAT       ERDAT
ERNAM       ERNAM
AEDAT       AEDAT
AENAM       AENAM
```

### ZSPFLI

```text
MANDT       MANDT          key
CARRID      ZDE_CARRID     key FK ZSCARR
CONNID      ZDE_CONNID     key
COUNTRYFR   LAND1
CITYFROM    CHAR40
AIRPFROM    CHAR3
COUNTRYTO   LAND1
CITYTO      CHAR40
AIRPTO      CHAR3
FLTIME      INT4
DEPTIME     TIMS
ARRTIME     TIMS
DISTANCE    DEC 9,2
DISTID      UNIT
```

### ZSFLIGHT

```text
MANDT       MANDT          key
CARRID      ZDE_CARRID     key FK ZSPFLI
CONNID      ZDE_CONNID     key FK ZSPFLI
FLDATE      DATS           key
PRICE       ZDE_AMOUNT
CURRENCY    WAERS
PLANETYPE   CHAR10
SEATSMAX    INT4
SEATSOCC    INT4
STATUS      CHAR10
ERDAT       ERDAT
ERNAM       ERNAM
AEDAT       AEDAT
AENAM       AENAM
```

### ZSCUSTOM

```text
MANDT       MANDT          key
CUSTOMID    ZDE_CUSTOMID   key
NAME_FIRST  CHAR40
NAME_LAST   CHAR40
EMAIL       AD_SMTPADR
PHONE       CHAR30
COUNTRY     LAND1
LANGU       SPRAS
VIP_FLAG    XFELD
ERDAT       ERDAT
ERNAM       ERNAM
AEDAT       AEDAT
AENAM       AENAM
```

### ZSBOOK

```text
MANDT          MANDT        key
BOOKID         ZDE_BOOKID   key
CUSTOMID       ZDE_CUSTOMID FK ZSCUSTOM
CARRID         ZDE_CARRID
CONNID         ZDE_CONNID
FLDATE         DATS
BOOKDATE       DATS
STATUS         ZDE_BOOK_STATUS
SEAT_CLASS     ZDE_SEAT_CLASS
BASE_AMOUNT    ZDE_AMOUNT
TAX_AMOUNT     ZDE_AMOUNT
TOTAL_AMOUNT   ZDE_AMOUNT
CURRENCY       WAERS
CANCEL_REASON  CHAR80
ERDAT          ERDAT
ERNAM          ERNAM
AEDAT          AEDAT
AENAM          AENAM
```

### Extension SD

Les tables `ZSORDER`, `ZSORDER_ITEM`, `ZSINVOICE`, `ZSINVOICE_ITEM`, `ZSPRICING`, `ZSPAYMENT`, `ZSSTATUS_HIST` reprennent les cles et champs documentes dans `docs/02_modele_donnees.md`.

## Search helps

- `ZSH_CARRID`: `ZSCARR-CARRID`, `CARRNAME`.
- `ZSH_CONNID`: `ZSPFLI-CARRID`, `CONNID`, villes.
- `ZSH_FLIGHT`: `ZSFLIGHT-CARRID`, `CONNID`, `FLDATE`, statut.
- `ZSH_CUSTOM`: `ZSCUSTOM-CUSTOMID`, nom, email.
- `ZSH_BOOK`: `ZSBOOK-BOOKID`, client, vol, statut.
- `ZSH_ORDER`: `ZSORDER-ORDERID`, client, statut.
- `ZSH_INVOICE`: `ZSINVOICE-INVOICEID`, commande, statut.

