-- Requête --

-- procedure qui  assigne l'entraineur à un cours --
	select * from Membres
	select * from Cours
	select * from EntraineurCours
	go;
	create procedure AjouterCoursEntraineur
		@CoursID int,
		@EntraineurID int
	as
		set nocount on;
	begin
		update Cours
		set EntraineurID = @EntraineurID
		where CoursID = @CoursID
	end;
	exec AjouterCoursEntraineur 10,5

	-- trigger ajotuer le cours et l'entraineur à la table EntraineurCours
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

-- Voir à quelles heures sont les cours avec un coach
	select NomDeCours,TempsCours
	from Cours
	where EntraineurID is not null