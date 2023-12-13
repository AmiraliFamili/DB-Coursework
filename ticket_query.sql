-- Query 1 : displaying the relevant information about Exeter Food Festival
-- Assuming that the Child ticket is for children between 5 to 15 and Adult tickets are for Ages more than 16
-- This can be handled through website : Since a father can buy tickets for his sons and his sons wouldn't have to register with the website
CREATE VIEW ExeterFoodFestival AS
SELECT
    E.EventName AS FestivalName,
    E.EventLocation AS Venue,
    E.EventDate AS StartDate,
    DATE_ADD(E.EventDate, INTERVAL E.EventDuration HOUR) AS EndDate,
    (SELECT AvailableTickets FROM Tickets WHERE EventID = 1 AND TicketType = 'Adult') AS AdultTicketsAvailable,
    (SELECT AvailableTickets FROM Tickets WHERE EventID = 1 AND TicketType = 'Child') AS ChildTicketsAvailable
FROM Event E
WHERE E.EventName = 'Exeter Food Festival 2023';


-- Query 2 : displaying all events in "Exeter" from "2023-07-01" to "2023-07-10"
CREATE VIEW EventsInExeter AS
SELECT
    EventName,
    EventTime AS StartTime,
    DATE_ADD(EventTime, INTERVAL EventDuration HOUR) AS EndTime,
    EventDescription
FROM Event
WHERE EventLocation LIKE '%Exeter%' 
AND EventDate BETWEEN '2023-07-01' AND '2023-07-10';


-- Query 3 : displaying "bronze" ticket's price and available tickets 
CREATE VIEW BronzeTicketsPrice AS
SELECT
    TicketType,
    TicketTypePrice AS Price,
    AvailableTickets
FROM Tickets
WHERE EventID = 2 AND TicketType = 'Bronze';


-- Query 4 : displaying customers who have booked gold tickets for "Exmouth Music Festival" and the number of sold tickets for each customer
CREATE VIEW GoldTicketsBought AS
SELECT
    C.FirstName AS CustomerFirstName,
    C.LastName AS CustomerLastName,
    SUM(BT.Quantity) AS NumberOfGoldTickets
FROM Customer C
JOIN Booking B ON C.Email = B.CustomerEmail
JOIN BoughtTickets BT ON B.ReferenceCode = BT.BookingID
WHERE B.EventID = 2 AND BT.TicketType = 'Gold'
GROUP BY C.Email;



-- Query 5 : listing all the event names and the number of sold tickets 
CREATE VIEW EventsAndSoldTickets AS
SELECT
    E.EventName AS EventName,
    SUM(T.SoldTickets) AS SoldOutTickets
FROM Event E
INNER JOIN Tickets T ON E.EventID = T.EventID
GROUP BY E.EventID
ORDER BY SoldOutTickets DESC;

-- Query 6 : all relevant information that one can gain using a bookingID
CREATE VIEW BookingIDInfo AS
SELECT
    B.ReferenceCode AS BookingID,
    C.FirstName AS CustomerFirstName,
    C.LastName AS CustomerLastName,
    B.BookingTime AS BookingTime,
    B.BookingDate AS BookingDate,
    E.EventName AS EventTitle,
    B.TicketDelivery AS DeliveryOptions,
    BT.TicketType AS TicketType,
    BT.Quantity AS NumberOfTickets,
    (SELECT TotalPrice FROM Purchase WHERE BookingID = B.ReferenceCode) AS TotalPayment
FROM Booking B
JOIN Customer C ON B.CustomerEmail = C.Email
JOIN Event E ON B.EventID = E.EventID
JOIN BoughtTickets BT ON B.ReferenceCode = BT.BookingID
WHERE B.CancellationStatus = 0
ORDER By NumberOfTickets DESC;

-- Query 7 : finding the event with the maximum income so far 
CREATE VIEW MaximumIncome AS
SELECT
    E.EventName AS EventTitle,
    SUM(TotalPrice) AS TotalIncome
FROM Event E
JOIN Booking B ON E.EventID = B.EventID
JOIN Purchase P ON B.ReferenceCode = P.BookingID
GROUP BY E.EventName
ORDER BY TotalIncome DESC;




