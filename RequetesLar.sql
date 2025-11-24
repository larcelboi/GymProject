-- Requête --

-- procedure qui  ajoute le cours et l'entraineur à la table de relation --
	select * from Membres
	select * from Cours
	select * from EntraineurCours
	go;
	create procedure AjouterCoursEntraineur
		@CoursID int,
		@EntraineurID int
	as
	begin
		update Cours
		set EntraineurID = @EntraineurID
		where CoursID = @CoursID

		insert into EntraineurCours(CoursID,EntraineurID)
		values(@CoursID,@EntraineurID)
	end;
	exec AjouterCoursEntraineur 3,200

	-- fonction qui retourne une liste des membres assignés à un EntraineurID
	select * from Membres
	select * from Entraineur
	go;
	create or alter function MembresEntraineur (@EntraineurID int)
	returns table
	as 
	return
	(
		select * 
		from Membres
		where Entrai
	)

-- Voir à quelles heures sont les cours avec un coach
	select NomDeCours,TempsCours
	from Cours
	where EntraineurID is not null