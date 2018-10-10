# Installation d'un serveur d'hébergement web


##Objectif

L'objectif est de créer une machine permettant l’hébergement de plusieurs sites web.
Cette machine tournera sous Linux, l'installation et la configuration se fait "from scratch"
et sans interface graphique.

## Organisation 

Nous sommes un groupe de 3 personnes pour la réalisation de ce serveur.

* Davide Carboni
* Antonio Giordano
* Quentin Rossier


## Installation de Debian 8

## Host Configuration

## Mise en place de l'environnement

## NgineX

### Installation
	apt-get install 
## MariaDB

### Installation
Installation de MariaDB serveur.

	apt-get install mariadb-server
	

Inscrivez votre mot de passe root pour MariaDB, vous pouvez toujours le laissez blanc ou le changer après.

Pour sécuriser l'installation, lancez le script de sécurité suivant pour changer quelques options de base insécurisées.
	
	mysql_secure_installation	

Entré le mot de passe pour l'utilisateur root, appuyer sur "Enter" s'il n'y en à pas.

Changer ou non de mot de passe en appuyant sur "y" ou "n" . Il est vivement conseillé d'avoir un mot de passe root. 

Les questions suivantes ne doivent être répondue que par "y" afin de supprimer: un utilisateur de test, une base de données de test, la connexion en administrateur distante et recharge ensuite ses nouvelles règles pour immédiatement intégrer les nouvelles options.

Pour avoir une connexion distance avec l'utilisateur root de MariaDB, il faut modifier la réponse sur l'option précédemment configurée. Un fichier doit être modifier :  

	/etc/mysql/my.cnf 

Dans ce fichier, la ligne suivante indique à MySQL de n'écouter que localhost.  Il faut la désactiver.

	bin-adress = 127.0.0.1	

L'installation et la configuration de MariaDB est à présent terminée.







