# MPrinter

Ce script permet aux joueurs de posséder et de gérer des imprimantes d'argent dans leur serveur FiveM utilisant le framework ESX.

## Fonctionnalités

- Possibilité d'acheter des imprimantes d'argent à différents prix
- Les imprimantes génèrent de l'argent automatiquement
- Les joueurs peuvent retirer l'argent des imprimantes
- Les joueurs peuvent ajouter du papier aux imprimantes
- Les joueurs peuvent voir les informations de leurs imprimantes (argent à l'intérieur, papier restant, etc.)

## Installation

1. Téléchargez le script depuis le dépôt GitHub.
2. Placez le dossier `MPrinter` dans le dossier `resources` de votre serveur FiveM.
3. Importez le fichier SQL `MPrinter.sql` dans votre base de données.
4. Ajoutez `start MPrinter` dans votre fichier `server.cfg` pour démarrer le script.

## Configuration

Dans le fichier `server.lua`, vous pouvez modifier les prix des imprimantes et la quantité d'argent générée par les imprimantes.

## Utilisation

- Pour acheter une imprimante, les joueurs doivent se rendre dans un magasin et interagir avec le vendeur.
- Les joueurs peuvent retirer l'argent des imprimantes en interagissant avec elles.
- Les joueurs peuvent ajouter du papier aux imprimantes en interagissant avec elles.

## Crédits

Ce script a été créé par [MaskeZenos]
