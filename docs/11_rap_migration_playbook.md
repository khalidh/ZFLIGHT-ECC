# RAP Migration Playbook

Ce document capitalise les apprentissages faits pendant la stabilisation du projet ZFLIGHT-ECC en RAP. Il sert de checklist reutilisable pour les prochains objets ou projets similaires.

## Objectif

Pendant une migration RAP, l'objectif prioritaire est de stabiliser progressivement :

1. les objets CDS,
2. les behavior definitions,
3. les annotations Fiori,
4. les service definitions,
5. les service bindings,
6. puis seulement les actions metier.

Il faut eviter d'exposer trop tot des comportements ou actions dont les handlers ne sont pas encore implementes ou fiables.

## Ordre D'Activation Recommande

Activer les objets par couches, du plus bas niveau vers le plus haut niveau :

1. Tables de base, si elles viennent d'etre creees ou modifiees.
2. Data Definitions interface `ZF2_I_*`.
3. Data Definitions projection `ZF2_C_*`.
4. Behavior Definitions interface `ZF2_I_*`.
5. Behavior Definitions projection `ZF2_C_*`.
6. Metadata Extensions `ZF2_C_*_UI`.
7. Service Definitions `ZF2_UI_*` ou `ZF2_API_*`.
8. Service Bindings `*_O4`.

Si un service binding remonte une erreur vague, ouvrir l'objet cite dans `Problems`. Le wizard du binding ne montre souvent pas la vraie cause.

## Regles De Stabilisation

Pendant la phase de migration initiale, utiliser des behavior definitions volontairement simples.

### Authorization Master

Eviter temporairement :

```abap
authorization master ( instance )
```

si les handlers d'autorisation ne sont pas implementes dans la classe behavior pool.

Symptome typique :

```text
CX_RAP_HANDLER_NOT_IMPLEMENTED
ABAP Runtime error 'RAISE_SHORTDUMP'
```

Correction temporaire : retirer `authorization master ( instance )`.

### Strict Mode

Eviter temporairement :

```abap
strict ( 2 );
```

tant que les objets RAP ne sont pas completement propres.

Le strict mode est utile plus tard, mais pendant la stabilisation il peut bloquer pour des warnings ou exigences non critiques.

### Actions De Projection

Ne pas exposer les actions dans les projections `ZF2_C_*` tant que les handlers ne sont pas confirmes.

Exemple a eviter au debut :

```abap
projection;
define behavior for ZF2_C_Booking alias Booking
{
  use create;
  use update;
  use delete;
  use action confirm;
  use action cancel;
  use action createOrder;
}
```

Version de stabilisation :

```abap
projection;
define behavior for ZF2_C_Booking alias Booking
{
  use create;
  use update;
  use delete;
}
```

Les actions peuvent rester declarees dans les behaviors interface `ZF2_I_*`, mais ne doivent pas forcement etre exposees dans les projections UI tant qu'elles ne sont pas testees.

## Patterns Valides Dans Ce Projet

### Nommage Booking

Le projet utilise la convention `ZF2_*` pour les objets RAP. Ne pas conserver
d'anciens objets de tutoriel comme `ZI_Booking` ou `zfl_booking`.

Definition correcte de l'interface booking :

```abap
define root view entity ZF2_I_Booking
  as select from zf2_booking
```

Si ADT affiche une reference a `zfl_booking`, ouvrir l'objet concerne et le
remplacer par `ZF2_I_Booking` / `zf2_booking`, ou supprimer l'ancien objet s'il
n'est pas expose par les services `ZF2_*`.

### Projection Behavior Minimal

```abap
projection;
define behavior for ZF2_C_<Entity> alias <Alias>
{
  use create;
  use update;
  use delete;
}
```

### Interface Behavior Minimal

```abap
managed implementation in class zf2_bp_i_<entity> unique;
define behavior for ZF2_I_<Entity> alias <Alias>
persistent table zf2_<table>
lock master
etag master LastChangedAt
{
  create;
  update;
  delete;

  field ( readonly ) LastChangedAt;

  mapping for zf2_<table>
  {
    <Field> = <db_field>;
  }
}
```

