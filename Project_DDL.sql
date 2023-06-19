
-----------CREATES A NEW DATABASE------------
CREATE DATABASE Project
GO

USE Project
GO
-----------CREATES OWNERSHIP TABLE------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ownership]') AND type in (N'U'))
DROP TABLE [dbo].[Ownership]
GO

CREATE TABLE Ownership(
    Ownership_id int IDENTITY (1,1),
    Name varchar(50),
    Username varchar(50) unique not null,
    Password varbinary(64) not null,
    Email varchar(30),
    CONSTRAINT ownershipid_pk PRIMARY KEY (Ownership_id)
);

ALTER TABLE Ownership
ADD Phone varchar(20);

-----------CREATES COWORKER TABLE------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoWorker]') AND type in (N'U'))
DROP TABLE [dbo].[CoWorker]
GO

CREATE TABLE CoWorker(
    Coworker_id int IDENTITY (999,1),
    Name varchar(50),
    Username varchar(50) unique not null,
    Password varbinary(64) not null,
    Email varchar(30),
    CONSTRAINT coworkerid_pk PRIMARY KEY (Coworker_id)
);

ALTER TABLE CoWorker
ADD Phone varchar(20);


-----------CREATES PROPERTIES TABLE------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Properties]') AND type in (N'U'))
DROP TABLE [dbo].[Properties]
GO

CREATE TABLE Properties(
    Property_id int IDENTITY (825,1),
    Ownership_id int,
    Address varchar(50),
    Neighborhood varchar(50),
    Squarefeet varchar(50),
    Parking bit default 'False',
    Transportation bit default 'False',
    CONSTRAINT propertyid_pk PRIMARY KEY(Property_id),
    FOREIGN KEY (Ownership_id) REFERENCES Ownership(Ownership_id)
);


-----------CREATES WORKSPACE TABLE------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workspace]') AND type in (N'U'))
DROP TABLE [dbo].[Workspace]
GO

CREATE TABLE Workspace(
    Workspace_id int IDENTITY (310,1),
    Property_id int,
    Room varchar(50),
    Availability bit default 'True',
    Date_Availability date,
    Smoking bit default 'False',
    Capacity int,
    CONSTRAINT workspace_id PRIMARY KEY(Workspace_id),
    FOREIGN KEY (Property_id) REFERENCES Properties(Property_id)
);

-----------CREATES LEASE TABLE------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lease]') AND type in (N'U'))
DROP TABLE [dbo].[Lease]
GO

CREATE TABLE Lease(
    Lease_id int IDENTITY (5001,1),
    Price money,
    Workspace_id int,
    Owner_id int,
    Property_id int,
    Coworker_id int,
    CONSTRAINT lease_id PRIMARY KEY(Lease_id),
    FOREIGN KEY (Workspace_id) REFERENCES Workspace(Workspace_id),
    FOREIGN KEY (Owner_id) REFERENCES Ownership(Ownership_id),
    FOREIGN KEY (Property_id) REFERENCES Properties(Property_id),
    FOREIGN KEY (Coworker_id) REFERENCES CoWorker(Coworker_id)
);

ALTER TABLE Lease
ADD LeaseTerm varchar(20);





