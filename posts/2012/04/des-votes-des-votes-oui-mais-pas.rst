.. title: Des votes !
.. slug: des-votes-des-votes-oui-mais-pas
.. date: 2012-04-10 18:32:00
.. tags: fr,société
.. description: 


Les élections approchent et si j’en crois mon entourage, il n’est pas
facile pour tout le monde de choisir quel bulletin mettre dans l’urne :
*« Faut-il voter utile ? »*, *« Ah non, je voterai pour mon candidat favori
quoiqu’il arrive ! »*, *« oui, mais quand même, je ne veux pas voir le FN
au second tour ! »*…

Mais au fait comment un 21 avril est-il possible ? Comment peut-on avoir
au second tour un candidat que moins de 18% des votants veulent voir élu ?

.. TEASER_END

.. image:: /images/condorcet_essai.jpg
     :class: "float-right"
     :width: 300px
     :alt: Condorcet - essai sur l'application de l'analyse à la probabilité
           des décisions rendues à la pluralité des voix.


Condorcet à la rescousse !
====================================


Cette problématique n’est bien sûr pas nouvelle et a été analysée par
le marquis Nicolas De Condorcet en 1785 dans son « Essai sur
l’application de l’analyse à la probabilité des décisions rendues à la
pluralité des voix ». Il y montre notamment qu’une procédure de
décision à la majorité des voix peut conduire à des résultats
paradoxaux.


Le scrutin uninominal majoritaire à deux tours — notre système de
scrutin pour la présidentielle — ne respecte pas le critère suivant
dit « critère de Condorcet » : un candidat qui, confronté à tout autre
candidat est toujours le gagnant, doit être élu. Ce critère semble
pourtant bien naturel ! Mais aujourd’hui, on risque au premier tour
d’éliminer un candidat qui aurait pourtant gagné face à tous les
autres candidats pris un par un.

Exemple :
---------

Sur 21 électeurs :

-  7 électeurs ont pour préférence : A puis C puis B ;
-  8 électeurs ont pour préférence : B puis C puis A ;
-  6 électeurs ont pour préférence : C puis A puis B.

Avec un vote uninominal majoritaire à deux tours, le candidat C est
éliminé dès le premier tour alors qu’il aurait gagné son duel contre A
(A : 7 et C : 14) et son duel contre B (B : 8 et C : 13).

Il est possible que ce scénario soit proche de celui du 21 avril 2002
qui a vu la présence du FN au second tour.

Alors, pourquoi utilise-t on ce mode de scrutin ?

Il faut dire qu’il a un énorme avantage : sa simplicité ! On sait en
effet le mettre un œuvre assez facilement à l’aide de bulletins
papiers et d’un dépouillement manuel, ce qui n’est pas le cas de tous
les systèmes de vote.

Le bon système
==============

Je suis désolé, car malgré le titre de cette section, il n’existe pas de
bon système. Kenneth Arrow, un économiste américain, montrera
mathématiquement en 1951 avec son célèbre théorème d’impossibilité qu’il
n’existe aucun système électoral qui permette indiscutablement et
démocratiquement de transformer des choix individuels en choix
collectif, tout en préservant un certain nombre de critères raisonnables
(du type du critère de Condorcet).

Mais alors ? Sommes-nous réduit à devoir utiliser des systèmes de vote
qui n’ont pas de justifications mathématiques solides et qui n’ont
parfois pas plus de valeur qu’un lancé de dès ?

Des systèmes pas trop mauvais
=============================

La situation n’est pas aussi catastrophique qu’il n’y parait. S’il
n’existe pas de “bon système”, il existe tout de même plusieurs systèmes
“pas trop mauvais” qui, à défaut de respecter tous les critères d’Arrow,
en respectent une bonne partie, et notamment ceux qui - comme le critère
de Condorcet - paraissent les plus importants.

Le marquis de Condorcet proposa ainsi une méthode de vote qui s’avère
plus équitable que le scrutin uninominal à deux tours, mais qui a pour
inconvénient d’être difficile à mettre en œuvre, à moins d’utiliser un
système de vote électronique. Elle demande en effet aux votants de
comparer les candidats deux à deux…

Jean-Charles de Borda, mathématicien, physicien, politologue et marin
français, contemporain de Condorcet, formalisa en 1770 une méthode de
vote qui consiste à attribuer un score à chaque candidat. Le candidat
gagnant est alors celui qui cumule le plus grand score. Il existe un
certain nombre de variantes regroupées sous le vocable de vote par
notation.

Exemple de mise en œuvre :
--------------------------

Imaginons que quatre villes soient sollicitées pour déterminer la ville
où sera construit l’hôpital de leur canton.