Ajouter les determinations, validations et actions seulement si les methodes correspondantes sont implementees et testees.

### Metadata Extension Avec Detail Fiori

Si un facet utilise `#IDENTIFICATION_REFERENCE`, chaque champ a afficher en detail doit avoir `@UI.identification`.

Exemple :

```abap
@Metadata.layer: #CORE
annotate view ZF2_C_Booking with {
  @UI.facet: [
    { id: 'Booking', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Booking', position: 10 }
  ]
  @UI.identification: [{ position: 10 }]
  @UI.lineItem: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  BookingID;

  @UI.identification: [{ position: 20 }]
  @UI.lineItem: [{ position: 20 }]
  CustomerID;

  @UI.identification: [{ position: 30 }]
  @UI.lineItem: [{ position: 30 }]
  FlightDate;
}
```

Exemple applique a Order :

```abap
@Metadata.layer: #CORE
annotate view ZF2_C_Order with {
  @UI.facet: [
    { id: 'Order', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Order', position: 10 }
  ]
  @UI.identification: [{ position: 10, label: 'Order ID' }]
  @UI.lineItem: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  OrderID;

  @UI.identification: [{ position: 20, label: 'Booking ID' }]
  @UI.lineItem: [{ position: 20 }]
  BookingID;

  @UI.identification: [{ position: 30, label: 'Customer ID' }]
  @UI.lineItem: [{ position: 30 }]
  CustomerID;

  @UI.identification: [{ position: 40, label: 'Order Date' }]
  @UI.lineItem: [{ position: 40 }]
  OrderDate;

  @UI.identification: [{ position: 50, label: 'Order Status' }]
  @UI.lineItem: [{ position: 50 }]
  OrderStatus;

  @UI.identification: [{ position: 60, label: 'Net Amount' }]
  @UI.lineItem: [{ position: 60 }]
  NetAmount;

  @UI.identification: [{ position: 70, label: 'Tax Amount' }]
  @UI.lineItem: [{ position: 70 }]
  TaxAmount;

  @UI.identification: [{ position: 80, label: 'Gross Amount' }]
  @UI.lineItem: [{ position: 80 }]
  GrossAmount;

  @UI.identification: [{ position: 90, label: 'Currency' }]
  @UI.lineItem: [{ position: 90 }]
  CurrencyCode;
}
```

Exemple applique a Invoice :

```abap
@Metadata.layer: #CORE
annotate view ZF2_C_Invoice with {
  @UI.facet: [
    { id: 'Invoice', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Invoice', position: 10 }
  ]
  @UI.identification: [{ position: 10, label: 'Invoice ID' }]
  @UI.lineItem: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  InvoiceID;

  @UI.identification: [{ position: 20, label: 'Order ID' }]
  @UI.lineItem: [{ position: 20 }]
  OrderID;

  @UI.identification: [{ position: 30, label: 'Invoice Date' }]
  @UI.lineItem: [{ position: 30 }]
  InvoiceDate;

  @UI.identification: [{ position: 40, label: 'Invoice Status' }]
  @UI.lineItem: [{ position: 40 }]
  InvoiceStatus;

  @UI.identification: [{ position: 50, label: 'Total Amount' }]
  @UI.lineItem: [{ position: 50 }]
  TotalAmount;

  @UI.identification: [{ position: 60, label: 'Paid Amount' }]
  @UI.lineItem: [{ position: 60 }]
  PaidAmount;

  @UI.identification: [{ position: 70, label: 'Currency' }]
  @UI.lineItem: [{ position: 70 }]
  CurrencyCode;
}
```

Sans `@UI.identification`, le detail Fiori peut afficher :

```text
Unable to find annotationPath @com.sap.vocabularies.UI.v1.Identification
```

## Erreurs Connues Et Corrections

