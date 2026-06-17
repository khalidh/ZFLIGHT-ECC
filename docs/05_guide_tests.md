# Guide de tests

## Jeux de donnees

Executer `ZFLIGHT_LOAD_DEMO_DATA`:

- 20 compagnies.
- 100 connexions.
- 1000 vols.
- 500 clients.
- 5000 reservations.

## Cas de tests fonctionnels

1. Rechercher des vols ouverts par date, compagnie et ville.
2. Creer une reservation pour un client existant.
3. Verifier que `ZSFLIGHT-SEATSOCC` augmente de 1.
4. Confirmer la reservation.
5. Creer une commande depuis la reservation.
6. Creer une facture depuis la commande.
7. Enregistrer un paiement total.
8. Verifier la cloture de facture et commande.
9. Annuler une reservation `NEW`.
10. Refuser l'annulation d'une reservation deja `FLOWN`.

## Tests concurrence

1. Ouvrir deux sessions SAP GUI.
2. Tenter de reserver la derniere place du meme vol.
3. Verifier que le verrou `EZSFLIGHT` evite le surbooking.
4. Verifier message `005` si capacite insuffisante.

## Tests autorisations

1. Utilisateur display only: `ACTVT=03`.
2. Verifier l'acces aux ALV.
3. Verifier refus creation reservation.
4. Utilisateur create/change: `ACTVT=01,02`.
5. Verifier creation, confirmation, annulation.

## Tests reporting

- Tri par compagnie, date, statut.
- Sous-totaux par compagnie et devise.
- Export tableur depuis ALV.
- KPI CA par compagnie.
- KPI taux de remplissage.

