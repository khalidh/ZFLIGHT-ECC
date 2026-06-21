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

## Etat Actuel Du Projet

Les choix de stabilisation appliques actuellement sont :

- pas de `authorization master ( instance )` dans les BDEF interface principales,
- pas de `strict ( 2 );` dans les BDEF principales,
- actions masquees dans les projections UI `ZF2_C_BOOKING`, `ZF2_C_INVOICE`, `ZF2_C_ORDER`,
- `@UI.identification` ajoute sur les metadata extensions principales.

Ces choix sont temporaires et servent a stabiliser le service UI avant de reintroduire les exigences RAP avancees.