### `No data retrieved from ABAP dictionary for entity ...`

Cause probable :

- objet CDS absent,
- objet non active,
- service binding compile une ancienne version,
- dependance inactive.

Action :

1. Ouvrir l'objet cite.
2. Activer sa Data Definition.
3. Activer sa Behavior Definition si elle existe.
4. Revenir au service binding et rafraichir/publier.

### `Behavior definition ... has syntax errors`

Cause probable :

- erreur dans la BDEF de projection,
- erreur heritee de la BDEF interface,
- action exposee en projection mais handler non fiable,
- strict mode trop exigeant.

Action :

1. Ouvrir la BDEF citee directement.
2. Verifier l'onglet `Problems`.
3. Reduire temporairement la projection a `use create/update/delete`.
4. Reactiver la BDEF, puis la service definition, puis le binding.

### `CX_RAP_HANDLER_NOT_IMPLEMENTED`

Cause probable :

- handler RAP declare mais non implemente,
- authorization instance declaree sans implementation,
- action appelee ou exposee trop tot.

Action :

1. Retirer temporairement `authorization master ( instance )`.
2. Retirer les `use action ...` dans les projections.
3. Tester lecture/detail avant de remettre les actions.

### `Unable to find annotationPath ... Identification`

Cause probable :

- facet `#IDENTIFICATION_REFERENCE` present,
- mais aucun champ avec `@UI.identification`.

Action :

Ajouter `@UI.identification` sur les champs affiches en detail.

### Preview Fiori Ne Charge Pas Le Composant UI5

Message typique :

```text
Impossible d'ouvrir l'application car le composant SAP UI5 de l'application n'a pas pu etre charge.
```

Action :

1. Fermer l'onglet preview.
2. Relancer `Preview...` depuis le service binding.
3. Faire `Ctrl + Shift + R`.
4. Tester en navigation privee si le cache Chrome garde un etat ancien.

## Strategie De Test

Tester dans cet ordre :

1. List report : affichage des donnees.
2. Filtre simple sur la cle.
3. Navigation detail.
4. Annotations detail.
5. Tri et personnalisation des colonnes.
6. Creation d'un enregistrement de test.
7. Modification d'un champ simple.
8. Suppression d'un enregistrement de test.
9. Navigation vers entites liees.
10. Actions metier, une par une.

Ne pas commencer par les actions metier.

## Reintroduction Des Actions

Une fois lecture/detail/create/update/delete stabilises :

1. Ajouter une seule action dans la projection.
2. Activer la BDEF projection.
3. Activer la service definition.
4. Rafraichir le service binding.
5. Tester dans Fiori.
6. Passer a l'action suivante seulement si tout est stable.

Exemple pour Booking :

```abap
use action confirm;
```

puis tester. Ensuite seulement :

```abap
use action cancel;
```

puis :

```abap
use action createOrder;
```

## Apprentissages Projet Et Outillage

Cette section conserve les apprentissages qui ne sont pas seulement du code RAP, mais qui ont ete utiles pendant le projet de migration.

### Workflow Fonctionnel A Tester

Le scenario cible tourne autour des objets suivants :

1. `Bookings` : reservation de vol.
2. `Orders` : commande creee a partir d'une reservation.
3. `OrderItems` : lignes de commande.
4. `Invoices` : facture liee a une commande.
5. `Payments` : paiement lie a une facture.

Ordre de test recommande :

1. Afficher la liste des bookings.
2. Filtrer un booking, par exemple `BookingID = 5001`.
3. Ouvrir le detail du booking.
4. Verifier les champs affiches par les annotations `@UI.identification`.
5. Tester les entites exposees dans le service booking :
   - `Bookings`,
   - `Orders`,
   - `OrderItems`,
   - `Invoices`,
   - `Payments`.
6. Tester creation/modification/suppression standard avant les actions metier.
7. Reintroduire les actions metier seulement apres stabilisation :
   - `confirm`,
   - `cancel`,
   - `createOrder`,
   - `release`,
   - `createInvoice`,
   - `registerPayment`.

