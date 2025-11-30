-- Page création des utilisateurs -- -- Xavier 

-- création des logins --
CREATE LOGIN ManagerGym WITH PASSWORD = 'Password1';
CREATE LOGIN Coach WITH PASSWORD = 'Password1';

-- création des users --
USE Gym  
CREATE USER ManagerGym FOR LOGIN ManagerGym;
CREATE USER Coach FOR LOGIN Coach;
-- ajout des rôles pour ManagerGym;
ALTER ROLE db_datareader ADD MEMBER ManagerGym;
ALTER ROLE db_datawriter ADD MEMBER ManagerGym;
-- ajout rôle pour Coach --
ALTER ROLE db_datareader ADD MEMBER Coach;

