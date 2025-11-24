USE Gym
-- SUPPRESSION DES TABLES DANS LE BON ORDRE
DROP TABLE IF EXISTS EntraineurCours;
DROP TABLE IF EXISTS Cours;
DROP TABLE IF EXISTS Entraineur;
DROP TABLE IF EXISTS Membres;
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
        ON DELETE CASCADE 
);
-- Ajouter la colonne Coach --
GO
ALTER TABLE dbo.Membres
ADD CoachID INT NULL
CONSTRAINT FK_CoachID
    FOREIGN KEY (CoachID)
    REFERENCES Entraineur(EntraineurID)
    ON DELETE CASCADE

------------------------------------
-- TABLE Entraineur
------------------------------------
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
        ON DELETE CASCADE 
);

------------------------------------
-- TABLE Cours
------------------------------------
CREATE TABLE Cours
(
    CoursID INT IDENTITY(1,1) NOT NULL,
    NomDeCours NVARCHAR(250) NOT NULL,
    EntraineurID INT NULL,
    TempsCours DATETIME UNIQUE NOT NULL,

    CONSTRAINT PK_CoursID PRIMARY KEY CLUSTERED (CoursID),

    CONSTRAINT FK_Cours_EntraineurID
        FOREIGN KEY (EntraineurID)
        REFERENCES Entraineur(EntraineurID)
        ON DELETE SET NULL
);


------------------------------------
-- TABLE Relation Entraineur / Cours
------------------------------------
CREATE TABLE EntraineurCours
(
    EntraineurID INT NOT NULL,
    CoursID INT NOT NULL,

    CONSTRAINT FK_CoachCours_EntraineurID
        FOREIGN KEY (EntraineurID)
        REFERENCES Entraineur(EntraineurID),

    CONSTRAINT FK_CoachCours_CoursID
        FOREIGN KEY (CoursID)
        REFERENCES Cours(CoursID)
);