### Workflow abapGit Et GitHub

Deux flux ont ete utilises :

1. Modifications dans le repo local VS Code, puis push GitHub.
2. Pull depuis Eclipse ADT via abapGit pour importer les objets ABAP.
3. Activation manuelle dans Eclipse ADT.
4. Tests dans le service binding et Fiori Elements preview.
5. Si des corrections sont faites directement dans Eclipse, exporter/stage/push via abapGit pour resynchroniser GitHub.

Bonnes pratiques :

- Faire un `Pull` abapGit avant de tester une correction poussee depuis VS Code.
- Activer les objets apres le pull, car abapGit importe le source mais ne garantit pas que tout soit actif.
- Ne pas se fier uniquement au service binding : ouvrir l'objet cite dans `Problems`.
- Garder les commits GitHub petits et nommes par intention technique.
- Ne pas exporter vers GitHub des objets experimentaux tant qu'ils ne compilent pas.
- Si un pull abapGit semble reussi mais que l'objet ADT affiche encore l'ancienne source, ouvrir l'objet et verifier le contenu reel. Dans ce cas, refaire un commit avec une petite modification source explicite, refaire le pull, ou coller manuellement le contenu attendu dans ADT.

### Objets Sensibles Dans ZFLIGHT-ECC

Les objets suivants ont ete touches ou identifies comme sensibles.

Booking :

- `ZF2_I_BOOKING` : Data Definition interface.
- `ZF2_C_BOOKING` : Data Definition projection.
- `ZF2_I_BOOKING` : Behavior Definition interface.
- `ZF2_C_BOOKING` : Behavior Definition projection.
- `ZF2_C_BOOKING_UI` : Metadata Extension.
- `ZF2_BOOKING_CANCEL_PARAM` : structure/CDS de parametre d'action.

Invoice :

- `ZF2_I_INVOICE`.
- `ZF2_C_INVOICE`.
- `ZF2_I_INVOICE` Behavior Definition.
- `ZF2_C_INVOICE` Behavior Definition.
- `ZF2_C_INVOICE_UI`.
- `ZF2_PAYMENT_INPUT`.

Order :

- `ZF2_I_ORDER`.
- `ZF2_C_ORDER`.
- `ZF2_I_ORDER_ITEM`.
- `ZF2_C_ORDER_ITEM`.
- `ZF2_C_ORDER_UI`.

Payment :

- `ZF2_I_PAYMENT`.
- `ZF2_C_PAYMENT`.
- `ZF2_C_PAYMENT` Behavior Definition.

Customer et Flight :

- `ZF2_I_CUSTOMER` doit etre actif avant `ZF2_C_CUSTOMER` et `ZF2_C_CUSTOMER_UI`.
- `ZF2_I_FLIGHT` doit etre actif avant `ZF2_C_FLIGHT` et `ZF2_C_FLIGHT_UI`.
- Ces objets peuvent bloquer leurs metadata extensions, mais ne sont pas toujours prioritaires pour tester le service booking.

Services :

- `ZF2_UI_BOOKING_MANAGE`.
- `ZF2_UI_BOOKING_MANAGE_O4`.
- `ZF2_API_FLIGHT_BOOKING`.
- `ZF2_API_FLIGHT_BOOKING_O4`.
- `ZF2_UI_FLIGHT_MANAGE`.
- `ZF2_UI_FLIGHT_MANAGE_O4`.

### Conventions De Nommage

Conventions utilisees dans le projet :

- `ZF2_I_*` : CDS interface view/entity.
- `ZF2_C_*` : CDS projection/consumption view/entity.
- `ZF2_C_*_UI` : Metadata Extension Fiori.
- `ZF2_BP_I_*` : Behavior pool ABAP pour interface behavior.
- `ZF2_UI_*` : Service Definition orientee Fiori Elements UI.
- `ZF2_API_*` : Service Definition orientee API.
- `*_O4` : Service Binding OData V4.

