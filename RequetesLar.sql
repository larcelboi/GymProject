-- REQUÊTE --

	-- 1. procedure qui  assigne l'entraineur à un cours --
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

	-- 2. Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours
	select * from Membres
	select * from Entraineur
	select * from EntraineurCours

	drop trigger if exists AjouterCourEntraineur

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

	-- 3. Voir à quelles heures sont les cours avec qui ont un entraineur
	go
	create or alter function CoursDisponible(@Heure NVARCHAR(10))
	returns table
	as
	return
	(
		select NomDeCours,en.Nom,format(TempsCours,'h tt') as 'Début du Cours'
		from Cours c inner join Entraineur en on en.EntraineurID = c.EntraineurID
		where en.EntraineurID is not null  and format(TempsCours,'h tt') like '2 PM'
	)
	go
	select * from  dbo.CoursDisponible('2 PM')

	-- 4. Requête qui montre le nombre de membre entrainé par coach --
	go
	create or alter procedure GénérerCoachM
	as
		set nocount on;
	begin
		declare @compteur int = 1;
		set @compteur = 0
		while @compteur < 225
		begin
			set @compteur = @compteur + 1
			declare  @chiffre int;
			set @chiffre = FLOOR(RAND() * (225 - 1 + 1)) + 1

			update Membres
			set CoachID = @chiffre
			where MembreID = @compteur
		end
	end

	go
	exec GénérerCoachM

	select 
		en.EntraineurID,
		en.Nom,
		count(*) as 'Membres'
	from Entraineur en inner join Membres mem on mem.CoachID = en.EntraineurID
	group by en.EntraineurID,en.Nom


	-- 5. Trouver le cours le plus populaire --
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
	exec GénérerEntraineurC
	
	select top 1 cours.NomDeCours,count(*) as 'Réservés'
	from EntraineurCours ec inner join Cours cours on ec.CoursID = cours.CoursID
	group by cours.NomDeCours
	order by count(*) desc
	

	-- DELETE --
	go 
	create or alter trigger EnleverEntrainerAuCours
	on EntraineurCours
	after delete
	as
		set nocount on;
	begin 
		delete from Cours 
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

	
	exec EnleverCoursTableRelation 1,185
	select * from EntraineurCours 
	select * from Cours 

	