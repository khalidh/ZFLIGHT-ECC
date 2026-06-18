# Audit de migration ZFLIGHT-ECC2 vers SAP BTP

## Synthese executive

`ZFLIGHT-ECC2` est une application SAP ECC classique basee sur DDIC, SAP GUI, ALV, Function Modules, classes ABAP Objects, verrous explicites et transactions SE93. Le dossier contient deja une cible SAP BTP ABAP Environment orientee RAP/OData V4 dans `src/btp_rap`, avec tables persistantes, CDS, behavior definitions, services, metadata Fiori Elements, DCL/IAM, classes helper et plan de tests.

La migration est faisable, mais elle ne doit pas etre traitee comme un simple transport technique. Les objets de presentation SAP GUI, les Function Modules, les verrous ECC, les `COMMIT WORK`, les number ranges classiques et les controles d'autorisation doivent etre reconcus selon les contraintes ABAP Cloud, RAP, Fiori Elements et IAM.

Recommandation: adopter une migration progressive par domaines metier. Les lectures peuvent etre basculees rapidement via CDS/OData, tandis que les transactions d'ecriture doivent passer par des BO RAP avec validations, determinations, actions, locking, ETag, draft et tests EML.

## Perimetre audite

### Sources ECC

- Documentation fonctionnelle et technique dans `docs/`.
- Specifications DDIC dans `src/abap/ddic/ZFLIGHT_DDIC_SPEC.md`.
- Classes metier ECC dans `src/abap/classes/`.
- Function group `ZFG_FLIGHT`.
- Reports ALV.
- Module Pool `SAPMZFLIGHT`.
- Messages et autorisations.

### Cible BTP/RAP existante

- Tables persistantes ABAP Cloud dans `src/btp_rap/tables`.
- CDS interface/projection dans `src/btp_rap/cds`.
- Behavior definitions dans `src/btp_rap/behavior`.
- Services OData V4 dans `src/btp_rap/services`.
- Metadata Fiori Elements dans `src/btp_rap/metadata`.
- DCL/IAM dans `src/btp_rap/auth`.
- Classes helper et tests dans `src/btp_rap/classes` et `src/btp_rap/tests`.

## Etat actuel

| Domaine | Etat ECC | Etat BTP cible | Maturite |
|---|---|---|---|
| Modele de donnees | Tables Z* documentees, relations et index identifies | Tables `ZF2_*` generees | Bon socle, mapping a valider champ par champ |
| Logique metier | Classes ECC separees de la presentation | Helpers RAP initiaux | Reutilisation partielle possible, adaptation ABAP Cloud requise |
| UI | SAP GUI, Dynpro, ALV | Fiori Elements via projections et metadata | Refonte necessaire |
| API | Function Modules proceduraux | OData V4 UI/API | Refonte contractuelle necessaire |
| Verrous | Lock objects `EZSFLIGHT`, `EZSBOOK` | RAP lock master, ETag, draft | Strategie cible amorcee |
| Transactions | SE93, reports et module pool | Services et apps Fiori Launchpad | Remplacement fonctionnel a planifier |
| Securite | Objet `Z_FLIGHT` et `AUTHORITY-CHECK` | DCL/IAM cible | Redesign obligatoire |
| Tests | Guide manuel ECC | Plan EML/OData et test pricing | Couverture a completer |

## Cartographie de migration

| Objet ECC | Cible SAP BTP | Strategie recommandee |
|---|---|---|
| `ZSCARR`, `ZSPFLI`, `ZSFLIGHT` | `ZF2_CARRIER`, `ZF2_CONNECTION`, `ZF2_FLIGHT` | Migrer vers tables ABAP Cloud et CDS interface/projection |
| `ZSCUSTOM`, `ZSBOOK` | `ZF2_CUSTOMER`, `ZF2_BOOKING` | Creer BO RAP `Customer` et `Booking` avec validations |
| `ZSORDER`, `ZSORDER_ITEM` | `ZF2_ORDER`, `ZF2_ORDER_ITEM` | Modeliser en composition RAP depuis booking/order |
| `ZSINVOICE`, `ZSPAYMENT` | `ZF2_INVOICE`, `ZF2_PAYMENT` | Actions RAP pour facture et paiement |
| `ZSSTATUS_HIST` | `ZF2_STATUS_HIST` | Determination/action de journalisation centralisee |
| Search Helps DDIC | Value Help CDS | Reprendre les aides principales: compagnie, connexion, vol, client |
| ALV reports | Fiori Elements List Reports | Remplacer les variantes ALV par filtres, facets, annotations UI |
| Module Pool `SAPMZFLIGHT` | Fiori Elements Object Pages | Reconcevoir les ecrans comme objets metier navigables |
| Function Modules `ZFG_FLIGHT` | Actions RAP et OData V4 | Publier API stable via service definition et communication arrangement |
| Lock objects | RAP locking, ETag, draft | Remplacer le verrou explicite par verrouillage transactionnel RAP |
| `AUTHORITY-CHECK` | IAM, DCL, instance authorization | Separar les droits UI, API et instance |

