USE GYM
GO
--- Requetes 1 Xavier:
--- le Nombre de Membres qui ont pris un abonement chauqe mois dans la dernière années et les mettres dans une vue ---
CREATE OR ALTER VIEW VueAfficherNbAbonnementMois
AS
	SELECT DATEPART(MONTH, DateDebutMemberShip) AS Mois,COUNT(Nom) AS NB_Membres
	FROM dbo.Membres m JOIN dbo.MemberShip ms ON m.MembershipID = ms.ID
	WHERE DateDebutMemberShip BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE()
	GROUP BY DATEPART(MONTH, DateDebutMemberShip)
GO

--- Requete 2 Xavier: --
-- Afficher les membres dont le membership expire dans 1 mois et moin en excluant les membres avec un abonement déja terminé et les mettres dans une vue. --
CREATE OR ALTER VIEW VueAfficherMembresMemberShipBientotFinis
AS
	SELECT m.Nom,m.MembreID,ms.FinMemberShip
	FROM dbo.Membres m JOIN dbo.MemberShip ms ON m.MembershipID = ms.ID
	WHERE ms.FinMemberShip <= DATEADD(MONTH, +1, GETDATE()) AND ms.FinMemberShip > GETDATE()
GO



-- traitement automatise : ---
--- assigner un coach à des membres --
SELECT * FROM dbo.membres
SELECT * FROM dbo.Entraineur

GO
CREATE OR ALTER PROCEDURE pAssignerCoachGroupe
    @CoachID INT,
    @MinID INT,
    @MaxID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Membres
    SET CoachID = @CoachID
    WHERE MembreID BETWEEN @MinID AND @MaxID;
END;
GO


-- EXEC --
EXEC pAssignerCoachGroupe @CoachID = 3, @MinID = 10, @MaxID = 30;
EXEC pAssignerCoachGroupe @CoachID = 34, @MinID = 40, @MaxID = 60



-- traitement automatise --
-- inscrire / ajouter un membre a un cours
GO
CREATE OR ALTER PROCEDURE dbo.pInscrireMembreAuCours
    @MembreID INT,
    @CoursID  INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.MembreCours WHERE MembreID = @MembreID AND CoursID = @CoursID)
    BEGIN
        SELECT 'Déjà inscrit.' AS Message;
        RETURN;
    END

    INSERT INTO dbo.MembreCours (MembreID, CoursID)
    VALUES (@MembreID, @CoursID);

    SELECT 'Inscription réussie.' AS Message;
END;
GO

-- execution -- 
EXEC dbo.pInscrireMembreAuCours @MembreID = 5, @CoursID = 3;



-- traitement automatise--
GO
CREATE OR ALTER PROCEDURE dbo.pDesinscrireMembreDuCours_Simple
    @MembreID INT,
    @CoursID  INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.MembreCours
    WHERE MembreID = @MembreID AND CoursID = @CoursID;

    SELECT @@ROWCOUNT AS LignesSupprimees;
END;
GO


-- execution -- 
EXEC dbo.pDesinscrireMembreDuCours_Simple @MembreID = 5, @CoursID = 3;


-- requette 3 Vue , afficher les cours le plus populair par rapport au nb  de participants--
CREATE OR ALTER VIEW vCoursAvecNombreDeMembres
AS
SELECT 
    c.CoursID,
    c.NomDeCours,
    c.TempsCours,
    COUNT(mc.MembreID) AS NombreDeMembres
FROM Cours c
LEFT JOIN MembreCours mc ON c.CoursID = mc.CoursID
GROUP BY c.CoursID, c.NomDeCours, c.TempsCours;
GO


-- execution -- 
SELECT *
FROM vCoursAvecNombreDeMembres
ORDER BY NombreDeMembres DESC;



-- requete 4 --
--  afficher les membres sans coach ( pour insite ensuite à en prendre un ) but commerciale ---
SELECT *
FROM Membres
WHERE MembreID NOT IN (
    SELECT MembreID
    FROM MembresCours
);


