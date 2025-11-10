
drop table if exists Coach
create  table Coach
(
	CoachID int identity(1,1) not null,
	Nom nvarchar(250) not null,
	Age int not null,
	Spécialiter nvarchar(250) not null,
	Niveau_Expérience nvarchar(250) not null,
	MembreID int

	constraint "PK_CoachID" 
	primary key clustered ("CoachID"),

	-- Need Xavier to create his class
	/*constraint "FK_MembreID"
	foreign key ("MembreID")
	references "dbo"."Membre" ("MembreID")
	on delete set cascade */

)

drop table if exists Cours
create  table Cours
(
	CoursID int identity(1,1)  not null,
	TypeCours nvarchar(250) not null,
	NomDeCours nvarchar(250) not null,
	CoachID int  null,
	TempsCours Datetime not null

	constraint "PK_CoursID"
	primary key clustered ("CoursID","TempsCours"),

	constraint "FK_CoachID"
	foreign key  ("CoachID")
	references "dbo"."Coach" ("CoachID")
	on delete cascade -- le cours n'a juste pus de coach , might set to cascade later on

)
