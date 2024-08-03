SET NOCOUNT ON

use [trek];

-- Create Login
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'DabLogin')
    CREATE LOGIN [DabLogin] WITH PASSWORD = 'P@ssw0rd!';
ALTER SERVER ROLE sysadmin ADD MEMBER [DabLogin];

-- Create User
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DabUser')
    CREATE USER [DabUser] FOR LOGIN [DabLogin];
EXEC sp_addrolemember 'db_owner', 'DabUser';

-- Drop tables in reverse order of creation due to foreign key dependencies
DROP TABLE IF EXISTS Character_Species;
DROP TABLE IF EXISTS Series_Character;
DROP TABLE IF EXISTS Character;
DROP TABLE IF EXISTS Species;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Series;

-- create tables
CREATE TABLE Series (
    Id INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL
);

CREATE TABLE Actor (
    Id INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    [BirthYear] INT NOT NULL
);

CREATE TABLE Species (
    Id INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL
);

CREATE TABLE Character (
    Id INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    ActorId INT NOT NULL,
    Stardate DECIMAL(10, 2),
    FOREIGN KEY (ActorId) REFERENCES Actor(Id)
);

CREATE TABLE Series_Character (
    SeriesId INT,
    CharacterId INT,
	Role VARCHAR(500),
    FOREIGN KEY (SeriesId) REFERENCES Series(Id),
    FOREIGN KEY (CharacterId) REFERENCES Character(Id),
    PRIMARY KEY (SeriesId, CharacterId)
);

CREATE TABLE Character_Species (
    CharacterId INT,
    SpeciesId INT,
    FOREIGN KEY (CharacterId) REFERENCES Character(Id),
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id),
    PRIMARY KEY (CharacterId, SpeciesId)
);
