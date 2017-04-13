# Tutoriel ActionCable - Instructions

## A. Installer l'appli en local

1. Cloner l'application :
```shell
$ git clone git@github.com:nantesrb/tuto-actioncable.git
$ cd tuto-actioncable
```

1. Se mettre sur la branche `tuto-base`:
```shell
$ git checkout tuto-base
```

1. Déployer la base de donnée:
```shell
$ rails db:migrate db:seed
```

1. Lancer l'application en local
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