Attention ADT :

- icone bleue `D` : Data Definition.
- icone violette `B` : Behavior Definition.
- icone bleue `E` : Metadata Extension.
- service definition et service binding sont dans `Business Services`.

Une confusion frequente consiste a coller du code BDEF dans une Data Definition ou inversement.

### Re-creation Manuelle D'Objets ADT

Quand abapGit importe un objet mais qu'ADT indique qu'il n'existe pas, il peut etre necessaire de le recreer manuellement.

Regle generale :

1. Creer l'objet avec le bon type ADT.
2. Utiliser le meme nom technique.
3. Choisir le bon `Referenced Object` :
   - pour une projection CDS `ZF2_C_*`, referencer souvent `ZF2_I_*`,
   - pour une interface CDS `ZF2_I_*`, referencer souvent la table de base ou laisser vide selon le wizard.
4. Coller le code exact depuis GitHub/le repo local.
5. Sauvegarder et activer dans l'ordre des dependances.

Si le wizard refuse un `Referenced Object`, verifier d'abord que cet objet existe et est actif.

### SAP Build, Joule Et Dev Space

Problemes observes :

- SAP Build peut afficher une limite d'espaces de developpement atteinte meme apres suppression visuelle d'un projet. Dans ce cas, verifier le Dev Space Manager et les espaces restants, pas seulement la page SAP Build.
- Joule dans BAS/ADT depend du contexte projet et des droits. Si le panneau demande de choisir un projet, utiliser `Change Project` et selectionner le projet ABAP actif.
- Une extension ADT/ABAP dans VS Code ou BAS peut aider pour l'edition ou la navigation, mais ne remplace pas toujours Eclipse ADT pour l'activation ABAP, les service bindings et certains wizards.
- Dans VS Code, le message `Specified workspace folder ... uses an unsupported URI scheme: abap:/...` vient de l'extension `SAP CDS Language Support`. Il signifie qu'un dossier distant ABAP a ete ajoute comme dossier workspace, alors que l'extension attend un dossier local. Retirer ce dossier `abap:/...` du workspace VS Code et travailler soit depuis le repo local, soit depuis Eclipse ADT/BAS pour les objets ABAP distants.

### Diagnostic Depuis Le Debugger

Quand Fiori Elements affiche :

```text
ABAP Runtime error 'RAISE_SHORTDUMP'
```

ouvrir le debugger ADT et inspecter les variables de l'erreur.

Indice important observe :

```text
MX_EXCEPTION = CX_RAP_HANDLER_NOT_IMPLEMENTED
```

Ce diagnostic oriente vers :

- authorization handler manquant,
- action handler non implemente,
- behavior pool vide ou incomplet,
- action exposee trop tot dans la projection.

### Ce Qui A Debloque Le Projet

Les corrections qui ont permis d'obtenir un preview Fiori fonctionnel :

1. Retirer `authorization master ( instance )` des behaviors interface principaux.
2. Retirer `strict ( 2 );` des behavior definitions principales.
3. Masquer les actions dans les projections `ZF2_C_BOOKING`, `ZF2_C_INVOICE`, `ZF2_C_ORDER`.
4. Activer les objets par dependance, pas uniquement le service binding.
5. Ajouter `@UI.identification` aux metadata extensions avec facet `#IDENTIFICATION_REFERENCE`.
6. Relancer le preview depuis le service binding et vider le cache navigateur si necessaire.

## Etat Actuel Du Projet

Les choix de stabilisation appliques actuellement sont :

- pas de `authorization master ( instance )` dans les BDEF interface principales,
- pas de `strict ( 2 );` dans les BDEF principales,
- actions masquees dans les projections UI `ZF2_C_BOOKING`, `ZF2_C_INVOICE`, `ZF2_C_ORDER`,
- `@UI.identification` ajoute sur les metadata extensions principales.

Ces choix sont temporaires et servent a stabiliser le service UI avant de reintroduire les exigences RAP avancees.
