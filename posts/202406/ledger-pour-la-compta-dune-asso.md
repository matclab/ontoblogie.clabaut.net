---
title: Ledger pour la compta d'une asso
slug: ledger-pour-la-compta-dune-asso
date: 2024-06-12 15:38:11 UTC+02:00
tags: banque,comptes
category: 
link: 
description: 
type: text
mastodon: 112945282442285191
---

{{% thumbnail "/images/comptable.jpg" imgclass="float-right" %}}{{% /thumbnail %}}

Dans mon village, nous avons récemment créé une chouette association : [La
Tourbillonnante](https://latourbillonnate.fr). Il se trouve que j'ai l'insigne
honneur d'en être le trésorier (il faut dire qu'il n'y a en général pas
beaucoup de volontaires pour ce poste).

J'ai décidé d'utiliser ledger pour tenir la comptabilité… Je vous décris ici
pourquoi et comment je m'y suis pris.


<!-- TEASER_END -->
# Contexte

J'ai déjà raconté ici {{% doc %}}comment j'utilisai ledger-cli pour faire mes
comptes <Gérer ses comptes en ligne de commande>{{% /doc %}}. Entre-temps, j'ai
eu l'occasion d'assurer l'intérim pour la gestion de la trésorerie de la
[Bibliothèque municipale de La
Tour-d'Aigues](https://www.bibliothequelatourdaigues.fr/) (qui en vrai est une
bibliothèque associative et ressemble fortement à une délégation de service
publique par des bénévoles, mais c'est une autre histoire).

Le trésorier précédent faisait ses comptes sur un tableau excel et j'ai passé
des dizaines d'heures à finaliser les comptes en fin d'année tellement il y
avait des erreurs de copier/coller, de formules erronées, etc. J'avais hésité
à tout migrer sous *ledger cli*, mais je me suis dit que ça rendrait difficile
la reprise par quelqu'un d'autre, et comme j'étais juste là pour dépanner, je
n'ai rien changé.

Résultat : le trésorier suivant à tout changé et a utilisé le logiciel qu'il
connaissait pour faire les comptes. Je me suis rendu compte que chaque
changement de trésorier conduisait à un changement des outils utilisés. À
partir de ce moment, je me suis dit que si l'occasion se présentait, je
partirais sur *ledger cli* la prochaine fois.

Et l'occasion s'est présentée !

# Mise en place

J'ai utilisé trois fichiers pour les comptes :

- `legal.ledger` qui reprend la base de comptabilité légale augmentée des
  comptes spécifiques aux associations.
- `account.ledger` qui contient les comptes, tags et monnaies spécifiques à
  l'association. Il inclut notamment le fichier `legal.ledger`.
- `periodic.ledger` qui définit les transactions périodiques pour le budget
  prévisionnel et le suivi de ce dernier.
- `prev.ledger` qui se contente d'inclure `periodic.ledger` et d'initialiser
  les comptes. C'est ce fichier qui est utilisé par le script `budget.sh`
  (voir [budget prévisionnel](#budget-previsionnel) ci-après).
- `asso.ledger` qui contient l'initialisation des comptes et les
  transactions.

J'ai choisi d'utiliser une arborescence numérique du type `1:0:2:1`. Le
fichier `legal.ledger` contient par exemple :
```
# Comptes spécifiques association
…
account 8:6:2
  alias 862
  alias Prestations
  note Prestations
account 8:6:4
  alias 864
  alias Personnel bénévole
  note Personnel bénévole
account 8:7
  alias Contributions volontaires en nature
  note Contributions volontaires en nature
account 8:7:0
  alias 870
  alias Dons en nature
  note Dons en nature
account 8:7:1
  alias 871
  alias Prestations en nature
  note Prestations en nature
account 8:7:5
  alias 875
  alias Bénévolat
  note Bénévolat

# Comptes généraux
account 1
  alias Capital
  note Capital
account 1:0
  alias 10
  alias capital et réserves
  note capital et réserves
account 1:0:1
  alias 101
  alias Capital
  note Capital
account 1:0:1:1
  alias 1011
  alias Capital souscrit - non appelé
  note Capital souscrit - non appelé
```

Il est alors possible d'écrire des transactions dans le fichier `asso.ledger`
en référençant les alias, par exemple :

```
2024/03/27 * Jeanne Truc
    cotisation             -20.00 € 
    caisse                  20 €

2024/03/27 * (FR63908007) OVH SAS
    ; Jean Truc paye sa cotisation par les frais de nom de domaine
    cotisation             -6.71 € ; Payee: Jean Truc
    nom de domaine          6.71 €

2024/06/06 * Jean Truc  ; avance pour ouverture de compte
   prêt adhérents    -150 €
   crédit coopératif

2024/08/07 * Jean Truc  ; remboursement partiel de l'avance sur la caisse
   prêt adhérents    130 €
   caisse
```

La difficulté est qu'en utilisant l'arborescence des numéros de compte, le
registre et la balance n'est pas très explicite :

```
$ ledger bal -f asso.ledger
           -20.00 €  4
            -20.00 €    6:7:1
             40.00 €  5
            150.00 €    1:2:1:1
           -110.00 €    3:1
             16.52 €  6
              9.81 €    2
              9.81 €      6
              6.71 €    5
              6.71 €      1:2
            -36.52 €  7
            -36.52 €    5
            -36.52 €      8:1
                   0  8
             60.00 h    6
             60.00 h      4
            -60.00 h    7
            -60.00 h      5
--------------------
                   0
```

J'ai donc positionné des variables d'environnements (dans le fichier
[.envrc](https://gitlab.com/matclab/compta-asso-ledger/-/blob/github/.envrc)
qui peut être chargé automatiquement si vous utilisez [direnv](https://github.com/direnv/direnv)), qui utilise l'annotation de compte pour afficher un journal plus explicite :

<pre>
$ direnv allow  # à ne réaliser qu'une fois
$ ledger bal
            <span style="color:red;">-20.00 €</span>  <span style="color:blue;">4</span> Divers – charges à payer et produits à recevoir
            <span style="color:red;">-20.00 €</span>    <span style="color:blue;">6:7:1</span> Prêt temporaire d'adhérents
             40.00 €  <span style="color:blue;">5</span> Comptes financiers
            150.00 €    <span style="color:blue;">1:2:1:1</span> compte courant crédit coopératif
           <span style="color:red;">-110.00 €</span>    <span style="color:blue;">3:1</span> caisse
             16.52 €  <span style="color:blue;">6</span> Charges
              9.81 €    <span style="color:blue;">2</span> Autres services extérieurs
              9.81 €      <span style="color:blue;">6</span> Frais postaux et de télécommunications
              6.71 €    <span style="color:blue;">5</span> Autres charges de gestion courante
              6.71 €      <span style="color:blue;">1:2</span> achat nom de domaine
            <span style="color:red;">-36.52 €</span>  <span style="color:blue;">7</span> Produits
            <span style="color:red;">-36.52 €</span>    <span style="color:blue;">5</span> Autres produits de gestion courante
            <span style="color:red;">-36.52 €</span>      <span style="color:blue;">8:1</span> Cotisations des adhérents
                   0  <span style="color:blue;">8</span> Comptes spéciaux
             60.00 h    <span style="color:blue;">6</span> Emplois des contributions volontaires en nature
             60.00 h      <span style="color:blue;">4</span> Personnel bénévole
            <span style="color:red;">-60.00 h</span>    <span style="color:blue;">7</span> Contributions volontaires en nature
            <span style="color:red;">-60.00 h</span>      <span style="color:blue;">5</span> Bénévolat
--------------------
                   0
</pre>

J'ai commencé à écrire quelques scripts d'aide :

- `budget.sh` qui sort le budget prévisionnel pour l'année en cours ou
  l'année passée en paramètre. Il produit également un fichier CSV prêt à être
  importé dans libreoffice.
- `bilan.sh` qui affiche le bilan actif/passif pour l'année en cours ou
  l'année passée en paramètre.
- `compte_résultat.sh` qui affiche les comptes de résultat
  (exploitation/financiers/contributions volontaires en nature) pour l'année
  en cours ou l'année passée en paramètre.
- `cotisations.sh` qui exploite le fichier des utilisateurs `users.yaml` et
  les comptes pour savoir qui est en retard de paiement de cotisation (compte
  7:5:8:1).

# Budget prévisionnel

Le Budget est défini par les transactions périodiques dans `periodic.ledger`.
Par exemple :

```
~ Monthly  From 2024/06/01
   627            7.40 €  ; frais banquaire / compte
   crédit coopératif

~ Yearly 
   cotisation                   -500 €  ; Adhésions
   nom de domaine               6.71 €    
   hébergement                  30 €
   publications                 150 €  ; achat affiches, flyer,  …
   6091                         50 €  ;  café, …
   Fournitures administratives  150 €   ;  post-it, …
   poste                        50 €   ; timbres
   crédit coopératif

~ Monthly From 2024/04/01
   Personnel bénévole   (2*2*20 h)  ; réunion
   Bénévolat  (-2*2*20 h)
~ Yearly
   Personnel bénévole   (20*10 h)  ; actions
   Bénévolat   (-20*10 h)
```

Ce qui donne :

<pre>
$ ./budget.sh
           <span style="color:red;">-473.71 €</span>  <span style="color:blue;">6</span> Charges
           <span style="color:red;">-200.00 €</span>    <span style="color:blue;">0</span> Achats (sauf 603)
           <span style="color:red;">-150.00 €</span>      <span style="color:blue;">6:4</span> Fournitures administratives
            <span style="color:red;">-50.00 €</span>      <span style="color:blue;">9:1</span> de matières premières (et fournitures)
            <span style="color:red;">-30.00 €</span>    <span style="color:blue;">1</span> Services extérieurs
            <span style="color:red;">-30.00 €</span>      <span style="color:blue;">3:3</span> achat hébergement services web
           <span style="color:red;">-237.00 €</span>    <span style="color:blue;">2</span> Autres services extérieurs
           <span style="color:red;">-150.00 €</span>      <span style="color:blue;">3</span> Publicité, publications, relations publiques
            <span style="color:red;">-50.00 €</span>      <span style="color:blue;">6</span> Frais postaux et de télécommunications
            <span style="color:red;">-37.00 €</span>      <span style="color:blue;">7</span> Services bancaires et assimilés
                   0    <span style="color:blue;">3</span> Impôts, taxes et versements assimilés
                   0    <span style="color:blue;">4</span> Charges de personnel
             <span style="color:red;">-6.71 €</span>    <span style="color:blue;">5</span> Autres charges de gestion courante
             <span style="color:red;">-6.71 €</span>      <span style="color:blue;">1:2</span> achat nom de domaine
                   0    <span style="color:blue;">6</span> Charges financières
                   0    <span style="color:blue;">7</span> Charges exceptionnelles
                   0    <span style="color:blue;">8</span> Dotations aux amortissements, aux dépréciations et aux provisions
            500.00 €  <span style="color:blue;">7</span> Produits
                   0    <span style="color:blue;">0</span> Ventes de produits fabriqués, prestations de services, marchandises
                   0    <span style="color:blue;">1</span> Production stockée (ou déstockage)
                   0    <span style="color:blue;">2</span> Production immobilisée
                   0    <span style="color:blue;">3</span> Concours publics
                   0    <span style="color:blue;">4</span> Subventions d'exploitation
            500.00 €    <span style="color:blue;">5</span> Autres produits de gestion courante
            500.00 €      <span style="color:blue;">8:1</span> Cotisations des adhérents
                   0    <span style="color:blue;">6</span> Produits financiers
                   0    <span style="color:blue;">7</span> Produits exceptionnels
                   0    <span style="color:blue;">8</span> Reprises sur amortissements, dépréciations et provisions
                   0  <span style="color:blue;">8</span> Comptes spéciaux
           <span style="color:red;">-600.00 h</span>    <span style="color:blue;">6</span> Emplois des contributions volontaires en nature
           <span style="color:red;">-600.00 h</span>      <span style="color:blue;">4</span> Personnel bénévole
            600.00 h    <span style="color:blue;">7</span> Contributions volontaires en nature
            600.00 h      <span style="color:blue;">5</span> Bénévolat
--------------------
             26.29 €
</pre>

ainsi qu'un fichier CSV qui peut être importé et facilement mis en forme dans
libreoffice pour les besoins de communications à des personnes qui attendent
ce type de format.

# Bilan et compte de résultat

Les scripts `bilan.sh` et `compte_résultat.sh` permettent d'afficher les
éléments pour le bilan de fin d'année. 
J'envisage d'ajouter une sortie au format CSV ou OpenOffice… À suivre

<pre>
$ ./compte_résultat.sh

EXPLOITATION
======================================================
            <span style="color:red;">-23.82 €</span>  <span style="color:blue;">6</span> Charges
                   0    <span style="color:blue;">0</span> Achats (sauf 603)
                   0    <span style="color:blue;">1</span> Services extérieurs
            <span style="color:red;">-17.11 €</span>    <span style="color:blue;">2</span> Autres services extérieurs
             <span style="color:red;">-9.81 €</span>      <span style="color:blue;">6</span> Frais postaux et de télécommunications
             <span style="color:red;">-7.30 €</span>      <span style="color:blue;">7</span> Services bancaires et assimilés
                   0    <span style="color:blue;">3</span> Impôts, taxes et versements assimilés
                   0    <span style="color:blue;">4</span> Charges de personnel
             <span style="color:red;">-6.71 €</span>    <span style="color:blue;">5</span> Autres charges de gestion courante
             <span style="color:red;">-6.71 €</span>      <span style="color:blue;">1:2</span> achat nom de domaine
                   0    <span style="color:blue;">7</span> Charges exceptionnelles
                   0    <span style="color:blue;">8</span> Dotations aux amortissements, aux dépréciations et aux provisions
             36.52 €  <span style="color:blue;">7</span> Produits
                   0    <span style="color:blue;">0</span> Ventes de produits fabriqués, prestations de services, marchandises
                   0    <span style="color:blue;">1</span> Production stockée (ou déstockage)
                   0    <span style="color:blue;">2</span> Production immobilisée
                   0    <span style="color:blue;">3</span> Concours publics
                   0    <span style="color:blue;">4</span> Subventions d'exploitation
             36.52 €    <span style="color:blue;">5</span> Autres produits de gestion courante
             36.52 €      <span style="color:blue;">8:1</span> Cotisations des adhérents
                   0    <span style="color:blue;">7</span> Produits exceptionnels
                   0    <span style="color:blue;">8</span> Reprises sur amortissements, dépréciations et provisions
--------------------
             12.70 €
FINANCIERS
======================================================
                   0  <span style="color:blue;">6:6</span> Charges financières
                   0  <span style="color:blue;">7:6</span> Produits financiers
--------------------
                   0
CONTRIBUTIONS VOLONTAIRES EN NATURE
======================================================
                   0  <span style="color:blue;">8</span> Comptes spéciaux
          <span style="color:red;">-1080.00 €</span>    <span style="color:blue;">6</span> Emplois des contributions volontaires en nature
          <span style="color:red;">-1080.00 €</span>      <span style="color:blue;">4</span> Personnel bénévole
           1080.00 €    <span style="color:blue;">7</span> Contributions volontaires en nature
           1080.00 €      <span style="color:blue;">5</span> Bénévolat
--------------------
                   0
</pre>

# Comptabilisation des heures de bénévolat

Les comptes `8:6:4` et `8:7:5` permettent de comptabiliser les heures des
bénévoles. Au bilan, le résultat est nul, mais ça permet de montrer aux
éventuelles parties intéressées (par exemple pour des demandes de subvention)
l'implication des bénévoles dans l'association. Le plus dur est de faire en
sorte que les bénévoles notent leurs heures…

Une transaction peut se noter en heures :
```
2024/12/04 * Jean Truc  ; Bénévolat sur l'année
   Personnel bénévole     60 h
   Bénévolat
```

Le taux horaire est défini dans `account.ledger` par :
```
# Valuation de la seconde  (18€/h)
P 2024/01/01 00:00:00 s 0.005 €  
```

# Suivi des cotisations

Ayant les paiement des cotisations dans le journal des transactions, je me
suis dit que c'était l'occasion d'écrire un script pour connaître l'état
courant des cotisations.

J'ai par ailleurs la liste des membres dans un fichier *yaml*.

Ça donne par exemple :
```
$ ok=1 ./cotisations.sh
Caroline Truc est à jour (20240419)
Jean Truc est à jour (20240327)
Jeanne Truc est à jour (20240327)
Béatrice Machin doit payer sa cotisation (n'a jamais payé)
3/4 cotisations payées
```
# Code source

Les fichiers décrits dans cet article sont disponibles sur
[gitlab](https://gitlab.com/matclab/compta-asso-ledger).

# Problèmes et améliorations
## Alias dans les requêtes

[Ce bug de ledger](https://github.com/ledger/ledger/issues/1164) ne permet pas
d'utiliser les alias dans les requêtes ledger. On doit donc écrire `ledger reg
5:3:1` plutôt que `ledger reg caisse` pour voir toutes les transactions de la
caisse. Ce n'est pas pratique. J'espère pouvoir proposer une correction, mais
pour l'instant ma compréhension du fonctionnement interne de ledger est encore
un peu floue.

## Export CSV/Excel

J'aimerais idéalement pouvoir sortir le bilan au format excel, afin qu'il
soit plus facilement exploitable par les gens habitués à cet outil.


