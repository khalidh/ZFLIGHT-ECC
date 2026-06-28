# Guide d'installation ECC

## Prerequis

- SAP ECC 6.0 ou NetWeaver AS ABAP classique.
- Acces SE11, SE80/SE24/SE37/SE38, SE91, SU21, SNRO, SE93.
- Droits de developpement et transport.

## Etapes

1. Creer le package `ZFLIGHT-ECC3`.
2. Creer la classe de messages `ZFLIGHT_MSG` dans SE91.
3. Creer les domaines et data elements selon [ZFLIGHT_DDIC_SPEC.md](../src/abap/ddic/ZFLIGHT_DDIC_SPEC.md).
4. Creer les tables transparentes, cles et foreign keys.
5. Generer les search helps et index secondaires.
6. Creer les objets SNRO: `ZBOOKID`, `ZCUSTID`, `ZORDERID`, `ZINV_ID`, `ZPAY_ID`.
7. Creer les lock objects `EZSFLIGHT`, `EZSBOOK`, puis generer les modules `ENQUEUE_*` et `DEQUEUE_*`.
8. Creer l'objet d'autorisation `Z_FLIGHT` dans SU21 et l'affecter aux roles via PFCG.
9. Creer les classes globales dans SE24 ou ADT en reprenant les sources `src/abap/classes`.
10. Creer le function group `ZFG_FLIGHT` et ses function modules.
11. Creer les reports ALV et le programme `ZFLIGHT_LOAD_DEMO_DATA`.
12. Creer le module pool `SAPMZFLIGHT`, ses includes et ecrans.
13. Creer les transactions SE93.
14. Activer l'ensemble.
15. Charger les donnees demo.

## Execution

- Transaction principale: `ZFLIGHT`.
- Reporting vols: `ZFLIGHT_ALV`.
- Reporting reservations: `ZBOOKING`.
- Reporting clients: `ZCUSTOMER`.

## WebGUI

Activer SICF si necessaire:

```text
/sap/bc/gui/sap/its/webgui
```

Les ALV bases sur `REUSE_ALV_GRID_DISPLAY` ont moins de dependances frontend et sont plus predictibles sous WebGUI.
