-- Creating The Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    Email VARCHAR(255) PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    ContactNumber VARCHAR(20),
    Address VARCHAR(255),
    Age INT
);

-- Creating The Event Table
CREATE TABLE IF NOT EXISTS Event (
    EventID INT NOT NULL AUTO_INCREMENT,
    EventName VARCHAR(255),
    EventDate DATE,
    EventTime TIME,
    EventDuration INT,
    EventLocation VARCHAR(255),
    EventDescription TEXT, 
    PRIMARY KEY (EventID)
);

-- Creating The Tickets Table
CREATE TABLE IF NOT EXISTS Tickets (
    EventID INT,
    TicketType VARCHAR(50),
    TicketTypePrice DECIMAL(10, 2),
    AvailableTickets INT,
    SoldTickets INT,
    PRIMARY KEY (EventID, TicketType),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

-- Creating The Voucher Table
CREATE TABLE IF NOT EXISTS  Voucher (
    VoucherCode VARCHAR(20) PRIMARY KEY,
    EventID INT,
    Discount DECIMAL(5, 2),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

-- Creating The Booking Table
CREATE TABLE IF NOT EXISTS  Booking (
    ReferenceCode VARCHAR(20) PRIMARY KEY,
    EventID INT,
    CustomerEmail VARCHAR(255),
    TicketDelivery VARCHAR(255),
    BookingDate DATE,
    BookingTime TIME,
    CancellationStatus BOOLEAN,
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (CustomerEmail) REFERENCES Customer(Email)
);

-- Creating The BoughtTickets Table
CREATE TABLE IF NOT EXISTS  BoughtTickets (
    BookingID VARCHAR(20),
    TicketType VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (BookingID, TicketType),
    FOREIGN KEY (BookingID) REFERENCES Booking(ReferenceCode)
);

-- Creating The Purchase Table
CREATE TABLE IF NOT EXISTS  Purchase (
    BookingID VARCHAR(20),
    CardNumber VARCHAR(16),
    SecurityCode VARCHAR(4),
    ExpiryDate DATE,
    CardType VARCHAR(20),
    TotalPrice DECIMAL(10, 2),
    VoucherCode VARCHAR(20),
    PRIMARY KEY (BookingID),
    FOREIGN KEY (BookingID) REFERENCES Booking(ReferenceCode),
    FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode)
);

-- Creating The Cancellation Table
CREATE TABLE IF NOT EXISTS  Cancellation (
    BookingID VARCHAR(20),
    CancellationTime TIME,
    CancellationDate DATE,
    Reason TEXT,
    RefundAmount DECIMAL(10, 2),
    PRIMARY KEY (BookingID),
    FOREIGN KEY (BookingID) REFERENCES Booking(ReferenceCode)
);

-- arbitrary data for Customer
INSERT INTO Customer (Email, FirstName, LastName, ContactNumber, Address, Age)
VALUES
    ('Joe.Smith@Gmail.com', 'Joe', 'Smith', '+44-376-847-2837', 'Exeter, High Street', 34),
    ('lan.Cooper@exeter.ac.uk', 'Ian', 'Cooper', '+44-834-823-9845', 'Exeter, Central Station', 46);

-- arbitrary data for Event
INSERT INTO Event (EventName, EventDate, EventTime, EventDuration, EventLocation, EventDescription)
VALUES
    ('Exeter Food Festival 2023', '2023-07-05', '11:30:00', 12, 'Exeter Central Park', 'A lovely food festival. Buy or register with us to sell your food. Kids have a discount!'),
    ('Exmouth Music Festival 2023', '2023-07-09', '13:00:00', 7, 'Exmouth Main Beach', 'Music means everything! Come and join this festival, bring your guitar if you can play.');

-- arbitrary data for Tickets
INSERT INTO Tickets (EventID, TicketType, TicketTypePrice, AvailableTickets, SoldTickets)
VALUES
    (1, 'Adult', 20.00, 100, 20),
    (1, 'Child', 10.00, 50, 5),
    (2, 'Gold', 30.00, 150, 42),
    (2, 'Silver', 20.00, 220, 63),
    (2, 'Bronze', 15.00, 110, 12);

-- arbitrary data for Voucher
INSERT INTO Voucher (VoucherCode, EventID, Discount)
VALUES
    ('FOOD10', 1, 10.00);

-- arbitrary data for Booking
INSERT INTO Booking (ReferenceCode, EventID, CustomerEmail, TicketDelivery, BookingDate, BookingTime, CancellationStatus)
VALUES
    ('REF12345', 1, 'Joe.Smith@Gmail.com', 'Email', '2023-06-17', '15:30:00', 1),
    ('REF34875', 2, 'Joe.Smith@Gmail.com', 'PickUp', '2023-06-25', '21:35:00', 0),
    ('REF67890', 2, 'lan.Cooper@exeter.ac.uk', 'PickUp', '2023-06-09', '18:43:05', 0);

-- arbitrary data for MultiTickets
INSERT INTO BoughtTickets (BookingID, TicketType, Quantity)
VALUES
    ('REF12345', 'Adult', 1),
    ('REF67890', 'Gold', 1),
    ('REF34875', 'Bronze', 3),
    ('REF67890', 'Silver', 3);

-- arbitrary data for Purchase
INSERT INTO Purchase (BookingID, CardNumber, SecurityCode, ExpiryDate, CardType, TotalPrice, VoucherCode)
VALUES
    ('REF12345', '1234567812345678', '467', '2026-12-31', 'Visa', 40.00, null),
    ('REF34875', '1234567812345678', '467', '2026-12-31', 'Visa', 50.00, null),
    ('REF67890', '9876543219876543', '873', '2027-11-30', 'MasterCard', 80.00, null);

-- arbitrary data for Cancellation
INSERT INTO Cancellation (BookingID, CancellationTime, CancellationDate, Reason, RefundAmount)
VALUES
    ('REF12345', '10:00:00', '2023-06-25', 'Busy Schedule', 40.00);
