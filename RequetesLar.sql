-- Hacher Salt -- 

	-- Ajouter une colonne avec varbinary
	alter table Entraineur
	add DateNaisHacher varbinary(512) NULL;

	-- Ajouter une colonne avec varbinary pour salt
	alter table Entraineur
	add salt varbinary(32) NULL;

	-- LOOP qui vas hacher tous les dates de naissances dans la table -- 

	-- declarer un compteur pour la loop et un @salt pour chiffrer -- 
		declare @compteur int = 1;
		declare @salt VARBINARY(32);

		set @compteur = 0
		while @compteur < 260
		begin
			set @compteur = @compteur + 1

			set @salt = crypt_gen_random (32);

			UPDATE Entraineur
			SET salt = @salt,
				DateNaisHacher = HASHBYTES('SHA2_512', CONCAT(DateNais, @salt))
			WHERE EntraineurID = @compteur;
		end

	alter table entraineur
	drop column salt

-- CHIFFREMENT --

	-- Création de Master Key -- 
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PasswordDMK';

	-- Création d'une asymetric key -- 
	CREATE ASYMMETRIC KEY AsymEntraineurkey WITH ALGORITHM = RSA_2048

	CREATE SYMMETRIC KEY EntraineurKey WITH ALGORITHM = AES_256
	ENCRYPTION BY ASYMMETRIC KEY AsymEntraineurkey;

	-- Aller chercher un ID d'une clé asym
	SELECT ASYMKEY_ID('AsymEntraineurkey')

	-- Aller chercher le ID d'une clé sym
	SELECT Key_GUID('EntraineurKey')

	-- Ajouter une colonne pour pemettre de chiffrer DateNais
	alter table entraineur
	add DateNaisChiffrer varbinary(8000) null;

	 -- Chiffrer avec  une clé asym  -- ENCRYPTBYASYMKEY
	UPDATE Entraineur
	SET DateNaisChiffrer = ENCRYPTBYASYMKEY(
        ASYMKEY_ID('EntraineurKey'),
        CONVERT(varchar(50), DateNais) -- Convert la DateNais pour permettre le convert et le chiffrement
    );

	-- Chiffrer avec  une clé asym  -- EncryptByKey 
	OPEN SYMMETRIC KEY EntraineurKey
	DECRYPTION BY ASYMMETRIC KEY AsymEntraineurkey;

	UPDATE Entraineur
	SET DateNaisChiffrer = EncryptByKey(
        Key_GUID('EntraineurKey'),
        CONVERT(varchar(50), DateNais) -- Convert la DateNais pour permettre le convert et le chiffrement
    );

	-- test
	select * from Entraineur


-- REQUÊTE --

	-- 1. Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours
	go
	create or alter TRIGGER  AjouterCourEntraineur
	on Cours
	after update
	as
	begin
		insert into EntraineurCours(CoursID,EntraineurID)
		select CoursID,EntraineurID 
		from inserted
		where EntraineurID is not null;
	end
	go

	-- 2. procedure qui  permet à l'entraineur de réserver un cours--
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

	-- exec
	exec UpdateCoursEntraineur 100,200

	
	-- 3. Procéure qui trouve le cours le plus populaire --
	go
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
	
	-- exec
	exec GénérerEntraineurC
	
	-- test
	select top 1 cours.NomDeCours,count(*) as 'Réservés'
	from EntraineurCours ec inner join Cours cours on ec.CoursID = cours.CoursID
	group by cours.NomDeCours
	order by count(*) desc
	

	-- 4. Requête qu afficher l'entraineur et les cours réservés --
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

	-- test
	select * from VueCoursRéservé


	-- 5. Voir à quelles heures sont les cours avec qui ont un entraineur
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

	-- test
	select * from  dbo.CoursDisponible('2 PM')


-- DELETE --

	-- Trigger qui Enlève l'entraineur dans tous les tables -- 
	go 
	create or alter trigger EnlverEntraineur
	on Entraineur
	instead of delete
	as
	begin 
		-- Supprime l'entraineur de la table de relation EntraineurCours
		DELETE FROM EntraineurCours
		WHERE EntraineurID IN (SELECT EntraineurID FROM deleted);

		-- Modifie l'EntraineurID à null
		update Cours
		set EntraineurID  = null
		where EntraineurID = (select EntraineurID from deleted) and  CoursID = (select CoursID from deleted)

		DELETE FROM Entraineur
		WHERE EntraineurID IN (SELECT EntraineurID FROM deleted);
	end
	go

	-- test delete
	delete from Entraineur
	where EntraineurID = 9


	-- Trigger qui Enlève le cours dans tous les tables -- 
	go 
	create or alter trigger EnleverCours
	on Cours
	instead of delete
	as
	begin 
		-- Supprimer le cours de la table de relation EntraineurCours
		DELETE FROM EntraineurCours
		WHERE CoursID IN (SELECT CoursID FROM deleted);

		-- Supprime le cours de la table Cours
		DELETE FROM Cours
		WHERE CoursID IN (SELECT CoursID FROM deleted);
	end
	go

	-- test delete
	delete from Cours
	where CoursID = 1