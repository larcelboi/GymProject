USE Gym
-- ENLEVER LES CLÉS DANS LES TABLES --
alter table Cours
drop constraint FK_Cours_EntraineurID;
alter table Membres
drop constraint FK_CoachID;
alter table Entraineur
drop constraint FK_MembreID;

-- SUPPRESSION DES TABLES DANS LE BON ORDRE --
DROP TABLE IF EXISTS EntraineurCours;
DROP TABLE IF EXISTS Cours
DROP TABLE IF EXISTS Membres;
DROP TABLE IF EXISTS Entraineur;
DROP TABLE IF EXISTS MemberShip;



------------------------------------
-- TABLE Membership
------------------------------------

CREATE TABLE MemberShip
(
    ID INT IDENTITY (1,1) NOT NULL,
    DateDebutMemberShip DATETIME NOT NULL,
    FinMemberShip DATETIME NOT NULL,

    CONSTRAINT PK_MembershipID PRIMARY KEY CLUSTERED (ID)
);

------------------------------------
-- TABLE Membres
------------------------------------

CREATE TABLE Membres
(
    MembreID INT IDENTITY(1,1) NOT NULL,
    Nom NVARCHAR(50) NOT NULL,
    NomFamille NVARCHAR(50) NOT NULL,
    MembershipID INT NOT NULL,

    CONSTRAINT PK_MembreID PRIMARY KEY CLUSTERED (MembreID),

    CONSTRAINT FK_Membres_MembershipID
        FOREIGN KEY (MembershipID)
        REFERENCES MemberShip(ID)
        ON DELETE cascade 
);

------------------------------------

------------------------------------
-- TABLE Entraineur
------------------------------------
go
CREATE TABLE Entraineur
(
    EntraineurID INT IDENTITY(1,1) NOT NULL,
    Nom NVARCHAR(250) NOT NULL,
    DateNais DATE NOT NULL,
    Specialite NVARCHAR(250) NULL,
    Niveau_Expérience NVARCHAR(250) NOT NULL,
    MembreID int,
  

    CONSTRAINT PK_EntraineurID PRIMARY KEY CLUSTERED (EntraineurID),
        
    CONSTRAINT FK_MembreID
        FOREIGN KEY (MembreID)
        REFERENCES Membres(MembreID)
        ON DELETE set null 
);

-- Ajouter la colonne Coach --
GO
ALTER TABLE dbo.Membres
ADD CoachID INT NULL
CONSTRAINT FK_CoachID
    FOREIGN KEY (CoachID)
    REFERENCES Entraineur(EntraineurID)
    on delete set null
------------------------------------
-- TABLE Cours
------------------------------------
go
CREATE TABLE Cours
(
    CoursID INT IDENTITY(1,1) NOT NULL,
    NomDeCours NVARCHAR(250) NOT NULL,
    EntraineurID INT NULL,
    TempsCours DATETIME  NOT NULL,

    CONSTRAINT PK_CoursID PRIMARY KEY CLUSTERED (CoursID),

    CONSTRAINT FK_Cours_EntraineurID
        FOREIGN KEY (EntraineurID)
        REFERENCES Entraineur(EntraineurID)
        ON DELETE CASCADE 
);

------------------------------------
-- TABLE Relation Entraineur / Cours
------------------------------------
CREATE TABLE EntraineurCours
(
    EntraineurID INT  NOT NULL,
    CoursID INT  NOT NULL,

    CONSTRAINT FK_CoachCours_EntraineurID
        FOREIGN KEY (EntraineurID)
        REFERENCES Entraineur(EntraineurID),

    CONSTRAINT FK_CoachCours_CoursID
        FOREIGN KEY (CoursID)
        REFERENCES Cours(CoursID),

    constraint "PK_EntraineurID_CoursID"
        primary key CLUSTERED (EntraineurID,CoursID) 
);

-- table de relation MembreCours --
CREATE TABLE dbo.MembreCours
(
    MembreID INT NOT NULL,
    CoursID  INT NOT NULL,
    DateInscription DATETIME NOT NULL DEFAULT (GETDATE()),

    CONSTRAINT PK_MembreCours PRIMARY KEY CLUSTERED (MembreID, CoursID),

    CONSTRAINT FK_MembreCours_MembreID
        FOREIGN KEY (MembreID)
        REFERENCES dbo.Membres(MembreID)
        ON DELETE CASCADE, 

    CONSTRAINT FK_MembreCours_CoursID
        FOREIGN KEY (CoursID)
        REFERENCES dbo.Cours(CoursID)
        ON DELETE CASCADE  
);
GO
