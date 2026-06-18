# ZFLIGHT_ECC

Application pedagogique SAP ECC classique pour gerer un mini systeme de reservation aerienne avec extension SD simplifiee.

Le livrable est volontairement oriente ECC 6.0 / NetWeaver AS ABAP classique: DDIC, Function Modules, ABAP Objects, ALV Grid, Module Pool, messages, autorisations, verrous et transactions SAP GUI.

## Contenu

- [docs/01_architecture_generale.md](docs/01_architecture_generale.md)
- [docs/02_modele_donnees.md](docs/02_modele_donnees.md)
- [docs/03_objets_sap.md](docs/03_objets_sap.md)
- [docs/04_installation_ecc.md](docs/04_installation_ecc.md)
- [docs/05_guide_tests.md](docs/05_guide_tests.md)
- [docs/06_migration_btp_rap.md](docs/06_migration_btp_rap.md)
- [docs/07_transactions_dynpro.md](docs/07_transactions_dynpro.md)
- [docs/08_livrable_etapes.md](docs/08_livrable_etapes.md)
- [docs/09_audit_migration_btp.md](docs/09_audit_migration_btp.md)
- [src/abap/ddic/ZFLIGHT_DDIC_SPEC.md](src/abap/ddic/ZFLIGHT_DDIC_SPEC.md)
- [src/abap/classes/](src/abap/classes)
- [src/abap/function_groups/](src/abap/function_groups)
- [src/abap/reports/](src/abap/reports)
- [src/abap/module_pool/](src/abap/module_pool)
- [src/abap/security/](src/abap/security)
- [src/btp_rap/](src/btp_rap) - objets cibles SAP BTP RAP/OData V4

## Ordre de creation recommande

1. DDIC: domaines, data elements, tables, cles et index.
2. Objets techniques: messages, number ranges, lock objects, autorisation.
3. Classes ABAP OO.
4. Function group `ZFG_FLIGHT`.
5. Reports ALV et programme de donnees demo.
6. Module pool `SAPMZFLIGHT` et transactions SE93.
7. Tests fonctionnels puis tests concurrence/verrous.

## Migration BTP RAP/OData

Les objets cibles RAP/OData sont generes dans [src/btp_rap/](src/btp_rap). Ils forment une pile separee de la version ECC: tables persistantes ABAP Cloud, CDS interface/projection, behavior definitions, services OData V4, metadata extensions, DCL/IAM, classes helper et tests.
