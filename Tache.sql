-- Chiffrement de la date de Naissance
    --pk? 
ALTER TABLE Entraineur
ADD DateNaisHash VARBINARY(64) NULL;


DECLARE @Nombre_row INT;
DECLARE @Compteur INT = 1;

SET @Nombre_row = (SELECT COUNT(*) FROM Entraineur);

WHILE @Compteur <= @Nombre_row
BEGIN
    UPDATE Entraineur
    SET DateNaisHash = HASHBYTES(
                        'SHA2_512',
                        CONCAT('SALT', CONVERT(NVARCHAR(50), DateNais))
                   )
    WHERE EntraineurID = @Compteur;

    SET @Compteur = @Compteur + 1;
END;

-- Requêtes --
    select * from Entraineur
    select * from Cours

-- Avoir une lite de touts les cours avec le nom de l'entraineur
    select c.NomDeCours, e.Nom
    from Entraineur e inner join Cours c on c.EntraineurID = e.EntraineurID

-- Compter le nombre de cours chaque entraineurs ensaignent
    select e.Nom ,count(*) as 'Nombre de cours'
    from Entraineur e inner join Cours c on c.EntraineurID = e.EntraineurID
    where c.EntraineurID = e.EntraineurID
    group by e.Nom

-- Trouver l'entraineur avec le plus cours 
-- Montrer les cour avec l'entraineur spécialité