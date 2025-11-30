<H1>Projet</H1>
Notre projet va être sur un gym.

<H2>Table</H2>
Nos table seront :<br>
  - MemberShip
  - Entraineur (entité)<br>
  - Membre (entité)<br>
  - Cours (entité)<br>
  - EntraineurCours (table relation entre Entraineur et Cours)<br>
  - MembresCours ( table relation entre Membre et Cours )
<H3>schéma entité-relation</H3>
<img width="1051" height="731" alt="Copie de GymBD drawio" src="https://github.com/user-attachments/assets/894358a0-cf42-4a97-98d7-14a9e24753e7" />



<H2>Requetes Larcel</H2><br>
  1. Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours
    Explication :  Les administrateurs ont besoin que chaque fois qu’un cours est modifié, 
		l’assignation entraîneur–cours soit automatiquement enregistrée dans la table de relation.
  2. procedure qui  permet à l'entraineur de réserver un cours
     Explication : Les entraîneurs doivent pouvoir être assignés à un cours spécifique.
  4. Trouver le cours le plus populaire
     Explication : La direction doit savoir quels cours
		  sont les plus réservés, afin de mieux planifier les horaires et les ressources.
  5. Requête quel entraineur réserve quel cours
     Explication : L’administration doit pouvoir consulter facilement 
		 toutes les réservations faites par les entraîneurs.
  6. Voir à quelles heures sont les cours avec qui ont un entraineur
     Explication : Les utilisateurs veulent voir quel cours commence à
		 une heure donnée, avec l’entraîneur responsable.

<H2>Planification Sauvegarder/Restaurer</H2><br>

<H2> Tableau d'autorisations / Utilisateurs </H2><br>
<img width="2481" height="3509" alt="tableau autorisation BD" src="https://github.com/user-attachments/assets/fb18a6a7-402f-48ee-8ffb-c4479f7de19c" />



<H2> Fierté Xavier </H2><br>
  - Avoir terminé ma partie du projet avant le jour de remise
  - la table MembreCours
  -  Sa création
  - Ses procédures stockées pour ajouter et supprimer des données