-- requete 5 -- 
-- afficher l'entraineur avec le plus de membres / personnes qu'il coach , vise a recompeser le meilleur employer ) 
SELECT EntraineurID,Nom
FROM Entraineur
WHERE EntraineurID = (
    SELECT TOP 1 CoachID
    FROM Membres
    WHERE CoachID IS NOT NULL
    GROUP BY CoachID
    ORDER BY COUNT(*) DESC
);








----- chiffrement et hachage ------
-- chiffrement et hachage de CarteCredit ---

-- ===========================
-- 1️⃣ Ajouter la colonne chiffrée CarteCredit
-- ===========================
ALTER TABLE Membres
ADD CarteCredit VARBINARY(MAX);
GO

-- ===========================
-- 2️⃣ Ajouter une colonne temporaire pour stocker le numéro en clair
-- ===========================
ALTER TABLE Membres
ADD CarteCreditClair NVARCHAR(20);
GO

-- ===========================
-- 3️⃣ Générer un numéro aléatoire simple (8 chiffres)
-- ===========================
UPDATE Membres
SET CarteCreditClair = RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS NVARCHAR(8)), 8);
GO

-- ===========================
-- 4️⃣ Créer la Master Key si elle n'existe pas
-- ===========================
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MotDePasseTrèsFort123!';
END
GO

-- ===========================
-- 5️⃣ Créer la clé asymétrique si elle n'existe pas
-- ===========================
IF NOT EXISTS (SELECT * FROM sys.asymmetric_keys WHERE name = 'CarteCreditKEK')
BEGIN
    CREATE ASYMMETRIC KEY CarteCreditKEK
    WITH ALGORITHM = RSA_4096;
END
GO

-- ===========================
-- 6️⃣ Créer la clé symétrique si elle n'existe pas
-- ===========================
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'CarteCreditKey')
BEGIN
    CREATE SYMMETRIC KEY CarteCreditKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY ASYMMETRIC KEY CarteCreditKEK;
END
GO

-- ===========================
-- 7️⃣ Ouvrir la clé et chiffrer la colonne temporaire
-- ===========================
OPEN SYMMETRIC KEY CarteCreditKey
DECRYPTION BY ASYMMETRIC KEY CarteCreditKEK;
GO

UPDATE Membres
SET CarteCredit = EncryptByKey(
    Key_GUID('CarteCreditKey'),
    CONVERT(VARBINARY(MAX), CarteCreditClair) -- conversion explicite
);
GO

CLOSE SYMMETRIC KEY CarteCreditKey;
GO

-- ===========================
-- 8️⃣ Supprimer la colonne temporaire en clair
-- ===========================
ALTER TABLE Membres
DROP COLUMN CarteCreditClair;
GO






-- déchiffré CarteCredit --
OPEN SYMMETRIC KEY CarteCreditKey
DECRYPTION BY ASYMMETRIC KEY CarteCreditKEK;
GO

SELECT CONVERT(NVARCHAR(50), DecryptByKey(CarteCredit)) AS CarteCreditDechiffree
FROM Membres;
GO

CLOSE SYMMETRIC KEY CarteCreditKey;
GO





-- procédure stockée Ajoutd'un membre avec sa carte de credit --

CREATE PROCEDURE AjouterMembreAvecCarte
    @Nom NVARCHAR(50),
    @NomFamille NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NumeroCarte NVARCHAR(20);

    -- 1️⃣ Générer un numéro aléatoire simple (8 chiffres)
    SET @NumeroCarte = RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS NVARCHAR(8)), 8);

    -- 2️⃣ Ouvrir la clé symétrique
    OPEN SYMMETRIC KEY CarteCreditKey
    DECRYPTION BY ASYMMETRIC KEY CarteCreditKEK;

    -- 3️⃣ Insérer le membre et chiffrer directement le numéro
    INSERT INTO Membres (Nom,NomFamille, CarteCredit)
    VALUES (@Nom, @NomFamille, EncryptByKey(Key_GUID('CarteCreditKey'), CONVERT(VARBINARY(MAX), @NumeroCarte)));

    -- 4️⃣ Fermer la clé
    CLOSE SYMMETRIC KEY CarteCreditKey;
END
GO







