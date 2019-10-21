.. title: Migration du blog nikola + GAE
.. slug: migration-du-blog-nikola-+-gae
.. date: 2017-12-28 19:14:23 UTC+01:00
.. tags: informatique,web
.. link: 
.. description: 
.. type: text


.. class:: ad
  
   Ce blog est en léthargie profonde depuis plusieurs années. Je ne suis pas
   certain d'arriver à le faire revivre, mais je vais essayer, en commençant
   par vous expliquer comment je m'y suis pris pour le migrer de *blogger* à
   un hébergement de site statique généré par `nikola
   <https://getnikola.com>`__  et hébergé sur GAE (Google app engine).

.. TEASER_END

Import dans Nikola
==================

*Nikola* propose le plugin :code:`import_blogger` qui permet d'importer un 
fichier d'export XML de *blogger* dans la structure des fichiers de *nikola*.  
Il s'installe par :

.. code-block:: shell

   nikola plugin -i import_blogger

Un projet *nikola* se crée alors avec la commande :

.. code-block:: shell

   nikola import_blogger -o nom_du_blog blogger_export.xml

Il faut ensuite copier le fichier de configuration générée (par exemple
:code:`conf.py.import_blogger-20171228_142937`) dans le fichier :code:`conf.py` et modifier la configuration selon vos souhaits.

Les fichiers des articles de blog sont générés au format *html* accompagné 
d'un fichier *.meta* au format *restructuredtext* contenant les méta-données 
de l'article.

Globalement la conversion se passe bien et le rendu est acceptable. Certains 
articles nécessitent néanmoins une reprise. Je suis pour cela passé par les 
outils :code:`pandoc` et :code:`html2text2` pour obtenir une version de 
l'article au format *restructuredtext* à  reprendre et modifier à la main :

.. code-block:: shell

   html2text2 article.html | pandoc -f markdown -t rst > article.rst
   mv article.html article.bak


Hébergement sur GAE
===================

Google fournit des explications assez détaillées pour `héberger un blog 
statique sur GAE 
<https://cloud.google.com/appengine/docs/standard/python/getting-started/hosting-a-static-website>`__.  
Appliquée à un blog statique généré par *Nikola*, il faut dans les grandes 
lignes :

1. Créer un projet sur la `console google cloud 
   <https://console.cloud.google.com/project>`__
2. Mettre le fichier :code:`app.yaml` suivant dans le répertoire :code:`files` 
   à la racine du projet :

   .. code:: yaml

      runtime: python27
      api_version: 1
      threadsafe: true

      handlers:
      - url: /
        static_files: index.html
        upload: index.html

      - url: /en/
        static_files: en/index.html
        upload: en/index.html

      - url: /(.*)
        static_files: \1
        upload: (.*)

3. Modifier le paramètre :code:`DEPLOY_COMMANDS` dans le fichier 
   :code:`conf.py` comme suit (en remplaçant :code:`gae_project_id` par l'identifiant du projet créé en 1.  :

   .. code:: python

     STRIP_INDEXES = False
     PRETTY_URLS = False
     DEPLOY_COMMANDS = {
         'default': [
             "cd output && gcloud app deploy --project gae_project_id"
         ]
     }

Il est sans doute possible d'utiliser :code:`PRETTY_URLS` en modifiant le 
fichier :code:`app.yaml` pour prendre par défaut les fichiers `index.html`, 
mais cette configuration permet de garder les mêmes URLs que sur *blogger*, à
condition de configurer une redirection pour les URLs existantes :

.. code:: python
 
   REDIRECTIONS = [
       ('2012/04/lettre-eva-joly.html', '/posts/2012/04/lettre-eva-joly.html'),
       ]

Ou encore plus simplement, comme me l'a très aimablement fait remarquer
@GetNikola sur twitter, en  remplaçant :code:`"posts"` par :code:`""` dans la
variable :code:`POSTS` :

.. code:: python

   POSTS = (
               ("posts/*.txt", "", "post.tmpl"),
               ("posts/*.rst", "", "post.tmpl"),
               ("posts/*.html", "", "post.tmpl"),
               )

Ensuite un simple :code:`nikola build && nikola deploy` rendra accessible le 
site sur l'URL https://gae_project_id.appspot.com. Libre à vous de configurer 
votre enregistrement DNS pour que votre nom de domaine redirige vers cette 
page. Il vous est également possible de configurer la génération et le 
renouvellement automatique de certificats afin de rendre votre site accessible 
en *HTTPS*. Cela se fait facilement sur la console *google cloud*.


