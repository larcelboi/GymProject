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
	SELECT Nom ,NomFamille , FinMemberShip
	FROM dbo.Membres m JOIN dbo.MemberShip ms ON m.MembershipID = ms.ID
	WHERE ms.FinMemberShip <= DATEADD(MONTH, +1, GETDATE()) AND ms.FinMemberShip > GETDATE()
GO



-- Requette 3 Xavier : ---
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



-- prequete / procedure 4 --
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



-- requete 5  procedure pour désinscrire un membre d'un cours --
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



-- creation d'une vue , afficher cours le plus populaire --
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
