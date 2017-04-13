# Tutoriel ActionCable - Instructions

## A. Installation
1.  Cloner l'application :
    ```shell
    $ git clone git@github.com:nantesrb/tuto-actioncable.git
    $ cd tuto-actioncable
    ```

1.  Se mettre sur la branche `tuto-base`:
    ```shell
    $ git checkout tuto-base
    ```

1.  Déployer la base de donnée:
    ```shell
    $ rails db:migrate db:seed
    ```

1.  Lancer l'application en local
    ```shell
    $ rails server
    ```

Vous voilà avec une application de t'chat de base. Il existe des seeds pour utiliser l'application avec les utilisateurs Alice et Bob :
```
Alice:
  email:    alice@example.com
  password: password

Bob:
  email:    bob@example.com
  password: password
```

A cette étape, il est nécessaire de recharger la page pour voir si de nouveaux messages sont arrivés... Pas très pratique ! Mettons en place ActionCable pour fluidifier tout ça...

## B. Configuration de base
TODO

## C. Configuration client
TODO

## D. Configuration serveur
TODO

## E. Configuration pour la production (Heroku)
TODO

## Bonus : Identifier le `current_user`
TODO
