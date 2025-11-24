-- Requête --

-- procedure qui  assigne l'entraineur à un cours --
	select * from Membres
	select * from Cours
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

	-- Trigger qui ajoute le cours et l'entraineur à la table EntraineurCours
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

-- Voir à quelles heures sont les cours avec qui ont un entraineur
		

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
