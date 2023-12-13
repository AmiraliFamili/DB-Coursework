-- Update 1 : add 100 Adult tickets to "Exeter Food Festival"
START TRANSACTION;

UPDATE Tickets
SET AvailableTickets = AvailableTickets + 100
WHERE EventID = 1 AND TicketType = 'Adult';

COMMIT;


-- Update 2 : Lan Cooper books 3 tickets (2 adult and 1 child) for "Exeter Food Festival" with Voucher Code "FOOD10" using his credit card for purchase 
START TRANSACTION;

INSERT INTO Booking (ReferenceCode, EventID, CustomerEmail, TicketDelivery, BookingDate, BookingTime, CancellationStatus)
SELECT 'REF73653', 1, 'lan.Cooper@exeter.ac.uk', 'Email', CURDATE(), CURTIME(), 0;

INSERT INTO Purchase (BookingID, CardNumber, SecurityCode, ExpiryDate, CardType, TotalPrice, VoucherCode)
VALUES
    ('REF73653', '9876543219876543', '873', '2027-11-30', 'MasterCard', ((SELECT TicketTypePrice FROM Tickets WHERE EventID = 1 AND TicketType = 'Adult') * 2 +
       (SELECT TicketTypePrice FROM Tickets WHERE EventID = 1 AND TicketType = 'Child')) * 
        (1 - (SELECT Discount / 100 FROM Voucher WHERE VoucherCode = 'FOOD10' AND EventID = 1)), "FOOD10");


INSERT INTO BoughtTickets (BookingID, TicketType, Quantity)
VALUES ('REF73653', 'Adult', 2),  ('REF73653', 'Child', 1);

UPDATE Tickets
SET
    AvailableTickets = AvailableTickets - 2,
    SoldTickets = SoldTickets + 2 
WHERE EventID = 1 AND TicketType = 'Adult';

UPDATE Tickets
SET
    AvailableTickets = AvailableTickets - 1, 
    SoldTickets = SoldTickets + 1 
WHERE EventID = 1 AND TicketType = 'Child';

COMMIT;


-- Update 3 : Joe Smith Cancel's his Booking due to a change of plans 
START TRANSACTION;

INSERT INTO Cancellation (BookingID, CancellationTime, CancellationDate, Reason, RefundAmount)
VALUES ('REF34875', '14:45:00', '2023-06-30', 'Change of Plans', 50.00);

UPDATE Tickets
SET
    AvailableTickets = AvailableTickets + 3, 
    SoldTickets = SoldTickets - 3 
WHERE EventID = 2 AND TicketType = 'Bronze';

UPDATE Booking
SET CancellationStatus = 1
WHERE ReferenceCode = 'REF34875';

DELETE FROM BoughtTickets WHERE BookingID = 'REF34875';

-- we can keep the payment information or we can just refer to cancellation table 
DELETE FROM Purchase
WHERE BookingID = 'REF34875';

COMMIT;




-- Update 4 : adding the Voucher Code "SUMMER20" for the "Exmouth Music Festival" with 20% discount
START TRANSACTION;

INSERT INTO Voucher (VoucherCode, EventID, Discount)
VALUES ('SUMMER20', 2, 20.00);

COMMIT;
