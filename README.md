<h1>Projet</h1>
<p>Notre projet porte sur un gym.</p>

<h2>Tables</h2>
<ul>
  <li>MemberShip</li>
  <li>Entraineur (entité)</li>
  <li>Membre (entité)</li>
  <li>Cours (entité)</li>
  <li>EntraineurCours (table relation entre Entraineur et Cours)</li>
  <li>MembresCours (table relation entre Membre et Cours)</li>
</ul>

<h2>Schéma entité-relation</h2>
<img width="1051" height="731" alt="Schéma GymBD" src="https://github.com/user-attachments/assets/894358a0-cf42-4a97-98d7-14a9e24753e7" />

<h2>Requêtes SQL</h2>

<h4>1. Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours</h4>
<p>Explication : Les administrateurs ont besoin que chaque fois qu’un cours est modifié, 
l’assignation entraîneur–cours soit automatiquement enregistrée dans la table de relation.</p>

<h4>2. Procédure qui permet à l'entraineur de réserver un cours</h4>
<p>Explication : Les entraîneurs doivent pouvoir être assignés à un cours spécifique.</p>

<h4>3. Trouver le cours le plus populaire</h4>
<p>Explication : La direction doit savoir quels cours sont les plus réservés, afin de mieux planifier les horaires et les ressources.</p>

<h4>4. Requête : quel entraineur réserve quel cours</h4>
<p>Explication : L’administration doit pouvoir consulter facilement toutes les réservations faites par les entraîneurs.</p>

<h4>5. Voir à quelles heures sont les cours avec l’entraîneur responsable</h4>
<p>Explication : Les utilisateurs veulent voir quel cours commence à une heure donnée, avec l’entraîneur responsable.</p>

<h2>Planification Sauvegarder/Restaurer</h2>

<h3>Sauvegarder</h3>
<ul>
  <li><strong>Simple :</strong> Utiliser lorsqu’il y a des changements apportés aux schémas des tables ou aux insertions de données.</li>
  <li><strong>Complète :</strong> Utiliser après la création de la base de données, des tables et l’insertion des données. Ensuite, faire des sauvegardes complètes chaque jour.</li>
  <li><strong>Utilisant les journaux de transactions :</strong> Utiliser après chaque modification apportée à la base de données. Programmer pour être utilisé toutes les 20 minutes.</li>
</ul>

<h3>Restaurer</h3>
<p>À compléter selon votre stratégie de restauration.</p>

<h2>Tableau d'autorisations / Utilisateurs</h2>
<img width="2481" height="3509" alt="Tableau d'autorisation BD" src="https://github.com/user-attachments/assets/fb18a6a7-402f-48ee-8ffb-c4479f7de19c" />

<h2>Fierté Xavier</h2>
<ul>
  <li>Avoir terminé ma partie du projet avant le jour de remise</li>
  <li>La table MembreCours</li>
  <li>Sa création</li>
  <li>Ses procédures stockées pour ajouter et supprimer des données</li>
</ul>
