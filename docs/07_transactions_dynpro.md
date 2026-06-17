# Transactions et Dynpro

## Transactions SE93

| Transaction | Type | Objet | Description |
|---|---|---|---|
| ZFLIGHT | Programme module pool | `SAPMZFLIGHT`, screen `0100` | Cockpit SAP GUI |
| ZFLIGHT_ALV | Report | `ZFLIGHT_ALV_FLIGHTS` | Liste vols |
| ZBOOKING | Report | `ZFLIGHT_ALV_BOOKINGS` | Liste reservations |
| ZCUSTOMER | Report | `ZFLIGHT_ALV_CUSTOMERS` | Liste clients |
| ZORDER_ALV | Report | `ZORDER_ALV` | Commandes |
| ZINVOICE_ALV | Report | `ZINVOICE_ALV` | Factures |
| ZPAYMENT_ALV | Report | `ZPAYMENT_ALV` | Paiements |

## Ecrans SE51

### 0100 Menu principal

Elements:

- Bouton `FLIGHTS`: vols.
- Bouton `BOOKINGS`: reservations.
- Bouton `CUSTOMERS`: clients.
- Boutons standard `BACK`, `EXIT`, `CANC`.

Flow logic:

```abap
PROCESS BEFORE OUTPUT.
  MODULE status_0100.

PROCESS AFTER INPUT.
  MODULE user_command_0100.
```

### 0200 Liste des vols

MVP: bouton `ALV` qui lance `ZFLIGHT_ALV_FLIGHTS`.

Flow logic:

```abap
PROCESS AFTER INPUT.
  MODULE user_command_0200.
```

### 0300 Detail vol

Ecran reserve pour afficher `ZSFLIGHT` et actions de reservation.

### 0400 Reservations

Elements:

- Champ `GV_BOOKID`.
- Bouton `ALV`.
- Bouton `CANCEL`.

Flow logic:

```abap
PROCESS AFTER INPUT.
  MODULE user_command_0400.
```

### 0500 Clients

MVP: bouton `ALV` qui lance `ZFLIGHT_ALV_CUSTOMERS`.

Flow logic:

```abap
PROCESS AFTER INPUT.
  MODULE user_command_0500.
```

