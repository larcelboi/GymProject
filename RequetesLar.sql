-- Chiffrement
	select * from Entraineur

	alter table Entraineur
	add DateNaisC varbinary(512) NULL;

	
	alter table Entraineur
	add salt varbinary(32) NULL;

	select * from Entraineur


	declare @compteur int = 1;
	declare @salt VARBINARY(32);

	set @compteur = 0

	while @compteur < 260
	begin

		set @compteur = @compteur + 1
		set @salt = crypt_gen_random (32);

		UPDATE Entraineur
		SET salt = @salt,
			DateNaisC = HASHBYTES('SHA2_512', CONCAT(DateNais, @salt))
		WHERE EntraineurID = @compteur;
	end

	SELECT name, key_algorithm, key_length
	FROM master.sys.symmetric_keys

	-- Voir si la Database Master Key est définie (DMK)
	SELECT name, key_algorithm, key_length
	FROM sys.symmetric_keys
	WHERE name = '##MS_DatabaseMasterKey##'

	-- Création de Master Key -- 
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PasswordDMK';

	BACKUP MASTER KEY TO FILE = 'D:\data\MasterKeyBackup.key'  
	ENCRYPTION BY PASSWORD = 'PasswordfichierDMK'

	CREATE ASYMMETRIC KEY AsymmCustomerKey WITH ALGORITHM = RSA_2048

	CREATE SYMMETRIC KEY CustomerKey WITH ALGORITHM = AES_256
	ENCRYPTION BY ASYMMETRIC KEY AsymmCustomerKey;

-- REQUÊTE --

	-- 1. Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours

		/* Explication :  Les administrateurs ont besoin que chaque fois qu’un cours est modifié, 
		l’assignation entraîneur–cours soit automatiquement enregistrée dans la table de relation. */

	select * from Membres
	select * from Entraineur
	select * from EntraineurCours

	go
	create or alter TRIGGER  AjouterCourEntraineur
	on Cours
	after update
	as
	begin
		insert into EntraineurCours(CoursID,EntraineurID)
		select CoursID,EntraineurID 
		from inserted
	end
	go

	-- 2. procedure qui  permet à l'entraineur de réserver un cours--
		/* Explication : Les entraîneurs doivent pouvoir être assignés à un cours spécifique. */

	select * from Membres
	select * from Cours
	select * from Entraineur
	select * from EntraineurCours

	go
	create procedure UpdateCoursEntraineur
		@CoursID int,
		@EntraineurID int
	as
		set nocount on;
	begin
		update Cours
		set EntraineurID = @EntraineurID
		where CoursID = @CoursID
	end;
	exec UpdateCoursEntraineur 100,200

	
	-- 3. Trouver le cours le plus populaire --
		/* Explication : La direction doit savoir quels cours
		sont les plus réservés, afin de mieux planifier les horaires et les ressources. */
	go
	-- Procédure qui ajoute des EntraineurIDs aux cours
	create or alter procedure GénérerEntraineurC
	as
		set nocount on;
	begin
		declare @compteur int = 1;
		set @compteur = 0
		while @compteur < 200
		begin
			set @compteur = @compteur + 1
			declare  @chiffre int;
			set @chiffre = FLOOR(RAND() * (225 - 1 + 1)) + 1

			update Cours
			set EntraineurID = @chiffre
			where CoursID = @compteur
		end
	end

	go
	exec GénérerEntraineurC
	
	select top 1 cours.NomDeCours,count(*) as 'Réservés'
	from EntraineurCours ec inner join Cours cours on ec.CoursID = cours.CoursID
	group by cours.NomDeCours
	order by count(*) desc
	

	-- 4. Requête quel entraineur réserve quel cours --
		/*Explication : L’administration doit pouvoir consulter facilement 
		toutes les réservations faites par les entraîneurs.  */

	go
	create or alter view VueCoursRéservé
	as
	select 
		en.EntraineurID,
		en.Nom as 'NomEntraineur',
		cou.NomDeCours,
		cou.CoursID
	from EntraineurCours ec
		inner join Entraineur en on en.EntraineurID = ec.EntraineurID
		inner join Cours cou on cou.CoursID = ec.CoursID
	
	go
	select * from VueCoursRéservé

	-- 5. Voir à quelles heures sont les cours avec qui ont un entraineur
		/*Explication : Les utilisateurs veulent voir quel cours commence à
		une heure donnée, avec l’entraîneur responsable.  */

	go
	create or alter function CoursDisponible(@Heure NVARCHAR(10))
	returns table
	as
	return
	(
		select NomDeCours,en.Nom,format(TempsCours,'h tt') as 'Début du Cours'
		from Cours c inner join Entraineur en on en.EntraineurID = c.EntraineurID
		where en.EntraineurID is not null  and format(TempsCours,'h tt') like @Heure
	)
	go
	select * from  dbo.CoursDisponible('2 PM')

-- DELETE --

	-- Trigger qui enlève le cours --
	go 
	create or alter trigger EnleverEntrainerAuCours
	on EntraineurCours
	after delete
	as
		set nocount on;
	begin 
		delete from  Cours
		where EntraineurID = (select EntraineurID from deleted) and  CoursID = (select CoursID from deleted)
	end

	go
	create or alter procedure EnleverCoursTableRelation
		@CoursID int,
		@Entraineur int
	as
		set nocount on ;
	begin
		delete from EntraineurCours
		where CoursID = @CoursID and EntraineurID = @Entraineur
	end
	go

	exec EnleverCoursTableRelation 142,3
	select * from EntraineurCours 
	select * from Cours 

	-- Enlever entraineur dan table entraineur -- 
	select * from Entraineur
	delete from Entraineur
	where EntraineurID = 1

	-- SET null entraineur lorsque tu le delete de la table entraineur
	select * from Cours