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