Imaginons d’autre part que la ville A regroupe 42 % des votants, la
ville B 26 %, la ville C 15 % et la ville D 17 %.

Il est certain que chaque habitant souhaiterait que l’hôpital soit le
plus proche possible de sa ville. On obtient donc les résultats de vote
suivant, où les 42 % des votants de la ville A mettent en premier la
ville A, puis en second la ville B qui est moins éloignée que la ville C
et D, et ainsi de suite…:

+-----------------+-----------------+-----------------+-----------------+
| Ville A (42 %)  | Ville B (26 %)  | Ville C (15 %)  | Ville D (17 %)  |
+=================+=================+=================+=================+
| 1. Ville A      | 1. Ville B      | 1. Ville C      | 1. Ville D      |
| 2. Ville B      | 2. Ville C      | 2. Ville D      | 2. Ville C      |
| 3. Ville C      | 3. Ville D      | 3. Ville B      | 3. Ville B      |
| 4. Ville D      | 4. Ville A      | 4. Ville A      | 4. Ville A      |
+-----------------+-----------------+-----------------+-----------------+

Ce qui conduit au décompte de points suivant (le premier obtient 4
points, le second 3 points, le troisième, 2 points et le dernier 1 point) :

+-------+-----+----+----+----+-------------------+
| Ville |     |    |    |    |                   |
|       | 1re | 2e | 3e | 4e | Points            |
+=======+=====+====+====+====+===================+
| A     | 42  | 0  | 0  | 58 | 226               |
|       |     |    |    |    | (=42*4+58*1)      |
+-------+-----+----+----+----+-------------------+
| B     | 26  | 42 | 32 | 0  | 294               |
|       |     |    |    |    | (=26*4+42*3+32*2) |
+-------+-----+----+----+----+-------------------+
| C     | 15  | 43 | 42 | 0  | 273               |
+-------+-----+----+----+----+-------------------+
| D     | 17  | 15 | 26 | 42 | 207               |
+-------+-----+----+----+----+-------------------+

Alors qu’un vote à la majorité aurait conclu à une construction de
l’hôpital dans la ville A, le choix se porte avec la méthode de Borda
sur la ville B.

Et les questions ?
==================

Les questions ? Oui, les questions qui ont servi d’introduction à ce
petit billet et à ce que vous pouvez entendre autour de vous, comme par
exemple « Faut-il voter utile ? ». Et bien les voilà éradiquées ! Avec
un système de vote par notation, vous pouvez vous exprimer à votre
convenance pour le candidat que vous souhaitez élire, pour les candidats
que vous accepteriez éventuellement de voir élus, et vous pouvez aussi
nommer les candidats dont vous ne pourriez supporter de subir les
inconséquences crasses.

Une expérience pour 2012
========================

Un de mes cousins a porté récemment à ma connaissance une initiative
intéressante pour l’élection de 2012 qui propose aux citoyens de
participer, parallèlement aux élections officielles, à une élection
selon un système de notation similaire au système de Borda : le vote
de valeur. L’initiative est consultable sur le site
`http://www.votedevaleur.org <http://www.votedevaleur.org/>`__ et a
pour objectif une comparaison scientifique d’un scrutin uninominal à
deux tours et d’un système avec vote de valeur.

Je vous encourage fortement à y participer. On peut espérer que ça
ouvre la voie à la mise en place d’un système de vote plus
représentatif que le mode de scrutin actuel.

Le vote électronique ?
======================

Pour finir, un dernier mot sur la problématique du dépouillement des
votes. Pour un scrutin majoritaire, on sait faire. Ça se passe à peu
près bien et dans des délais raisonnables. La présence d’observateurs
tiers permet de limiter les erreurs ou les bourrages d’urnes !

La méthode de vote proposée par Condorcet n’est par contre pas adaptée
à ce style de dépouillement en raison du grand nombre de bulletins et
de calculs nécessaire à l’obtention du résultat final. À notre époque,
il est tentant de faire appel aux ordinateurs pour traiter toutes ces
données — après tout, le traitement de grande quantité de données est
bien leur raison d’être !

Mais, car il y a un « mais », les ordinateurs sont très sensibles aux
erreurs de programmation, aux virus, aux hackers;… Il est tellement
facile de tricher avec des ordinateurs qu’on se demande encore comment
des élections peuvent aujourd’hui utiliser des machines à voter, et
qui plus est, dans des démocraties !

Bref, un changement de processus électoral ne pourra être réalisé que
si une technique manuelle de dépouillement peut être mise en œuvre.
L’initiative référencée ci-dessus propose quelques pistes.