## Analyse des ecarts

### 1. Compatibilite ABAP Cloud

Constat: les sources ECC utilisent des objets et patterns classiques: Function Modules, `NUMBER_GET_NEXT`, lock objects, ALV, Dynpro, `COMMIT WORK`, `AUTHORITY-CHECK`, `REUSE_ALV_GRID_DISPLAY` et acces SQL direct.

Impact: ces elements ne sont pas directement compatibles avec une application RAP propre en ABAP Cloud. La logique metier doit etre isolee dans des classes compatibles et appelee par behavior pools, validations, determinations et actions.

Actions:

- Extraire les regles metier pures des classes ECC.
- Supprimer toute dependance SAP GUI, FM classique et `COMMIT WORK` des composants reutilisables.
- Remplacer le numbering par early/late numbering RAP ou un service de numerotation compatible.
- Convertir les exceptions et messages en `reported`/`failed` RAP.

### 2. Modele de donnees et persistance

Constat: le modele ECC est bien documente et la cible `ZF2_*` existe. Le risque principal se situe dans la correspondance exacte des cles, statuts, devises, quantites, timestamps, champs d'audit et associations.

Impact: un ecart de type, de cle ou de statut peut casser les associations CDS, les value helps, les actions RAP et les reprises de donnees.

Actions:

- Produire une matrice champ a champ ECC vers BTP.
- Confirmer les cles techniques et fonctionnelles.
- Ajouter les champs d'audit cloud: created/changed by, timestamps, local last changed.
- Verifier les associations obligatoires: carrier, connection, flight, customer, booking, order, invoice, payment.
- Definir la strategie client/tenant, car `MANDT` ECC n'est pas le modele cible applicatif dans BTP.

### 3. Logique transactionnelle

Constat: la logique ECC met a jour directement les tables, controle les verrous et laisse parfois le commit au Function Group ou au Dynpro. RAP impose une unite transactionnelle geree par le framework.

Impact: si les commits, updates directs ou verrous explicites sont repris tels quels, les actions RAP risquent de contourner le cycle `modify/save`, les drafts, les messages et les validations.

Actions:

- Reprendre les actions metier dans les behavior pools: `confirmBooking`, `cancelBooking`, `createOrder`, creation facture, paiement.
- Implementer les validations sur save: capacite vol, client actif, statut compatible, montant valide.
- Implementer les determinations: calcul prix, taxes, statut initial, historique de statut.
- Couvrir chaque transition par tests EML.

### 4. Interface utilisateur

Constat: la presentation ECC repose sur ALV et Dynpro. La cible BTP repose sur Fiori Elements, CDS annotations et Object Pages.

Impact: les ecrans ne sont pas migrables a l'identique. Les usages doivent etre reconstruits autour de listes, pages objet, facets, actions et navigations.

Actions:

- Mapper chaque report ALV vers une List Report.
- Mapper `SAPMZFLIGHT` vers une ou plusieurs Object Pages.
- Definir les filtres obligatoires, variantes, colonnes KPI et actions en barre d'outil.
- Verifier les metadata extensions `ZF2_C_*_UI`.

### 5. API et integrations

Constat: l'API ECC est une facade Function Modules. La cible propose `ZF2_API_FLIGHT_BOOKING` en OData V4 Web API.

Impact: les consommateurs RFC ou legacy ne peuvent pas etre bascules sans contrat API explicite. Les erreurs, statuts HTTP, payloads et autorisations changent.

Actions:

- Stabiliser un contrat API OData V4: entites exposees, actions, payloads, erreurs.
- Documenter les differences par rapport aux FM.
- Prevoir une periode de coexistence ECC/BTP si des consommateurs RFC existent.
- Creer des tests smoke OData pour lecture, creation reservation, confirmation, annulation et paiement.

### 6. Securite

Constat: ECC utilise `Z_FLIGHT` avec `ACTVT`. BTP doit utiliser IAM, catalogues, roles business, DCL et eventuellement instance authorization RAP.

Impact: les anciens roles ne sont pas transportables tels quels. Les controles doivent etre repenses par app, service, operation et instance.

Actions:

- Definir les personas: agent reservation, manager, finance, integration API, lecture seule.
- Mapper `ACTVT` vers privileges IAM et authorizations RAP.
- Ajouter des DCL restrictifs sur les CDS exposes.
- Tester explicitement les acces read/create/update/action par role.

### 7. Donnees et migration

Constat: les donnees demo ECC couvrent compagnies, connexions, vols, clients et reservations. La cible inclut un generateur demo, mais l'audit ne trouve pas encore de procedure de reprise productive.

Impact: la migration ne peut pas etre validee sans strategie d'extraction, transformation, chargement et reconciliation.

Actions:

- Definir l'ordre de chargement: referentiels, vols, clients, reservations, commandes, factures, paiements, historique.
- Prevoir des conversions de cles, statuts, devises et quantites.
- Creer controles de reconciliation: volumes, montants, statuts, capacite occupee, liens commande/facture/paiement.
- Prevoir un mode delta ou un gel applicatif selon la fenetre de migration.

## Risques principaux

| Risque | Probabilite | Impact | Mitigation |
|---|---:|---:|---|
| Reprise directe de logique ECC non compatible ABAP Cloud | Elevee | Eleve | Refactoriser en helpers cloud-ready et behavior pools |
| Perte de controle transactionnel avec commits/verrous ECC | Moyenne | Eleve | Utiliser cycle RAP, validations, determinations, lock/ETag |
| Sous-estimation de la refonte UI SAP GUI vers Fiori | Elevee | Moyen | Prototyper rapidement les List Reports/Object Pages |
| Incoherence des statuts apres migration | Moyenne | Eleve | Centraliser transitions et tests EML |
| Autorisations trop larges en BTP | Moyenne | Eleve | IAM par persona, DCL, tests negatifs |
| Contrat API incomplet pour integrations legacy | Moyenne | Moyen | Documenter OData, tests smoke et coexistence |
| Reprise de donnees sans reconciliation | Moyenne | Eleve | Scripts de controle et rapport de reconciliation |

## Backlog priorise

### P0 - Fondations

- Valider la matrice champ a champ ECC vers `ZF2_*`.
- Activer les tables, CDS interface/projection et DCL en environnement BTP.
- Corriger les artifacts incomplets: draft tables, behavior pools vides, classes helper minimales.
- Definir personas IAM et catalogues.

### P1 - BO metier critiques

- Finaliser BO `Booking`: creation, validation capacite, pricing, confirmation, annulation.
- Finaliser BO `Order`: creation depuis reservation, postes, statuts.
- Finaliser BO `Invoice`: creation facture, paiement, cloture.
- Implementer journalisation `ZF2_STATUS_HIST`.

### P2 - UI et API

- Publier `ZF2_UI_FLIGHT_MANAGE` et `ZF2_UI_BOOKING_MANAGE` en OData V4 UI.
- Publier `ZF2_API_FLIGHT_BOOKING` en OData V4 Web API.
- Remplacer les ALV par List Reports.
- Remplacer le module pool par Object Pages et actions RAP.

### P3 - Migration et exploitation

- Construire la procedure de chargement initial.
- Ajouter controles de reconciliation.
- Definir monitoring, logs applicatifs et support.
- Decommissionner progressivement les transactions ECC.

## Roadmap recommandee

| Phase | Objectif | Livrables | Critere de sortie |
|---|---|---|---|
| 0. Cadrage | Confirmer perimetre et architecture cible | Matrice objets, personas, contraintes BTP | Go/No-Go migration valide |
| 1. Read-only | Exposer referentiels et listes | Tables, CDS, List Reports read-only | Donnees consultables en Fiori |
| 2. Booking | Migrer reservation | BO `Booking`, actions, validations, tests | Creation/confirmation/annulation OK |
| 3. SD simplifie | Migrer commande, facture, paiement | BO `Order`, `Invoice`, `Payment` | Flux bout en bout OK |
| 4. API | Publier integration | `ZF2_API_FLIGHT_BOOKING`, contrats, smoke tests | Consommateurs pilotes valides |
| 5. Migration donnees | Charger et reconcilier | Procedure ETL, rapport reconciliation | Ecarts controles et acceptes |
| 6. Cutover | Basculer usages | Plan cutover, roles, support | ECC en lecture seule ou decommissionne |

## Criteres d'acceptation cible

- Toutes les entites principales sont exposees via CDS et services OData V4 actives.
- Les flux reservation, commande, facture et paiement fonctionnent en RAP sans `COMMIT WORK` applicatif.
- Les actions RAP retournent des messages metier coherents via `reported`/`failed`.
- Les autorisations IAM/DCL couvrent les personas et bloquent les acces non prevus.
- Les tests EML couvrent les transitions de statut et les erreurs principales.
- Les tests OData couvrent les services UI et API.
- La reprise de donnees produit un rapport de reconciliation accepte.
- Les transactions SAP GUI remplacees ont une alternative Fiori ou API documentee.

## Decision d'architecture

La cible recommandee est une reimplementation RAP selective, pas une conversion 1:1. Les objets ECC doivent servir de reference fonctionnelle et de source de regles metier, tandis que l'execution cible doit respecter les standards SAP BTP:

- ABAP Cloud pour le code applicatif.
- RAP pour les transactions.
- CDS pour le modele expose.
- Fiori Elements pour l'interface.
- IAM/DCL pour la securite.
- OData V4 pour les APIs.

Le projet est au bon niveau de preparation pour lancer un prototype BTP. Le prochain jalon utile est l'activation d'un flux vertical complet: lecture vols, creation reservation, confirmation, creation commande, facture et paiement, avec tests EML et smoke tests OData.
