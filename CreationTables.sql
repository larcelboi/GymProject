-- -création table Xavier

DROP TABLE IF EXISTS Membres
CREATE TABLE Membres
(
	MembreID INT IDENTITY(1,1) NOT NULL,
	Nom NVARCHAR(50) NOT NULL,
	NomFamille NVARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	MembershipID INT NOT NULL,
	CoachID INT NULL


	CONSTRAINT "PK_MembreID"
	PRIMARY KEY CLUSTERED ("MembreID"),

	CONSTRAINT "FK_MemberShipID"
	FOREIGN KEY ("MemberShipID")

	REFERENCES "dbo"."MemberShip" ("ID"),

	CONSTRAINT "FK_CoachID"
	FOREIGN KEY ("CoachID")

	REFERENCES "dbo"."Entraineur" ("EntraineurID")
	)


DROP TABLE IF EXISTS MemberShip
CREATE TABLE MemberShip
(	ID INT IDENTITY (1,1) NOT NULL,
	DateDebutMemberShip DATETIME NOT NULL,
	FinMemberShip DATETIME NOT NULL

	CONSTRAINT "PK_ID"
	PRIMARY KEY CLUSTERED ("ID")
)



--- Création table larcel-- 

drop table if exists Entraineur
create  table Entraineur
(
	EntraineurID int identity(1,1) not null,
	Nom nvarchar(250) not null,
	DateNais int not null,
	Spécialiter nvarchar(250) null,
	Niveau_Expérience nvarchar(250) not null,
	MembreID int

	constraint "PK_EntraineurID" 
	primary key clustered ("EntraineurID"),

	-- Need Xavier to create his class
	constraint "FK_MembreID"
	foreign key ("MembreID")
	references "dbo"."Membres" ("MembreID")
	on delete cascade 

)

drop table if exists Cours
create  table Cours
(
	CoursID int identity(1,1)  not null,
	NomDeCours nvarchar(250) not null,
	EntraineurID int  null,
	TempsCours Datetime unique not null, -- Temps du cours disponible

	constraint "PK_CoursID"
	primary key clustered ("CoursID"),

	constraint "FK_EntraineurID"
	foreign key  ("EntraineurID")
	references "dbo"."Entraineur" ("EntraineurID")
	on delete cascade -- le cours n'a juste pus de coach , might set to cascade later on

)

-- Table Relation Coach/Cours
drop table if exists EntraineurCours
create table EntraineurCours
(
	EntraineurID int,
	CoursID int

	constraint "FK_Coach_CoachID"
	foreign key ("EntraineurID")
	references "dbo"."Entraineur" ("EntraineurID"),

	constraint "FK_Cours_CoursID"
	foreign key ("CoursID")
	references "dbo"."Cours" ("CoursID")

)
