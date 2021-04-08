CREATE TABLE Passenger(
PassengerID int IDENTITY(1,1) PRIMARY KEY,
FName varchar(30) NOT NULL,
PreferredFName varchar(30),
LName varchar(40) NOT NULL,
Gender char(1) CHECK (Gender = 'M' OR Gender = 'F' OR Gender = 'X' OR Gender IS NULL),
Email varchar(60),
Phone char(14)
);

--limit of 5 trains, 'enforce' by only inserting 5 :)
CREATE TABLE TrainList(
TrainID int IDENTITY(1,1) PRIMARY KEY,
TrainName varchar(30)
);

--Theres no weekday datatype that stores days as their plaintext values. There is an enum that goes from 1-7, but it is inconsistent depending on different regions. Personal solution is to hardcode the string values and clean them up on insertion.
CREATE TABLE DaysAvailable(
TrainID int FOREIGN KEY (TrainID) REFERENCES TrainList,
[Day] char(9) CHECK ([Day] = 'Monday' OR [Day] = 'Tuesday' OR [Day] = 'Wednesday' OR  [Day] = 'Thursday' OR  [Day] = 'Friday' OR  [Day] = 'Saturday' OR  [Day] = 'Sunday')
);

CREATE TABLE [Routes](
RouteID int IDENTITY(1,1) PRIMARY KEY,
Source varchar(50) NOT NULL,
Destination varchar(50) NOT NULL,
Distance decimal(15,3) NULL
);

CREATE TABLE TrainRoutes(
TrainID int FOREIGN KEY (TrainID) REFERENCES TrainList,
RouteID int FOREIGN KEY (RouteID) REFERENCES [Routes]
);

CREATE TABLE FareTypes(
FareTypeID int PRIMARY KEY,
FareName varchar(30) NOT NULL,
FareAbbrev char(5)
);

CREATE TABLE TrainSeatsFareprices(
TrainID int FOREIGN KEY (TrainID) REFERENCES TrainList,
FareTypeID int FOREIGN KEY (FareTypeID) REFERENCES FareTypes
);

--Handle Waiting/Deletion of tickets with procedures. The Check is here to make sure data is clean.
CREATE TABLE Tickets(
TicketID int PRIMARY KEY,
PassengerID int FOREIGN KEY (PassengerID) REFERENCES Passenger,
TrainID int FOREIGN KEY (TrainID) REFERENCES TrainList,
RouteID int FOREIGN KEY (RouteID) REFERENCES [Routes],
FareTypeID int FOREIGN KEY (FareTypeID) REFERENCES FareTypes,
TicketStatus char(10) CHECK(TicketStatus = 'Confirmed' OR TicketStatus = 'Cancelled' OR TicketStatus = 'Waiting' OR TicketStatus = 'Processed' OR TicketStatus = 'DELETED')
);
