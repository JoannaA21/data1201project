USE Project


-- 1. As a user, I can sign up for an account and provide my information
-- name, phone, and email). I can give my role as an owner or coworker as option.

    ----For Owners----
        INSERT INTO Ownership (Username, Name, Phone, Email, Password) VALUES ('Joanna030','Joanna', '030-0074321', 'joanna1@gmail.com', CAST('c44321e51ec184a2f739318639cec426de774451' as varbinary(MAX)))
    -- To show all the binary password: CAST it to varchar
        SELECT Ownership_id, Name, CAST(password AS varchar(MAX)) AS Password from Ownership

    ----For Coworkers---
        INSERT INTO CoWorker(Username, Name, Email, Password) VALUES ('Allan943','Allan', 'allan12@yahoo.com', CAST('d94321e51ec184a2f739318639cec426de774452' as varbinary(MAX)))
    -- To show all the binary password: CAST it to varchar
        SELECT CoWorker_id, Name, CAST(password AS varchar(64)) AS Password from CoWorker 



-- 2. As an owner, I can list a property with its address, neighborhood,
-- square feet, whether it has a parking garage, and whether it is
-- reachable by public transportation.

    -- Query the Ownership_id to specific Username since it is a unique value and can only be created as one for each user.
        INSERT INTO Properties
        VALUES  ( (SELECT Ownership_id FROM Ownership WHERE Username ='Joanna030'), 'Cornerstone','Safeway',500, 1,1);




-- 3. As an owner, I can select one of my properties and list workspaces 
-- for rent. Workspaces could be meeting rooms, private office rooms, or desks 
-- in an open work area. For each workspace, I can specify how many individuals 
-- it can seat, whether smoking is allowed or not, availability date, lease term (day, week, or month), and price.

    -- INSERT data and list the properties to workspace---
    INSERT INTO Workspace (Room, Availability, Smoking, Capacity, Property_id)
    VALUES ('Private Office Room', 1, 1, 3, (SELECT Property_id FROM Properties JOIN Ownership ON Ownership.Ownership_id = Properties.Ownership_id WHERE Username = 'Joanna030' AND Properties.Property_id = '825'))


    -- INSERT data to Lease Join to specific Username and propertys_id to have connection.
    INSERT INTO Lease (Price, LeaseTerm, Workspace_id, Owner_id, Property_id,Coworker_id)
    VALUES (30, 'Daily', (SELECT Workspace_id FROM Workspace WHERE Workspace_id = 314) , (SELECT Ownership_id FROM Ownership WHERE Username = 'Joanna030'),
    (SELECT Property_id FROM Properties JOIN Ownership ON Ownership.Ownership_id = Properties.Ownership_id WHERE Username = 'Joanna030' AND Properties.Property_id = '825'), NULL )

    -- SELECT properties of specific Username
    SELECT Property_id,
        Properties.Ownership_id,
        Address,
        Neighborhood,
        Squarefeet,
        Parking,
        Transportation
        FROM Properties
        JOIN Ownership ON Ownership.Ownership_id = Properties.Ownership_id
        WHERE Username = 'Joanna030'

    -- SELECT properties and workspace of specific Username
    SELECT Properties.Property_id,
        Properties.Ownership_id,
        Address,
        Neighborhood,
        Squarefeet,
        Parking,
        Transportation,
        Workspace_id,
        Room,
        Availability,
        Smoking,
        Capacity
        FROM Properties
        JOIN Ownership ON Ownership.Ownership_id = Properties.Ownership_id
        JOIN Workspace ON Workspace.Property_id = Properties.Property_id
        WHERE Username = 'Joanna030'

    -- SELECT from properties, workspace and lease of specific Username
    SELECT Properties.Property_id,
        Properties.Ownership_id,
        Address,
        Neighborhood,
        Squarefeet,
        Parking,
        Transportation,
        Workspace.Workspace_id,
        Room,
        Availability,
        Date_Availability,
        Smoking,
        Capacity,
        LeaseTerm,
        Price
        FROM Properties
        JOIN Ownership ON Ownership.Ownership_id = Properties.Ownership_id
        JOIN Workspace ON Workspace.Property_id = Properties.Property_id
        JOIN Lease ON Lease.Owner_id = Ownership.Ownership_id
        WHERE Ownership.Username = 'Joanna030'



-- 4. As an owner, I can modify the data for any of my properties or any of my workspaces.

    -- t1 refers to Properties table and t2 refers to Ownership table.
    UPDATE 
        t1
    SET 
        t1.Address = 'Penrith',
        t1.Neighborhood = 'Penmeadow',
        t1.Squarefeet = '600'
    FROM 
        Properties t1
        JOIN Ownership t2 ON t2.Ownership_id = t1.Ownership_id
    WHERE 
        t2.Username = 'Joanna030' AND t1.Property_id = 825;



-- 5. As an owner, I can delist or remove any of my properties or any of my workspaces from the database.

    -- Query the Property_id first to get specific value of property_id and then delist or remove the specific data
    SELECT * FROM Properties t2 JOIN Ownership t1 ON t1.Ownership_id = t2.Ownership_id WHERE t1.Username = 'Joanna030';

    -- To delist or remove specific data
    DELETE t2 
        FROM Properties t2
        JOIN Ownership t1 ON t1.Ownership_id = t2.Ownership_id
        WHERE t1.Username = 'Joanna030'
        AND t2.Property_id = 827



-- 6. As a coworker, I can search for workspaces by address, neighborhood, square feet, with/without parking, with/without public transportation,
-- number of individuals it can seat, with/without smoking, availability date, lease term, or price.

    SELECT p.Address, p.Neighborhood, p.Squarefeet, p.Parking, p.Transportation, w.Room, w.Capacity, w.Smoking, w.Availability, w.Date_Availability, l.LeaseTerm, l.Price
        FROM Workspace w
        JOIN Properties p ON p.Property_id = w.Property_id
        JOIN Lease l ON l.Property_id = w.Property_id


-- 7. As a coworker, I can select a workspace and view its details.

    -- Drop View
    DROP VIEW IF EXISTS [CoWorker_View]

    -- CREATE a new VIEW for data
    CREATE VIEW [CoWorker_View] AS
    SELECT *
    FROM Workspace

    -- Query Data for new VIEW
    SELECT * FROM [CoWorker_View] WHERE Property_id = 827;



-- 8. As a coworker, I can get the contact information of a workspace’s owner.

    SELECT o.Name, o.Email, o.Phone FROM Workspace w
    JOIN Properties p ON p.Property_id = w.Property_id
    JOIN Ownership o ON o.Ownership_id = p.Ownership_id
    WHERE w.Workspace_id = 317;