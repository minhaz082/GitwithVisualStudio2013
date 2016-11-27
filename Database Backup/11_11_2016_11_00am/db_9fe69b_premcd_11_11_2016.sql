-- phpMyAdmin SQL Dump
-- version 4.4.0
-- http://www.phpmyadmin.net
--
-- Host: MYSQL5014
-- Generation Time: Sep 10, 2016 at 08:58 PM
-- Server version: 5.6.26-log
-- PHP Version: 5.5.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db_9fe69b_premcd`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetDepositInfo`(IN `fromDate` DATETIME, IN `toDate` DATETIME)
SELECT
d.`MCD_NO`,
m.`MCDDate`, 
m.`CollectionPurpose`,
m.`PaidAmount` ,
d .`DEPOSIT_TYPE`,
d .`DEPOSIT_RECEIVE_DATE`,
d.`DepositedAmount`,
d.`BANK_CHARGE`,  
d.`OutStanding`,
m.`StationOffice`,
m.`ModeOfPayment`,
m.`ChequeNo`

FROM `depositinfo`d 
JOIN  `mcdinfo` m on d.`MCDID` = m.`MCDID`
Where d.`VoidStatus` = 1 
AND DATE_FORMAT(d.`DEPOSIT_RECEIVE_DATE`, '%Y-%m-%d')  between DATE_FORMAT(fromDate, '%Y-%m-%d')  and DATE_FORMAT(toDate, '%Y-%m-%d') ORDER BY  d.`MCD_NO`$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetDepositInfoOfficewise`(IN `fromDate` DATETIME, IN `toDate` DATETIME, IN `officeID` INT)
SELECT
d.`MCD_NO`,
m.`MCDDate`, 
m.`CollectionPurpose`,
m.`PaidAmount` ,
d .`DEPOSIT_TYPE`,
d .`DEPOSIT_RECEIVE_DATE`,
d.`DepositedAmount`,
d.`BANK_CHARGE`,  
d.`OutStanding`,
m.`StationOffice`,
m.`ModeOfPayment`,
m.`ChequeNo`

FROM `depositinfo`d 
JOIN  `mcdinfo` m on d.`MCDID` = m.`MCDID`
Where d.`VoidStatus` = 1 AND  d.`IssuerStationID`= officeID AND DATE_FORMAT(d.`DEPOSIT_RECEIVE_DATE`, '%Y-%m-%d')  between DATE_FORMAT(fromDate, '%Y-%m-%d')  AND DATE_FORMAT(toDate, '%Y-%m-%d')
ORDER BY d.`MCD_NO`$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetIncommingItemReport`(IN `purposeInput` VARCHAR(100), IN `StartRoute` VARCHAR(200), IN `fromDate` DATE, IN `toDate` DATE, IN `EndRoute` VARCHAR(200))
Begin
SELECT * FROM `mcdinfo` WHERE `CollectionPurpose`=purposeInput and `VoidStatus`=1 and `RouteEnd`=EndRoute and `RouteStart`=StartRoute and `MCDDate` between fromDate and toDate order by `FlightDate` desc;
END$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetails`()
SELECT
v.`McdDepositID`,
v.`MCD_NO`, 
v.`MCDDate`,
v.`StationOffice`,
v.`CorporateID`,
v.`CustomerName`,
v.`ModeOfPayment`,
v.`DEPOSIT_RECEIVE_DATE`,
v.`DEPOSIT_TYPE`, 
v.`DepositedAmount`,
v.`BANK_NAME`,
v.`ChequeNo`,
v.`VoidStatus`,
v.`TopUpStatus`,
v.`IssuerID`
FROM
`mcddepositinfo` v
WHERE
v.`CollectionPurpose`='agentTopup'$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetailsByMcdNo`(IN `autoSerial` VARCHAR(100))
SELECT
v.`McdDepositID`, v.`MCD_NO`, v.`MCDDate`, v.`StationOffice`, v.`CorporateID`, v.`CustomerName`, v.`ModeOfPayment`, v.`DEPOSIT_RECEIVE_DATE`, v.`DEPOSIT_TYPE`, v.`DepositedAmount`, v.`BANK_NAME`, v.`ChequeNo`, v.`VoidStatus`, v.`TopUpStatus`, v.`IssuerID`
FROM `mcddepositinfobyMCDNo` v 
WHERE v.`CollectionPurpose`='agentTopup' and v.`MCD_NO` Like autoSerial

/*
SELECT d.`DEPOSITID` as McdDepositID,d.`MCD_NO`, m.`MCDDate`,m.`StationOffice`,m.`CorporateID`,m.`CustomerName`,m.`ModeOfPayment`,d.`DEPOSIT_RECEIVE_DATE`,d.`DEPOSIT_TYPE`, d.`DepositedAmount`,d.`BANK_NAME`,m.`ChequeNo`,d.`VoidStatus`,d.`TopUpStatus`,m.`IssuerID`
FROM `depositinfo` d JOIN `mcdinfo` m on d.`MCDID` = m.`MCDID`
Where d.`MCD_NO` Like autoSerial
ORDER BY d.`MCD_NO` desc
*/$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetailsByMcdNoandUser`(IN `autoSerial` VARCHAR(100), IN `userID` INT)
SELECT
v.`McdDepositID`, v.`MCD_NO`, v.`MCDDate`, v.`StationOffice`, v.`CorporateID`, v.`CustomerName`, v.`ModeOfPayment`, v.`DEPOSIT_RECEIVE_DATE`, v.`DEPOSIT_TYPE`, v.`DepositedAmount`, v.`BANK_NAME`, v.`ChequeNo`, v.`VoidStatus`, v.`TopUpStatus`, v.`IssuerID`
FROM `mcddepositinfobyMCDNoandUser` v 
WHERE v.`CollectionPurpose`='agentTopup' 
AND v.`MCD_NO` Like autoSerial
AND v.`IssuerID`= userID




/*
SELECT d.`DEPOSITID` as McdDepositID,d.`MCD_NO`, m.`MCDDate`,m.`StationOffice`,m.`CorporateID`,m.`CustomerName`,m.`ModeOfPayment`,d.`DEPOSIT_RECEIVE_DATE`,d.`DEPOSIT_TYPE`, d.`DepositedAmount`,d.`BANK_NAME`,m.`ChequeNo`,d.`VoidStatus`,d.`TopUpStatus`,m.`IssuerID`
FROM `depositinfo` d JOIN `mcdinfo` m on d.`MCDID` = m.`MCDID`
Where d.`MCD_NO` Like autoSerial AND d.`IssuerID`=userID
ORDER BY d.`MCD_NO` desc
*/$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetailsDateandUserWise`(IN `fromDate` DATETIME, IN `toDate` DATETIME, IN `userID` INT)
SELECT
v.`McdDepositID`, v.`MCD_NO`, v.`MCDDate`, v.`StationOffice`, v.`CorporateID`, v.`CustomerName`, v.`ModeOfPayment`, v.`DEPOSIT_RECEIVE_DATE`, v.`DEPOSIT_TYPE`, v.`DepositedAmount`, v.`BANK_NAME`, v.`ChequeNo`, v.`VoidStatus`, v.`TopUpStatus`, v.`IssuerID`
FROM `mcddepositinfoDateandUserWise` v 
WHERE v.`CollectionPurpose`='agentTopup' 
AND v.`IssuerID`= userID
AND  DATE_FORMAT(v.`DEPOSIT_RECEIVE_DATE`,'%Y-%m-%d') BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')


/*
SELECT d.`DEPOSITID` as McdDepositID,d.`MCD_NO`, m.`MCDDate`,m.`StationOffice`,m.`CorporateID`,m.`CustomerName`,m.`ModeOfPayment`,d.`DEPOSIT_RECEIVE_DATE`,d.`DEPOSIT_TYPE`, d.`DepositedAmount`,d.`BANK_NAME`,m.`ChequeNo`,d.`VoidStatus`,d.`TopUpStatus`,m.`IssuerID`
FROM `depositinfo` d 
JOIN `mcdinfo` m on d.`MCDID` = m.`MCDID`
WHERE d.`IssuerID` = userID AND  DATE_FORMAT(d.`DEPOSIT_RECEIVE_DATE`,'%Y-%m-%d') BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

*/$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetailsDateWise`(IN `fromDate` DATETIME, IN `toDate` DATETIME)
SELECT
v.`McdDepositID`, v.`MCD_NO`, v.`MCDDate`, v.`StationOffice`, v.`CorporateID`, v.`CustomerName`, v.`ModeOfPayment`, v.`DEPOSIT_RECEIVE_DATE`, v.`DEPOSIT_TYPE`, v.`DepositedAmount`, v.`BANK_NAME`, v.`ChequeNo`, v.`VoidStatus`, v.`TopUpStatus`, v.`IssuerID`
FROM `mcddepositinfoDateWise` v 
WHERE v.`CollectionPurpose`='agentTopup' 
AND
DATE_FORMAT(v.`DEPOSIT_RECEIVE_DATE`,'%Y-%m-%d') BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')


/*
SELECT d.`DEPOSITID` as McdDepositID,d.`MCD_NO`, m.`MCDDate`,m.`StationOffice`,m.`CorporateID`,m.`CustomerName`,m.`ModeOfPayment`,d.`DEPOSIT_RECEIVE_DATE`,d.`DEPOSIT_TYPE`, d.`DepositedAmount`,d.`BANK_NAME`,m.`ChequeNo`,d.`VoidStatus`,d.`TopUpStatus`,m.`IssuerID` 
FROM `depositinfo` d 
JOIN `mcdinfo` m on d.`MCDID` = m.`MCDID`
WHERE DATE_FORMAT(d.`DEPOSIT_RECEIVE_DATE`,'%Y-%m-%d') BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

*/$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDDepositDetailsUserWise`(IN `userID` INT)
SELECT
v.`McdDepositID`, v.`MCD_NO`, v.`MCDDate`, v.`StationOffice`, v.`CorporateID`, v.`CustomerName`, v.`ModeOfPayment`, v.`DEPOSIT_RECEIVE_DATE`, v.`DEPOSIT_TYPE`, v.`DepositedAmount`, v.`BANK_NAME`, v.`ChequeNo`, v.`VoidStatus`, v.`TopUpStatus`, v.`IssuerID`
FROM `mcddepositinfoUserWise` v 
WHERE v.`CollectionPurpose`='agentTopup' 
AND v.`IssuerID`= userID


/*
SELECT d.`DEPOSITID` as McdDepositID,d.`MCD_NO`, m.`MCDDate`,m.`StationOffice`,m.`CorporateID`,m.`CustomerName`,m.`ModeOfPayment`,d.`DEPOSIT_RECEIVE_DATE`,d.`DEPOSIT_TYPE`, d.`DepositedAmount`,d.`BANK_NAME`,m.`ChequeNo`,d.`VoidStatus`,d.`TopUpStatus`,m.`IssuerID` 
FROM `depositinfo` d 
JOIN `mcdinfo` m on d.`MCDID` = m.`MCDID`
WHERE d. `IssuerID` = userID

*/$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDinfo`(IN `autoSerialInput` VARCHAR(50) CHARSET utf8)
BEGIN
	Select * from mcdinfo where AutoSerial = autoSerialInput ;
END$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMcdInfoReport`(IN `fromDateInput` DATE, IN `toDateInput` DATE, IN `counterInput` VARCHAR(100) CHARSET utf8, IN `purposeInput` VARCHAR(100) CHARSET utf8, IN `modePaymentInput` VARCHAR(100) CHARSET utf8, IN `userType` VARCHAR(100) CHARSET utf8)
Begin
if (counterInput = "" AND purposeInput = "" AND modePaymentInput = "" And userType ="")then
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE `CollectionPurpose` <> 'tkt_issu' AND `VoidStatus`=1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d');
else if(counterInput = "" AND purposeInput = "" AND modePaymentInput <> "" And userType ="") then
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE `CollectionPurpose` <> 'tkt_issu' AND `ModeOfPayment` = modePaymentInput AND `VoidStatus`=1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') ;
else if(counterInput = "" AND purposeInput <>"" AND modePaymentInput ="" And userType ="")then    
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `VoidStatus`=1 AND `CollectionPurpose` = purposeInput ;
else if(counterInput = "" AND purposeInput <>"" AND modePaymentInput <>"" And userType ="")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `CollectionPurpose` = purposeInput AND `VoidStatus`=1 AND `ModeOfPayment` = modePaymentInput ;
else if(counterInput <> "" AND purposeInput ="" AND modePaymentInput ="" And userType ="")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `VoidStatus`=1 ;
else if(counterInput <> "" AND purposeInput ="" AND modePaymentInput <>"" And userType ="")then    
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `ModeOfPayment` = modePaymentInput AND `VoidStatus`=1 ;   
else if(counterInput <> "" AND purposeInput <>"" AND modePaymentInput ="" And userType ="")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `CollectionPurpose` = purposeInput AND `VoidStatus`=1 ;
else if (counterInput = "" AND purposeInput = "" AND modePaymentInput = "" And userType <> "")then
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE `CollectionPurpose` <> 'tkt_issu' AND `UserName` = userType AND `VoidStatus`=1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d');
else if(counterInput = "" AND purposeInput = "" AND modePaymentInput <> "" And userType <> "") then
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE `CollectionPurpose` <> 'tkt_issu' AND `ModeOfPayment` = modePaymentInput AND `UserName` = userType AND `VoidStatus`=1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') ;
else if(counterInput = "" AND purposeInput <>"" AND modePaymentInput ="" And userType <> "")then    
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `CollectionPurpose` = purposeInput AND `UserName` = userType AND `VoidStatus`=1 ;
else if(counterInput = "" AND purposeInput <>"" AND modePaymentInput <>"" And userType <> "")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `CollectionPurpose` = purposeInput AND `ModeOfPayment` = modePaymentInput AND `VoidStatus`=1 AND `UserName` = userType ;
else if(counterInput <> "" AND purposeInput ="" AND modePaymentInput ="" And userType <> "")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `VoidStatus`=1 AND `UserName` = userType ;
else if(counterInput <> "" AND purposeInput ="" AND modePaymentInput <>"" And userType <> "")then    
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `ModeOfPayment` = modePaymentInput AND `VoidStatus`=1 AND `UserName` = userType ;   
else if(counterInput <> "" AND purposeInput <>"" AND modePaymentInput ="" And userType <> "")then     
SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `CollectionPurpose` = purposeInput AND `VoidStatus`=1 AND `UserName` = userType ;
else SELECT m.*,u.`LoginID` FROM mcdinfo m join Userinfo u on m.`IssuerID` = u.`UserID` WHERE DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDateInput, '%Y-%m-%d') AND DATE_FORMAT(toDateInput, '%Y-%m-%d') AND `CollectionPurpose` <> 'tkt_issu' AND `StationOffice` = counterInput AND `CollectionPurpose` = purposeInput AND `VoidStatus`=1 AND `ModeOfPayment` = modePaymentInput ;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
end if;
END$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDSummaryRpt`(IN `fromDate` DATETIME, IN `toDate` DATETIME, IN `counter` VARCHAR(200))
Begin
if (counter = "")then
SELECT `StationOffice`,`CollectionPurpose`, sum(`PaidAmount`) as TotalSum from `mcdinfo` where DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT( fromDate, '%Y-%m-%d') AND DATE_FORMAT(toDate, '%Y-%m-%d') group by `CollectionPurpose`,`StationOffice` order by `StationOffice`,`CollectionPurpose`;
else SELECT `StationOffice`,`CollectionPurpose`, sum(`PaidAmount`) as TotalSum from `mcdinfo` where `StationOffice` = counter AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') AND DATE_FORMAT(toDate, '%Y-%m-%d') group by `CollectionPurpose`,`StationOffice` order by `StationOffice`,`CollectionPurpose` ;
end if;
END$$

CREATE DEFINER=`9fe69b_premcd`@`%` PROCEDURE `GetMCDWideSummaryRpt`(IN `fromDate` DATETIME, IN `toDate` DATETIME, IN `counter` VARCHAR(200))
Begin
if (counter = "")then
SELECT distinct
'Barisal Airport' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Barisal Airport (BZL)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Barisal Airport (BZL)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Barisal Airport (BZL)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Barisal Airport (BZL)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Barisal Airport (BZL)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Barisal Airport (BZL)'

) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Barisal Airport (BZL)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Barisal Airport (BZL)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Barisal Airport (BZL)'

 UNION

SELECT distinct
'Chittagong Airport' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Chittagong Airport (CGP)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 and DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Chittagong Airport (CGP)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Chittagong Airport (CGP)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Chittagong Airport (CGP)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Chittagong Airport (CGP)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Chittagong Airport (CGP)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Chittagong Airport (CGP)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= 'Chittagong Airport (CGP)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Chittagong Airport (CGP)'
 
UNION 
 
SELECT distinct
"Cox's Bazar Airport" as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND  
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  "Cox's Bazar Airport (CXB)"
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  "Cox's Bazar Airport (CXB)"

UNION

SELECT distinct
'Dhaka Airport ' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND  
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Dhaka Airport (DAC)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Dhaka Airport (DAC)'

UNION

SELECT distinct
'Jessore Airport' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Jessore Airport (JSR)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Jessore Airport (JSR)'

UNION

SELECT distinct
'Rajshahi Airport' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'TicketIssue',

(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND  DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Rajshahi Airport (RJH)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Rajshahi Airport (RJH)'

UNION

SELECT distinct
'Revenue (Central)' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND  
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Revenue'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Revenue'

UNION

SELECT distinct
'Saidpur Airport' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND  DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Saidpur Airport (SPD)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Saidpur Airport (SPD)'


UNION

SELECT distinct
'Sylhet Airport ' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`=  'Sylhet Airport (ZYL)'
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`=  'Sylhet Airport (ZYL)'

UNION

SELECT distinct
'' as `StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 and DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`) as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')

) as 'TotalPaid'
FROM `mcdinfo`

;
else
SELECT DISTINCT 
`StationOffice`, 
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Issu' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'TicketIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'tkt_Exchange' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'TicketExchange',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'ebt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'EBT',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'cargo'
 AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'Cargo',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'mail_courier' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'MailCourier',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'bus_tkt' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'BusTicket',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `CollectionPurpose`= 'other' 
AND `VoidStatus` = 1 AND DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'OtherIssue',
(
SELECT cast(SUM(`PaidAmount`)as decimal(10,2)) FROM `mcdinfo` 
WHERE `VoidStatus` = 1 AND 
 DATE_FORMAT(`MCDDate`, '%Y-%m-%d') 
BETWEEN DATE_FORMAT(fromDate, '%Y-%m-%d') 
AND DATE_FORMAT(toDate, '%Y-%m-%d')
AND `StationOffice`= counter
) as 'TotalPaid'
FROM `mcdinfo`
WHERE `StationOffice`= counter
ORDER BY `StationOffice`;
end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `agencies`
--

CREATE TABLE IF NOT EXISTS `agencies` (
  `AgencyID` int(11) NOT NULL,
  `AgencyUserID` varchar(100) NOT NULL,
  `Zone` varchar(100) NOT NULL,
  `Country` varchar(100) NOT NULL,
  `Name` varchar(200) NOT NULL,
  `Setl_Currency` varchar(50) NOT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Address` varchar(500) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1914 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `agencies`
--

INSERT INTO `agencies` (`AgencyID`, `AgencyUserID`, `Zone`, `Country`, `Name`, `Setl_Currency`, `Phone`, `Address`) VALUES
(1, '10000002', 'KHL', 'BD', 'TAKEOFF TRAVELS', 'BDT', NULL, NULL),
(2, '10000003', 'DAC', 'BD', 'DRAGON BOAT TOURS & TRAVELS', 'BDT', NULL, NULL),
(3, '10000092', 'ZYL', 'BD', 'Alight Travels', 'BDT', NULL, NULL),
(4, '10000093', 'ZYL', 'BD', 'Al-Mansur Air Service Ltd', 'BDT', NULL, NULL),
(5, '10000094', 'ZYL', 'BD', 'Ashok Travels', 'BDT', NULL, NULL),
(6, '10000095', 'ZYL', 'BD', 'City Travels Tours', 'BDT', NULL, NULL),
(7, '10000096', 'ZYL', 'BD', 'Iqrah Travel & Tours', 'BDT', NULL, NULL),
(8, '10000097', 'ZYL', 'BD', 'Latif Travels (pvt) Ltd', 'BDT', NULL, NULL),
(9, '10000098', 'ZYL', 'BD', 'Alam Travels', 'BDT', NULL, NULL),
(10, '10000099', 'ZYL', 'BD', 'Hussain Overseas', 'BDT', NULL, NULL),
(11, '10000100', 'ZYL', 'BD', 'Shahi Enterprise Travel Tours', 'BDT', NULL, NULL),
(12, '10000101', 'ZYL', 'BD', 'M/S. Surma Trade Tours', 'BDT', NULL, NULL),
(13, '10000102', 'ZYL', 'BD', 'Mahfuz Travels', 'BDT', NULL, NULL),
(14, '10000103', 'ZYL', 'BD', 'Moon Travels (ZYL)', 'BDT', NULL, NULL),
(15, '10000104', 'ZYL', 'BD', 'Mouri Air Int''l', 'BDT', NULL, NULL),
(16, '10000105', 'ZYL', 'BD', 'New Modern Travels Int''l', 'BDT', NULL, NULL),
(17, '10000106', 'ZYL', 'BD', 'Nizam Trade Int''l', 'BDT', NULL, NULL),
(18, '10000107', 'ZYL', 'BD', 'Prime Express Travel Cargo', 'BDT', NULL, NULL),
(19, '10000108', 'ZYL', 'BD', 'Shamim Travels(PVT) Ltd', 'BDT', NULL, NULL),
(20, '10000109', 'ZYL', 'BD', 'Shiper Air Services', 'BDT', NULL, NULL),
(21, '10000110', 'ZYL', 'BD', 'Tashfique Travels Tours', 'BDT', NULL, NULL),
(22, '10000111', 'ZYL', 'BD', 'Travel on Air Services', 'BDT', NULL, NULL),
(23, '10000112', 'ZYL', 'BD', 'Travel West', 'BDT', NULL, NULL),
(24, '10000113', 'CGP', 'BD', 'Al-Falah Travels  Tours', 'BDT', NULL, NULL),
(25, '10000114', 'CGP', 'BD', 'Capco Aziz Limited', 'BDT', NULL, NULL),
(26, '10000115', 'CGP', 'BD', 'Expo Tours Travel', 'BDT', NULL, NULL),
(27, '10000116', 'CGP', 'BD', 'International Travel Corporation', 'BDT', NULL, NULL),
(28, '10000117', 'CGP', 'BD', 'ISKP Tours Travels', 'BDT', NULL, NULL),
(29, '10000118', 'CGP', 'BD', 'Jubilee Air International', 'BDT', NULL, NULL),
(30, '10000119', 'CGP', 'BD', 'Kagri International Travels Tours', 'BDT', NULL, NULL),
(31, '10000120', 'CGP', 'BD', 'Marine Travel Agency Limited', 'BDT', NULL, NULL),
(32, '10000121', 'CGP', 'BD', 'Nexus Tours Travels', 'BDT', NULL, NULL),
(33, '10000122', 'CGP', 'BD', 'S.M Tours Travels', 'BDT', NULL, NULL),
(34, '10000123', 'CGP', 'BD', 'Sundarban International Travel Tours', 'BDT', NULL, NULL),
(35, '10000124', 'CGP', 'BD', 'The travel World', 'BDT', NULL, NULL),
(36, '10000125', 'CGP', 'BD', 'Three Star Travels', 'BDT', NULL, NULL),
(37, '10000126', 'DAC', 'BD', 'Travel International Limited', 'BDT', NULL, NULL),
(38, '10000127', 'CGP', 'BD', 'World Link Tours Travels', 'BDT', NULL, NULL),
(39, '10000128', 'DAC', 'BD', 'ABN TRAVELS LTD.', 'BDT', NULL, NULL),
(40, '10000129', 'DAC', 'BD', 'Adriyan Tours Travels', 'BDT', NULL, NULL),
(41, '10000130', 'DAC', 'BD', 'Advance Travel Planner Ltd', 'BDT', NULL, NULL),
(42, '10000131', 'DAC', 'BD', 'AIRPATH AVIATION', 'BDT', NULL, NULL),
(43, '10000132', 'DAC', 'BD', 'Airspan Ltd', 'BDT', NULL, NULL),
(44, '10000133', 'DAC', 'BD', 'ANANASH TRAVEL RELATED SVC', 'BDT', NULL, NULL),
(45, '10000134', 'DAC', 'BD', 'Anowar Tours Tvl. Ltd.', 'BDT', NULL, NULL),
(46, '10000135', 'DAC', 'BD', 'Best Fly International', 'BDT', NULL, NULL),
(47, '10000136', 'DAC', 'BD', 'Bextrade Limited', 'BDT', NULL, NULL),
(48, '10000137', 'DAC', 'BD', 'Business Travel Services', 'BDT', NULL, NULL),
(49, '10000138', 'DAC', 'BD', 'Camair Travels Ltd', 'BDT', NULL, NULL),
(50, '10000139', 'DAC', 'BD', 'Career Travel International Ltd.', 'BDT', NULL, NULL),
(51, '10000140', 'DAC', 'BD', 'Crystal Way Travels', 'BDT', NULL, NULL),
(52, '10000141', 'DAC', 'BD', 'Dhaka Holidays', 'BDT', NULL, NULL),
(53, '10000142', 'DAC', 'BD', 'Elegant Air Travels', 'BDT', NULL, NULL),
(54, '10000143', 'DAC', 'BD', 'Executive Tours Travels', 'BDT', NULL, NULL),
(55, '10000144', 'DAC', 'BD', 'Flyer Travels Express', 'BDT', NULL, NULL),
(56, '10000145', 'DAC', 'BD', 'Flyers Zone (BD) Ltd', 'BDT', NULL, NULL),
(57, '10000146', 'DAC', 'BD', 'Galaxy Travel International', 'BDT', NULL, NULL),
(58, '10000147', 'DAC', 'BD', 'Glide Tours Travels Ltd', 'BDT', NULL, NULL),
(59, '10000148', 'DAC', 'BD', 'GoldAir Enterprises Ltd', 'BDT', NULL, NULL),
(60, '10000149', 'DAC', 'BD', 'Grand Tours Travels', 'BDT', NULL, NULL),
(61, '10000150', 'DAC', 'BD', 'Hajee Air Travels', 'BDT', NULL, NULL),
(62, '10000151', 'DAC', 'BD', 'Happy Air Tours Travels', 'BDT', NULL, NULL),
(63, '10000152', 'DAC', 'BD', 'Icon Travel Tours', 'BDT', NULL, NULL),
(64, '10000153', 'DAC', 'BD', 'International Travel link', 'BDT', NULL, NULL),
(65, '10000154', 'DAC', 'BD', 'Jaas Travel Corporation Ltd', 'BDT', NULL, NULL),
(66, '10000155', 'DAC', 'BD', 'Jahanara Travels Tours', 'BDT', NULL, NULL),
(67, '10000156', 'DAC', 'BD', 'Janata Travels Ltd.', 'BDT', NULL, NULL),
(68, '10000157', 'DAC', 'BD', 'Jumla Tours Travels', 'BDT', NULL, NULL),
(69, '10000158', 'DAC', 'BD', 'Labib Hajj Overseas', 'BDT', NULL, NULL),
(70, '10000159', 'DAC', 'BD', 'Lakshmipur Air Travels', 'BDT', NULL, NULL),
(71, '10000160', 'DAC', 'BD', 'Mars Universal Limited', 'BDT', NULL, NULL),
(72, '10000161', 'DAC', 'BD', 'Mountain club Tours Travels', 'BDT', NULL, NULL),
(73, '10000162', 'DAC', 'BD', 'MP TRAVELS LIMITED', 'BDT', NULL, NULL),
(74, '10000163', 'DAC', 'BD', 'NEW DISCOVERY TOURS AND LOGISTICS', 'BDT', NULL, NULL),
(75, '10000164', 'DAC', 'BD', 'Overseas Link Ltd.', 'BDT', NULL, NULL),
(76, '10000165', 'DAC', 'BD', 'Race Aviation Services', 'BDT', NULL, NULL),
(77, '10000166', 'DAC', 'BD', 'Runway Travel & Tours', 'BDT', NULL, NULL),
(78, '10000167', 'DAC', 'BD', 'S.D.S Tours Travels', 'BDT', NULL, NULL),
(79, '10000168', 'DAC', 'BD', 'Sam Travel Tours', 'BDT', NULL, NULL),
(80, '10000169', 'DAC', 'BD', 'Sanjila Muntasir Travels Tours Ltd.', 'BDT', NULL, NULL),
(81, '10000170', 'DAC', 'BD', 'Shams Air Tours Travels', 'BDT', NULL, NULL),
(82, '10000171', 'DAC', 'BD', 'Silicon Trade Wind Tours Travels Limited', 'BDT', NULL, NULL),
(83, '10000172', 'DAC', 'BD', 'Sky Holidays', 'BDT', NULL, NULL),
(84, '10000173', 'DAC', 'BD', 'Sky Touch Aviation', 'BDT', NULL, NULL),
(85, '10000174', 'DAC', 'BD', 'Sky Travels', 'BDT', NULL, NULL),
(86, '10000175', 'DAC', 'BD', 'Sundarban Tourism Plus', 'BDT', NULL, NULL),
(87, '10000176', 'DAC', 'BD', 'Sunshine Travel Air International', 'BDT', NULL, NULL),
(88, '10000177', 'DAC', 'BD', 'SYR Tours ,Travels Counselors', 'BDT', NULL, NULL),
(89, '10000178', 'DAC', 'BD', 'T.S. Aviation', 'BDT', NULL, NULL),
(90, '10000179', 'DAC', 'BD', 'Talon Corporation Ltd', 'BDT', NULL, NULL),
(91, '10000180', 'DAC', 'BD', 'Travel Channel', 'BDT', NULL, NULL),
(92, '10000181', 'DAC', 'BD', 'Travel Shop Ltd.', 'BDT', NULL, NULL),
(93, '10000182', 'DAC', 'BD', 'Travel Solution', 'BDT', NULL, NULL),
(94, '10000183', 'DAC', 'BD', 'Travel Wise Ltd', 'BDT', NULL, NULL),
(95, '10000184', 'DAC', 'BD', 'Trips Advisor', 'BDT', NULL, NULL),
(96, '10000185', 'DAC', 'BD', 'UniRoute Overseas Tour Ltd', 'BDT', NULL, NULL),
(97, '10000186', 'DAC', 'BD', 'Vision Travel Consultant', 'BDT', NULL, NULL),
(98, '10000187', 'DAC', 'BD', 'World Travel Services', 'BDT', NULL, NULL),
(99, '10000188', 'CXB', 'BD', 'Cox''s Bazar Tours Travels', 'BDT', NULL, NULL),
(100, '10000189', 'CXB', 'BD', 'Universal Tourism Travels', 'BDT', NULL, NULL),
(101, '10000270', 'DAC', 'BD', 'USBA Holidays', 'BDT', NULL, NULL),
(102, '10000271', 'DAC', 'BD', 'ONE TRAVELS', 'BDT', NULL, NULL),
(103, '10000272', 'DAC', 'BD', 'BLUEWAYS TOURS  TRAVELS', 'BDT', NULL, NULL),
(104, '10000273', 'DAC', 'BD', 'INTERNATIONAL TRAVEL CORPORATION LTD', 'BDT', NULL, NULL),
(105, '10000274', 'DAC', 'BD', 'PARTS AVIATIONS LTD.', 'BDT', NULL, NULL),
(106, '10000275', 'DAC', 'BD', 'WINUX TRAVELS', 'BDT', NULL, NULL),
(107, '10000277', 'CGP', 'BD', 'BE FRESH', 'BDT', NULL, NULL),
(108, '10000278', 'CGP', 'BD', 'TUSTI ENTERPRISE', 'BDT', NULL, NULL),
(109, '10000279', 'CGP', 'BD', 'UNION TOURS AND TRAVELS', 'BDT', NULL, NULL),
(110, '10000283', 'CGP', 'BD', 'AL SIRAJ TRAVELS CGP', 'BDT', NULL, NULL),
(111, '10000284', 'CGP', 'BD', 'RAFI INTERNATIONAL TRAVELS AND TOURS', 'BDT', NULL, NULL),
(112, '10000285', 'CGP', 'BD', 'JF BANGADESH LIMITED (CGP)', 'BDT', NULL, NULL),
(113, '10000334', 'DAC', 'BD', 'COR Shahjahan Shajedur', 'BDT', NULL, NULL),
(114, '10000341', 'DAC', 'BD', 'COR Shekh Saadi Shishir', 'BDT', NULL, NULL),
(115, '10000344', 'DAC', 'BD', 'COR Mokhlesur Rahman', 'BDT', NULL, NULL),
(116, '10000345', 'KHL', 'BD', 'Cheap Mega Travel Pty Ltd.', 'BDT', NULL, NULL),
(117, '10000358', 'KHL', 'BD', 'AIR INFORMATION', 'BDT', NULL, NULL),
(118, '10000363', 'KHL', 'BD', 'BISMILLAH AVIATON & TOURS', 'BDT', NULL, NULL),
(119, '10000369', 'KHL', 'BD', 'CLOUDY TRAVELS', 'BDT', NULL, NULL),
(120, '10000381', 'JSR', 'BD', 'COCKPIT TRAVEL', 'BDT', NULL, NULL),
(121, '10000382', 'KHL', 'BD', 'FAST AIR PLAN TOURS', 'BDT', NULL, NULL),
(122, '10000383', 'JSR', 'BD', 'FLIGHT CENTER', 'BDT', NULL, NULL),
(123, '10000384', 'KHL', 'BD', 'FLYWELL TRAVELS', 'BDT', NULL, NULL),
(124, '10000389', 'KHL', 'BD', 'KHULNA TRAVEL SERVICE', 'BDT', NULL, NULL),
(125, '10000393', 'JSR', 'BD', 'HASNAT & BROTHERS TOURS & TRAVELS', 'BDT', NULL, NULL),
(126, '10000394', 'KHL', 'BD', 'NEXT TRIP', 'BDT', NULL, NULL),
(127, '10000395', 'KHL', 'BD', 'PRIME AVIATION', 'BDT', NULL, NULL),
(128, '10000468', 'DAC', 'BD', 'D.B.H International', 'BDT', NULL, NULL),
(129, '10000483', 'DAC', 'BD', 'Ace aviation Services Ltd', 'BDT', NULL, NULL),
(130, '10000489', 'DAC', 'BD', 'Travelpro TRS Ltd', 'BDT', NULL, NULL),
(131, '10000529', 'DAC', 'BD', 'Dynamic Travels', 'BDT', NULL, NULL),
(132, '10000533', 'DAC', 'BD', 'Saimon Overseas Ltd', 'BDT', NULL, NULL),
(133, '10000538', 'JSR', 'BD', 'Sky Jet', 'BDT', NULL, NULL),
(134, '10000584', 'DAC', 'BD', 'SABRINA TRAVELS AND TOURS', 'BDT', NULL, NULL),
(135, '10000586', 'DAC', 'BD', 'AeroWing Aviation', 'BDT', NULL, NULL),
(136, '10000588', 'DAC', 'BD', 'Mak Travel & Tours', 'BDT', NULL, NULL),
(137, '10000592', 'DAC', 'BD', 'Deen Travels', 'BDT', NULL, NULL),
(138, '10000599', 'DAC', 'BD', 'Al-Fahad Air Ticketing', 'BDT', NULL, NULL),
(139, '10000608', 'DAC', 'BD', 'M.R Travels International', 'BDT', NULL, NULL),
(140, '10000609', 'DAC', 'BD', 'Emporio Travels (Pvt) Ltd', 'BDT', NULL, NULL),
(141, '10000610', 'DAC', 'BD', 'Shanjari Travels & Tours', 'BDT', NULL, NULL),
(142, '10000613', 'DAC', 'BD', 'Darwish Travels', 'BDT', NULL, NULL),
(143, '10000614', 'DAC', 'BD', 'Travelscene Limited', 'BDT', NULL, NULL),
(144, '10000615', 'DAC', 'BD', 'Regency Travels Limited', 'BDT', NULL, NULL),
(145, '10000619', 'DAC', 'BD', 'DNOVO Travels Agency', 'BDT', NULL, NULL),
(146, '10000623', 'DAC', 'BD', 'Travels Online', 'BDT', NULL, NULL),
(147, '10000624', 'DAC', 'BD', 'Ground Zero Limited', 'BDT', NULL, NULL),
(148, '10000625', 'DAC', 'BD', 'Travel Smart Limited', 'BDT', NULL, NULL),
(149, '10000626', 'DAC', 'BD', 'Air Vision Travels & Tours', 'BDT', NULL, NULL),
(150, '10000629', 'DAC', 'BD', 'Easy Going (pvt.) Ltd', 'BDT', NULL, NULL),
(151, '10000633', 'DAC', 'BD', 'Travel & Tours Solutions Ltd', 'BDT', NULL, NULL),
(152, '10000636', 'DAC', 'BD', 'Bengal Travel & Tours Ltd.', 'BDT', NULL, NULL),
(153, '10000639', 'DAC', 'BD', 'Discovery Tours & Logistic', 'BDT', NULL, NULL),
(154, '10000640', 'DAC', 'BD', 'Glocom Travels & Tours', 'BDT', NULL, NULL),
(155, '10000644', 'DAC', 'BD', 'Dana Aviation Limited', 'BDT', NULL, NULL),
(156, '10000651', 'DAC', 'BD', 'Conveyor Aviation & Adventures', 'BDT', NULL, NULL),
(157, '10000652', 'DAC', 'BD', 'Creative Tours & Travels', 'BDT', NULL, NULL),
(158, '10000654', 'DAC', 'BD', 'Sadman Holidays', 'BDT', NULL, NULL),
(159, '10000656', 'DAC', 'BD', 'Atlantis Travel Point', 'BDT', NULL, NULL),
(160, '10000665', 'CGP', 'BD', 'A.Intraco (BD) Ltd', 'BDT', NULL, NULL),
(161, '10000667', 'CGP', 'BD', 'Air Bangla Tours & Travels', 'BDT', NULL, NULL),
(162, '10000676', 'CGP', 'BD', 'Air Bangla International Ltd.', 'BDT', NULL, NULL),
(163, '10000677', 'CGP', 'BD', 'Alif Travel', 'BDT', NULL, NULL),
(164, '10000678', 'CGP', 'BD', 'Al-Safa International', 'BDT', NULL, NULL),
(165, '10000679', 'CGP', 'BD', 'Enani Travels & Tours', 'BDT', NULL, NULL),
(166, '10000680', 'CGP', 'BD', 'HRC Travels Limited', 'BDT', NULL, NULL),
(167, '10000682', 'CGP', 'BD', 'Regency Air International Travel', 'BDT', NULL, NULL),
(168, '10000683', 'CGP', 'BD', 'Standard Travel International', 'BDT', NULL, NULL),
(169, '10000686', 'CGP', 'BD', 'Gulf Travels', 'BDT', NULL, NULL),
(170, '10000709', 'DAC', 'BD', 'COR Md. Shahnewaz', 'BDT', NULL, NULL),
(171, '10000720', 'CXB', 'BD', 'Inani Aviation CXB', 'BDT', NULL, NULL),
(172, '10000741', 'DAC', 'BD', 'COR M I Moeen', 'BDT', NULL, NULL),
(173, '10000744', 'DAC', 'BD', 'COR Md. Kaisar', 'BDT', NULL, NULL),
(174, '10000750', 'DAC', 'BD', 'COR Taukir Ahmed', 'BDT', NULL, NULL),
(175, '10000752', 'SPD', 'BD', '12 Event Travels & Tours', 'BDT', NULL, NULL),
(176, '10000788', 'DAC', 'BD', 'Maverick Tours  Travels', 'BDT', NULL, NULL),
(177, '10000793', 'DAC', 'BD', 'AEROLINE TOURS  TRAVELS  LTD', 'BDT', NULL, NULL),
(178, '10000821', 'CGP', 'BD', 'Keya Enterprise', 'BDT', NULL, NULL),
(179, '10000830', 'DAC', 'BD', 'COR Md Saidur Rahman', 'BDT', NULL, NULL),
(180, '10000832', 'DAC', 'BD', 'COR Md Mofazzal Hossain', 'BDT', NULL, NULL),
(181, '10000833', 'DAC', 'BD', 'COR Md Abdul Mottalib', 'BDT', NULL, NULL),
(182, '10000834', 'DAC', 'BD', 'COR Md Mobarak Hossain', 'BDT', NULL, NULL),
(183, '10000837', 'DAC', 'BD', 'COR Md Abu Rahat Rony', 'BDT', NULL, NULL),
(184, '10000852', 'DAC', 'BD', 'Oracle Travels Limited', 'BDT', NULL, NULL),
(185, '10000862', 'CGP', 'BD', 'Multi Trade Corporation', 'BDT', NULL, NULL),
(186, '10000876', 'DAC', 'BD', 'Unique Tours and Travels', 'BDT', NULL, NULL),
(187, '10000877', 'DAC', 'BD', 'Travel Zoo Bangladesh', 'BDT', NULL, NULL),
(188, '10000921', 'CGP', 'BD', 'Wings Classic Tours and Travels', 'BDT', NULL, NULL),
(189, '10000925', 'CGP', 'BD', 'Popular Travel  and Tours', 'BDT', NULL, NULL),
(190, '10000928', 'CGP', 'BD', 'Concorde International', 'BDT', NULL, NULL),
(191, '10000933', 'CGP', 'BD', 'MK Travels and Tours', 'BDT', NULL, NULL),
(192, '10000936', 'CGP', 'BD', 'Move On', 'BDT', NULL, NULL),
(193, '10000947', 'DAC', 'BD', 'Travel Wise Ltd', 'BDT', NULL, NULL),
(194, '10000962', 'CGP', 'BD', 'CORP Multi Trade Corporation', 'BDT', NULL, NULL),
(195, '10001044', 'DAC', 'BD', 'Rainbow Holidays Ltd.', 'BDT', NULL, NULL),
(196, '10001074', 'SPD', 'BD', 'Eque Travels Int''l', 'BDT', NULL, NULL),
(197, '10001077', 'DAC', 'BD', 'Horizon Express Limited', 'BDT', NULL, NULL),
(198, '10001091', 'ZYL', 'BD', 'Babor Travels', 'BDT', NULL, NULL),
(199, '10001098', 'DAC', 'BD', 'Urich Travels  Tours Limited', 'BDT', NULL, NULL),
(200, '10001100', 'ZYL', 'BD', 'Jatrik Travels', 'BDT', NULL, NULL),
(201, '10001144', 'DAC', 'BD', 'HPS Travelss and Tours', 'BDT', NULL, NULL),
(202, '10001160', 'DAC', 'BD', 'Lucky Travels  and Tourism', 'BDT', NULL, NULL),
(203, '10001258', 'CGP', 'BD', 'Al-Bakar Travels', 'BDT', NULL, NULL),
(204, '10001261', 'CGP', 'BD', 'Anita Travels', 'BDT', NULL, NULL),
(205, '10001263', 'CGP', 'BD', 'Golden Travels', 'BDT', NULL, NULL),
(206, '10001270', 'CGP', 'BD', 'N.K. Travels & Tours', 'BDT', NULL, NULL),
(207, '10001282', 'CGP', 'BD', 'Rani Travels & tours', 'BDT', NULL, NULL),
(208, '10001285', 'CGP', 'BD', 'Sigma Aviation Service', 'BDT', NULL, NULL),
(209, '10001291', 'DAC', 'BD', 'Travel Guide Ltd', 'BDT', NULL, NULL),
(210, '10001293', 'CGP', 'BD', 'ZAM ZAM International', 'BDT', NULL, NULL),
(211, '10001294', 'CGP', 'BD', 'Welcome Air International', 'BDT', NULL, NULL),
(212, '10001299', 'DAC', 'BD', 'Easy Way Travels', 'BDT', NULL, NULL),
(213, '10001319', 'DAC', 'BD', 'Millennium AirServices', 'BDT', NULL, NULL),
(214, '10001380', 'DAC', 'BD', 'Bismillah Aviation', 'BDT', NULL, NULL),
(215, '10001385', 'DAC', 'BD', 'Five Star Holidays', 'BDT', NULL, NULL),
(216, '10001511', 'DAC', 'BD', 'Smoothway Oceanic Services Ltd', 'BDT', NULL, NULL),
(217, '10001516', 'DAC', 'BD', 'BAEI Travels and Tours Ltd', 'BDT', NULL, NULL),
(218, '10001525', 'DAC', 'BD', 'Sunspread Travels Ltd', 'BDT', NULL, NULL),
(219, '10001533', 'DAC', 'BD', 'Travel Times Ltd', 'BDT', NULL, NULL),
(220, '10001538', 'DAC', 'BD', 'Bd Trans World Aviation', 'BDT', NULL, NULL),
(221, '10001616', 'DAC', 'BD', 'Dahmashi Tours and Travels Ltd', 'BDT', NULL, NULL),
(222, '10001638', 'DAC', 'BD', 'Dhaka Air International', 'BDT', NULL, NULL),
(223, '10001642', 'DAC', 'BD', 'Travelers World', 'BDT', NULL, NULL),
(224, '10001648', 'DAC', 'BD', 'Lexus Tours & Travels', 'BDT', NULL, NULL),
(225, '10001660', 'DAC', 'BD', 'Airstar Travels and Tours Ltd', 'BDT', NULL, NULL),
(226, '10001671', 'DAC', 'BD', 'Travelmart bd', 'BDT', NULL, NULL),
(227, '10001675', 'DAC', 'BD', 'Travel House Limited', 'BDT', NULL, NULL),
(228, '10001692', 'DAC', 'BD', 'Rajbithi Travels Limited', 'BDT', NULL, NULL),
(229, '10001729', 'DAC', 'BD', 'Star Holidays', 'BDT', NULL, NULL),
(230, '10001755', 'DAC', 'BD', 'Ultimate Air International', 'BDT', NULL, NULL),
(231, '10002062', 'DAC', 'BD', 'Al Borak International', 'BDT', NULL, NULL),
(232, '10002100', 'DAC', 'BD', 'Lord Travels', 'BDT', NULL, NULL),
(233, '10002141', 'DAC', 'BD', 'Sunshine Express Travel Inc.', 'BDT', NULL, NULL),
(234, '10002178', 'DAC', 'BD', 'Century Tarvel Services Ltd', 'BDT', NULL, NULL),
(235, '10002182', 'DAC', 'BD', 'Green Red Travels', 'BDT', NULL, NULL),
(236, '10002194', 'DAC', 'BD', 'Meraj Travel Agency', 'BDT', NULL, NULL),
(237, '10002199', 'DAC', 'BD', 'Versatile Travels & Tours Ltd.', 'BDT', NULL, NULL),
(238, '10002204', 'DAC', 'BD', 'WW Avion Tours & Travels Ltd.', 'BDT', NULL, NULL),
(239, '10002218', 'JSR', 'BD', 'Jess Tours and Travels', 'BDT', NULL, NULL),
(240, '10002241', 'DAC', 'BD', 'COR Credit Realization Department 1', 'BDT', NULL, NULL),
(241, '10002244', 'DAC', 'BD', 'COR Credit Realization Department 2', 'BDT', NULL, NULL),
(242, '10002322', 'DAC', 'BD', 'Universal Overseas Ltd', 'BDT', NULL, NULL),
(243, '10002550', 'CGP', 'BD', 'Global Guide Tours & Trvl', 'BDT', NULL, NULL),
(244, '10002553', 'CGP', 'BD', 'Sonar Bangla Travel & Tour', 'BDT', NULL, NULL),
(245, '10002557', 'CGP', 'BD', 'Mohim Overseas Limited', 'BDT', NULL, NULL),
(246, '10002567', 'ZYL', 'BD', 'Central Air Service', 'BDT', NULL, NULL),
(247, '10002569', 'ZYL', 'BD', 'M/S Arifa Enterprise Travel Agent', 'BDT', NULL, NULL),
(248, '10002587', 'ZYL', 'BD', 'Prantik Travels', 'BDT', NULL, NULL),
(249, '10002589', 'ZYL', 'BD', 'Popular Air Service', 'BDT', NULL, NULL),
(250, '10002593', 'ZYL', 'BD', 'Taj Travels & Tours', 'BDT', NULL, NULL),
(251, '10002609', 'ZYL', 'BD', 'Quddus Travels', 'BDT', NULL, NULL),
(252, '10002623', 'ZYL', 'BD', 'Suma International Services', 'BDT', NULL, NULL),
(253, '10002628', 'ZYL', 'BD', 'Ababil Air Service', 'BDT', NULL, NULL),
(254, '10002630', 'ZYL', 'BD', 'Surma Travels (PVT) Ltd.', 'BDT', NULL, NULL),
(255, '10002633', 'ZYL', 'BD', 'National Travels', 'BDT', NULL, NULL),
(256, '10002637', 'ZYL', 'BD', 'Al Ihsan Travels', 'BDT', NULL, NULL),
(257, '10002654', 'DAC', 'BD', 'World Link Airways Ltd', 'BDT', NULL, NULL),
(258, '10002657', 'DAC', 'BD', 'Padma Travels Ltd', 'BDT', NULL, NULL),
(259, '10002660', 'DAC', 'BD', 'Express Holidays', 'BDT', NULL, NULL),
(260, '10002672', 'DAC', 'BD', 'Lumex International Ltd', 'BDT', NULL, NULL),
(261, '10002678', 'DAC', 'BD', 'Arnim Holidays', 'BDT', NULL, NULL),
(262, '10002681', 'DAC', 'BD', 'Aziza Tours and Travels Ltd', 'BDT', NULL, NULL),
(263, '10002688', 'DAC', 'BD', 'Victory Travels Limited', 'BDT', NULL, NULL),
(264, '10002839', 'DAC', 'BD', 'Northern Air Ltd', 'BDT', NULL, NULL),
(265, '10002840', 'DAC', 'BD', 'Flight Centre Ltd (DAC)', 'BDT', NULL, NULL),
(266, '10002869', 'DAC', 'BD', 'GH Holidays', 'BDT', NULL, NULL),
(267, '10002875', 'DAC', 'BD', 'Travel Care Travels and Tours', 'BDT', NULL, NULL),
(268, '10002934', 'KHL', 'BD', 'The Desh Bidesh Tours and Travels', 'BDT', NULL, NULL),
(269, '10003042', 'DAC', 'BD', 'Global Tours and Travels', 'BDT', NULL, NULL),
(270, '10003118', 'DAC', 'BD', 'Flyer''s Tours and Travels', 'BDT', NULL, NULL),
(271, '10003132', 'DAC', 'BD', 'Travel Counsel', 'BDT', NULL, NULL),
(272, '10003136', 'DAC', 'BD', 'makemytrip.bd', 'BDT', NULL, NULL),
(273, '10003160', 'ZYL', 'BD', 'Fast Travelinks', 'BDT', NULL, NULL),
(274, '10003226', 'DAC', 'BD', 'Travel Wizard Ltd', 'BDT', NULL, NULL),
(275, '10003244', 'DAC', 'BD', 'Cosmos Holiday', 'BDT', NULL, NULL),
(276, '10003247', 'DAC', 'BD', 'Miaz Tours and Travels', 'BDT', NULL, NULL),
(277, '10003271', 'DAC', 'BD', 'Blue Bird Tours and Travels', 'BDT', NULL, NULL),
(278, '10003273', 'DAC', 'BD', 'City Air International', 'BDT', NULL, NULL),
(279, '10003311', 'CGP', 'BD', 'Fortune Tours and Travels', 'BDT', NULL, NULL),
(280, '10003313', 'CGP', 'BD', 'Safa Travels', 'BDT', NULL, NULL),
(281, '10003315', 'CGP', 'BD', 'Nahar International', 'BDT', NULL, NULL),
(282, '10003317', 'CGP', 'BD', 'Hasnain Travels and Tours', 'BDT', NULL, NULL),
(283, '10003321', 'DAC', 'BD', 'Skylight Corporation', 'BDT', NULL, NULL),
(284, '10003324', 'DAC', 'BD', 'Urbi Travels & Tours', 'BDT', NULL, NULL),
(285, '10003326', 'DAC', 'BD', 'Orbit Bangla Tours and Travels', 'BDT', NULL, NULL),
(286, '10003680', 'DAC', 'BD', 'Madina Air Travels Ltd', 'BDT', NULL, NULL),
(287, '10003719', 'DAC', 'BD', 'Navigator', 'BDT', NULL, NULL),
(288, '10003721', 'DAC', 'BD', 'Touriffy Travels', 'BDT', NULL, NULL),
(289, '10003725', 'DAC', 'BD', 'Bonanza Travels Ltd', 'BDT', NULL, NULL),
(290, '10004709', 'DAC', 'BD', 'VIP Travel Services', 'BDT', NULL, NULL),
(291, '10004727', 'SPD', 'BD', 'Orittry Tours and Travels', 'BDT', NULL, NULL),
(292, '10005108', 'DAC', 'BD', 'Monika Travels International Ltd', 'BDT', NULL, NULL),
(293, '10005332', 'DAC', 'BD', 'Kazi Air International (Pvt) Ltd.', 'BDT', NULL, NULL),
(294, '10005343', 'DAC', 'BD', 'Farid Travels & Tour', 'BDT', NULL, NULL),
(295, '10005540', 'DAC', 'BD', 'Trans National Travel Ltd', 'BDT', NULL, NULL),
(296, '10005548', 'DAC', 'BD', 'Z. H. Tours & Travels', 'BDT', NULL, NULL),
(297, '10005673', 'DAC', 'BD', 'FARIDPUR TRAVELS and TOURS', 'BDT', NULL, NULL),
(298, '10005720', 'DAC', 'BD', 'Irving Aviation', 'BDT', NULL, NULL),
(299, '10005749', 'DAC', 'BD', 'S International Travel Point', 'BDT', NULL, NULL),
(300, '10005755', 'DAC', 'BD', 'Sky Navigator', 'BDT', NULL, NULL),
(301, '10006207', 'DAC', 'BD', 'VISA GETWAY', 'BDT', NULL, NULL),
(302, '10006749', 'DAC', 'BD', 'COR SAIFUL ISLAM', 'BDT', NULL, NULL),
(303, '10006819', 'DAC', 'BD', 'Al Siraj Travels (DAC)', 'BDT', NULL, NULL),
(304, '10006831', 'DAC', 'BD', 'Heritage Air Express', 'BDT', NULL, NULL),
(305, '10006836', 'DAC', 'BD', 'Aviation Tours & Travels Ltd', 'BDT', NULL, NULL),
(306, '10006839', 'DAC', 'BD', 'Dutch Tours And Travels', 'BDT', NULL, NULL),
(307, '10006901', 'DAC', 'BD', 'Mahima Tours & Travels', 'BDT', NULL, NULL),
(308, '10006903', 'DAC', 'BD', 'Just Holidays', 'BDT', NULL, NULL),
(309, '10006906', 'DAC', 'BD', 'Classic Air Services', 'BDT', NULL, NULL),
(310, '10006912', 'DAC', 'BD', 'Dolphin Tours', 'BDT', NULL, NULL),
(311, '10006914', 'DAC', 'BD', 'Shaptamohe Air Express', 'BDT', NULL, NULL),
(312, '10006917', 'DAC', 'BD', 'Sunway Tours & Travels', 'BDT', NULL, NULL),
(313, '10006920', 'DAC', 'BD', 'ARS Air International', 'BDT', NULL, NULL),
(314, '10006923', 'DAC', 'BD', 'The Pacific Garden International', 'BDT', NULL, NULL),
(315, '10006925', 'DAC', 'BD', 'Holiday Club Tours & Travels', 'BDT', NULL, NULL),
(316, '10007311', 'CGP', 'BD', 'CORP Abul Khair Group', 'BDT', NULL, NULL),
(317, '10007540', 'DAC', 'BD', 'CORP First Security Islami Bank', 'BDT', NULL, NULL),
(318, '10007548', 'DAC', 'BD', 'Air Trip International Ltd', 'BDT', NULL, NULL),
(319, '10007552', 'DAC', 'BD', 'Virtual Air Travels & Tours', 'BDT', NULL, NULL),
(320, '10007601', 'DAC', 'BD', 'CORP Mutual Trust Bank Ltd.', 'BDT', NULL, NULL),
(321, '10007611', 'DAC', 'BD', 'Fariha Travels Int''l', 'BDT', NULL, NULL),
(322, '10007613', 'DAC', 'BD', 'Al-Arafat Travel & Tours (Pvt) Ltd', 'BDT', NULL, NULL),
(323, '10007645', 'DAC', 'BD', 'Fly N Go Ltd', 'BDT', NULL, NULL),
(324, '10007657', 'DAC', 'BD', 'CORP USAID Agro-Inputs Project', 'BDT', NULL, NULL),
(325, '10007763', 'CGP', 'BD', 'Seri Mechan', 'BDT', NULL, NULL),
(326, '10007841', 'DAC', 'BD', 'Terrestrial Aviation and services Ltd', 'BDT', NULL, NULL),
(327, '10008191', 'DAC', 'BD', 'Samiha Aviation', 'BDT', NULL, NULL),
(328, '10008211', 'DAC', 'BD', 'Shahid Travel & Tours', 'BDT', NULL, NULL),
(329, '10008296', 'DAC', 'BD', 'Oryx Air Services', 'BDT', NULL, NULL),
(330, '10008298', 'DAC', 'BD', 'Bengal Air Sevices', 'BDT', NULL, NULL),
(331, '10008302', 'DAC', 'BD', 'Mims Travels & Tours Ltd', 'BDT', NULL, NULL),
(332, '10008306', 'DAC', 'BD', 'Seven Colors Travel', 'BDT', NULL, NULL),
(333, '10008333', 'CGP', 'BD', 'Chittagong Air Express', 'BDT', NULL, NULL),
(334, '10008386', 'CGP', 'BD', 'Miftah Travel & Tours', 'BDT', NULL, NULL),
(335, '10008745', 'DAC', 'BD', 'HAC Enterprise Ltd', 'BDT', NULL, NULL),
(336, '10008747', 'SPD', 'BD', 'Leisure Tours & Travels Ltd.', 'BDT', NULL, NULL),
(337, '10008892', 'DAC', 'BD', 'J.N Tours & Travels', 'BDT', NULL, NULL),
(338, '10008893', 'DAC', 'BD', 'World Aviation', 'BDT', NULL, NULL),
(339, '10008898', 'DAC', 'BD', 'G Travels', 'BDT', NULL, NULL),
(340, '10008900', 'SPD', 'BD', 'Galib International', 'BDT', NULL, NULL),
(341, '10008904', 'DAC', 'BD', 'Talha Tour and Travels', 'BDT', NULL, NULL),
(342, '10009692', 'DAC', 'BD', 'Patwary Trade International & Travel Agent', 'BDT', NULL, NULL),
(343, '10009696', 'DAC', 'BD', 'Ramna Air International', 'BDT', NULL, NULL),
(344, '10009706', 'DAC', 'BD', 'Baridhara Overseas Ltd', 'BDT', NULL, NULL),
(345, '10009842', 'JSR', 'BD', 'Air Sketch', 'BDT', NULL, NULL),
(346, '10009847', 'CGP', 'BD', 'Moon Travels (CGP)', 'BDT', NULL, NULL),
(347, '10010143', 'DAC', 'BD', 'KEARI Tours & Services Ltd', 'BDT', NULL, NULL),
(348, '10010156', 'CGP', 'BD', 'MACRO BANGLA TOURS & TRAVELS', 'BDT', NULL, NULL),
(349, '10010273', 'DAC', 'BD', 'Universal Travels & Commerce', 'BDT', NULL, NULL),
(350, '10010315', 'CGP', 'BD', 'CORP PACIFIC JEANS LTD', 'BDT', NULL, NULL),
(351, '10010324', 'DAC', 'BD', 'CORP Water Aid Bangladesh', 'BDT', NULL, NULL),
(352, '10010627', 'DAC', 'BD', 'CORP Solidaridad Network Asia', 'BDT', NULL, NULL),
(353, '10010768', 'CGP', 'BD', 'Mazumder International', 'BDT', NULL, NULL),
(354, '10010772', 'CGP', 'BD', 'Hatim Overseas', 'BDT', NULL, NULL),
(355, '10011013', 'DAC', 'BD', 'CORP Dutch-Bangla Pack Limited', 'BDT', NULL, NULL),
(356, '10011016', 'ZYL', 'BD', 'CORP Rose View Hotel', 'BDT', NULL, NULL),
(357, '10011053', 'DAC', 'BD', 'Valencia Air Travels & Tours', 'BDT', NULL, NULL),
(358, '10011055', 'DAC', 'BD', 'Welcome Travel Agents Ltd.', 'BDT', NULL, NULL),
(359, '10011057', 'DAC', 'BD', 'Icon Air Express', 'BDT', NULL, NULL),
(360, '10011349', 'DAC', 'BD', 'PMB Tours & Travels', 'BDT', NULL, NULL),
(361, '10011825', 'DAC', 'BD', 'Linkers Travels(Pvt)Ltd.', 'BDT', NULL, NULL),
(362, '10011827', 'DAC', 'BD', 'United Travels', 'BDT', NULL, NULL),
(363, '10011832', 'DAC', 'BD', 'Route Finders Tours & Travels', 'BDT', NULL, NULL),
(364, '10011833', 'DAC', 'BD', 'Relax Air', 'BDT', NULL, NULL),
(365, '10011837', 'DAC', 'BD', 'New line Travel International', 'BDT', NULL, NULL),
(366, '10011858', 'CGP', 'BD', 'CORP Denim Expert', 'BDT', NULL, NULL),
(367, '10011862', 'CGP', 'BD', 'CORP Regency Garments', 'BDT', NULL, NULL),
(368, '10011866', 'DAC', 'BD', 'Sureswar Travels', 'BDT', NULL, NULL),
(369, '10012353', 'DAC', 'BD', 'K.M.M Air International', 'BDT', NULL, NULL),
(370, '10012356', 'CGP', 'BD', 'CORP Ak Khan', 'BDT', NULL, NULL),
(371, '10012471', 'DAC', 'BD', 'Paradise Travels Limited', 'BDT', NULL, NULL),
(372, '10012487', 'DAC', 'BD', 'Nitol Tours & Travels', 'BDT', NULL, NULL),
(373, '10012489', 'DAC', 'BD', 'Guardian Travels & Cargo Ltd.', 'BDT', NULL, NULL),
(374, '10012493', 'DAC', 'BD', 'Skyscape Aviation', 'BDT', NULL, NULL),
(375, '10012643', 'KHL', 'BD', 'AMDA TOURS & TRAVELS', 'BDT', NULL, NULL),
(376, '10012725', 'DAC', 'BD', 'Twin Travels & Tours', 'BDT', NULL, NULL),
(377, '10012913', 'DAC', 'BD', 'Travel Adventures', 'BDT', NULL, NULL),
(378, '10012944', 'DAC', 'BD', 'Straight Way Tours & Travels', 'BDT', NULL, NULL),
(379, '10012945', 'DAC', 'BD', 'A Z Air Services', 'BDT', NULL, NULL),
(380, '10013015', 'DAC', 'BD', 'CORP IDLC FINANCE LIMITED', 'BDT', NULL, NULL),
(381, '10013394', 'JSR', 'BD', 'Air Line', 'BDT', NULL, NULL),
(382, '10013413', 'DAC', 'BD', 'Nusaibah Trade Corporation (NTC)', 'BDT', NULL, NULL),
(383, '10013425', 'DAC', 'BD', 'Antarik Travel International', 'BDT', NULL, NULL),
(384, '10013430', 'DAC', 'BD', 'BD Explore Tours & Travels', 'BDT', NULL, NULL),
(385, '10013508', 'DAC', 'BD', 'Amira Travels & Tours', 'BDT', NULL, NULL),
(386, '10013820', 'CGP', 'BD', 'VROMON', 'BDT', NULL, NULL),
(387, '10013823', 'DAC', 'BD', 'CORP Sea Pearl Beach Resort & SPA Ltd', 'BDT', NULL, NULL),
(388, '10013847', 'DAC', 'BD', 'Axomo Travel', 'BDT', NULL, NULL),
(389, '10014174', 'CGP', 'BD', 'EDEN TRAVELS & TOURS', 'BDT', NULL, NULL),
(390, '10014406', 'DAC', 'BD', 'April Tourism', 'BDT', NULL, NULL),
(391, '10014407', 'DAC', 'BD', 'Freelance Holidays', 'BDT', NULL, NULL),
(392, '10014431', 'DAC', 'BD', 'Kabir Travel Services', 'BDT', NULL, NULL),
(393, '10014440', 'DAC', 'BD', 'Smart Work Travel & Tours', 'BDT', NULL, NULL),
(394, '10014666', 'DAC', 'BD', 'Caravan Mode Ltd', 'BDT', NULL, NULL),
(395, '10014669', 'DAC', 'BD', 'AIR COX''S INTERNATIONAL LTD.', 'BDT', NULL, NULL),
(396, '10015183', 'CGP', 'BD', 'RS TRAVELS', 'BDT', NULL, NULL),
(397, '10015221', 'ZYL', 'BD', 'SELIM AIR TRAVELS', 'BDT', NULL, NULL),
(398, '10015222', 'ZYL', 'BD', 'SYLHET TRAVEL SERVICES', 'BDT', NULL, NULL),
(399, '10015224', 'ZYL', 'BD', 'BRITAIN OVERSEAS', 'BDT', NULL, NULL),
(400, '10015500', 'DAC', 'BD', 'Nirjhor Tours & Travels', 'BDT', NULL, NULL),
(401, '10015808', 'JSR', 'BD', 'Trisa Air Travel', 'BDT', NULL, NULL),
(402, '10015812', 'RJH', 'BD', 'AT-Tyaara Travels International', 'BDT', NULL, NULL),
(403, '10015816', 'DAC', 'BD', 'Tune Aviation Ltd.', 'BDT', NULL, NULL),
(404, '10016128', 'DAC', 'BD', 'Travel world Limited', 'BDT', NULL, NULL),
(405, '10016130', 'DAC', 'BD', 'Vision Tours & Travels Ltd', 'BDT', NULL, NULL),
(406, '10016136', 'DAC', 'BD', 'Mas Travels & Air International', 'BDT', NULL, NULL),
(407, '10016139', 'DAC', 'BD', 'Logos Air Express', 'BDT', NULL, NULL),
(408, '10016149', 'DAC', 'BD', 'Travel Land International', 'BDT', NULL, NULL),
(409, '10016201', 'CGP', 'BD', 'Kazi Travels & Tours', 'BDT', NULL, NULL),
(410, '10016224', 'DAC', 'BD', 'S.A. Travel & Tours', 'BDT', NULL, NULL),
(411, '10016819', 'DAC', 'BD', 'S.N Travels', 'BDT', NULL, NULL),
(412, '10017050', 'DAC', 'BD', 'MCO Travels & Tours', 'BDT', NULL, NULL),
(413, '10017591', 'DAC', 'BD', 'Nodi Tours & Travels', 'BDT', NULL, NULL),
(414, '10017595', 'DAC', 'BD', 'Pinnacle Travels Limited', 'BDT', NULL, NULL),
(415, '10017969', 'ZYL', 'BD', 'Tanvir Trade International', 'BDT', NULL, NULL),
(416, '10018100', 'DAC', 'BD', 'Air Concern International', 'BDT', NULL, NULL),
(417, '10018105', 'DAC', 'BD', 'Apsawra Tours & Travels', 'BDT', NULL, NULL),
(418, '10018106', 'DAC', 'BD', 'C Sharp', 'BDT', NULL, NULL),
(419, '10018235', 'DAC', 'BD', 'Anha Travels', 'BDT', NULL, NULL),
(420, '10018239', 'JSR', 'BD', 'Molla Travels & Air Service', 'BDT', NULL, NULL),
(421, '10018370', 'CXB', 'BD', 'CORP Ocean Paradise Hotel & Resort', 'BDT', NULL, NULL),
(422, '10018751', 'DAC', 'BD', 'Rubi Travel & Tours', 'BDT', NULL, NULL),
(423, '10018883', 'SPD', 'BD', 'Washington Travel International', 'BDT', NULL, NULL),
(424, '10019042', 'DAC', 'BD', 'The Bengal Tours Ltd', 'BDT', NULL, NULL),
(425, '10019234', 'SPD', 'BD', 'Fly Twenty Four Air Travels', 'BDT', NULL, NULL),
(426, '10019241', 'KHL', 'BD', 'Tour Plan', 'BDT', NULL, NULL),
(427, '10019251', 'DAC', 'BD', 'M. M. R. Aviation', 'BDT', NULL, NULL),
(428, '10019407', 'RJH', 'BD', 'TRAVEL CONSULTANT BD', 'BDT', NULL, NULL),
(429, '10019424', 'DAC', 'BD', 'SKY World Travel & Tours', 'BDT', NULL, NULL),
(430, '10019661', 'SPD', 'BD', 'R and R Traders', 'BDT', NULL, NULL),
(431, '10019677', 'DAC', 'BD', 'Escape Means Limited', 'BDT', NULL, NULL),
(432, '10019743', 'DAC', 'BD', 'Kushiara Travels & Tours Ltd', 'BDT', NULL, NULL),
(433, '10019911', 'DAC', 'BD', 'Gemini Travels Ltd', 'BDT', NULL, NULL),
(434, '10020483', 'SPD', 'BD', 'Mahin Travels & Tours', 'BDT', NULL, NULL),
(435, '10020559', 'DAC', 'BD', 'Shanji Tours & Travels', 'BDT', NULL, NULL),
(436, '10020715', 'DAC', 'BD', 'CORP Hotel The Cox Today', 'BDT', NULL, NULL),
(437, '10020724', 'DAC', 'BD', 'The Guide Tours Ltd.', 'BDT', NULL, NULL),
(438, '10020862', 'CGP', 'BD', 'CORP Hotel Saintmartin Ltd', 'BDT', NULL, NULL),
(439, '10021059', 'DAC', 'BD', 'Silver Sky', 'BDT', NULL, NULL),
(440, '10021061', 'DAC', 'BD', 'Dream Journeys', 'BDT', NULL, NULL),
(441, '10021080', 'ZYL', 'BD', 'Universal Travels (ZYL)', 'BDT', NULL, NULL),
(442, '10021285', 'SPD', 'BD', 'SARKER TRAVELS', 'BDT', NULL, NULL),
(443, '10021296', 'CGP', 'BD', 'MAA TRAVELS', 'BDT', NULL, NULL),
(444, '10021309', 'CGP', 'BD', 'Air Fly International', 'BDT', NULL, NULL),
(445, '10021312', 'CGP', 'BD', 'Ticket Zone', 'BDT', NULL, NULL),
(446, '10021953', 'DAC', 'BD', 'Nimbus Travels Limited', 'BDT', NULL, NULL),
(447, '10022105', 'DAC', 'BD', 'Locarno Tours & Travels', 'BDT', NULL, NULL),
(448, '10022106', 'DAC', 'BD', 'Dynamic Tours & Travels', 'BDT', NULL, NULL),
(449, '10022107', 'DAC', 'BD', 'Darbar Travel & Tours', 'BDT', NULL, NULL),
(450, '10024865', 'DAC', 'BD', 'Aviator Limited', 'BDT', NULL, NULL),
(451, '10025105', 'SPD', 'BD', 'Sheetal Tours & Travels', 'BDT', NULL, NULL),
(452, '10025551', 'DAC', 'BD', 'Orion Travels Ltd.', 'BDT', NULL, NULL),
(453, '10025553', 'DAC', 'BD', 'MM Air Express', 'BDT', NULL, NULL),
(454, '10025555', 'DAC', 'BD', 'CORP ITS Labtest Bangladesh Ltd.', 'BDT', NULL, NULL),
(455, '10025873', 'DAC', 'BD', 'CORP ACI Motors Limited', 'BDT', NULL, NULL),
(456, '10026434', 'JSR', 'BD', 'Aero Plane Tours and Travels', 'BDT', NULL, NULL),
(457, '10026556', 'DAC', 'BD', 'Fiad Tours & Travels', 'BDT', NULL, NULL),
(458, '10026916', 'ZYL', 'BD', 'Quddus Air International', 'BDT', NULL, NULL),
(459, '10027114', 'DAC', 'BD', 'CORP Ezzy services & Resource Management limited', 'BDT', NULL, NULL),
(460, '10027131', 'SPD', 'BD', 'Alif Tour & Travels', 'BDT', NULL, NULL),
(461, '10027794', 'DAC', 'BD', 'Air Home Tours & Travels', 'BDT', NULL, NULL),
(462, '10027860', 'DAC', 'BD', 'CORP Diaz Hotel & Resorts', 'BDT', NULL, NULL),
(463, '10027891', 'DAC', 'BD', 'AKIJ AIR', 'BDT', NULL, NULL),
(464, '10027901', 'DAC', 'BD', 'Mount 2 Ocean Travel & Tours', 'BDT', NULL, NULL),
(465, '10027903', 'DAC', 'BD', 'Trip Maker', 'BDT', NULL, NULL),
(466, '10027906', 'DAC', 'BD', 'Apollo Holidays', 'BDT', NULL, NULL),
(467, '10027908', 'RJH', 'BD', 'Sarker Air Express and Travels', 'BDT', NULL, NULL),
(468, '10027910', 'CGP', 'BD', 'Tamim Tours & Travels', 'BDT', NULL, NULL),
(469, '10028289', 'DAC', 'BD', 'CORP Crown Cement', 'BDT', NULL, NULL),
(470, '10028515', 'DAC', 'BD', 'Olympic Travel Bangladesh Ltd.', 'BDT', NULL, NULL),
(471, '10028522', 'UK', 'UK', 'SYLHET TRAVEL SERVICES (UK)', 'GBP', NULL, NULL),
(472, '10028605', 'UK', 'UK', 'TRAVEL LINK WORLDWIDE LTD', 'GBP', NULL, NULL),
(473, '10030325', 'DAC', 'BD', 'Amin Trade International', 'BDT', NULL, NULL),
(474, '10030326', 'DAC', 'BD', 'Nova Tours and Travels', 'BDT', NULL, NULL),
(475, '10030327', 'DAC', 'BD', 'East West Travels and Tours (pvt) Ltd.', 'BDT', NULL, NULL),
(476, '10030328', 'DAC', 'BD', 'Dhaka Nationals Travels Ltd.', 'BDT', NULL, NULL),
(477, '10030385', 'DAC', 'BD', 'Cosmic Air International', 'BDT', NULL, NULL),
(478, '10030386', 'DAC', 'BD', 'Amazing Tours', 'BDT', NULL, NULL),
(479, '10031748', 'DAC', 'BD', 'Kasba Travels & Tours', 'BDT', NULL, NULL),
(480, '10031751', 'DAC', 'BD', 'Nahar Air International', 'BDT', NULL, NULL),
(481, '10031755', 'DAC', 'BD', 'M Ali International Travels', 'BDT', NULL, NULL),
(482, '10031756', 'DAC', 'BD', 'Jinghua Bangla Tours & Travels Ltd.', 'BDT', NULL, NULL),
(483, '10031767', 'DAC', 'BD', 'Luner Aviation & Services Ltd.', 'BDT', NULL, NULL),
(484, '10031980', 'DAC', 'BD', 'CORP United Hospital Limited', 'BDT', NULL, NULL),
(485, '10032112', 'SPD', 'BD', 'Araf Travel and Tours', 'BDT', NULL, NULL),
(486, '10032113', 'CGP', 'BD', 'Eastern Travels', 'BDT', NULL, NULL),
(487, '10032612', 'DAC', 'BD', 'MS Protiva Tours & Travels', 'BDT', NULL, NULL),
(488, '10032672', 'DAC', 'BD', 'Babus Salam Sky Airways', 'BDT', NULL, NULL),
(489, '10032679', 'DAC', 'BD', 'Eastern Tours & Travels', 'BDT', NULL, NULL),
(490, '10032680', 'DAC', 'BD', 'Gravity Travel Agency', 'BDT', NULL, NULL),
(491, '10032683', 'DAC', 'BD', 'Planet Travels Ltd', 'BDT', NULL, NULL),
(492, '10032687', 'CGP', 'BD', 'Silvia Travel International', 'BDT', NULL, NULL),
(493, '10032790', 'DAC', 'BD', 'Hakil Tours & Travels', 'BDT', NULL, NULL),
(494, '10033153', 'SPD', 'BD', 'Alam Tours and Travels', 'BDT', NULL, NULL),
(495, '10033196', 'SPD', 'BD', 'Rabi Tours and Travels', 'BDT', NULL, NULL),
(496, '10033220', 'DAC', 'BD', 'T.S Corporation', 'BDT', NULL, NULL),
(497, '10033858', 'DAC', 'BD', 'Fast Tours & Events', 'BDT', NULL, NULL),
(498, '10033859', 'SPD', 'BD', 'Sreyoshi Tours & Travels', 'BDT', NULL, NULL),
(499, '10033873', 'UK', 'UK', 'Imran Travels', 'GBP', NULL, NULL),
(500, '10033876', 'UK', 'UK', 'Sonargaon Travels', 'GBP', NULL, NULL),
(501, '10033878', 'UK', 'UK', 'Milfa Travels', 'GBP', NULL, NULL),
(502, '10033880', 'UK', 'UK', 'Front Line Travel &Tours Ltd', 'GBP', NULL, NULL),
(503, '10033881', 'UK', 'UK', 'UK Bangla Travel', 'GBP', NULL, NULL),
(504, '10033956', 'UK', 'UK', 'Shukriya Travels LTd', 'GBP', NULL, NULL),
(505, '10034053', 'ZYL', 'BD', 'Khaja Air Liner', 'BDT', NULL, NULL),
(506, '10034057', 'DAC', 'BD', 'Absolute Ambitions Travel Services', 'BDT', NULL, NULL),
(507, '10034069', 'DAC', 'BD', 'Raiyan Travels International', 'BDT', NULL, NULL),
(508, '10034070', 'DAC', 'BD', 'Ali Air Travels & Tours', 'BDT', NULL, NULL),
(509, '10034073', 'CGP', 'BD', 'Mani Travels & Tours', 'BDT', NULL, NULL),
(510, '10034104', 'DAC', 'BD', 'S.Sarder Travel Agency', 'BDT', NULL, NULL),
(511, '10034683', 'DAC', 'BD', 'Grasp International Ltd.', 'BDT', NULL, NULL),
(512, '10034688', 'DAC', 'BD', 'Silkways Tours & Travels Ltd.', 'BDT', NULL, NULL),
(513, '10034764', 'DAC', 'BD', 'Aamar Tour Ltd.', 'BDT', NULL, NULL),
(514, '10034784', 'CGP', 'BD', 'Hamim International Travel & Tours', 'BDT', NULL, NULL),
(515, '10034925', 'DAC', 'BD', 'CORP CIMMYT', 'BDT', NULL, NULL),
(516, '10034969', 'UK', 'UK', 'Foysal Visa Services & Travel', 'GBP', NULL, NULL),
(517, '10034974', 'UK', 'UK', 'Key Connexions', 'GBP', NULL, NULL),
(518, '10035107', 'DAC', 'BD', 'Bluebell Travel & Tours Ltd.', 'BDT', NULL, NULL),
(519, '10035705', 'DAC', 'BD', 'CORP Gemcon Group', 'BDT', NULL, NULL),
(520, '10035786', 'DAC', 'BD', 'Lifestyle solutions Ltd', 'BDT', NULL, NULL),
(521, '10036260', 'DAC', 'BD', 'Premier Consultants', 'BDT', NULL, NULL),
(522, '10036329', 'DAC', 'BD', 'CORP Exim Bank Limited', 'BDT', NULL, NULL),
(523, '10036342', 'DAC', 'BD', 'Rokon Tourism (pvt) Ltd.', 'BDT', NULL, NULL),
(524, '10036682', 'UK', 'UK', 'Labbaik Travel & Excursions', 'GBP', NULL, NULL),
(525, '10036809', 'DAC', 'BD', 'CORP Youngone Hi-Tech Sportswear Ind. Ltd.', 'BDT', NULL, NULL),
(526, '10037176', 'CGP', 'BD', 'Asian Tourism International', 'BDT', NULL, NULL),
(527, '10037181', 'CGP', 'BD', 'Shah Amanat Hajj Kafela Travel & Tours', 'BDT', NULL, NULL),
(528, '10037184', 'SPD', 'BD', 'Lucky Tour & Travels', 'BDT', NULL, NULL),
(529, '10037457', 'DAC', 'BD', 'Bikrampur Tours & Travels', 'BDT', NULL, NULL),
(530, '10037633', 'DAC', 'BD', 'Euro Link Council', 'BDT', NULL, NULL),
(531, '10037699', 'CGP', 'BD', 'Al Maqam Travels', 'BDT', NULL, NULL),
(532, '10037703', 'CGP', 'BD', 'Sabuj Bangla International', 'BDT', NULL, NULL),
(533, '10037711', 'CGP', 'BD', 'Thasin Travels', 'BDT', NULL, NULL),
(534, '10037713', 'DAC', 'BD', 'Al Maqum Overseas &Travels', 'BDT', NULL, NULL),
(535, '10037717', 'CGP', 'BD', 'Al Mansur Travels', 'BDT', NULL, NULL),
(536, '10037721', 'CGP', 'BD', 'Hayat International Travel & Tours', 'BDT', NULL, NULL),
(537, '10037724', 'CGP', 'BD', 'One Star Travels', 'BDT', NULL, NULL),
(538, '10037730', 'CGP', 'BD', 'Hoque International', 'BDT', NULL, NULL),
(539, '10037735', 'CGP', 'BD', 'Royal Air Service', 'BDT', NULL, NULL),
(540, '10037738', 'CGP', 'BD', 'AR Aviation &Tourism', 'BDT', NULL, NULL),
(541, '10037746', 'DAC', 'BD', 'Sky Station', 'BDT', NULL, NULL),
(542, '10037755', 'CGP', 'BD', 'JBC International', 'BDT', NULL, NULL),
(543, '10037757', 'CGP', 'BD', 'Sandwip Overseas', 'BDT', NULL, NULL),
(544, '10037767', 'CGP', 'BD', 'Al Riyadh Travels', 'BDT', NULL, NULL),
(545, '10037769', 'CGP', 'BD', 'Best Bangla Travels & Tours', 'BDT', NULL, NULL),
(546, '10037772', 'CGP', 'BD', 'Noori Travels & Tours', 'BDT', NULL, NULL),
(547, '10037776', 'ZYL', 'BD', 'Sky Link Travels', 'BDT', NULL, NULL),
(548, '10037869', 'DAC', 'BD', 'H.I.S Travel Limited', 'BDT', NULL, NULL),
(549, '10037874', 'KHL', 'BD', 'Plane Station', 'BDT', NULL, NULL),
(550, '10037877', 'SPD', 'BD', 'North West Tours & Travels', 'BDT', NULL, NULL),
(551, '10037879', 'ZYL', 'BD', 'Nibras International Travels', 'BDT', NULL, NULL),
(552, '10037881', 'ZYL', 'BD', 'Kajal Travels & Commerce', 'BDT', NULL, NULL),
(553, '10037882', 'ZYL', 'BD', 'Al Shorifine Travels & Tours', 'BDT', NULL, NULL),
(554, '10037885', 'ZYL', 'BD', 'Fatiha Travels', 'BDT', NULL, NULL),
(555, '10037891', 'ZYL', 'BD', 'Alom Overseas', 'BDT', NULL, NULL),
(556, '10037894', 'ZYL', 'BD', 'Royal Airlines Express', 'BDT', NULL, NULL),
(557, '10037897', 'ZYL', 'BD', 'Salim Travels Service', 'BDT', NULL, NULL),
(558, '10037900', 'ZYL', 'BD', 'Jonaki International Pvt. Ltd.', 'BDT', NULL, NULL),
(559, '10037902', 'ZYL', 'BD', 'Alpha Travel International', 'BDT', NULL, NULL),
(560, '10037905', 'ZYL', 'BD', 'Atlantic Travels International', 'BDT', NULL, NULL),
(561, '10037906', 'ZYL', 'BD', 'Kalam Travels', 'BDT', NULL, NULL),
(562, '10037916', 'DAC', 'BD', 'Travel Wing Limited', 'BDT', NULL, NULL),
(563, '10038074', 'ZYL', 'BD', 'CORP Nirvana Inn', 'BDT', NULL, NULL),
(564, '10038080', 'CGP', 'BD', 'CORP Premier 1888 Ltd.', 'BDT', NULL, NULL),
(565, '10039065', 'UK', 'UK', 'Aerolex (UK) Lmited', 'GBP', NULL, NULL),
(566, '10039068', 'UK', 'UK', 'Flight Concept', 'GBP', NULL, NULL),
(567, '10039385', 'DAC', 'BD', 'Fly Home Travels (PVT.) Ltd.', 'BDT', NULL, NULL),
(568, '10039561', 'CGP', 'BD', 'Al Abrar  Tours & Travels', 'BDT', NULL, NULL),
(569, '10039566', 'DAC', 'BD', 'Bay Air International Ltd.', 'BDT', NULL, NULL),
(570, '10039573', 'DAC', 'BD', 'York Holidays', 'BDT', NULL, NULL),
(571, '10039576', 'DAC', 'BD', 'Citycom International Travel Agency.', 'BDT', NULL, NULL),
(572, '10039580', 'DAC', 'BD', 'Pritom Travels', 'BDT', NULL, NULL),
(573, '10039582', 'CGP', 'BD', 'United Tours & Travel (CGP).', 'BDT', NULL, NULL),
(574, '10039583', 'ZYL', 'BD', 'Bangladesh Overseas Services', 'BDT', NULL, NULL),
(575, '10039586', 'ZYL', 'BD', 'Star Travel &Tourism', 'BDT', NULL, NULL),
(576, '10039589', 'ZYL', 'BD', 'Asha Travels', 'BDT', NULL, NULL),
(577, '10039592', 'CGP', 'BD', 'Overseas Air International.', 'BDT', NULL, NULL),
(578, '10039594', 'CGP', 'BD', 'Air Channel', 'BDT', NULL, NULL),
(579, '10039595', 'DAC', 'BD', 'Lee Air Service', 'BDT', NULL, NULL),
(580, '10039598', 'CGP', 'BD', 'Gaoucia Travels', 'BDT', NULL, NULL),
(581, '10039602', 'CGP', 'BD', 'Digital Globe.', 'BDT', NULL, NULL),
(582, '10040225', 'DAC', 'BD', 'CORP National Center For State Courts (NCSC)', 'BDT', NULL, NULL),
(583, '10040252', 'SPD', 'BD', 'Asia Tours and Travels', 'BDT', NULL, NULL),
(584, '10041266', 'DAC', 'BD', 'Bangla Air Service Tours & Travels', 'BDT', NULL, NULL),
(585, '10041270', 'DAC', 'BD', 'United Tours & Travels (DAC).', 'BDT', NULL, NULL),
(586, '10041283', 'DAC', 'BD', 'Mobin Overseas.', 'BDT', NULL, NULL),
(587, '10041289', 'DAC', 'BD', 'Noor E Madina Travels.', 'BDT', NULL, NULL),
(588, '10041296', 'DAC', 'BD', 'Reliance Tours & Travels.', 'BDT', NULL, NULL),
(589, '10041578', 'DAC', 'BD', 'Anfal International Limited.', 'BDT', NULL, NULL),
(590, '10041693', 'DAC', 'BD', 'CORP Banglalink Digital Communications Ltd.', 'BDT', NULL, NULL),
(591, '10041980', 'CGP', 'BD', 'Ihram Hazz Kafela', 'BDT', NULL, NULL),
(592, '10041984', 'CGP', 'BD', 'Al Multazim Hajj Kafela Travel & Tours', 'BDT', NULL, NULL),
(593, '10041988', 'CGP', 'BD', 'Dream Sky International', 'BDT', NULL, NULL),
(594, '10041989', 'CGP', 'BD', 'Al Haramain Travels & Hajj Agents', 'BDT', NULL, NULL),
(595, '10041991', 'CGP', 'BD', 'Chattagram Travels', 'BDT', NULL, NULL),
(596, '10042167', 'DAC', 'BD', 'Muna Travels and Tours Litd.', 'BDT', NULL, NULL),
(597, '10042169', 'DAC', 'BD', 'S.K Air Travels Ltd.', 'BDT', NULL, NULL),
(598, '10042171', 'DAC', 'BD', 'Sarina Travel Logistics Event Solution Ltd.', 'BDT', NULL, NULL),
(599, '10043565', 'DAC', 'BD', 'B R B Travels', 'BDT', NULL, NULL),
(600, '10043568', 'DAC', 'BD', 'CORP Heidelberg Cement Bangladesh Ltd', 'BDT', NULL, NULL),
(601, '10043666', 'DAC', 'BD', 'Roman Travel & Tours', 'BDT', NULL, NULL),
(602, '10043669', 'DAC', 'BD', 'Combined Travels Intl. Ltd.', 'BDT', NULL, NULL),
(603, '10043671', 'DAC', 'BD', 'Orchid Tours & Travel', 'BDT', NULL, NULL),
(604, '10043676', 'DAC', 'BD', 'L. R Travels', 'BDT', NULL, NULL),
(605, '10043687', 'CGP', 'BD', 'Chowdhury International', 'BDT', NULL, NULL),
(606, '10043694', 'CGP', 'BD', 'Shah Mohsan Awlia Noyeemia Travels International & Hajj Kafela', 'BDT', NULL, NULL),
(607, '10043695', 'CGP', 'BD', 'Mayor Hajj Kafela Tours & Travels', 'BDT', NULL, NULL),
(608, '10043697', 'CGP', 'BD', 'World View', 'BDT', NULL, NULL),
(609, '10043699', 'CGP', 'BD', 'Zaman International', 'BDT', NULL, NULL),
(610, '10043701', 'CGP', 'BD', 'Urmi Travel Agency', 'BDT', NULL, NULL),
(611, '10043702', 'DAC', 'BD', 'Keramotia Air Travels Ltd.', 'BDT', NULL, NULL),
(612, '10043708', 'DAC', 'BD', 'Imam Travels & Tours', 'BDT', NULL, NULL),
(613, '10043710', 'ZYL', 'BD', 'Bangladesh Overseas Express', 'BDT', NULL, NULL),
(614, '10043714', 'DAC', 'BD', 'S B N Travel & Tours', 'BDT', NULL, NULL),
(615, '10043718', 'ZYL', 'BD', 'S M Air Services', 'BDT', NULL, NULL),
(616, '10045162', 'DAC', 'BD', 'Deacon Air Travel Agency', 'BDT', NULL, NULL),
(617, '10045181', 'DAC', 'BD', 'Blue Sky', 'BDT', NULL, NULL),
(618, '10045185', 'DAC', 'BD', 'Aftab Travels & Tours', 'BDT', NULL, NULL),
(619, '10045189', 'DAC', 'BD', 'Gondola Aviation Inc', 'BDT', NULL, NULL),
(620, '10045205', 'CGP', 'BD', 'Flewby Travels & Tours', 'BDT', NULL, NULL),
(621, '10045207', 'CGP', 'BD', 'Al Imam Hazz Kafela Travels & Tours', 'BDT', NULL, NULL),
(622, '10045211', 'CXB', 'BD', 'Desh Bondhu Tours & Travels', 'BDT', NULL, NULL),
(623, '10045213', 'CXB', 'BD', 'Cox''s Bazar Overseas', 'BDT', NULL, NULL),
(624, '10045221', 'DAC', 'BD', 'CORP Seven Circle (Bangladesh) Ltd.', 'BDT', NULL, NULL),
(625, '10045545', 'DAC', 'BD', 'Sanjar Aviation Ltd.', 'BDT', NULL, NULL),
(626, '10045546', 'SPD', 'BD', 'Thai Tours and Travels', 'BDT', NULL, NULL),
(627, '10045558', 'ZYL', 'BD', 'Al Rabbani Travels', 'BDT', NULL, NULL),
(628, '10045572', 'ZYL', 'BD', 'Anupoma International', 'BDT', NULL, NULL),
(629, '10045573', 'ZYL', 'BD', 'Al Mohsin Air Service', 'BDT', NULL, NULL),
(630, '10045823', 'ZYL', 'BD', 'CORP Hotel Star Pacific', 'BDT', NULL, NULL),
(631, '10046057', 'DAC', 'BD', 'Earthwatch Travels', 'BDT', NULL, NULL),
(632, '10046061', 'DAC', 'BD', 'Abrar Tours & Travels', 'BDT', NULL, NULL),
(633, '10046076', 'DAC', 'BD', 'Helpline Travels & Tours', 'BDT', NULL, NULL),
(634, '10046097', 'DAC', 'BD', 'Minfa Travels', 'BDT', NULL, NULL),
(635, '10046100', 'CGP', 'BD', 'Green Bangla Travels', 'BDT', NULL, NULL),
(636, '10046122', 'SPD', 'BD', 'G. Force Airways', 'BDT', NULL, NULL),
(637, '10046420', 'DAC', 'BD', 'CORP NYK Line Bangladesh Ltd.', 'BDT', NULL, NULL),
(638, '10047569', 'SPD', 'BD', 'Alap Travels & Tours', 'BDT', NULL, NULL),
(639, '10047571', 'DAC', 'BD', 'S. S International Travels', 'BDT', NULL, NULL),
(640, '10047748', 'CGP', 'BD', 'Tulip Travels', 'BDT', NULL, NULL),
(641, '10047763', 'DAC', 'BD', 'Tehzeeb International Air Travel', 'BDT', NULL, NULL),
(642, '10047772', 'CGP', 'BD', 'Shirawi Travel & Tours', 'BDT', NULL, NULL),
(643, '10047775', 'CGP', 'BD', 'Al Waqia Travels & Tours', 'BDT', NULL, NULL),
(644, '10047780', 'CGP', 'BD', 'Albatross Travels &Tours', 'BDT', NULL, NULL),
(645, '10047787', 'DAC', 'BD', 'Wills Tours & Travels', 'BDT', NULL, NULL),
(646, '10047791', 'JSR', 'BD', 'Rahmania Air Travels', 'BDT', NULL, NULL),
(647, '10048288', 'DAC', 'BD', 'CORP Renata Limited.', 'BDT', NULL, NULL),
(648, '10048978', 'CGP', 'BD', 'CORP Trendex Furniture Ind. Co. Ltd.', 'BDT', NULL, NULL),
(649, '10049238', 'DAC', 'BD', 'Air Dotcom Tours & Travels', 'BDT', NULL, NULL),
(650, '10049612', 'DAC', 'BD', 'CSD Travel Related Services', 'BDT', NULL, NULL),
(651, '10049915', 'DAC', 'BD', 'Oasis Air Services', 'BDT', NULL, NULL),
(652, '10049921', 'ZYL', 'BD', 'Islamia Air International', 'BDT', NULL, NULL),
(653, '10049922', 'ZYL', 'BD', 'CORP Hotel Fortune Garden', 'BDT', NULL, NULL),
(654, '10049945', 'DAC', 'BD', 'Happy Holiday Travel & Tours', 'BDT', NULL, NULL),
(655, '10049958', 'DAC', 'BD', 'Travel Center', 'BDT', NULL, NULL),
(656, '10049963', 'DAC', 'BD', 'R2M World Wide', 'BDT', NULL, NULL),
(657, '10050681', 'CGP', 'BD', 'Balaka International', 'BDT', NULL, NULL),
(658, '10050690', 'DAC', 'BD', 'CORP Uttara Motors Ltd', 'BDT', NULL, NULL),
(659, '10050723', 'SPD', 'BD', 'Mawa Travels International', 'BDT', NULL, NULL),
(660, '10050727', 'DAC', 'BD', 'Society Aviation', 'BDT', NULL, NULL),
(661, '10050728', 'CXB', 'BD', 'Destination Cox''s Bazar', 'BDT', NULL, NULL),
(662, '10050765', 'CGP', 'BD', 'CORP Youngone (CEPZ) Ltd', 'BDT', NULL, NULL),
(663, '10050780', 'DAC', 'BD', 'Navigator Tourism', 'BDT', NULL, NULL),
(664, '10050783', 'DAC', 'BD', 'Tayran Travels & Tours Limited', 'BDT', NULL, NULL),
(665, '10050790', 'CGP', 'BD', 'Banglalink Travels Internationals', 'BDT', NULL, NULL),
(666, '10051189', 'DAC', 'BD', 'Global Village Travels & Tours', 'BDT', NULL, NULL),
(667, '10051191', 'DAC', 'BD', 'CORP Radiant Bagda-Golda Hatchery & Nursery', 'BDT', NULL, NULL),
(668, '10051866', 'DAC', 'BD', 'CORP Projukti Global Limited', 'BDT', NULL, NULL),
(669, '10051870', 'DAC', 'BD', 'CORP Arai International Corporation', 'BDT', NULL, NULL);
INSERT INTO `agencies` (`AgencyID`, `AgencyUserID`, `Zone`, `Country`, `Name`, `Setl_Currency`, `Phone`, `Address`) VALUES
(670, '10052156', 'DAC', 'BD', 'Blue Horizon', 'BDT', NULL, NULL),
(671, '10052158', 'DAC', 'BD', 'Pan Bright Travels Pvt. Ltd.', 'BDT', NULL, NULL),
(672, '10052161', 'DAC', 'BD', 'Sea Waves Travels & Tours', 'BDT', NULL, NULL),
(673, '10052760', 'DAC', 'BD', 'CORP Compassion International Bangladesh', 'BDT', NULL, NULL),
(674, '10052766', 'DAC', 'BD', 'CORP Metro Net Bangladesh Limited', 'BDT', NULL, NULL),
(675, '10052772', 'DAC', 'BD', 'Unify Tours & Travels', 'BDT', NULL, NULL),
(676, '10052778', 'SPD', 'BD', 'Rangpur Tours & Travels', 'BDT', NULL, NULL),
(677, '10052783', 'KHL', 'BD', 'Fire Fly Travels', 'BDT', NULL, NULL),
(678, '10053290', 'DAC', 'BD', 'CORP APL (Bangladesh) Pvt. Ltd.', 'BDT', NULL, NULL),
(679, '10053482', 'DAC', 'BD', 'CORP Hotel Washington', 'BDT', NULL, NULL),
(680, '10053484', 'ZYL', 'BD', 'CORP Barakatullah Electro Dynamics Limited', 'BDT', NULL, NULL),
(681, '10053489', 'DAC', 'BD', 'CORP Pacific Bangladesh Telecom Ltd (Citycell)', 'BDT', NULL, NULL),
(682, '10054041', 'DAC', 'BD', 'CORP IPDC of Bangladesh Ltd', 'BDT', NULL, NULL),
(683, '10054054', 'DAC', 'BD', 'International Travel Services Ltd.', 'BDT', NULL, NULL),
(684, '10054262', 'DAC', 'BD', 'Nexus Tours & Travels (DAC)', 'BDT', NULL, NULL),
(685, '10054836', 'DAC', 'BD', 'Abdullah Amir Travel and Tours', 'BDT', NULL, NULL),
(686, '10054889', 'DAC', 'BD', 'CORP J.K Group', 'BDT', NULL, NULL),
(687, '10054912', 'DAC', 'BD', 'Maker', 'BDT', NULL, NULL),
(688, '10055195', 'DAC', 'BD', 'Golden Sky Tours & Travels', 'BDT', NULL, NULL),
(689, '10055199', 'DAC', 'BD', 'Papeellion Holidays', 'BDT', NULL, NULL),
(690, '10055204', 'DAC', 'BD', 'Progati Travels', 'BDT', NULL, NULL),
(691, '10055205', 'DAC', 'BD', 'Wonder Ways Ltd.', 'BDT', NULL, NULL),
(692, '10055206', 'DAC', 'BD', 'Bidesh Bhraman', 'BDT', NULL, NULL),
(693, '10055686', 'CGP', 'BD', 'CORP Youngone Corporation.', 'BDT', NULL, NULL),
(694, '10055780', 'DAC', 'BD', 'CORP Blue Planet Group', 'BDT', NULL, NULL),
(695, '10055783', 'DAC', 'BD', 'CORP Islam Garments Ltd', 'BDT', NULL, NULL),
(696, '10056223', 'DAC', 'BD', 'Ashabe Suffah Hajj Kafela', 'BDT', NULL, NULL),
(697, '10056412', 'CGP', 'BD', 'Darul Eman International Travel & Tours', 'BDT', NULL, NULL),
(698, '10056414', 'DAC', 'BD', 'Time Holidays Bangladesh', 'BDT', NULL, NULL),
(699, '10056416', 'DAC', 'BD', '7One Tours & Resorts Ltd.', 'BDT', NULL, NULL),
(700, '10056418', 'DAC', 'BD', 'Shirina Air Travels', 'BDT', NULL, NULL),
(701, '10056421', 'ZYL', 'BD', 'Sheuly Overseas Express', 'BDT', NULL, NULL),
(702, '10056425', 'DAC', 'BD', 'Akash Travels & Tours', 'BDT', NULL, NULL),
(703, '10056433', 'DAC', 'BD', 'Surma Overseas Ltd.', 'BDT', NULL, NULL),
(704, '10056445', 'DAC', 'BD', 'Holiday Travels Limited', 'BDT', NULL, NULL),
(705, '10056446', 'DAC', 'BD', 'Ultimate Tourism', 'BDT', NULL, NULL),
(706, '10056451', 'DAC', 'BD', 'Air Mishel', 'BDT', NULL, NULL),
(707, '10056452', 'DAC', 'BD', 'Planet International Travels', 'BDT', NULL, NULL),
(708, '10056453', 'CGP', 'BD', 'Chittagong Air International Ltd.', 'BDT', NULL, NULL),
(709, '10056456', 'CGP', 'BD', 'Al Hera Tours & Travels', 'BDT', NULL, NULL),
(710, '10056462', 'CGP', 'BD', 'Sun Air Tours & Travels', 'BDT', NULL, NULL),
(711, '10056463', 'CXB', 'BD', 'Travel Mark', 'BDT', NULL, NULL),
(712, '10056466', 'DAC', 'BD', 'Sawari Overseas', 'BDT', NULL, NULL),
(713, '10056470', 'DAC', 'BD', 'Hazrin Travels & Tours Ltd.', 'BDT', NULL, NULL),
(714, '10056472', 'DAC', 'BD', 'Air Speed Pvt. Ltd.', 'BDT', NULL, NULL),
(715, '10056479', 'DAC', 'BD', 'Khan Corporation', 'BDT', NULL, NULL),
(716, '10056497', 'DAC', 'BD', 'CORP G4S Secure Solutions Bangladesh (P) Ltd', 'BDT', NULL, NULL),
(717, '10056505', 'CXB', 'BD', 'Air Momtaz Aviation', 'BDT', NULL, NULL),
(718, '10056825', 'DAC', 'BD', 'Rebus International Travels Ltd.', 'BDT', NULL, NULL),
(719, '10056842', 'DAC', 'BD', 'Aero Ways Travel Agent & Tour Operator', 'BDT', NULL, NULL),
(720, '10056964', 'DAC', 'BD', 'Fly BD', 'BDT', NULL, NULL),
(721, '10056968', 'DAC', 'BD', 'Egarosindur Travels Ltd.', 'BDT', NULL, NULL),
(722, '10057171', 'DAC', 'BD', 'CORP Akij Group', 'BDT', NULL, NULL),
(723, '10057258', 'DAC', 'BD', 'Asian Travel Network', 'BDT', NULL, NULL),
(724, '10057467', 'DAC', 'BD', 'CORP Bkash Limited', 'BDT', NULL, NULL),
(725, '10057477', 'DAC', 'BD', 'CORP M M Ispahani Limited', 'BDT', NULL, NULL),
(726, '10057481', 'DAC', 'BD', 'CORP Super Star Group Limited', 'BDT', NULL, NULL),
(727, '10057662', 'DAC', 'BD', 'Innovator Tours and Travels', 'BDT', NULL, NULL),
(728, '10057776', 'KHL', 'BD', 'Treat Aviation', 'BDT', NULL, NULL),
(729, '10057895', 'DAC', 'BD', 'CORP IFC Travel Desk', 'BDT', NULL, NULL),
(730, '10057914', 'DAC', 'BD', 'CORP Eskayef Bangladesh', 'BDT', NULL, NULL),
(731, '10058349', 'DAC', 'BD', 'CORP Haychem (Bangladesh) Limited', 'BDT', NULL, NULL),
(732, '10058729', 'DAC', 'BD', 'CORP Well Group', 'BDT', NULL, NULL),
(733, '10058732', 'DAC', 'BD', 'CORP Summit Alliance Port Limited', 'BDT', NULL, NULL),
(734, '10058735', 'CXB', 'BD', 'Sea Tours and Travels', 'BDT', NULL, NULL),
(735, '10058782', 'DAC', 'BD', 'Jetpack Travels Limited', 'BDT', NULL, NULL),
(736, '10058784', 'DAC', 'BD', 'CORP Yasin Knittex Industries Ltd.', 'BDT', NULL, NULL),
(737, '10058805', 'DAC', 'BD', 'Koras Aviation', 'BDT', NULL, NULL),
(738, '10058946', 'DAC', 'BD', 'CORP Samata Developers Ltd.', 'BDT', NULL, NULL),
(739, '10059345', 'DAC', 'BD', 'L F M Aviation', 'BDT', NULL, NULL),
(740, '10059362', 'CGP', 'BD', 'Ayar Tours & Travels', 'BDT', NULL, NULL),
(741, '10059468', 'DAC', 'BD', 'Liberal Tours & Travels', 'BDT', NULL, NULL),
(742, '10059875', 'DAC', 'BD', 'CORP Juki Bangladesh Ltd.', 'BDT', NULL, NULL),
(743, '10059965', 'DAC', 'BD', 'SK Travels & Logistics', 'BDT', NULL, NULL),
(744, '10060231', 'CGP', 'BD', 'Highway Overseas Travel Agent', 'BDT', NULL, NULL),
(745, '10060236', 'CGP', 'BD', 'CORP Asian University For Women', 'BDT', NULL, NULL),
(746, '10060241', 'DAC', 'BD', 'CORP Helen Keller International Bangladesh', 'BDT', NULL, NULL),
(747, '10060243', 'DAC', 'BD', 'Dhaka (BD) Travels', 'BDT', NULL, NULL),
(748, '10060246', 'DAC', 'BD', 'Ma Arej Trade International', 'BDT', NULL, NULL),
(749, '10060258', 'DAC', 'BD', 'Sky Port Travels & Tours', 'BDT', NULL, NULL),
(750, '10060261', 'CGP', 'BD', 'Habib Travels International', 'BDT', NULL, NULL),
(751, '10060264', 'KUL', 'MY', 'Daily Tours And Travel SDN. BHD.', 'MYR', NULL, NULL),
(752, '10060272', 'DAC', 'BD', 'Asian Holidays', 'BDT', NULL, NULL),
(753, '10060278', 'DAC', 'BD', 'Everest BD Tours & Travels', 'BDT', NULL, NULL),
(754, '10060682', 'JSR', 'BD', 'City Travels & Tours', 'BDT', NULL, NULL),
(755, '10060836', 'DAC', 'BD', 'Travel Club', 'BDT', NULL, NULL),
(756, '10061529', 'DAC', 'BD', 'TRAVEL COOK LIMITED', 'BDT', NULL, NULL),
(757, '10062255', 'CGP', 'BD', 'Al Razi Air International', 'BDT', NULL, NULL),
(758, '10062258', 'CGP', 'BD', 'Al Rafique Overseas', 'BDT', NULL, NULL),
(759, '10062772', 'DAC', 'BD', 'CORP Batayan Housing & Development LTD.', 'BDT', NULL, NULL),
(760, '10062773', 'DAC', 'BD', 'CORP New Car Choice', 'BDT', NULL, NULL),
(761, '10062776', 'DAC', 'BD', 'CORP Sumaiya Auto Trading', 'BDT', NULL, NULL),
(762, '10062778', 'DAC', 'BD', 'CORP La Villa A Boutique Hotel', 'BDT', NULL, NULL),
(763, '10064234', 'SPD', 'BD', 'Tangon Airlines & Tours', 'BDT', NULL, NULL),
(764, '10064246', 'CGP', 'BD', 'Arabian International', 'BDT', NULL, NULL),
(765, '10064290', 'DAC', 'BD', 'CORP SGS Bangladesh Ltd.', 'BDT', NULL, NULL),
(766, '10064398', 'DAC', 'BD', 'CORP Youngone Corporation', 'BDT', NULL, NULL),
(767, '10064536', 'DAC', 'BD', 'CORP Hotel 71 Dhaka', 'BDT', NULL, NULL),
(768, '10064557', 'DAC', 'BD', 'Maple Tours Travels', 'BDT', NULL, NULL),
(769, '10064560', 'DAC', 'BD', 'Avion Tours & Travels', 'BDT', NULL, NULL),
(770, '10064577', 'ZYL', 'BD', 'Safa Air Service', 'BDT', NULL, NULL),
(771, '10064581', 'DAC', 'BD', 'Rupsha Air Services Pvt. Ltd.', 'BDT', NULL, NULL),
(772, '10064585', 'DAC', 'BD', 'Farhan Air Travels', 'BDT', NULL, NULL),
(773, '10064744', 'DAC', 'BD', 'CORP Intraco CNG Ltd', 'BDT', NULL, NULL),
(774, '10065318', 'DAC', 'BD', 'Mizi Travels & Tours', 'BDT', NULL, NULL),
(775, '10065320', 'SPD', 'BD', 'Ellien Air Travels', 'BDT', NULL, NULL),
(776, '10065410', 'CGP', 'BD', 'Siddique Air International Travels &  Tours', 'BDT', NULL, NULL),
(777, '10065412', 'CGP', 'BD', 'Arab Bangladesh Overseas & Hajj Group', 'BDT', NULL, NULL),
(778, '10065425', 'CXB', 'BD', 'Naf International Travels & Consultancy', 'BDT', NULL, NULL),
(779, '10065429', 'CXB', 'BD', 'Pacific Tours & Logistics', 'BDT', NULL, NULL),
(780, '10065431', 'SPD', 'BD', 'Mama Air Travels', 'BDT', NULL, NULL),
(781, '10065526', 'DAC', 'BD', 'CORP AFS Consolidation Ltd.', 'BDT', NULL, NULL),
(782, '10065827', 'DAC', 'BD', 'CORP NRB Global Bank Ltd.', 'BDT', NULL, NULL),
(783, '10065873', 'CGP', 'BD', 'CORP RSRM', 'BDT', NULL, NULL),
(784, '10066608', 'ZYL', 'BD', 'Central Travels & Tours', 'BDT', NULL, NULL),
(785, '10067330', 'DAC', 'BD', 'Air Continental Travel Agent', 'BDT', NULL, NULL),
(786, '10067340', 'CGP', 'BD', 'Guardian Travels', 'BDT', NULL, NULL),
(787, '10067528', 'DAC', 'BD', 'Taslima Overseas', 'BDT', NULL, NULL),
(788, '10067530', 'DAC', 'BD', 'Season Holidays Travel & Tours', 'BDT', NULL, NULL),
(789, '10068116', 'DAC', 'BD', 'San Travel & Tours', 'BDT', NULL, NULL),
(790, '10068119', 'DAC', 'BD', 'CORP Aristocrat Agro Ltd.', 'BDT', NULL, NULL),
(791, '10068424', 'DAC', 'BD', 'CORP Quasem Drycells Ltd', 'BDT', NULL, NULL),
(792, '10068433', 'DAC', 'BD', 'CORP LANKABANGLA FINANCE LTD.', 'BDT', NULL, NULL),
(793, '10068680', 'CXB', 'BD', 'Almas Tours & Travels', 'BDT', NULL, NULL),
(794, '10068684', 'DAC', 'BD', 'CORP Asia Pacific Hotel', 'BDT', NULL, NULL),
(795, '10068688', 'KHL', 'BD', 'Air News', 'BDT', NULL, NULL),
(796, '10068695', 'DAC', 'BD', 'Inter Tours Travel Consulting', 'BDT', NULL, NULL),
(797, '10068704', 'DAC', 'BD', 'Air Bridge Travels & Tours', 'BDT', NULL, NULL),
(798, '10068709', 'DAC', 'BD', 'CORP Expo International Ltd.', 'BDT', NULL, NULL),
(799, '10068719', 'DAC', 'BD', 'CORP Orange Bangladesh Ltd.', 'BDT', NULL, NULL),
(800, '10068853', 'DAC', 'BD', 'Travel Designers', 'BDT', NULL, NULL),
(801, '10068864', 'DAC', 'BD', 'Sunbay Travels Services', 'BDT', NULL, NULL),
(802, '10068873', 'DAC', 'BD', 'Travel  Bridge Syndicate', 'BDT', NULL, NULL),
(803, '10068889', 'DAC', 'BD', 'CORP Sharat Telefilm', 'BDT', NULL, NULL),
(804, '10069092', 'DAC', 'BD', 'CORP Prime Pusti Ltd', 'BDT', NULL, NULL),
(805, '10069545', 'DAC', 'BD', 'NSS Tours & Travels', 'BDT', NULL, NULL),
(806, '10069553', 'DAC', 'BD', 'CORP Fashion Flash Ltd.', 'BDT', NULL, NULL),
(807, '10069608', 'DAC', 'BD', 'CORP Iota  Business Limited', 'BDT', NULL, NULL),
(808, '10069612', 'DAC', 'BD', 'CORP Janco Bangladesh Ltd.', 'BDT', NULL, NULL),
(809, '10069614', 'DAC', 'BD', 'CORP HKG Steel Mills Limited', 'BDT', NULL, NULL),
(810, '10069619', 'DAC', 'BD', 'A.P Tours & Travels', 'BDT', NULL, NULL),
(811, '10069621', 'DAC', 'BD', 'Ababil Travels & Tours', 'BDT', NULL, NULL),
(812, '10069679', 'DAC', 'BD', 'Travel Makers Ltd', 'BDT', NULL, NULL),
(813, '10070057', 'DAC', 'BD', 'Infinity Global Tours & Travels', 'BDT', NULL, NULL),
(814, '10070579', 'DAC', 'BD', 'Glory Air Travels', 'BDT', NULL, NULL),
(815, '10070580', 'DAC', 'BD', 'Megatop Travel International Pvt. Ltd.', 'BDT', NULL, NULL),
(816, '10070582', 'DAC', 'BD', 'Adib Air Service', 'BDT', NULL, NULL),
(817, '10071339', 'DAC', 'BD', 'Moushumi Air Travels Ltd.', 'BDT', NULL, NULL),
(818, '10071340', 'DAC', 'BD', 'Himaliah Holidays', 'BDT', NULL, NULL),
(819, '10072008', 'SPD', 'BD', 'Talha Tours & Travels (SPD)', 'BDT', NULL, NULL),
(820, '10072080', 'DAC', 'BD', 'CORP Lamisa Fashion', 'BDT', NULL, NULL),
(821, '10072090', 'DAC', 'BD', 'International Travel Point', 'BDT', NULL, NULL),
(822, '10072094', 'DAC', 'BD', 'CORP Pathfinder International', 'BDT', NULL, NULL),
(823, '10072991', 'CGP', 'BD', 'R T Overseas', 'BDT', NULL, NULL),
(824, '10073139', 'DAC', 'BD', 'CORP A G Printing & Packaging', 'BDT', NULL, NULL),
(825, '10073828', 'DAC', 'BD', 'Novo Aviation Services Ltd.', 'BDT', NULL, NULL),
(826, '10073835', 'CGP', 'BD', 'Mahamud Travels & Tours', 'BDT', NULL, NULL),
(827, '10073840', 'DAC', 'BD', 'AHB Travels Int.Ltd.', 'BDT', NULL, NULL),
(828, '10073842', 'CGP', 'BD', 'Asif International Travels & Tours', 'BDT', NULL, NULL),
(829, '10073870', 'DAC', 'BD', 'Bengal Trade &Tourism Ltd.', 'BDT', NULL, NULL),
(830, '10073888', 'DAC', 'BD', 'Belsai Holidays', 'BDT', NULL, NULL),
(831, '10074241', 'CGP', 'BD', 'Golden Bengal Travels & Tours', 'BDT', NULL, NULL),
(832, '10074253', 'DAC', 'BD', 'Fly Bd Tours & Travels', 'BDT', NULL, NULL),
(833, '10074260', 'DAC', 'BD', 'Star Tours & Travels', 'BDT', NULL, NULL),
(834, '10074914', 'DAC', 'BD', 'A1 Tours & Travels', 'BDT', NULL, NULL),
(835, '10075008', 'DAC', 'BD', 'Amirah Travel Agency Limited', 'BDT', NULL, NULL),
(836, '10075011', 'DAC', 'BD', 'Vivid global Connect Ltd.', 'BDT', NULL, NULL),
(837, '10075014', 'DAC', 'BD', 'Mokarrom Tours & Travels', 'BDT', NULL, NULL),
(838, '10075238', 'DAC', 'BD', 'CORP Square Hospitals Ltd.', 'BDT', NULL, NULL),
(839, '10075545', 'DAC', 'BD', 'CORP BRAC Bank Limited.', 'BDT', NULL, NULL),
(840, '10075553', 'DAC', 'BD', 'Fantacy International', 'BDT', NULL, NULL),
(841, '10075691', 'DAC', 'BD', 'agv test peyroche', 'BDT', NULL, NULL),
(842, '10076186', 'CXB', 'BD', 'Swift Tours & Travels', 'BDT', NULL, NULL),
(843, '10076190', 'CGP', 'BD', 'Bareka Bangladesh International', 'BDT', NULL, NULL),
(844, '10076193', 'SPD', 'BD', 'Vinnya Jagat Travels International', 'BDT', NULL, NULL),
(845, '10076252', 'DAC', 'BD', 'CORP Incepta Pharmaceuticals Ltd.', 'BDT', NULL, NULL),
(846, '10076258', 'DAC', 'BD', 'CORP UNIMAX SIGN', 'BDT', NULL, NULL),
(847, '10077271', 'DAC', 'BD', 'Compact Travel & Tours Service Ltd.', 'BDT', NULL, NULL),
(848, '10077278', 'SPD', 'BD', 'North Bengal Hajj Travels & Tours', 'BDT', NULL, NULL),
(849, '10077280', 'DAC', 'BD', 'Ima Overseas Tours & Travels Ltd.', 'BDT', NULL, NULL),
(850, '10077281', 'CGP', 'BD', 'Rahat Travels & Tours', 'BDT', NULL, NULL),
(851, '10077283', 'DAC', 'BD', 'Monaz Aviation', 'BDT', NULL, NULL),
(852, '10077289', 'DAC', 'BD', 'CORP Softtech Ltd.', 'BDT', NULL, NULL),
(853, '10077297', 'CGP', 'BD', 'Halda Travels & Tours', 'BDT', NULL, NULL),
(854, '10077304', 'ZYL', 'BD', 'Uttara Travels', 'BDT', NULL, NULL),
(855, '10077308', 'DAC', 'BD', 'CORP Jamuna Spacetecg Hoint Venture Limited', 'BDT', NULL, NULL),
(856, '10078048', 'DAC', 'BD', 'CORP Garden Residence', 'BDT', NULL, NULL),
(857, '10078053', 'DAC', 'BD', 'Akash Bhraman Limited', 'BDT', NULL, NULL),
(858, '10078162', 'DAC', 'BD', 'Al Beruni Overseas', 'BDT', NULL, NULL),
(859, '10079093', 'DAC', 'BD', 'The Dhaka Travels', 'BDT', NULL, NULL),
(860, '10079095', 'DAC', 'BD', 'Mahad Travel Corporation', 'BDT', NULL, NULL),
(861, '10089353', 'DAC', 'BD', 'Victor Air Travels', 'BDT', NULL, NULL),
(862, '10089355', 'DAC', 'BD', 'Cox''s Bazar Overseas', 'BDT', NULL, NULL),
(863, '10089357', 'CGP', 'BD', 'CORP Asian SR Hotel', 'BDT', NULL, NULL),
(864, '10089359', 'CGP', 'BD', 'CORP Asian Apparels Ltd.', 'BDT', NULL, NULL),
(865, '10089655', 'DAC', 'BD', 'Appolo Tours & Travels Ltd.', 'BDT', NULL, NULL),
(866, '10089658', 'JSR', 'BD', 'Hasan Tours and Travels', 'BDT', NULL, NULL),
(867, '10090144', 'DAC', 'BD', 'CORP Jamuna Bank Limited', 'BDT', NULL, NULL),
(868, '10090148', 'DAC', 'BD', 'CORP Robi Axiata Limited', 'BDT', NULL, NULL),
(869, '10090154', 'DAC', 'BD', 'CORP Future Holdings Ltd.', 'BDT', NULL, NULL),
(870, '10090321', 'DAC', 'BD', 'Euro Air International Travels', 'BDT', NULL, NULL),
(871, '10090322', 'DAC', 'BD', 'Deshari Air Service', 'BDT', NULL, NULL),
(872, '10090324', 'DAC', 'BD', 'Avia Overseas Ltd.', 'BDT', NULL, NULL),
(873, '10090327', 'DAC', 'BD', 'Admire Air Travels Limited', 'BDT', NULL, NULL),
(874, '10090330', 'CGP', 'BD', 'CORP Hotel Agrabad', 'BDT', NULL, NULL),
(875, '10090333', 'CGP', 'BD', 'CORP Ambia Apparels Ltd.', 'BDT', NULL, NULL),
(876, '10090335', 'CGP', 'BD', 'CORP Grand Park Hotel.', 'BDT', NULL, NULL),
(877, '10090338', 'CGP', 'BD', 'CORP Orchid Business Hotel', 'BDT', NULL, NULL),
(878, '10091057', 'CGP', 'BD', 'CORP Hotel Tower Inn International Ltd.', 'BDT', NULL, NULL),
(879, '10091061', 'CGP', 'BD', 'CORP Mostafa Group of Industries', 'BDT', NULL, NULL),
(880, '10091069', 'CGP', 'BD', 'CORP The Avenue Hotel & Suites', 'BDT', NULL, NULL),
(881, '10091076', 'CGP', 'BD', 'CORP Ambassador Residency', 'BDT', NULL, NULL),
(882, '10091080', 'DAC', 'BD', 'Karnaphuli Travel Agency Limited', 'BDT', NULL, NULL),
(883, '10091087', 'DAC', 'BD', 'Star Tours and Travels Limited', 'BDT', NULL, NULL),
(884, '10091099', 'DAC', 'BD', 'Travel Business Ltd.', 'BDT', NULL, NULL),
(885, '10091102', 'DAC', 'BD', 'Perfect Travels', 'BDT', NULL, NULL),
(886, '10091106', 'CGP', 'BD', 'CORP R.B.N Shipping Ltd.', 'BDT', NULL, NULL),
(887, '10091192', 'DAC', 'BD', 'Al Qaswa Travels Wal Hajj Wal- Omrah', 'BDT', NULL, NULL),
(888, '10091200', 'DAC', 'BD', 'Al Amin Travel & Tourism', 'BDT', NULL, NULL),
(889, '10091202', 'DAC', 'BD', 'Airland International Ltd.', 'BDT', NULL, NULL),
(890, '10091518', 'DAC', 'BD', 'Travel World Express', 'BDT', NULL, NULL),
(891, '10092128', 'DAC', 'BD', 'National Overseas', 'BDT', NULL, NULL),
(892, '10092129', 'DAC', 'BD', 'Activation Tourism', 'BDT', NULL, NULL),
(893, '10092230', 'DAC', 'BD', 'Islamia Overseas Ltd.', 'BDT', NULL, NULL),
(894, '10092239', 'CGP', 'BD', 'CORP Fariha Enterprise', 'BDT', NULL, NULL),
(895, '10092298', 'ZYL', 'BD', 'CRESCENT OVERSEAS EXPRESS', 'BDT', NULL, NULL),
(896, '10092438', 'DAC', 'BD', 'Bright Star Corporation Limited', 'BDT', NULL, NULL),
(897, '10092440', 'DAC', 'BD', 'T.M Overseas', 'BDT', NULL, NULL),
(898, '10092441', 'DAC', 'BD', 'K.M Aviation', 'BDT', NULL, NULL),
(899, '10092444', 'DAC', 'BD', 'Starline Tours & Travels Ltd.', 'BDT', NULL, NULL),
(900, '10092446', 'DAC', 'BD', 'I Shahara Aviation', 'BDT', NULL, NULL),
(901, '10092449', 'DAC', 'BD', 'Prime International Tours & Travels Ltd.', 'BDT', NULL, NULL),
(902, '10092450', 'DAC', 'BD', 'Al Zabir Travels', 'BDT', NULL, NULL),
(903, '10092452', 'DAC', 'BD', 'CORP Palli Karma Sahayak Foundation', 'BDT', NULL, NULL),
(904, '10092881', 'CGP', 'BD', 'CORP Continental Group', 'BDT', NULL, NULL),
(905, '10092884', 'CGP', 'BD', 'CORP N.H Enterprise', 'BDT', NULL, NULL),
(906, '10092887', 'CGP', 'BD', 'CORP Orlance Shipping & Trading Agency', 'BDT', NULL, NULL),
(907, '10092888', 'CGP', 'BD', 'Any International Travels & Tours', 'BDT', NULL, NULL),
(908, '10092892', 'CGP', 'BD', 'Dwip International', 'BDT', NULL, NULL),
(909, '10093188', 'DAC', 'BD', 'Maruf Travels', 'BDT', NULL, NULL),
(910, '10093189', 'DAC', 'BD', 'Rahima Air International', 'BDT', NULL, NULL),
(911, '10093192', 'DAC', 'BD', 'Elahi Enterprise', 'BDT', NULL, NULL),
(912, '10093196', 'DAC', 'BD', 'Al Noor Overseas', 'BDT', NULL, NULL),
(913, '10093198', 'DAC', 'BD', 'Care Travel & Tours', 'BDT', NULL, NULL),
(914, '10093200', 'DAC', 'BD', 'Farhan Aviation Services', 'BDT', NULL, NULL),
(915, '10093201', 'CGP', 'BD', 'CORP Imperial Hospital Limited', 'BDT', NULL, NULL),
(916, '10093584', 'DAC', 'BD', 'Marhama Air Travels & Tours', 'BDT', NULL, NULL),
(917, '10093588', 'DAC', 'BD', 'South Asian Travels & Tours', 'BDT', NULL, NULL),
(918, '10093590', 'DAC', 'BD', 'CORP Germania Corporation Ltd.', 'BDT', NULL, NULL),
(919, '10093984', 'DAC', 'BD', 'Tour Vision Limited', 'BDT', NULL, NULL),
(920, '10094112', 'DAC', 'BD', 'Noor E Shefa Aviation', 'BDT', NULL, NULL),
(921, '10094115', 'DAC', 'BD', 'Suwath International', 'BDT', NULL, NULL),
(922, '10094116', 'DAC', 'BD', 'Hyun Tours & Travels', 'BDT', NULL, NULL),
(923, '10094117', 'DAC', 'BD', 'Star Vision', 'BDT', NULL, NULL),
(924, '10094122', 'DAC', 'BD', 'Badarpur Travels & Tours', 'BDT', NULL, NULL),
(925, '10094123', 'DAC', 'BD', 'Air Matco International', 'BDT', NULL, NULL),
(926, '10094300', 'DAC', 'BD', 'Hollywood Tours & Travels Pvt. Ltd.', 'BDT', NULL, NULL),
(927, '10094304', 'DAC', 'BD', 'Shahjalal Overseas Ltd.', 'BDT', NULL, NULL),
(928, '10094456', 'DAC', 'BD', 'Tanvir Travels', 'BDT', NULL, NULL),
(929, '10094459', 'DAC', 'BD', 'Prottasha Travel Agency Ltd.', 'BDT', NULL, NULL),
(930, '10094462', 'DAC', 'BD', 'Efaz Tours & Travels Service', 'BDT', NULL, NULL),
(931, '10094831', 'DAC', 'BD', 'CORP HS Corporation', 'BDT', NULL, NULL),
(932, '10094853', 'DAC', 'BD', 'Bangla Air Service', 'BDT', NULL, NULL),
(933, '10095567', 'DAC', 'BD', 'Majestic Travel International', 'BDT', NULL, NULL),
(934, '10095579', 'DAC', 'BD', 'Delta Aviation Total Travel Solution', 'BDT', NULL, NULL),
(935, '10095623', 'DAC', 'BD', 'Parabat Travels & Tours Ltd.', 'BDT', NULL, NULL),
(936, '10095627', 'DAC', 'BD', 'Airborne Services Ltd.', 'BDT', NULL, NULL),
(937, '10095633', 'DAC', 'BD', 'Life Line Scenic Travels', 'BDT', NULL, NULL),
(938, '10095642', 'ZYL', 'BD', 'Discovery Sylhet Travels & Tours', 'BDT', NULL, NULL),
(939, '10095645', 'ZYL', 'BD', 'Taj Overseas', 'BDT', NULL, NULL),
(940, '10095646', 'ZYL', 'BD', 'Kuhetur Overseas Pvt. Ltd.', 'BDT', NULL, NULL),
(941, '10095652', 'ZYL', 'BD', 'City Overseas', 'BDT', NULL, NULL),
(942, '10095656', 'ZYL', 'BD', 'Linkers Travels Pvt. Ltd.', 'BDT', NULL, NULL),
(943, '10095660', 'ZYL', 'BD', 'Rabbani Overseas Services', 'BDT', NULL, NULL),
(944, '10095667', 'CGP', 'BD', 'CORP Port Land International', 'BDT', NULL, NULL),
(945, '10095672', 'CGP', 'BD', 'CORP Hotel Lords Inn', 'BDT', NULL, NULL),
(946, '10096004', 'DAC', 'BD', 'Dynasty Travels Ltd.', 'BDT', NULL, NULL),
(947, '10096229', 'DAC', 'BD', 'Desh Bhraman pvt. Limited', 'BDT', NULL, NULL),
(948, '10096239', 'DAC', 'BD', 'Air King Travel & Tours', 'BDT', NULL, NULL),
(949, '10096245', 'DAC', 'BD', 'Lucky Overseas', 'BDT', NULL, NULL),
(950, '10096250', 'DAC', 'BD', 'Lamaras Travels', 'BDT', NULL, NULL),
(951, '10096254', 'DAC', 'BD', 'Midland Travels', 'BDT', NULL, NULL),
(952, '10096260', 'DAC', 'BD', 'East West Air', 'BDT', NULL, NULL),
(953, '10096272', 'DAC', 'BD', 'Al Sameeyu Travels & Tours', 'BDT', NULL, NULL),
(954, '10096326', 'DAC', 'BD', 'Rakib Air Travel & Tours', 'BDT', NULL, NULL),
(955, '10096759', 'DAC', 'BD', 'Comilla Travels', 'BDT', NULL, NULL),
(956, '10096761', 'DAC', 'BD', 'Radiant Overseas', 'BDT', NULL, NULL),
(957, '10096853', 'DAC', 'BD', 'Sunfine Travels International', 'BDT', NULL, NULL),
(958, '10096857', 'CGP', 'BD', 'M G International Travel & Tours', 'BDT', NULL, NULL),
(959, '10096865', 'CGP', 'BD', 'DBH Travels & Tours', 'BDT', NULL, NULL),
(960, '10097133', 'DAC', 'BD', 'Avian Tours & Travels', 'BDT', NULL, NULL),
(961, '10097139', 'DAC', 'BD', 'Labbaik Overseas Ltd.', 'BDT', NULL, NULL),
(962, '10097453', 'CGP', 'BD', 'CORP Elite Force', 'BDT', NULL, NULL),
(963, '10097458', 'CGP', 'BD', 'CORP The Delta Group of Industries Limited', 'BDT', NULL, NULL),
(964, '10097461', 'CGP', 'BD', 'CORP Shyms Fashions Ltd.', 'BDT', NULL, NULL),
(965, '10097497', 'DAC', 'BD', 'CORP Global World Ltd.', 'BDT', NULL, NULL),
(966, '10097600', 'DAC', 'BD', 'Sentra Travel & Tours', 'BDT', NULL, NULL),
(967, '10097632', 'CGP', 'BD', 'CORP Confidence Cement Limited', 'BDT', NULL, NULL),
(968, '10097638', 'CGP', 'BD', 'CORP The Peninsula Chittagong Limited', 'BDT', NULL, NULL),
(969, '10097640', 'CGP', 'BD', 'CORP A.S Overseas C & F', 'BDT', NULL, NULL),
(970, '10097641', 'ZYL', 'BD', 'Ajwah Tour And Travels', 'BDT', NULL, NULL),
(971, '10097722', 'CGP', 'BD', 'CORP ICB Capital Management Limited.', 'BDT', NULL, NULL),
(972, '10097733', 'CGP', 'BD', 'CORP Hotel Al Faisal International Ltd.', 'BDT', NULL, NULL),
(973, '10097742', 'CGP', 'BD', 'CORP Zahed Traders', 'BDT', NULL, NULL),
(974, '10097765', 'CGP', 'BD', 'CORP Chowdhury  Traders', 'BDT', NULL, NULL),
(975, '10097868', 'BZL', 'BD', 'Super Travels & Tourism', 'BDT', NULL, NULL),
(976, '10097872', 'BZL', 'BD', 'The River Tours & Travel', 'BDT', NULL, NULL),
(977, '10097876', 'BZL', 'BD', 'Brothers Tours & Travels', 'BDT', NULL, NULL),
(978, '10097979', 'CGP', 'BD', 'CORP Sanmar Properties Limited', 'BDT', NULL, NULL),
(979, '10098337', 'DAC', 'BD', 'United Int. Travel & Tourism', 'BDT', NULL, NULL),
(980, '10098677', 'BZL', 'BD', 'Noor Tours & Travels', 'BDT', NULL, NULL),
(981, '10098683', 'BZL', 'BD', 'Shugandha Travels & Tours', 'BDT', NULL, NULL),
(982, '10098688', 'BZL', 'BD', 'Talukder Tours & Travels', 'BDT', NULL, NULL),
(983, '10098691', 'BZL', 'BD', 'Intel Travels & Tours', 'BDT', NULL, NULL),
(984, '10098972', 'BZL', 'BD', 'Deshi Travels & Tours', 'BDT', NULL, NULL),
(985, '10098979', 'BZL', 'BD', 'Dutch Bangla Tours & Travels', 'BDT', NULL, NULL),
(986, '10098993', 'DAC', 'BD', 'CORP GlaxoSmithkline Bangladesh Limited', 'BDT', NULL, NULL),
(987, '10098994', 'CGP', 'BD', 'S A R Travels', 'BDT', NULL, NULL),
(988, '10098996', 'CGP', 'BD', 'Al Zahir Travels & Tours', 'BDT', NULL, NULL),
(989, '10099000', 'DAC', 'BD', 'Sameer Tours & Travels', 'BDT', NULL, NULL),
(990, '10099005', 'DAC', 'BD', 'IR Air Tickting & Travel', 'BDT', NULL, NULL),
(991, '10099007', 'DAC', 'BD', 'Win International', 'BDT', NULL, NULL),
(992, '10099010', 'DAC', 'BD', 'Tayaf International', 'BDT', NULL, NULL),
(993, '10099027', 'DAC', 'BD', 'Travel Holidays', 'BDT', NULL, NULL),
(994, '10099028', 'DAC', 'BD', 'Challenger Travels & Tours Ltd.', 'BDT', NULL, NULL),
(995, '10099031', 'DAC', 'BD', 'Rodela International', 'BDT', NULL, NULL),
(996, '10099033', 'DAC', 'BD', 'CORP Atlas Logistics Bangladesh (Pvt) Ltd.', 'BDT', NULL, NULL),
(997, '10099035', 'SPD', 'BD', 'Maria Aviation', 'BDT', NULL, NULL),
(998, '10099213', 'DAC', 'BD', 'Al Rayeen International', 'BDT', NULL, NULL),
(999, '10099468', 'DAC', 'BD', 'Travel Ways Limited', 'BDT', NULL, NULL),
(1000, '10099471', 'DAC', 'BD', 'Genial Tours & Travels Ltd.', 'BDT', NULL, NULL),
(1001, '10100038', 'CGP', 'BD', 'Elegance Air Travels', 'BDT', NULL, NULL),
(1002, '10100041', 'BZL', 'BD', 'Friends Travels & Event Management', 'BDT', NULL, NULL),
(1003, '10100057', 'DAC', 'BD', 'Tour Booking Bangladesh', 'BDT', NULL, NULL),
(1004, '10100214', 'DAC', 'BD', 'Muntaqa Tours & Travels', 'BDT', NULL, NULL),
(1005, '10100217', 'DAC', 'BD', 'Skynet Travels & Tours', 'BDT', NULL, NULL),
(1006, '10100225', 'DAC', 'BD', 'Minar Air Travels', 'BDT', NULL, NULL),
(1007, '10100232', 'DAC', 'BD', 'Rakib Air International', 'BDT', NULL, NULL),
(1008, '10100236', 'DAC', 'BD', 'Narita Tours & Travels', 'BDT', NULL, NULL),
(1009, '10100240', 'DAC', 'BD', 'Shakib Aviation', 'BDT', NULL, NULL),
(1010, '10100242', 'DAC', 'BD', 'Bangladesh & World Travel', 'BDT', NULL, NULL),
(1011, '10100981', 'DAC', 'BD', 'Tafa Travel Consultant', 'BDT', NULL, NULL),
(1012, '10101367', 'DAC', 'BD', 'Vista Travels', 'BDT', NULL, NULL),
(1013, '10101408', 'DAC', 'BD', 'CORP Abdul Monem Limited', 'BDT', NULL, NULL),
(1014, '10101443', 'DAC', 'BD', 'Mexico Air Travels', 'BDT', NULL, NULL),
(1015, '10101446', 'CGP', 'BD', 'CORP BSA Group of Companies', 'BDT', NULL, NULL),
(1016, '10101452', 'CGP', 'BD', 'South Bangla Tours & Travels', 'BDT', NULL, NULL),
(1017, '10101643', 'CGP', 'BD', 'Hashim Overseas', 'BDT', NULL, NULL),
(1018, '10101649', 'CGP', 'BD', 'S I International', 'BDT', NULL, NULL),
(1019, '10101653', 'DAC', 'BD', 'Tour Plus International Ltd.', 'BDT', NULL, NULL),
(1020, '10101662', 'SPD', 'BD', 'Nibir Internation Tours & Travels', 'BDT', NULL, NULL),
(1021, '10101673', 'SPD', 'BD', 'Sharif Airlines & Tours', 'BDT', NULL, NULL),
(1022, '10101675', 'DAC', 'BD', 'Shakib Al Chisty Aviation', 'BDT', NULL, NULL),
(1023, '10101687', 'DAC', 'BD', 'Dhali Overseas Limited', 'BDT', NULL, NULL),
(1024, '10101695', 'DAC', 'BD', 'Air Bond Travels', 'BDT', NULL, NULL),
(1025, '10101716', 'DAC', 'BD', 'Union Travels Ltd.', 'BDT', NULL, NULL),
(1026, '10101729', 'CXB', 'BD', 'CORP Fouad Al Khateeb Hospital Cox''s Bazar', 'BDT', NULL, NULL),
(1027, '10101849', 'DAC', 'BD', 'Golden Arrow Travels & Tours', 'BDT', NULL, NULL),
(1028, '10102073', 'CGP', 'BD', 'Talukder Overseas', 'BDT', NULL, NULL),
(1029, '10102493', 'CGP', 'BD', 'CORP IOC International Ltd.', 'BDT', NULL, NULL),
(1030, '10102498', 'CGP', 'BD', 'CORP Hotel Eastern View', 'BDT', NULL, NULL),
(1031, '10102654', 'DAC', 'BD', 'Martena Travels & Tours International', 'BDT', NULL, NULL),
(1032, '10102662', 'DAC', 'BD', 'CORP Delta Life Insurance Company Ltd.', 'BDT', NULL, NULL),
(1033, '10102767', 'DAC', 'BD', 'Koli Travels & Tours', 'BDT', NULL, NULL),
(1034, '10102774', 'DAC', 'BD', 'Wings Travels & Tour Ltd.', 'BDT', NULL, NULL),
(1035, '10102784', 'DAC', 'BD', 'Kowmee Travels & Tours', 'BDT', NULL, NULL),
(1036, '10102790', 'DAC', 'BD', 'T.A. Air International', 'BDT', NULL, NULL),
(1037, '10102794', 'DAC', 'BD', 'North South Travels Ltd.', 'BDT', NULL, NULL),
(1038, '10102801', 'DAC', 'BD', 'Golden Bengal Tours and Travels', 'BDT', NULL, NULL),
(1039, '10102804', 'DAC', 'BD', 'Shams Mirza Travels', 'BDT', NULL, NULL),
(1040, '10102811', 'JSR', 'BD', 'ST Air Travels', 'BDT', NULL, NULL),
(1041, '10102822', 'KHL', 'BD', 'Sameer Tours & Travels', 'BDT', NULL, NULL),
(1042, '10103071', 'CXB', 'BD', 'Allegro Holiday Suites', 'BDT', NULL, NULL),
(1043, '10103073', 'DAC', 'BD', 'Miqat Travels Pvt. Ltd.', 'BDT', NULL, NULL),
(1044, '10103086', 'DAC', 'BD', 'Khandaker Air International', 'BDT', NULL, NULL),
(1045, '10103635', 'DAC', 'BD', 'Wings Classic Tours & Travels Ltd. (DAC)', 'BDT', NULL, NULL),
(1046, '10103637', 'DAC', 'BD', 'Samin Tours & Travels', 'BDT', NULL, NULL),
(1047, '10104246', 'DAC', 'BD', 'Eco Travels', 'BDT', NULL, NULL),
(1048, '10104755', 'RJH', 'BD', 'Safe Travels International', 'BDT', NULL, NULL),
(1049, '10104766', 'RJH', 'BD', 'Suvecha Travels & Tours', 'BDT', NULL, NULL),
(1050, '10104772', 'RJH', 'BD', 'Mazumder Travel & Tours', 'BDT', NULL, NULL),
(1051, '10104778', 'RJH', 'BD', 'Modina New Tours & Travel', 'BDT', NULL, NULL),
(1052, '10104788', 'RJH', 'BD', 'Rawsan Ara Tour and Travels', 'BDT', NULL, NULL),
(1053, '10104795', 'RJH', 'BD', 'Hello Baneswar Travels & Tours', 'BDT', NULL, NULL),
(1054, '10104799', 'RJH', 'BD', 'Puthia Tours & Travel', 'BDT', NULL, NULL),
(1055, '10104844', 'RJH', 'BD', 'Media Tours & Travels', 'BDT', NULL, NULL),
(1056, '10104856', 'RJH', 'BD', 'Raj Travels', 'BDT', NULL, NULL),
(1057, '10104860', 'RJH', 'BD', 'Rahbare Haramain Tours & Travel', 'BDT', NULL, NULL),
(1058, '10104866', 'RJH', 'BD', 'Ziarate Haramain Travels', 'BDT', NULL, NULL),
(1059, '10104869', 'RJH', 'BD', 'Khan Aviation & Tourism Services', 'BDT', NULL, NULL),
(1060, '10106201', 'RJH', 'BD', 'Iqbal Tours & Travel', 'BDT', NULL, NULL),
(1061, '10106204', 'RJH', 'BD', 'Awal Tours & Travel', 'BDT', NULL, NULL),
(1062, '10106212', 'ZYL', 'BD', 'Royal Travels & Tours', 'BDT', NULL, NULL),
(1063, '10106214', 'DAC', 'BD', 'Trourism Window', 'BDT', NULL, NULL),
(1064, '10106222', 'CGP', 'BD', 'Meghna International Tours & Tours', 'BDT', NULL, NULL),
(1065, '10106230', 'DAC', 'BD', 'CORP Concern Universal', 'BDT', NULL, NULL),
(1066, '10106236', 'DAC', 'BD', 'CORP Basumati Distribution Ltd.', 'BDT', NULL, NULL),
(1067, '10106237', 'DAC', 'BD', 'Al Tacowa Tours & Travels', 'BDT', NULL, NULL),
(1068, '10106242', 'DAC', 'BD', 'Uttara Travels International', 'BDT', NULL, NULL),
(1069, '10106805', 'DAC', 'BD', 'Sharp Travels Limited', 'BDT', NULL, NULL),
(1070, '10106812', 'DAC', 'BD', 'Darvish Travels & Tours', 'BDT', NULL, NULL),
(1071, '10106815', 'DAC', 'BD', 'SAS Air Travels Ltd.', 'BDT', NULL, NULL),
(1072, '10106819', 'SPD', 'BD', 'Amana Tours And Travels', 'BDT', NULL, NULL),
(1073, '10106824', 'SPD', 'BD', 'Ziyarah Aviation', 'BDT', NULL, NULL),
(1074, '10107020', 'CGP', 'BD', 'Labbaik Travels & Tours', 'BDT', NULL, NULL),
(1075, '10107024', 'DAC', 'BD', 'Target Travels & Tours', 'BDT', NULL, NULL),
(1076, '10107030', 'DAC', 'BD', 'Srantho Tours & Travels', 'BDT', NULL, NULL),
(1077, '10107032', 'DAC', 'BD', 'Rafat Overseas', 'BDT', NULL, NULL),
(1078, '10107034', 'DAC', 'BD', 'Sharnali Travels International', 'BDT', NULL, NULL),
(1079, '10107045', 'DAC', 'BD', 'S.N Travels & Tours', 'BDT', NULL, NULL),
(1080, '10108098', 'DAC', 'BD', 'Rafid Tours & Travels', 'BDT', NULL, NULL),
(1081, '10108104', 'DAC', 'BD', 'Kansat Tours & Travels', 'BDT', NULL, NULL),
(1082, '10108108', 'DAC', 'BD', 'Mother Love Air Travels', 'BDT', NULL, NULL),
(1083, '10108381', 'DAC', 'BD', 'Safe Air Travels', 'BDT', NULL, NULL),
(1084, '10108386', 'ZYL', 'BD', 'CORP Hotel Valley Garden', 'BDT', NULL, NULL),
(1085, '10108397', 'ZYL', 'BD', 'CORP Britannia Hotel', 'BDT', NULL, NULL),
(1086, '10108401', 'CGP', 'BD', 'CORP NSN Enterprise', 'BDT', NULL, NULL),
(1087, '10108415', 'BZL', 'BD', 'Rongon Tours & Travels', 'BDT', NULL, NULL),
(1088, '10108445', 'ZYL', 'BD', 'Rabbani Overseas Aviation', 'BDT', NULL, NULL),
(1089, '10108450', 'DAC', 'BD', 'Go Bd Go Limited', 'BDT', NULL, NULL),
(1090, '10108456', 'BZL', 'BD', 'Bsit Tours & Travels', 'BDT', NULL, NULL),
(1091, '10108460', 'BZL', 'BD', 'B H Tours & Travels', 'BDT', NULL, NULL),
(1092, '10108467', 'DAC', 'BD', 'Parents Air International', 'BDT', NULL, NULL),
(1093, '10109009', 'DAC', 'BD', 'CORP Sonali Life Insurance Company Limited', 'BDT', NULL, NULL),
(1094, '10109016', 'DAC', 'BD', 'Columbia Tavels International', 'BDT', NULL, NULL),
(1095, '10109047', 'DAC', 'BD', 'Travel Gallery', 'BDT', NULL, NULL),
(1096, '10109183', 'DAC', 'BD', 'CORP M K Electronics', 'BDT', NULL, NULL),
(1097, '10109769', 'DAC', 'BD', 'Bikrampur Travel & Tours', 'BDT', NULL, NULL),
(1098, '10110044', 'DAC', 'BD', 'RJ Avition', 'BDT', NULL, NULL),
(1099, '10110908', 'DAC', 'BD', 'Tour Planners Limited', 'BDT', NULL, NULL),
(1100, '10110926', 'DAC', 'BD', 'Shaker Hajj Kafela & Travels', 'BDT', NULL, NULL),
(1101, '10110929', 'DAC', 'BD', 'Monira Tour & Travels', 'BDT', NULL, NULL),
(1102, '10110934', 'DAC', 'BD', 'Sky View Tours & Travels', 'BDT', NULL, NULL),
(1103, '10110940', 'DAC', 'BD', 'Khawaja Air Media Services Ltd.', 'BDT', NULL, NULL),
(1104, '10111288', 'CGP', 'BD', 'Need82 Enterprise', 'BDT', NULL, NULL),
(1105, '10111298', 'DAC', 'BD', 'Vision Tourism', 'BDT', NULL, NULL),
(1106, '10111302', 'DAC', 'BD', 'London Air Services LTD', 'BDT', NULL, NULL),
(1107, '10111325', 'DAC', 'BD', 'Zhong You Tours & Business Ltd.', 'BDT', NULL, NULL),
(1108, '10111777', 'DAC', 'BD', 'United Stars Travels', 'BDT', NULL, NULL),
(1109, '10111783', 'DAC', 'BD', 'Air Link Travels & Tours', 'BDT', NULL, NULL),
(1110, '10111787', 'CGP', 'BD', 'Top Ten Travels & Tours', 'BDT', NULL, NULL),
(1111, '10111795', 'CGP', 'BD', 'Traveliam Tours &Travels', 'BDT', NULL, NULL),
(1112, '10111800', 'CXB', 'BD', 'Tourism Window', 'BDT', NULL, NULL),
(1113, '10111803', 'CXB', 'BD', 'Green Village', 'BDT', NULL, NULL),
(1114, '10112209', 'CGP', 'BD', 'Mohua International', 'BDT', NULL, NULL),
(1115, '10112289', 'DAC', 'BD', 'CORP Modern Testing Services Bangladesh Limited', 'BDT', NULL, NULL),
(1116, '10113648', 'DAC', 'BD', 'CORP Chaity Group', 'BDT', NULL, NULL),
(1117, '10113675', 'DAC', 'BD', 'Hatim Travels & Tours', 'BDT', NULL, NULL),
(1118, '10113677', 'DAC', 'BD', 'Kazi Tourism', 'BDT', NULL, NULL),
(1119, '10113679', 'DAC', 'BD', 'Homnabad Travels', 'BDT', NULL, NULL),
(1120, '10113685', 'DAC', 'BD', 'Union Tour Services Ltd.', 'BDT', NULL, NULL),
(1121, '10113691', 'BZL', 'BD', 'Mastermind Travel & Tour', 'BDT', NULL, NULL),
(1122, '10113696', 'DAC', 'BD', 'Fashion Fly', 'BDT', NULL, NULL),
(1123, '10113883', 'BZL', 'BD', 'CORP Fortune Shoes Limited', 'BDT', NULL, NULL),
(1124, '10114391', 'CXB', 'BD', 'Warisa International', 'BDT', NULL, NULL),
(1125, '10115394', 'DAC', 'BD', 'Din Global Services Ltd.', 'BDT', NULL, NULL),
(1126, '10116292', 'DAC', 'BD', 'ITS Holidays', 'BDT', NULL, NULL),
(1127, '10116436', 'ZYL', 'BD', 'CORP Holy Sylhet Holding Limited', 'BDT', NULL, NULL),
(1128, '10116447', 'ZYL', 'BD', 'CORP Hotel Garden Inn', 'BDT', NULL, NULL),
(1129, '10116457', 'CGP', 'BD', 'Modern Travels', 'BDT', NULL, NULL),
(1130, '10116463', 'CGP', 'BD', 'Dhiofur Rahman Travels', 'BDT', NULL, NULL),
(1131, '10116470', 'ZYL', 'BD', 'Barun Travels', 'BDT', NULL, NULL),
(1132, '10116473', 'ZYL', 'BD', 'Travel International', 'BDT', NULL, NULL),
(1133, '10116620', 'DAC', 'BD', 'Grand Media Tours & Travels', 'BDT', NULL, NULL),
(1134, '10117321', 'DAC', 'BD', 'Piec Travel', 'BDT', NULL, NULL),
(1135, '10117334', 'DAC', 'BD', 'Diganta Tours & Travels', 'BDT', NULL, NULL),
(1136, '10117590', 'BZL', 'BD', 'Barisal Tours & Travels', 'BDT', NULL, NULL),
(1137, '10117595', 'CGP', 'BD', 'A.S Overseas Tours & Travels', 'BDT', NULL, NULL),
(1138, '10117599', 'SPD', 'BD', 'Hridoy Airlines & Travels', 'BDT', NULL, NULL),
(1139, '10118051', 'DAC', 'BD', 'CORP Total Tel', 'BDT', NULL, NULL),
(1140, '10119531', 'DAC', 'BD', 'CORP ENA GROUP', 'BDT', NULL, NULL),
(1141, '10119537', 'DAC', 'BD', 'CORP Selection Interior', 'BDT', NULL, NULL),
(1142, '10119542', 'DAC', 'BD', 'CORP Megatex International LLC', 'BDT', NULL, NULL),
(1143, '10119552', 'DAC', 'BD', 'CORP Ziska Pharmaceuticals Limited', 'BDT', NULL, NULL),
(1144, '10119560', 'DAC', 'BD', 'Eurasia Overseas', 'BDT', NULL, NULL),
(1145, '10119563', 'DAC', 'BD', 'Soudi Bangla Air Services Ltd.', 'BDT', NULL, NULL),
(1146, '10119746', 'KHL', 'BD', 'Air Solution', 'BDT', NULL, NULL),
(1147, '10119749', 'ZYL', 'BD', 'CORP G4S Secure Solutions Bangladesh (P) Ltd (ZYL)', 'BDT', NULL, NULL),
(1148, '10120337', 'DAC', 'BD', 'International Travel Services (ITS)', 'BDT', NULL, NULL),
(1149, '10120359', 'DAC', 'BD', 'City Neon Travels', 'BDT', NULL, NULL),
(1150, '10120366', 'DAC', 'BD', 'Easy Tours & Travels', 'BDT', NULL, NULL),
(1151, '10120370', 'DAC', 'BD', 'Inspire Aviation', 'BDT', NULL, NULL),
(1152, '10120374', 'DAC', 'BD', 'Good Link Air', 'BDT', NULL, NULL),
(1153, '10120433', 'DAC', 'BD', 'Assurance Air Services', 'BDT', NULL, NULL),
(1154, '10120437', 'DAC', 'BD', 'Orbit Tours & Travels', 'BDT', NULL, NULL),
(1155, '10120481', 'JSR', 'BD', 'Saikat Travels', 'BDT', NULL, NULL),
(1156, '10120489', 'DAC', 'BD', 'Afnan Air International', 'BDT', NULL, NULL),
(1157, '10124564', 'DAC', 'BD', 'Nodi Travels International', 'BDT', NULL, NULL),
(1158, '10124567', 'DAC', 'BD', 'Archives Tours & Travels', 'BDT', NULL, NULL),
(1159, '10125794', 'CGP', 'BD', 'CORP SBAC Bank Limited', 'BDT', NULL, NULL),
(1160, '10125797', 'CGP', 'BD', 'Nasif Aviation', 'BDT', NULL, NULL),
(1161, '10126328', 'ZYL', 'BD', 'CORP Hotel Holy Gate', 'BDT', NULL, NULL),
(1162, '10126333', 'DAC', 'BD', 'CORP Galaxy Facilitation Services Ltd.', 'BDT', NULL, NULL),
(1163, '10127878', 'DAC', 'BD', 'Newport Express Bd Ltd.', 'BDT', NULL, NULL),
(1164, '10127880', 'DAC', 'BD', 'CORP Khandaker Enterprise', 'BDT', NULL, NULL),
(1165, '10127884', 'DAC', 'BD', 'Fine Touch Travel & Tours', 'BDT', NULL, NULL),
(1166, '10127889', 'SPD', 'BD', 'Sagor Tour And Travel', 'BDT', NULL, NULL),
(1167, '10128276', 'DAC', 'BD', 'Fly World Ltd.', 'BDT', NULL, NULL),
(1168, '10128281', 'DAC', 'BD', 'Buraq Travels', 'BDT', NULL, NULL),
(1169, '10128287', 'CGP', 'BD', 'CORP Liberty Group', 'BDT', NULL, NULL),
(1170, '10128296', 'JSR', 'BD', 'Fly Air Travels', 'BDT', NULL, NULL),
(1171, '10128302', 'CGP', 'BD', 'Al Noor Travels & Tours', 'BDT', NULL, NULL),
(1172, '10128306', 'CXB', 'BD', 'Travel Box', 'BDT', NULL, NULL),
(1173, '10128366', 'DAC', 'BD', 'CORP NRBC Bank Limited', 'BDT', NULL, NULL),
(1174, '10129520', 'DAC', 'BD', 'Bizwiz Aviation & Tourism Ltd.', 'BDT', NULL, NULL),
(1175, '10129524', 'ZYL', 'BD', 'CORP Prime Bank Limited', 'BDT', NULL, NULL),
(1176, '10129528', 'DAC', 'BD', 'Kibria Air International Ltd.', 'BDT', NULL, NULL),
(1177, '10129531', 'DAC', 'BD', 'Darus Salam Travels & Tours', 'BDT', NULL, NULL),
(1178, '10129641', 'DAC', 'BD', 'S & H Travels', 'BDT', NULL, NULL),
(1179, '10129860', 'ZYL', 'BD', 'CORP North East Medical College', 'BDT', NULL, NULL),
(1180, '10129862', 'CGP', 'BD', 'CORP SG Logistics Pvt Limited', 'BDT', NULL, NULL),
(1181, '10129865', 'CGP', 'BD', 'CORP October 04 Ltd.', 'BDT', NULL, NULL),
(1182, '10129870', 'CGP', 'BD', 'CORP Bangladesh Spinners & Knitters (Pvt) Ltd.', 'BDT', NULL, NULL),
(1183, '10129873', 'CGP', 'BD', 'CORP Baizid Group', 'BDT', NULL, NULL),
(1184, '10130582', 'BZL', 'BD', 'New Rozy Tours & Travels', 'BDT', NULL, NULL),
(1185, '10130586', 'DAC', 'BD', 'Momenshahi Travels', 'BDT', NULL, NULL),
(1186, '10130593', 'DAC', 'BD', 'Natasha Travels', 'BDT', NULL, NULL),
(1187, '10130594', 'DAC', 'BD', 'CORP Energypac', 'BDT', NULL, NULL),
(1188, '10130597', 'ZYL', 'BD', 'CORP Shahjalal University of Science and Technology', 'BDT', NULL, NULL),
(1189, '10130603', 'ZYL', 'BD', 'CORP Sylhet Club Limited', 'BDT', NULL, NULL),
(1190, '10130784', 'ZYL', 'BD', 'CORP Cosmos Shoes International Ltd.', 'BDT', NULL, NULL),
(1191, '10130791', 'DAC', 'BD', 'Air Castle Travels', 'BDT', NULL, NULL),
(1192, '10132134', 'CGP', 'BD', 'CORP S.A Group of Industries', 'BDT', NULL, NULL),
(1193, '10132137', 'CGP', 'BD', 'CORP Chittagong Stock Exchange', 'BDT', NULL, NULL),
(1194, '10132162', 'SPD', 'BD', 'Tista Tours & Travels', 'BDT', NULL, NULL),
(1195, '10132641', 'DAC', 'BD', 'Saeed Air International', 'BDT', NULL, NULL),
(1196, '10132670', 'RJH', 'BD', 'Visa Network', 'BDT', NULL, NULL),
(1197, '10133123', 'DAC', 'BD', 'CORP Impress Fashion Ltd.', 'BDT', NULL, NULL),
(1198, '10133128', 'DAC', 'BD', 'CORP Far Pavilion Ltd.', 'BDT', NULL, NULL),
(1199, '10133349', 'DAC', 'BD', 'CORP Airtel Bangladesh Limited', 'BDT', NULL, NULL),
(1200, '10134517', 'SPD', 'BD', 'Travel Avenue', 'BDT', NULL, NULL),
(1201, '10134521', 'CGP', 'BD', 'CORP Confidence Creators', 'BDT', NULL, NULL),
(1202, '10134526', 'CGP', 'BD', 'CORP Institute of Management & Medical Technology', 'BDT', NULL, NULL),
(1203, '10134528', 'ZYL', 'BD', 'Al- Raiyan Overseas', 'BDT', NULL, NULL),
(1204, '10134530', 'DAC', 'BD', 'CORP Epyllion Group', 'BDT', NULL, NULL),
(1205, '10134533', 'DAC', 'BD', 'JTS Travels Ltd.', 'BDT', NULL, NULL),
(1206, '10134535', 'DAC', 'BD', 'Beacon Travel International Ltd.', 'BDT', NULL, NULL),
(1207, '10134536', 'DAC', 'BD', 'Xplorer Tourism', 'BDT', NULL, NULL),
(1208, '10134540', 'DAC', 'BD', 'Universal Travel Servies Ltd.', 'BDT', NULL, NULL),
(1209, '10134671', 'BZL', 'BD', 'Arman Tours & Travels', 'BDT', NULL, NULL),
(1210, '10134681', 'RJH', 'BD', 'Safari Tour & Travels', 'BDT', NULL, NULL),
(1211, '10134686', 'DAC', 'BD', 'Air Exhibition Ltd.', 'BDT', NULL, NULL),
(1212, '10134691', 'DAC', 'BD', 'Hashem Air International', 'BDT', NULL, NULL),
(1213, '10134906', 'DAC', 'BD', 'CORP Daewoo International', 'BDT', NULL, NULL),
(1214, '10134909', 'DAC', 'BD', 'United  Makkah Madina Travel & Assistance Co. Ltd.', 'BDT', NULL, NULL),
(1215, '10135253', 'CGP', 'BD', 'CORP Fergasam Bangladesh Limited', 'BDT', NULL, NULL),
(1216, '10135258', 'CGP', 'BD', 'CORP RTT Textile Industries Pvt.Ltd.', 'BDT', NULL, NULL),
(1217, '10136594', 'CGP', 'BD', 'CORP Lords Inn', 'BDT', NULL, NULL),
(1218, '10136597', 'DAC', 'BD', 'Asif Travels Limited', 'BDT', NULL, NULL),
(1219, '10136599', 'KHL', 'BD', 'Air Ticket Point', 'BDT', NULL, NULL),
(1220, '10136620', 'DAC', 'BD', 'CORP UL VS Bangladesh Limited', 'BDT', NULL, NULL),
(1221, '10136748', 'DAC', 'BD', 'Desh Travels & Tours', 'BDT', NULL, NULL),
(1222, '10136757', 'DAC', 'BD', 'CORP Shamsher Group', 'BDT', NULL, NULL),
(1223, '10137472', 'CGP', 'BD', 'CORP MARINERS CARGO SERVICES LTD.', 'BDT', NULL, NULL),
(1224, '10138489', 'DAC', 'BD', 'CORP Bangas Tallu Group', 'BDT', NULL, NULL),
(1225, '10138496', 'DAC', 'BD', 'CORP Kallol Group of Companies', 'BDT', NULL, NULL),
(1226, '10139242', 'DAC', 'BD', 'CORP Super Jute Mills', 'BDT', NULL, NULL),
(1227, '10139839', 'CGP', 'BD', 'CORP Sarc Enterprise', 'BDT', NULL, NULL),
(1228, '10139845', 'RJH', 'BD', 'Sharib Tours & Travels', 'BDT', NULL, NULL),
(1229, '10140047', 'DAC', 'BD', 'CORP Amber Denim Ltd.', 'BDT', NULL, NULL),
(1230, '10140051', 'DAC', 'BD', 'CORP Kaltimex Energy Bangladesh Pvt. Ltd.', 'BDT', NULL, NULL),
(1231, '10140056', 'RJH', 'BD', 'Eden Travels', 'BDT', NULL, NULL),
(1232, '10140067', 'RJH', 'BD', 'Jamuna Leisure & Holday Tours', 'BDT', NULL, NULL),
(1233, '10140074', 'CGP', 'BD', 'CORP Hela Clothing Bd Ltd.', 'BDT', NULL, NULL),
(1234, '10140097', 'DAC', 'BD', 'A K Azad Travel & Tours', 'BDT', NULL, NULL),
(1235, '10140299', 'DAC', 'BD', 'CORP Bangladesh Legal Aid and Services Trust', 'BDT', NULL, NULL),
(1236, '10140304', 'ZYL', 'BD', 'CORP Excelsior Sylhet Hotel & Resort', 'BDT', NULL, NULL),
(1237, '10140351', 'DAC', 'BD', 'CORP Bureau Veritas', 'BDT', NULL, NULL),
(1238, '10140354', 'CGP', 'BD', 'CORP KDS Steel Division', 'BDT', NULL, NULL),
(1239, '10140359', 'DAC', 'BD', 'CORP KDS Group', 'BDT', NULL, NULL),
(1240, '10140365', 'CGP', 'BD', 'CORP Corvo Cycles Ltd.', 'BDT', NULL, NULL),
(1241, '10140682', 'DAC', 'BD', 'Sabreen Travels & Tours', 'BDT', NULL, NULL),
(1242, '10140736', 'CGP', 'BD', 'CORP RF Builders Limited', 'BDT', NULL, NULL),
(1243, '10140740', 'CGP', 'BD', 'CORP Aramit Cement Limited', 'BDT', NULL, NULL),
(1244, '10141710', 'DAC', 'BD', 'Shanjid Travels Internaitona', 'BDT', NULL, NULL),
(1245, '10141711', 'SPD', 'BD', 'OHI Travels Limited', 'BDT', NULL, NULL),
(1246, '10143134', 'SPD', 'BD', 'Ashirbad Tours & Travels', 'BDT', NULL, NULL),
(1247, '10143530', 'BZL', 'BD', 'Dhaka Airlines', 'BDT', NULL, NULL),
(1248, '10144494', 'DAC', 'BD', 'CORP DHS Motors Limited', 'BDT', NULL, NULL),
(1249, '10144496', 'DAC', 'BD', 'CORP Karnaphuli Fertilizer Company Limited', 'BDT', NULL, NULL),
(1250, '10144689', 'RJH', 'BD', 'Love Air Travel Agency', 'BDT', NULL, NULL),
(1251, '10144929', 'BZL', 'BD', 'Sultania Tours & Travels', 'BDT', NULL, NULL),
(1252, '10144935', 'CGP', 'BD', 'CORP Premier Cement Mills Limited', 'BDT', NULL, NULL),
(1253, '10145311', 'DAC', 'BD', 'CORP ITX Trading S.A Bangladesh Liasion Office', 'BDT', NULL, NULL),
(1254, '10145317', 'CXB', 'BD', 'New Cox''s Bazar Tours & Travels', 'BDT', NULL, NULL),
(1255, '10145624', 'SPD', 'BD', 'Saidpur Travels', 'BDT', NULL, NULL),
(1256, '10145725', 'DAC', 'BD', 'Rimjhim Upashohar Limited', 'BDT', NULL, NULL),
(1257, '10145729', 'DAC', 'BD', 'CBS Holidays', 'BDT', NULL, NULL),
(1258, '10147969', 'DAC', 'BD', 'The City Holidays', 'BDT', NULL, NULL),
(1259, '10148606', 'DAC', 'BD', 'Jamuna Travel Services', 'BDT', NULL, NULL),
(1260, '10148611', 'CGP', 'BD', 'S A Travels', 'BDT', NULL, NULL),
(1261, '10148616', 'ZYL', 'BD', 'CORP M Ahmed Tea & Lands Company Limited', 'BDT', NULL, NULL),
(1262, '10148621', 'DAC', 'BD', 'CORP MGB Metro Group Buying HK Limited', 'BDT', NULL, NULL),
(1263, '10148995', 'DAC', 'BD', 'Sundial Travels Ltd.', 'BDT', NULL, NULL),
(1264, '10150496', 'DAC', 'BD', 'The Grand Master Events Ltd.', 'BDT', NULL, NULL),
(1265, '10151176', 'KUL', 'MY', 'Nahian Travel & Tours SND BHD', 'MYR', NULL, NULL),
(1266, '10151217', 'DAC', 'BD', 'Elite Travels & Tours', 'BDT', NULL, NULL),
(1267, '10151221', 'DAC', 'BD', 'Skylark Tours & Travels Ltd.', 'BDT', NULL, NULL),
(1268, '10151243', 'DAC', 'BD', 'Fortune Air Travels', 'BDT', NULL, NULL),
(1269, '10151245', 'DAC', 'BD', 'Independent Travels Limited', 'BDT', NULL, NULL),
(1270, '10151246', 'DAC', 'BD', 'Venice Travels & Tours', 'BDT', NULL, NULL),
(1271, '10151621', 'DAC', 'BD', 'Air World Communications', 'BDT', NULL, NULL),
(1272, '10151647', 'DAC', 'BD', 'Vivid Holidays Limited', 'BDT', NULL, NULL),
(1273, '10151656', 'DAC', 'BD', 'CORP Brother International Singapore Pte Ltd.', 'BDT', NULL, NULL),
(1274, '10152032', 'CGP', 'BD', 'CORP Medical Centre', 'BDT', NULL, NULL),
(1275, '10152456', 'DAC', 'BD', 'CORP Praasad Paradise', 'BDT', NULL, NULL),
(1276, '10152898', 'DAC', 'BD', 'CORP Goldenkey Agribusiness Company Limited, Bangladesh', 'BDT', NULL, NULL),
(1277, '10153311', 'DAC', 'BD', 'CORP Impact PR', 'BDT', NULL, NULL),
(1278, '10153320', 'DAC', 'BD', 'CORP Guardian Network', 'BDT', NULL, NULL),
(1279, '10153322', 'CXB', 'BD', 'CORP Seagull Hotels Ltd.', 'BDT', NULL, NULL),
(1280, '10153925', 'SPD', 'BD', 'Angel International Tours & Travels', 'BDT', NULL, NULL),
(1281, '10154399', 'DAC', 'BD', 'CORP Brushes & Needles', 'BDT', NULL, NULL),
(1282, '10154403', 'DAC', 'BD', 'Bengal Airways & Travels', 'BDT', NULL, NULL),
(1283, '10154406', 'CXB', 'BD', 'Cheer Holiday', 'BDT', NULL, NULL),
(1284, '10154874', 'DAC', 'BD', 'CORP Kuehne+Nagel', 'BDT', NULL, NULL),
(1285, '10155311', 'SPD', 'BD', 'Ashraf Overseas', 'BDT', NULL, NULL),
(1286, '10155485', 'DAC', 'BD', 'Air Wings Travel & Tours', 'BDT', NULL, NULL),
(1287, '10156982', 'DAC', 'BD', 'CORP Professional Associates Ltd.', 'BDT', NULL, NULL),
(1288, '10156985', 'CXB', 'BD', 'Sapphire Toursim & Entertainment', 'BDT', NULL, NULL),
(1289, '10156988', 'DAC', 'BD', 'Ensaf Tours & Travels', 'BDT', NULL, NULL),
(1290, '10156999', 'DAC', 'BD', 'Kushir Tours & Travels Ltd.', 'BDT', NULL, NULL),
(1291, '10157460', 'CGP', 'BD', 'CORP Chevron ClinicaL Laboratory (PTE) Ltd.', 'BDT', NULL, NULL),
(1292, '10157463', 'CGP', 'BD', 'CORP Ritzy Apparels Ltd.', 'BDT', NULL, NULL),
(1293, '10157475', 'DAC', 'BD', 'CORP Regent Group', 'BDT', NULL, NULL),
(1294, '10157628', 'DAC', 'BD', 'Bikrampur Overseas Ltd.', 'BDT', NULL, NULL),
(1295, '10157894', 'DAC', 'BD', 'CORP Deshbandhu Group', 'BDT', NULL, NULL),
(1296, '10157896', 'DAC', 'BD', 'Akashbari Holidays', 'BDT', NULL, NULL),
(1297, '10158607', 'CGP', 'BD', 'CORP Section Seven Limited', 'BDT', NULL, NULL),
(1298, '10158611', 'CGP', 'BD', 'CORP Chittagong Fashion Group', 'BDT', NULL, NULL),
(1299, '10158612', 'CGP', 'BD', 'CORP CSCR Pvt. Ltd.', 'BDT', NULL, NULL),
(1300, '10158619', 'CGP', 'BD', 'CORP Hotel safina Ltd.', 'BDT', NULL, NULL),
(1301, '10159124', 'DAC', 'BD', 'Esabah Enterprise', 'BDT', NULL, NULL),
(1302, '10159589', 'DAC', 'BD', 'World Traveller', 'BDT', NULL, NULL),
(1303, '10160150', 'DAC', 'BD', 'The Voyegers', 'BDT', NULL, NULL),
(1304, '10160156', 'DAC', 'BD', 'Travel Sky Connection', 'BDT', NULL, NULL),
(1305, '10160162', 'DAC', 'BD', 'Master Flight Ltd.', 'BDT', NULL, NULL),
(1306, '10160166', 'DAC', 'BD', 'Ehsan Air Travels', 'BDT', NULL, NULL),
(1307, '10160819', 'CGP', 'BD', 'CORP TNT Express', 'BDT', NULL, NULL),
(1308, '10160822', 'CGP', 'BD', 'CORP Rapid Group', 'BDT', NULL, NULL),
(1309, '10160829', 'CGP', 'BD', 'CORP Ocean Shipbuilders Ltd.', 'BDT', NULL, NULL),
(1310, '10160834', 'CXB', 'BD', 'CORP Nitol Bay Resort', 'BDT', NULL, NULL),
(1311, '10160836', 'DAC', 'BD', 'Ornob Orna', 'BDT', NULL, NULL),
(1312, '10160842', 'ZYL', 'BD', 'Aero Travels', 'BDT', NULL, NULL),
(1313, '10160854', 'DAC', 'BD', 'Sattar Travels & Tours', 'BDT', NULL, NULL),
(1314, '10161022', 'CGP', 'BD', 'CORP ZXY Apparel Manufacturing Limited', 'BDT', NULL, NULL),
(1315, '10161029', 'CGP', 'BD', 'CORP Habib Tazkira''s', 'BDT', NULL, NULL),
(1316, '10161843', 'DAC', 'BD', 'Amin Tours & Travels', 'BDT', NULL, NULL),
(1317, '10161846', 'CXB', 'BD', 'Prime Tours', 'BDT', NULL, NULL);
INSERT INTO `agencies` (`AgencyID`, `AgencyUserID`, `Zone`, `Country`, `Name`, `Setl_Currency`, `Phone`, `Address`) VALUES
(1318, '10161853', 'CGP', 'BD', 'CORP M. N Group', 'BDT', NULL, NULL),
(1319, '10161857', 'CGP', 'BD', 'CORP Copper Co. Ltd.', 'BDT', NULL, NULL),
(1320, '10162144', 'RJH', 'BD', 'Amin Hajj Group', 'BDT', NULL, NULL),
(1321, '10162220', 'CGP', 'BD', 'CORP The Techno House', 'BDT', NULL, NULL),
(1322, '10163100', 'DAC', 'BD', 'Master Overseas  (pvt.) Ltd.', 'BDT', NULL, NULL),
(1323, '10163874', 'CGP', 'BD', 'CORP R. M Group of Industries', 'BDT', NULL, NULL),
(1324, '10163876', 'CGP', 'BD', 'CORP Patenga Footwear (Pvt.) Ltd.', 'BDT', NULL, NULL),
(1325, '10163881', 'CGP', 'BD', 'Legacy Travel', 'BDT', NULL, NULL),
(1326, '10163888', 'DAC', 'BD', 'Mim Travels & Tours', 'BDT', NULL, NULL),
(1327, '10164476', 'DAC', 'BD', 'CORP AFC Health Ltd.', 'BDT', NULL, NULL),
(1328, '10164486', 'KHL', 'BD', 'Takeoff-SA', 'BDT', NULL, NULL),
(1329, '10164861', 'DAC', 'BD', 'CORP Grand Heritage Ltd.', 'BDT', NULL, NULL),
(1330, '10164908', 'KHL', 'BD', 'Travel Map', 'BDT', NULL, NULL),
(1331, '10165597', 'DAC', 'BD', 'CORP Corolla Corporation (BD) Limited', 'BDT', NULL, NULL),
(1332, '10165878', 'DAC', 'BD', 'Green Mask Travel & Tours', 'BDT', NULL, NULL),
(1333, '10165880', 'DAC', 'BD', 'Helana Tours & Travels', 'BDT', NULL, NULL),
(1334, '10165884', 'DAC', 'BD', 'Dream Touch Tours & Travels', 'BDT', NULL, NULL),
(1335, '10165885', 'DAC', 'BD', 'The Hazi Kamal Travel Agency', 'BDT', NULL, NULL),
(1336, '10165891', 'DAC', 'BD', 'Raisa Overseas Solution', 'BDT', NULL, NULL),
(1337, '10165895', 'DAC', 'BD', 'Rohani Air International', 'BDT', NULL, NULL),
(1338, '10166320', 'CGP', 'BD', 'CORP Trident Shipping Line Ltd.', 'BDT', NULL, NULL),
(1339, '10166324', 'SPD', 'BD', 'Sayma Travels International', 'BDT', NULL, NULL),
(1340, '10166554', 'CGP', 'BD', 'Taj International Travels & Tours', 'BDT', NULL, NULL),
(1341, '10166590', 'DAC', 'BD', 'Gloria Tours & Travels', 'BDT', NULL, NULL),
(1342, '10166611', 'DAC', 'BD', 'JF Bangladesh Limited (Dhaka)', 'BDT', NULL, NULL),
(1343, '10166847', 'CXB', 'BD', 'Be Safe Tours & Travels', 'BDT', NULL, NULL),
(1344, '10166850', 'ZYL', 'BD', 'CORP Noor Jahan Hospital Ltd.', 'BDT', NULL, NULL),
(1345, '10167572', 'CGP', 'BD', 'CORP Core Dent Dental & Implant Centre.', 'BDT', NULL, NULL),
(1346, '10168190', 'RJH', 'BD', 'TDS Tour & Travels', 'BDT', NULL, NULL),
(1347, '10168407', 'DAC', 'BD', 'Khan Air Travels', 'BDT', NULL, NULL),
(1348, '10169395', 'DAC', 'BD', 'CORP Center For Natural Resource Studies', 'BDT', NULL, NULL),
(1349, '10169407', 'DAC', 'BD', 'Tourist Gallery', 'BDT', NULL, NULL),
(1350, '10169410', 'DAC', 'BD', 'Al Aksa Travel & Tours', 'BDT', NULL, NULL),
(1351, '10171476', 'CGP', 'BD', 'CORP Four H Fashion Ltd.', 'BDT', NULL, NULL),
(1352, '10171890', 'DAC', 'BD', 'CORP UTI Pership (Pvt) Ltd.', 'BDT', NULL, NULL),
(1353, '10171895', 'DAC', 'BD', 'Sasco Air International', 'BDT', NULL, NULL),
(1354, '10171899', 'DAC', 'BD', 'Captain Holidays', 'BDT', NULL, NULL),
(1355, '10172270', 'SPD', 'BD', 'Milton Travels International', 'BDT', NULL, NULL),
(1356, '10172277', 'DAC', 'BD', 'Nilgiri Tours & Travels', 'BDT', NULL, NULL),
(1357, '10172453', 'CGP', 'BD', 'Air Fantasy Tours & Travels', 'BDT', NULL, NULL),
(1358, '10172458', 'CGP', 'BD', 'Holiday Plus', 'BDT', NULL, NULL),
(1359, '10172503', 'SPD', 'BD', 'Dooars Tours & Travels', 'BDT', NULL, NULL),
(1360, '10173605', 'DAC', 'BD', 'Jaf Travels', 'BDT', NULL, NULL),
(1361, '10174772', 'DAC', 'BD', 'Airbase Travels', 'BDT', NULL, NULL),
(1362, '10175366', 'CGP', 'BD', 'CORP Equity Property Management (Pvt.) Ltd.', 'BDT', NULL, NULL),
(1363, '10175393', 'JSR', 'BD', 'Sadman Tours & Travels', 'BDT', NULL, NULL),
(1364, '10175398', 'CXB', 'BD', 'Ocean Paradise Hotel & Resort', 'BDT', NULL, NULL),
(1365, '10175402', 'ZYL', 'BD', 'Royal Travels International', 'BDT', NULL, NULL),
(1366, '10176133', 'DAC', 'BD', 'Opshori Elma Enterprise', 'BDT', NULL, NULL),
(1367, '10176149', 'CGP', 'BD', 'Planet Air Communication''s', 'BDT', NULL, NULL),
(1368, '10176699', 'CGP', 'BD', 'CORP Total Shipping Agencies', 'BDT', NULL, NULL),
(1369, '10177268', 'DAC', 'BD', 'CORP Hema Far East Ltd.', 'BDT', NULL, NULL),
(1370, '10177269', 'CGP', 'BD', 'CORP Resort Development & Services Limited', 'BDT', NULL, NULL),
(1371, '10177276', 'CGP', 'BD', 'CORP JMS Garments Limited', 'BDT', NULL, NULL),
(1372, '10177279', 'CGP', 'BD', 'Shah Abdul Malek International & Hajj Group', 'BDT', NULL, NULL),
(1373, '10178364', 'DAC', 'BD', 'Siesta Travels', 'BDT', NULL, NULL),
(1374, '10180406', 'DAC', 'BD', 'Icejet Aviation', 'BDT', NULL, NULL),
(1375, '10181131', 'DAC', 'BD', 'CORP Aamra Group of Companies', 'BDT', NULL, NULL),
(1376, '10181141', 'DAC', 'BD', 'Shunfeng Travel Services Ltd.', 'BDT', NULL, NULL),
(1377, '10182780', 'DAC', 'BD', 'A B Education Tours & Travels', 'BDT', NULL, NULL),
(1378, '10182782', 'DAC', 'BD', 'Travel International Ltd.', 'BDT', NULL, NULL),
(1379, '10182807', 'DAC', 'BD', 'Zamzam Travels Bd', 'BDT', NULL, NULL),
(1380, '10183757', 'DAC', 'BD', 'Tokyo Travels International', 'BDT', NULL, NULL),
(1381, '10183760', 'DAC', 'BD', 'CORP Laser Trading', 'BDT', NULL, NULL),
(1382, '10183768', 'DAC', 'BD', 'BSC Tours & Travels', 'BDT', NULL, NULL),
(1383, '10185982', 'DAC', 'BD', 'Al Arafah Overseas', 'BDT', NULL, NULL),
(1384, '10185997', 'DAC', 'BD', 'Lintas Travels & Tours', 'BDT', NULL, NULL),
(1385, '10186000', 'DAC', 'BD', 'Brittania Aviation', 'BDT', NULL, NULL),
(1386, '10186013', 'DAC', 'BD', 'Dive Away Travels', 'BDT', NULL, NULL),
(1387, '10186017', 'DAC', 'BD', 'SZ Link Limited', 'BDT', NULL, NULL),
(1388, '10186020', 'DAC', 'BD', 'Al Rafi Travel Trade', 'BDT', NULL, NULL),
(1389, '10186251', 'DAC', 'BD', 'Grand Sikder Air Travels', 'BDT', NULL, NULL),
(1390, '10186946', 'USA', 'US', 'Blue Sky Travels', 'USD', NULL, NULL),
(1391, '10186983', 'CGP', 'BD', 'The Fly Today', 'BDT', NULL, NULL),
(1392, '10188829', 'DAC', 'BD', 'New Generation Overseas', 'BDT', NULL, NULL),
(1393, '10189697', 'KHL', 'BD', 'N N Welcome Travels & Tours', 'BDT', NULL, NULL),
(1394, '10189703', 'DAC', 'BD', 'CORP Norwest Industries Ltd.', 'BDT', NULL, NULL),
(1395, '10190331', 'DAC', 'BD', 'CORP Index  Group', 'BDT', NULL, NULL),
(1396, '10191547', 'DAC', 'BD', 'Khidmah Tours & Travels', 'BDT', NULL, NULL),
(1397, '10192186', 'DAC', 'BD', 'M M Travels & Tours', 'BDT', NULL, NULL),
(1398, '10192189', 'DAC', 'BD', 'Ticket Linker', 'BDT', NULL, NULL),
(1399, '10192192', 'DAC', 'BD', 'Inamon Aviation Limited', 'BDT', NULL, NULL),
(1400, '10192197', 'DAC', 'BD', 'M.H Overseas', 'BDT', NULL, NULL),
(1401, '10192201', 'DAC', 'BD', 'Magpie Tours & Travels', 'BDT', NULL, NULL),
(1402, '10192575', 'DAC', 'BD', 'Fuad Tours & Travels', 'BDT', NULL, NULL),
(1403, '10192581', 'DAC', 'BD', 'CORP Sleek Knit Garments Ltd.', 'BDT', NULL, NULL),
(1404, '10192654', 'USA', 'US', 'Rahmania Travels', 'USD', NULL, NULL),
(1405, '10192670', 'USA', 'US', 'Worldwide Travel Services', 'USD', NULL, NULL),
(1406, '10192673', 'DAC', 'BD', 'Aviation Plus Ltd.', 'BDT', NULL, NULL),
(1407, '10192689', 'DAC', 'BD', 'Rofrof Tours And Travels', 'BDT', NULL, NULL),
(1408, '10192692', 'DAC', 'BD', 'Related Tours & Travels', 'BDT', NULL, NULL),
(1409, '10194488', 'DAC', 'BD', 'CORP Star Porcelain Limited', 'BDT', NULL, NULL),
(1410, '10194491', 'CGP', 'BD', 'Sizzling Tour & Travels', 'BDT', NULL, NULL),
(1411, '10194495', 'DAC', 'BD', 'Faisal Air Travels & Tours', 'BDT', NULL, NULL),
(1412, '10194498', 'USA', 'US', 'Karnafully Travel Inc', 'USD', NULL, NULL),
(1413, '10194501', 'USA', 'US', 'Time Travel Inc', 'USD', NULL, NULL),
(1414, '10196001', 'USA', 'US', 'Meghna Travels', 'USD', NULL, NULL),
(1415, '10196013', 'USA', 'US', 'Rupali Travels & Services', 'USD', NULL, NULL),
(1416, '10196017', 'CGP', 'BD', 'Seven Tours & Travels', 'BDT', NULL, NULL),
(1417, '10196020', 'SPD', 'BD', 'Sifat Tours & Travels', 'BDT', NULL, NULL),
(1418, '10196563', 'DAC', 'BD', 'Sultana Travels & Tours', 'BDT', NULL, NULL),
(1419, '10196567', 'DAC', 'BD', 'Nishu Travel Agency', 'BDT', NULL, NULL),
(1420, '10196839', 'DAC', 'BD', 'CORP Novo Nordisk Pharma (Pvt) Ltd.', 'BDT', NULL, NULL),
(1421, '10197076', 'CGP', 'BD', 'Green Travels & Tours', 'BDT', NULL, NULL),
(1422, '10198134', 'DAC', 'BD', 'United Holiday', 'BDT', NULL, NULL),
(1423, '10198140', 'DAC', 'BD', 'Hasan Travels & Tours', 'BDT', NULL, NULL),
(1424, '10199160', 'DAC', 'BD', 'Dhaka Tours & Travels', 'BDT', NULL, NULL),
(1425, '10199767', 'KHL', 'BD', 'Fair Deal Enterprise', 'BDT', NULL, NULL),
(1426, '10199846', 'DAC', 'BD', 'ITS Holidays worldwide', 'BDT', NULL, NULL),
(1427, '10200074', 'DAC', 'BD', 'ICL Aviation Services', 'BDT', NULL, NULL),
(1428, '10200820', 'CGP', 'BD', 'Flamingo Tours & Travel', 'BDT', NULL, NULL),
(1429, '10200940', 'DAC', 'BD', 'Sara Travels', 'BDT', NULL, NULL),
(1430, '10200944', 'DAC', 'BD', 'Tahamina International Travels & Tours', 'BDT', NULL, NULL),
(1431, '10200949', 'DAC', 'BD', 'Bushra Aviation', 'BDT', NULL, NULL),
(1432, '10200952', 'DAC', 'BD', 'United Investment & Trading Corporation Limited', 'BDT', NULL, NULL),
(1433, '10200953', 'DAC', 'BD', 'Global Reach Tours & Travels', 'BDT', NULL, NULL),
(1434, '10200956', 'DAC', 'BD', 'Bashundhara Aviation Services', 'BDT', NULL, NULL),
(1435, '10201469', 'DAC', 'BD', 'Corp Partex Star Group', 'BDT', NULL, NULL),
(1436, '10202046', 'CGP', 'BD', 'CORP Imperial Group', 'BDT', NULL, NULL),
(1437, '10202051', 'CGP', 'BD', 'CORP Well Park Residence', 'BDT', NULL, NULL),
(1438, '10202480', 'DAC', 'BD', 'H M Air Travels', 'BDT', NULL, NULL),
(1439, '10202486', 'CGP', 'BD', 'Corp A N Textile Service', 'BDT', NULL, NULL),
(1440, '10202494', 'CGP', 'BD', 'Corp S J Industiral Bd  Ltd.', 'BDT', NULL, NULL),
(1441, '10202498', 'CGP', 'BD', 'Corp M Z M Textile Ltd', 'BDT', NULL, NULL),
(1442, '10202505', 'CGP', 'BD', 'Corp HKD International', 'BDT', NULL, NULL),
(1443, '10202843', 'DAC', 'BD', 'Corp Kuwait Joint Relief Committee', 'BDT', NULL, NULL),
(1444, '10202849', 'CGP', 'BD', 'Corp GH Haewae Co. Ltd.', 'BDT', NULL, NULL),
(1445, '10202856', 'CGP', 'BD', 'Corp Base Textiles Ltd.', 'BDT', NULL, NULL),
(1446, '10202870', 'DAC', 'BD', 'Corp Petrochem (Bangladesh) limited', 'BDT', NULL, NULL),
(1447, '10202877', 'DAC', 'BD', 'Mymensingh Haji Travels', 'BDT', NULL, NULL),
(1448, '10202892', 'CGP', 'BD', 'Corp GPH Ispat Ltd.', 'BDT', NULL, NULL),
(1449, '10203101', 'SIN', 'SG', 'Shahid Travels & Tours', 'SGD', NULL, NULL),
(1450, '10203113', 'DAC', 'BD', 'Corp World Fish', 'BDT', NULL, NULL),
(1451, '10203144', 'DAC', 'BD', 'Traveline Bangladesh', 'BDT', NULL, NULL),
(1452, '10203493', 'USA', 'US', 'Probasi Multiservices of Park Chester Inc.', 'USD', NULL, NULL),
(1453, '10203516', 'DAC', 'BD', 'Arham Travels & Tours', 'BDT', NULL, NULL),
(1454, '10203518', 'DAC', 'BD', 'Sonargaon Travel International', 'BDT', NULL, NULL),
(1455, '10203523', 'CGP', 'BD', 'Pioneer Tours & Travels', 'BDT', NULL, NULL),
(1456, '10203547', 'DAC', 'BD', 'Al Bid Air Travels', 'BDT', NULL, NULL),
(1457, '10203634', 'SPD', 'BD', 'Tithi Airlines & Travels', 'BDT', NULL, NULL),
(1458, '10204740', 'CGP', 'BD', 'CORP Mamiya-OP', 'BDT', NULL, NULL),
(1459, '10204800', 'DAC', 'BD', 'Sundarban Air Travels', 'BDT', NULL, NULL),
(1460, '10204873', 'DAC', 'BD', 'CORP APEX HOLDINGS LIMITED', 'BDT', NULL, NULL),
(1461, '10205047', 'CGP', 'BD', 'CORP Bangladesh Military Academy (BMA)', 'BDT', NULL, NULL),
(1462, '10205058', 'DAC', 'BD', 'CORP Brand Maker Property Management Ltd.', 'BDT', NULL, NULL),
(1463, '10205145', 'CGP', 'BD', 'CORP Meiji Industries Pvt. Ltd.', 'BDT', NULL, NULL),
(1464, '10205248', 'CGP', 'BD', 'CORP Delmas Apparels (Pvt.) Ltd.', 'BDT', NULL, NULL),
(1465, '10205291', 'CGP', 'BD', 'CORP Univogue Garments Ltd.', 'BDT', NULL, NULL),
(1466, '10205297', 'DAC', 'BD', 'The World Wide Travels & Tours', 'BDT', NULL, NULL),
(1467, '10205374', 'DAC', 'BD', 'CORP NEC Corporation', 'BDT', NULL, NULL),
(1468, '10205377', 'DAC', 'BD', 'CORP Ridge Park Holdings Ltd.', 'BDT', NULL, NULL),
(1469, '10205381', 'CGP', 'BD', 'Pragga Tours & Travels', 'BDT', NULL, NULL),
(1470, '10205659', 'CGP', 'BD', 'CORP STRONG FOOTWEAR LTD', 'BDT', NULL, NULL),
(1471, '10205798', 'CGP', 'BD', 'CORP VALTEX INTERNATIONAL', 'BDT', NULL, NULL),
(1472, '10205914', 'DAC', 'BD', 'Yasmin Travels & Tours', 'BDT', NULL, NULL),
(1473, '10205961', 'USA', 'US', 'Digital Travel & Tour', 'USD', NULL, NULL),
(1474, '10205971', 'CGP', 'BD', 'CORP Columbia Sportswear Company (Hong Kong) Ltd.', 'BDT', NULL, NULL),
(1475, '10206262', 'CGP', 'BD', 'CORP Young An Hat (BD) Ltd.', 'BDT', NULL, NULL),
(1476, '10206408', 'CGP', 'BD', 'CORP Smart Jeans Ltd.', 'BDT', NULL, NULL),
(1477, '10206415', 'DAC', 'BD', 'CORP Baly Yarn Dyeing Ltd.', 'BDT', NULL, NULL),
(1478, '10206421', 'DAC', 'BD', 'CORP Sanowara Drinks & Beverage Industries Limited', 'BDT', NULL, NULL),
(1479, '10206445', 'DAC', 'BD', 'EC Aviation Ltd.', 'BDT', NULL, NULL),
(1480, '10206548', 'USA', 'US', 'Global Air Services', 'USD', NULL, NULL),
(1481, '10207032', 'CGP', 'BD', 'CORP AK Khan Penfabric Co.Ltd', 'BDT', NULL, NULL),
(1482, '10207038', 'DAC', 'BD', 'CORP Microtech', 'BDT', NULL, NULL),
(1483, '10207046', 'CGP', 'BD', 'CORP BD Designs Private Ltd.', 'BDT', NULL, NULL),
(1484, '10207051', 'CGP', 'BD', 'CORP Clewiston Group', 'BDT', NULL, NULL),
(1485, '10207054', 'CGP', 'BD', 'CORP Coral Reef Properties Ltd.', 'BDT', NULL, NULL),
(1486, '10207059', 'DAC', 'BD', 'Skein Travel', 'BDT', NULL, NULL),
(1487, '10207116', 'DAC', 'BD', 'Air Madina Travels', 'BDT', NULL, NULL),
(1488, '10207117', 'DAC', 'BD', 'Sky Elevator Tours And Travels', 'BDT', NULL, NULL),
(1489, '10207122', 'DAC', 'BD', 'Orchid Travels', 'BDT', NULL, NULL),
(1490, '10207745', 'DAC', 'BD', 'M H M Overseas', 'BDT', NULL, NULL),
(1491, '10207747', 'DAC', 'BD', 'CORP Fareast Finance & Investment Limited', 'BDT', NULL, NULL),
(1492, '10208371', 'USA', 'US', 'Skyline Travels & Multiservices', 'USD', NULL, NULL),
(1493, '10208375', 'DAC', 'BD', 'CORP Nascent Gardenia', 'BDT', NULL, NULL),
(1494, '10208557', 'DAC', 'BD', 'CORP Spectra Hexa Feeds Ltd.', 'BDT', NULL, NULL),
(1495, '10208894', 'DAC', 'BD', 'CORP Spectra Group', 'BDT', NULL, NULL),
(1496, '10208939', 'CGP', 'BD', 'CORP Caesar Apparels Limited', 'BDT', NULL, NULL),
(1497, '10208947', 'CGP', 'BD', 'CORP Campex (BD) Ltd', 'BDT', NULL, NULL),
(1498, '10208953', 'CGP', 'BD', 'CORP SAIF Powertec Limited', 'BDT', NULL, NULL),
(1499, '10209355', 'CGP', 'BD', 'CORP Azim Group', 'BDT', NULL, NULL),
(1500, '10209358', 'ZYL', 'BD', 'Shimon Overseas Express', 'BDT', NULL, NULL),
(1501, '10209362', 'CGP', 'BD', 'Oxford International Travels & Tours', 'BDT', NULL, NULL),
(1502, '10209437', 'DAC', 'BD', 'CORP HQ Border Guard Bangladesh', 'BDT', NULL, NULL),
(1503, '10209615', 'CGP', 'BD', 'CORP Banoful & Co', 'BDT', NULL, NULL),
(1504, '10210373', 'DAC', 'BD', 'CORP NRB Bank', 'BDT', NULL, NULL),
(1505, '10210379', 'DAC', 'BD', 'CORP D.H. Euro Tech Co. Ltd', 'BDT', NULL, NULL),
(1506, '10212217', 'CGP', 'BD', 'Cosmos Tours & Travel', 'BDT', NULL, NULL),
(1507, '10212331', 'DAC', 'BD', 'Sarkar Travels & Tours', 'BDT', NULL, NULL),
(1508, '10242963', 'ZYL', 'BD', 'Ruzy Travels', 'BDT', NULL, NULL),
(1509, '10242970', 'CGP', 'BD', 'New Chowdhury International', 'BDT', NULL, NULL),
(1510, '10242975', 'DAC', 'BD', 'Zinatun Air Travels', 'BDT', NULL, NULL),
(1511, '10242979', 'CGP', 'BD', 'CORP MH Group of Companies', 'BDT', NULL, NULL),
(1512, '10242988', 'CGP', 'BD', 'CORP Sunman Group Of Companies', 'BDT', NULL, NULL),
(1513, '10243011', 'CGP', 'BD', 'CORP XIN CHANG SHOES (BD) LIMITED', 'BDT', NULL, NULL),
(1514, '10243023', 'CGP', 'BD', 'CORP Chittagong Knitwears (pvt) Ltd.', 'BDT', NULL, NULL),
(1515, '10243063', 'DAC', 'BD', 'Arva Aviation', 'BDT', NULL, NULL),
(1516, '10243071', 'DAC', 'BD', 'Ramoni Travel & Tours', 'BDT', NULL, NULL),
(1517, '10243279', 'CGP', 'BD', 'CORP OP-SEED CO., (BD) LTD.', 'BDT', NULL, NULL),
(1518, '10243515', 'CGP', 'BD', 'CORP T. K. Group of Industries', 'BDT', NULL, NULL),
(1519, '10243520', 'CGP', 'BD', 'CORP Intimate Apparels Ltd', 'BDT', NULL, NULL),
(1520, '10243523', 'DAC', 'BD', 'CORP Golden Harvest Group', 'BDT', NULL, NULL),
(1521, '10243525', 'CGP', 'BD', 'CORP Adila Apparels', 'BDT', NULL, NULL),
(1522, '10243528', 'DAC', 'BD', 'Masha-Allah Travels Solution', 'BDT', NULL, NULL),
(1523, '10243534', 'DAC', 'BD', 'Media Travels', 'BDT', NULL, NULL),
(1524, '10243535', 'DAC', 'BD', 'Gulshan Tours Ltd', 'BDT', NULL, NULL),
(1525, '10243538', 'DAC', 'BD', 'Rana Tours & Travels', 'BDT', NULL, NULL),
(1526, '10243543', 'DAC', 'BD', 'H. J Travels & Tours', 'BDT', NULL, NULL),
(1527, '10243544', 'DAC', 'BD', 'Airbest Ltd', 'BDT', NULL, NULL),
(1528, '10244156', 'DAC', 'BD', 'EVERGREEN Travels & Tours', 'BDT', NULL, NULL),
(1529, '10244222', 'DAC', 'BD', 'Al Haramine Tours & Travels', 'BDT', NULL, NULL),
(1530, '10244368', 'DAC', 'BD', 'Shan Travels', 'BDT', NULL, NULL),
(1531, '10244370', 'DAC', 'BD', 'CORP Helvetia Fast Food & Coffee House', 'BDT', NULL, NULL),
(1532, '10244373', 'DAC', 'BD', 'CORP MySoft Limited', 'BDT', NULL, NULL),
(1533, '10244375', 'DAC', 'BD', 'CORP Partex Group', 'BDT', NULL, NULL),
(1534, '10244378', 'DAC', 'BD', 'Silvee And Sinthe Travel Agency Ltd.', 'BDT', NULL, NULL),
(1535, '10244632', 'DAC', 'BD', 'A.P Tours & Travels', 'BDT', NULL, NULL),
(1536, '10244691', 'DAC', 'BD', 'Banga Raja Travels Service', 'BDT', NULL, NULL),
(1537, '10245790', 'CGP', 'BD', 'CORP FMC Group of Companies', 'BDT', NULL, NULL),
(1538, '10245795', 'CGP', 'BD', 'CORP Sicho Group', 'BDT', NULL, NULL),
(1539, '10245799', 'DAC', 'BD', 'CORP Bangladesh Edible Oil Limited (BEOL)', 'BDT', NULL, NULL),
(1540, '10245805', 'CGP', 'BD', 'CORP Alita (BD) Limited', 'BDT', NULL, NULL),
(1541, '10245810', 'CGP', 'BD', 'CORP Panam Ship Management Limited', 'BDT', NULL, NULL),
(1542, '10245813', 'DAC', 'BD', 'CORP Gazi Group', 'BDT', NULL, NULL),
(1543, '10246074', 'DAC', 'BD', 'CORP Network Elements of Security & Trust Ltd', 'BDT', NULL, NULL),
(1544, '10246080', 'DAC', 'BD', 'CORP Transcom Foods Limited.', 'BDT', NULL, NULL),
(1545, '10246086', 'DAC', 'BD', 'CORP Asia Excel Trading Ltd.', 'BDT', NULL, NULL),
(1546, '10246105', 'CGP', 'BD', 'CORP MZM (CEPZ) LTD', 'BDT', NULL, NULL),
(1547, '10246325', 'CGP', 'BD', 'CORP Hemple Rhee Mfg. Co. (BD) Ltd.', 'BDT', NULL, NULL),
(1548, '10246338', 'CGP', 'BD', 'CORP Mars Sportswear Ltd.', 'BDT', NULL, NULL),
(1549, '10246342', 'SPD', 'BD', 'MR Tours & Travels', 'BDT', NULL, NULL),
(1550, '10246347', 'SPD', 'BD', 'Jamuna  Travels & Tours Agency', 'BDT', NULL, NULL),
(1551, '10246845', 'DAC', 'BD', 'sunflower Tours & Travels', 'BDT', NULL, NULL),
(1552, '10247925', 'DAC', 'BD', 'CORP Mohammadi Electric Wires & Multi Products (MEP) Ltd', 'BDT', NULL, NULL),
(1553, '10248337', 'DAC', 'BD', 'CORP ACDI/VOCA', 'BDT', NULL, NULL),
(1554, '10248346', 'DAC', 'BD', 'CORP Nazdaq Technologies Inc.', 'BDT', NULL, NULL),
(1555, '10248809', 'DAC', 'BD', 'Razan Overseas (Pvt) Ltd', 'BDT', NULL, NULL),
(1556, '10248870', 'CGP', 'BD', 'CORP Naturub Accessories BD (Pvt) Ltd.', 'BDT', NULL, NULL),
(1557, '10248883', 'DAC', 'BD', 'Sardar Tours & Travels', 'BDT', NULL, NULL),
(1558, '10248887', 'DAC', 'BD', 'Shonir Akhara HD Tour and Travels', 'BDT', NULL, NULL),
(1559, '10249404', 'DAC', 'BD', 'ABCO Overseas', 'BDT', NULL, NULL),
(1560, '10249758', 'DAC', 'BD', 'Raisa Consultancy Limited & Travels', 'BDT', NULL, NULL),
(1561, '10249762', 'DAC', 'BD', 'Albatross Tourism', 'BDT', NULL, NULL),
(1562, '10249781', 'DAC', 'BD', 'Heaven Tours & Travels', 'BDT', NULL, NULL),
(1563, '10249882', 'CGP', 'BD', 'CORP Golden Son Limited', 'BDT', NULL, NULL),
(1564, '10249888', 'DAC', 'BD', 'Brightway Travels', 'BDT', NULL, NULL),
(1565, '10249892', 'DAC', 'BD', 'CORP Islamic Relief, Bangladesh (IRB)', 'BDT', NULL, NULL),
(1566, '10250170', 'DAC', 'BD', 'CORP Zenith Islami Life Insurance Ltd.', 'BDT', NULL, NULL),
(1567, '10250173', 'DAC', 'BD', 'CORP JTC Group of Companies', 'BDT', NULL, NULL),
(1568, '10250174', 'DAC', 'BD', 'CORP Woori Bank', 'BDT', NULL, NULL),
(1569, '10251477', 'DAC', 'BD', 'Global Air Tours & Travels', 'BDT', NULL, NULL),
(1570, '10251480', 'KHL', 'BD', 'Alena Air Service', 'BDT', NULL, NULL),
(1571, '10251511', 'ZYL', 'BD', 'CORP Nazimgarh Resorts', 'BDT', NULL, NULL),
(1572, '10251744', 'CGP', 'BD', 'Brown Air Bd Travel & Tours', 'BDT', NULL, NULL),
(1573, '10251751', 'DAC', 'BD', 'CORP Survey 2000', 'BDT', NULL, NULL),
(1574, '10251768', 'SPD', 'BD', 'Ela Traders', 'BDT', NULL, NULL),
(1575, '10251772', 'CGP', 'BD', 'CORP Bangladesh Pou Hung Industries Ltd.', 'BDT', NULL, NULL),
(1576, '10251782', 'CGP', 'BD', 'CORP Bismillah Group', 'BDT', NULL, NULL),
(1577, '10251795', 'KHL', 'BD', 'Air Space', 'BDT', NULL, NULL),
(1578, '10251797', 'KHL', 'BD', 'Route Map', 'BDT', NULL, NULL),
(1579, '10251802', 'KHL', 'BD', 'Ghuri Travel', 'BDT', NULL, NULL),
(1580, '10252345', 'DAC', 'BD', 'At Tablig Hajj Services', 'BDT', NULL, NULL),
(1581, '10252358', 'DAC', 'BD', 'RNB Aviation', 'BDT', NULL, NULL),
(1582, '10252663', 'DAC', 'BD', 'Prottasha Tours & Travels', 'BDT', NULL, NULL),
(1583, '10252667', 'DAC', 'BD', 'Zahi Air International', 'BDT', NULL, NULL),
(1584, '10252669', 'DAC', 'BD', 'Al Nayim Air International', 'BDT', NULL, NULL),
(1585, '10252672', 'DAC', 'BD', 'Mass Tour & Travels', 'BDT', NULL, NULL),
(1586, '10252676', 'ZYL', 'BD', 'CORP S.S Enterprise', 'BDT', NULL, NULL),
(1587, '10252681', 'DAC', 'BD', 'Speedy Intl Limited', 'BDT', NULL, NULL),
(1588, '10252683', 'DAC', 'BD', 'Sarail B-Baria Travels International', 'BDT', NULL, NULL),
(1589, '10252689', 'DAC', 'BD', 'Amit Travel International', 'BDT', NULL, NULL),
(1590, '10253780', 'CGP', 'BD', 'CORP Nurjahan Group', 'BDT', NULL, NULL),
(1591, '10253783', 'SPD', 'BD', 'Jannat Travels International', 'BDT', NULL, NULL),
(1592, '10254280', 'DAC', 'BD', 'CORP Hosaf Group of Companies', 'BDT', NULL, NULL),
(1593, '10254964', 'DAC', 'BD', 'Transerve Corporate Services Ltd.', 'BDT', NULL, NULL),
(1594, '10254975', 'DAC', 'BD', 'CORP DataSoft Systems Bangladesh Limited', 'BDT', NULL, NULL),
(1595, '10255001', 'DAC', 'BD', 'Xplore Holidays Limited', 'BDT', NULL, NULL),
(1596, '10255005', 'DAC', 'BD', 'A-One Air International', 'BDT', NULL, NULL),
(1597, '10255096', 'DAC', 'BD', 'New Dhanmondi Air Travels', 'BDT', NULL, NULL),
(1598, '10255241', 'DAC', 'BD', 'Pabna Tours And Travels', 'BDT', NULL, NULL),
(1599, '10255312', 'CGP', 'BD', 'CORP Eastern Logistics Limited', 'BDT', NULL, NULL),
(1600, '10255316', 'DAC', 'BD', 'Travel Aviation Servides Ltd.', 'BDT', NULL, NULL),
(1601, '10255405', 'CGP', 'BD', 'CORP Hotel Sea World Cox''s Bazar Ltd.', 'BDT', NULL, NULL),
(1602, '10256423', 'CGP', 'BD', 'The Aamar Ticket', 'BDT', NULL, NULL),
(1603, '10256830', 'DAC', 'BD', 'Journey By Air', 'BDT', NULL, NULL),
(1604, '10257135', 'DAC', 'BD', 'CORP GDS Chemical Bangladesh (Pvt.) Ltd.', 'BDT', NULL, NULL),
(1605, '10257444', 'DAC', 'BD', 'Nasir Aviation Services', 'BDT', NULL, NULL),
(1606, '10257620', 'DAC', 'BD', 'Silk Route Tours & Travels', 'BDT', NULL, NULL),
(1607, '10257633', 'DAC', 'BD', 'Vista Travels & Tours', 'BDT', NULL, NULL),
(1608, '10257637', 'DAC', 'BD', 'ZM Tours And Travels Ltd.', 'BDT', NULL, NULL),
(1609, '10258014', 'RJH', 'BD', 'Nahar Travel Agency', 'BDT', NULL, NULL),
(1610, '10258022', 'DAC', 'BD', 'Sun Light Aviation Services', 'BDT', NULL, NULL),
(1611, '10258714', 'CGP', 'BD', 'CORP Seven Seas Shipping & Trading', 'BDT', NULL, NULL),
(1612, '10258735', 'DAC', 'BD', 'S Unique Holidays', 'BDT', NULL, NULL),
(1613, '10258736', 'DAC', 'BD', 'Mintu Tours & Travels', 'BDT', NULL, NULL),
(1614, '10258743', 'DAC', 'BD', 'Masud Travels & Tours', 'BDT', NULL, NULL),
(1615, '10258747', 'DAC', 'BD', 'Tanjil Air Services', 'BDT', NULL, NULL),
(1616, '10258823', 'DAC', 'BD', 'CORP Kuakata Grand Hotel and Sea Resort', 'BDT', NULL, NULL),
(1617, '10259076', 'KTM', 'NP', 'NP Namaste Aviation International Pvt. Ltd.', 'NPR', NULL, NULL),
(1618, '10259212', 'Test', 'BD', 'NP USB Holiday (KTM)', 'BDT', NULL, NULL),
(1619, '10259672', 'DAC', 'BD', 'CORP Somoy Media Limited', 'BDT', NULL, NULL),
(1620, '10259678', 'DAC', 'BD', 'CORP JIC Suit Ltd.', 'BDT', NULL, NULL),
(1621, '10259681', 'CGP', 'BD', 'S S International Travel Agent', 'BDT', NULL, NULL),
(1622, '10260506', 'DAC', 'BD', 'CORP ADB TA: 8913 BAN Project of LGED', 'BDT', NULL, NULL),
(1623, '10260534', 'DAC', 'BD', 'CORP OTOBI Limited', 'BDT', NULL, NULL),
(1624, '10260548', 'DAC', 'BD', 'Cholbe', 'BDT', NULL, NULL),
(1625, '10260607', 'DAC', 'BD', 'Graey Travel Link', 'BDT', NULL, NULL),
(1626, '10260612', 'JSR', 'BD', 'S M Fee Amanillah Travel & Tours', 'BDT', NULL, NULL),
(1627, '10260614', 'CGP', 'BD', 'CORP Arakan Associates', 'BDT', NULL, NULL),
(1628, '10261356', 'CGP', 'BD', 'CORP Uni Garments Limited', 'BDT', NULL, NULL),
(1629, '10261362', 'DAC', 'BD', 'Seba Air Limited', 'BDT', NULL, NULL),
(1630, '10261845', 'DAC', 'BD', 'Bay Global Maritime Internatioanl', 'BDT', NULL, NULL),
(1631, '10262154', 'DAC', 'BD', 'Amazon Holidays Travel Services Ltd.', 'BDT', NULL, NULL),
(1632, '10262368', 'CGP', 'BD', 'CORP Kenpark Bangladesh Apparel (Pvt.) Limited', 'BDT', NULL, NULL),
(1633, '10262537', 'SPD', 'BD', 'Milon Travels Agency', 'BDT', NULL, NULL),
(1634, '10263000', 'DAC', 'BD', 'Embassy Travels', 'BDT', NULL, NULL),
(1635, '10263003', 'CXB', 'BD', 'Biplob Air International Travel Agency', 'BDT', NULL, NULL),
(1636, '10263389', 'DAC', 'BD', 'Al Abdhullah Services', 'BDT', NULL, NULL),
(1637, '10263392', 'DAC', 'BD', 'Monihar Travels Limited', 'BDT', NULL, NULL),
(1638, '10263393', 'DAC', 'BD', 'CORP Bengal Inn', 'BDT', NULL, NULL),
(1639, '10264174', 'KTM', 'NP', 'NP Namaste Travel (P) LTD', 'NPR', NULL, NULL),
(1640, '10264181', 'KTM', 'NP', 'NP Himalayan Travel Pvt Ltd', 'NPR', NULL, NULL),
(1641, '10264191', 'KTM', 'NP', 'NP Rainbow Travels and Tours Pvt Ltd', 'NPR', NULL, NULL),
(1642, '10264205', 'KTM', 'NP', 'NP Osho World Travel pvt Ltd', 'NPR', NULL, NULL),
(1643, '10264214', 'KTM', 'NP', 'NP Regency Nepal Travel and Tours', 'NPR', NULL, NULL),
(1644, '10264227', 'KTM', 'NP', 'NP Muskan Travel Pvt Ltd', 'NPR', NULL, NULL),
(1645, '10264232', 'KTM', 'NP', 'NP AM Trip Pvt Ltd', 'NPR', NULL, NULL),
(1646, '10264242', 'KTM', 'NP', 'NP Jaya Travels and Tours', 'NPR', NULL, NULL),
(1647, '10264244', 'KTM', 'NP', 'NP Koshi Travel pvt Ltd', 'NPR', NULL, NULL),
(1648, '10264247', 'KTM', 'NP', 'NP society travel pvt ltd', 'NPR', NULL, NULL),
(1649, '10264260', 'KTM', 'NP', 'NP Haevest Moon Travels and tours', 'NPR', NULL, NULL),
(1650, '10264263', 'KTM', 'NP', 'NP MegaByte Travel pvt Ltd', 'NPR', NULL, NULL),
(1651, '10264266', 'KTM', 'NP', 'NP Yeti travel Pvt Ltd', 'NPR', NULL, NULL),
(1652, '10264269', 'KTM', 'NP', 'NP sealinks Travels Pvt Ltd', 'NPR', NULL, NULL),
(1653, '10264273', 'KTM', 'NP', 'NP Yoyakha Travel pvt Ltd', 'NPR', NULL, NULL),
(1654, '10264276', 'KTM', 'NP', 'NP Moon Sun Travels', 'NPR', NULL, NULL),
(1655, '10264279', 'KTM', 'NP', 'NP Sumegh Tours and Travels', 'NPR', NULL, NULL),
(1656, '10264283', 'KTM', 'NP', 'NP Bon Travels & Tours', 'NPR', NULL, NULL),
(1657, '10264288', 'KTM', 'NP', 'NP Gandaki Travels', 'NPR', NULL, NULL),
(1658, '10264293', 'KTM', 'NP', 'NP Aroma Travels', 'NPR', NULL, NULL),
(1659, '10265231', 'DAC', 'BD', 'CORP Mcdonald Bangladesh (Pvt) Limited', 'BDT', NULL, NULL),
(1660, '10265252', 'DAC', 'BD', 'United Consultancy & Tours', 'BDT', NULL, NULL),
(1661, '10265647', 'KTM', 'NP', 'NP Everest Travel Srvices', 'NPR', NULL, NULL),
(1662, '10265654', 'KTM', 'NP', 'NP Peace Travel', 'NPR', NULL, NULL),
(1663, '10265657', 'KTM', 'NP', 'NP Broadway travel', 'NPR', NULL, NULL),
(1664, '10265663', 'KTM', 'NP', 'NP LALIMA TRAVELS PVT LTD', 'NPR', NULL, NULL),
(1665, '10265680', 'KTM', 'NP', 'NP Gorkha Trave', 'NPR', NULL, NULL),
(1666, '10265686', 'KTM', 'NP', 'NP Deurali Travel', 'NPR', NULL, NULL),
(1667, '10265696', 'KTM', 'NP', 'NP Kumari Tours', 'NPR', NULL, NULL),
(1668, '10265702', 'KTM', 'NP', 'NP Dyanmic Services', 'NPR', NULL, NULL),
(1669, '10265710', 'KTM', 'NP', 'NP Suruchi Travels', 'NPR', NULL, NULL),
(1670, '10265720', 'KTM', 'NP', 'NP President Travels and Trours', 'NPR', NULL, NULL),
(1671, '10265734', 'KTM', 'NP', 'NP World Trade Travel', 'NPR', NULL, NULL),
(1672, '10265738', 'KTM', 'NP', 'NP Liberal Tours', 'NPR', NULL, NULL),
(1673, '10265744', 'KTM', 'NP', 'NP Amrit Travels and Tours', 'NPR', NULL, NULL),
(1674, '10265761', 'KTM', 'NP', 'NP Dhaulagiri Adventures', 'NPR', NULL, NULL),
(1675, '10265769', 'KTM', 'NP', 'NP Swaa Tours and Travels', 'NPR', NULL, NULL),
(1676, '10265771', 'KTM', 'NP', 'NP Omni Express', 'NPR', NULL, NULL),
(1677, '10265781', 'KTM', 'NP', 'NP Everest Express', 'NPR', NULL, NULL),
(1678, '10265784', 'KTM', 'NP', 'NP Flight Connecetion', 'NPR', NULL, NULL),
(1679, '10265787', 'KTM', 'NP', 'NP Gorkha Vision Travels', 'NPR', NULL, NULL),
(1680, '10265791', 'KTM', 'NP', 'NP D K Travels', 'NPR', NULL, NULL),
(1681, '10265806', 'KTM', 'NP', 'NP Sunshine Travels P LTD', 'NPR', NULL, NULL),
(1682, '10265841', 'KTM', 'NP', 'NP AMA Travel', 'NPR', NULL, NULL),
(1683, '10265846', 'KTM', 'NP', 'NP Jayanti Travels and Tours', 'NPR', NULL, NULL),
(1684, '10265850', 'KTM', 'NP', 'NP Synergy Travels PVT LTD', 'NPR', NULL, NULL),
(1685, '10265858', 'KTM', 'NP', 'NP BCN Trvls &Tours', 'NPR', NULL, NULL),
(1686, '10265867', 'KTM', 'NP', 'NP Yeti Holidays', 'NPR', NULL, NULL),
(1687, '10265871', 'KTM', 'NP', 'NP Lucky Travels and Tours', 'NPR', NULL, NULL),
(1688, '10265876', 'KTM', 'NP', 'NP Florid Travels', 'NPR', NULL, NULL),
(1689, '10265885', 'KTM', 'NP', 'NP Lumbini Holidays', 'NPR', NULL, NULL),
(1690, '10265892', 'KTM', 'NP', 'NP Loyal Travels And Tours', 'NPR', NULL, NULL),
(1691, '10266089', 'DAC', 'BD', 'Eastern Nur Air', 'BDT', NULL, NULL),
(1692, '10266096', 'DAC', 'BD', 'Star Tourism & Travel Agency', 'BDT', NULL, NULL),
(1693, '10266103', 'KTM', 'NP', 'NP Pokhara flight Centre', 'NPR', NULL, NULL),
(1694, '10266122', 'KTM', 'NP', 'NP Vintage Travels', 'NPR', NULL, NULL),
(1695, '10266135', 'KTM', 'NP', 'NP Open heart', 'NPR', NULL, NULL),
(1696, '10266144', 'KTM', 'NP', 'NP Adam Tours', 'NPR', NULL, NULL),
(1697, '10266316', 'CGP', 'BD', 'CORP Jay Jay Mills (Bangladesh ) Private Limited', 'BDT', NULL, NULL),
(1698, '10267436', 'ZYL', 'BD', 'CORP Khadim Ceramics Ltd.', 'BDT', NULL, NULL),
(1699, '10267440', 'DAC', 'BD', 'CORP Lab Aid Group', 'BDT', NULL, NULL),
(1700, '10267444', 'CGP', 'BD', 'CORP Silver Syndicate', 'BDT', NULL, NULL),
(1701, '10267446', 'RJH', 'BD', 'Robi Air Travel Pvt. Ltd.', 'BDT', NULL, NULL),
(1702, '10267448', 'RJH', 'BD', 'A.L.T International', 'BDT', NULL, NULL),
(1703, '10267456', 'ZYL', 'BD', 'CORP Maa Enterprise & Travels', 'BDT', NULL, NULL),
(1704, '10267462', 'SPD', 'BD', 'Asian Travels', 'BDT', NULL, NULL),
(1705, '10267467', 'CGP', 'BD', 'Wings Travel International', 'BDT', NULL, NULL),
(1706, '10267474', 'RJH', 'BD', 'Natore Air Travel & Tours', 'BDT', NULL, NULL),
(1707, '10267808', 'RJH', 'BD', 'History & Heritage Tourism', 'BDT', NULL, NULL),
(1708, '10308297', 'KTM', 'NP', 'NP Fast International', 'NPR', NULL, NULL),
(1709, '10308663', 'KTM', 'NP', 'NP BUDGET TRAVELS AND TOURS', 'NPR', NULL, NULL),
(1710, '10308683', 'KTM', 'NP', 'NP DIANA TRAVELS', 'NPR', NULL, NULL),
(1711, '10308694', 'KTM', 'NP', 'NP NEWA TRAVELS & TOURS', 'NPR', NULL, NULL),
(1712, '10308745', 'DAC', 'BD', 'Uro-tech Travel & Tours Operation', 'BDT', NULL, NULL),
(1713, '10308903', 'DAC', 'BD', 'Great Air Travels', 'BDT', NULL, NULL),
(1714, '10308915', 'DAC', 'BD', 'CORP Ekram Trade International', 'BDT', NULL, NULL),
(1715, '10308947', 'ZYL', 'BD', 'Ahmed Hajj Umrah Service', 'BDT', NULL, NULL),
(1716, '10308952', 'DAC', 'BD', 'CORP Green University', 'BDT', NULL, NULL),
(1717, '10308962', 'SPD', 'BD', 'Ummul Qura Travels & Tours', 'BDT', NULL, NULL),
(1718, '10308976', 'SPD', 'BD', 'Discovery Tour & Travels', 'BDT', NULL, NULL),
(1719, '10308992', 'KTM', 'NP', 'NP TREASURE TOURS', 'NPR', NULL, NULL),
(1720, '10309000', 'KTM', 'NP', 'NP NEPA TRAVELS', 'NPR', NULL, NULL),
(1721, '10309013', 'KTM', 'NP', 'NP NEEL TRAVELS', 'NPR', NULL, NULL),
(1722, '10309101', 'KTM', 'NP', 'NP OPEN SKY TRAVEL', 'NPR', NULL, NULL),
(1723, '10309109', 'KTM', 'NP', 'NP MIDDLE EAST TRAVELS', 'NPR', NULL, NULL),
(1724, '10309111', 'KTM', 'NP', 'NP SHALIMAR TRAVELS', 'NPR', NULL, NULL),
(1725, '10309117', 'KTM', 'NP', 'NP POKHARA Tours &Travels', 'NPR', NULL, NULL),
(1726, '10309122', 'KTM', 'NP', 'NP COLUMBUS TRAVELS', 'NPR', NULL, NULL),
(1727, '10309125', 'KTM', 'NP', 'NP SAMRAT TOURS & TRAVELS', 'NPR', NULL, NULL),
(1728, '10309128', 'KTM', 'NP', 'NP VIJAYA TRAVELS', 'NPR', NULL, NULL),
(1729, '10309132', 'KTM', 'NP', 'NP SARAOGI NEPAL PVT LTD', 'NPR', NULL, NULL),
(1730, '10309137', 'KTM', 'NP', 'NP RAZI TOURS AND TRAVELS', 'NPR', NULL, NULL),
(1731, '10309143', 'KTM', 'NP', 'NP OUTSIGHT TRAVELS', 'NPR', NULL, NULL),
(1732, '10309147', 'KTM', 'NP', 'NP SUKUNDA TRAVELS', 'NPR', NULL, NULL),
(1733, '10309149', 'KTM', 'NP', 'NP RED LION', 'NPR', NULL, NULL),
(1734, '10309370', 'KTM', 'NP', 'NP DYNAMIC VISION TRAVELS & TOURS', 'NPR', NULL, NULL),
(1735, '10309373', 'KTM', 'NP', 'NP REX TRAVELS P LTD.', 'NPR', NULL, NULL),
(1736, '10309383', 'KTM', 'NP', 'NP PARAGON TRAVELS P LTD', 'NPR', NULL, NULL),
(1737, '10309388', 'KTM', 'NP', 'NP YATRI TOURS (P) LTD', 'NPR', NULL, NULL),
(1738, '10309391', 'KTM', 'NP', 'NP NATURE TRAIL TRAVELS', 'NPR', NULL, NULL),
(1739, '10309395', 'KTM', 'NP', 'NP SUNGAVA INTL TOURS P L', 'NPR', NULL, NULL),
(1740, '10309399', 'KTM', 'NP', 'NP ORCHID TOURS P LTD.', 'NPR', NULL, NULL),
(1741, '10309402', 'KTM', 'NP', 'NP AIRWAY TRAVEL & TOURS', 'NPR', NULL, NULL),
(1742, '10309403', 'KTM', 'NP', 'NP ACROSS TRAVELS & TOURS', 'NPR', NULL, NULL),
(1743, '10309408', 'KTM', 'NP', 'NP SUNGAVA NEPAL TOURS', 'NPR', NULL, NULL),
(1744, '10309412', 'KTM', 'NP', 'NP GORKHA INTERNATIONAL', 'NPR', NULL, NULL),
(1745, '10309417', 'KTM', 'NP', 'NP SINCERE TRAVELS', 'NPR', NULL, NULL),
(1746, '10309420', 'KTM', 'NP', 'NP VAISHALI TRAVELS P LTD.', 'NPR', NULL, NULL),
(1747, '10309423', 'KTM', 'NP', 'NP CHEERFUL HOLIDAY P LTD.', 'NPR', NULL, NULL),
(1748, '10309448', 'KTM', 'NP', 'NP PLAN JOURNEYS P LTD.', 'NPR', NULL, NULL),
(1749, '10309450', 'KTM', 'NP', 'NP EXPLORE HIMALAYA P LTD', 'NPR', NULL, NULL),
(1750, '10309451', 'KTM', 'NP', 'NP VERGE VOYAGE', 'NPR', NULL, NULL),
(1751, '10309452', 'KTM', 'NP', 'NP MAITRI TRAVELS & TOURS', 'NPR', NULL, NULL),
(1752, '10309453', 'KTM', 'NP', 'NP PLAN NEPAL TRAVELS & TOUR', 'NPR', NULL, NULL),
(1753, '10309454', 'KTM', 'NP', 'NP HIMAL REISEN', 'NPR', NULL, NULL),
(1754, '10309456', 'KTM', 'NP', 'NP RUPAKOT TOURS & TRAVELS', 'NPR', NULL, NULL),
(1755, '10309459', 'KTM', 'NP', 'NP FISHTAIL TOURS & TRAVELS', 'NPR', NULL, NULL),
(1756, '10309462', 'KTM', 'NP', 'NP ORION TRAVEL', 'NPR', NULL, NULL),
(1757, '10309468', 'KTM', 'NP', 'NP MARSHYANGDI TRAVEL', 'NPR', NULL, NULL),
(1758, '10309473', 'KTM', 'NP', 'NP International Travel Consolidater', 'NPR', NULL, NULL),
(1759, '10309477', 'KTM', 'NP', 'NP Prayas Travel', 'NPR', NULL, NULL),
(1760, '10309478', 'KTM', 'NP', 'NP SAMA TRAVELS & TOURS', 'NPR', NULL, NULL),
(1761, '10309871', 'DAC', 'BD', 'Travel For You', 'BDT', NULL, NULL),
(1762, '10310310', 'KTM', 'NP', 'NP Classic Himalaya Tours & Tvl', 'NPR', NULL, NULL),
(1763, '10311141', 'KTM', 'NP', 'NP Trips Out Travel Pvt. Ltd.', 'NPR', NULL, NULL),
(1764, '10311317', 'DAC', 'BD', 'ZM Air Tickting & Tourism Ltd.', 'BDT', NULL, NULL),
(1765, '10311324', 'DAC', 'BD', 'TM Air Ticketing & Tourism Ltd.', 'BDT', NULL, NULL),
(1766, '10311331', 'SPD', 'BD', 'Ruposhi Bangla Travels & Tours', 'BDT', NULL, NULL),
(1767, '10311337', 'CGP', 'BD', 'The Ezee Go', 'BDT', NULL, NULL),
(1768, '10312566', 'CGP', 'BD', 'CORP Masud Group', 'BDT', NULL, NULL),
(1769, '10312572', 'CXB', 'BD', 'Al Abrar Tours & Travels (CXB)', 'BDT', NULL, NULL),
(1770, '10314265', 'SPD', 'BD', 'Belal Tours & Traveling Agent', 'BDT', NULL, NULL),
(1771, '10314271', 'DAC', 'BD', 'Prime Air Tourism', 'BDT', NULL, NULL),
(1772, '10314276', 'CGP', 'BD', 'CORP Ranks FC Properties Ltd.', 'BDT', NULL, NULL),
(1773, '10314281', 'DAC', 'BD', 'Akbar Travels International', 'BDT', NULL, NULL),
(1774, '10314292', 'SPD', 'BD', 'Sky Way Tours & Travels', 'BDT', NULL, NULL),
(1775, '10314379', 'BZL', 'BD', 'CORP Hotel Grand Park', 'BDT', NULL, NULL),
(1776, '10315198', 'USA', 'US', 'Skyland Travel', 'USD', NULL, NULL),
(1777, '10315326', 'DAC', 'BD', 'Saya Tours & Travels Ltd', 'BDT', NULL, NULL),
(1778, '10315789', 'DAC', 'BD', 'Sadique Asor Travels and Tours', 'BDT', NULL, NULL),
(1779, '10316678', 'DAC', 'BD', 'SP Mazumdar Travels And Tours', 'BDT', NULL, NULL),
(1780, '10317054', 'ZYL', 'BD', 'A1 Travellers', 'BDT', NULL, NULL),
(1781, '10317059', 'CGP', 'BD', 'CORP Dream Knitting (BD) Ltd.', 'BDT', NULL, NULL),
(1782, '10317066', 'CGP', 'BD', 'CORP Easy Net', 'BDT', NULL, NULL),
(1783, '10317084', 'BZL', 'BD', 'K R Travels', 'BDT', NULL, NULL),
(1784, '10317315', 'ZYL', 'BD', 'Shahmalum Air Service', 'BDT', NULL, NULL),
(1785, '10319563', 'SPD', 'BD', 'North Bengle International Air Travels', 'BDT', NULL, NULL),
(1786, '10319566', 'DAC', 'BD', 'Shangbadik Kazi M.A Rahim Hajj Kafela', 'BDT', NULL, NULL),
(1787, '10319599', 'DAC', 'BD', 'Travel Edge BD', 'BDT', NULL, NULL),
(1788, '10319602', 'SPD', 'BD', 'Kaminy Tours & Travels Agency', 'BDT', NULL, NULL),
(1789, '10319604', 'SPD', 'BD', 'H.T Enterprise', 'BDT', NULL, NULL),
(1790, '10319912', 'DAC', 'BD', 'Sena Kalyan Travels & Tours', 'BDT', NULL, NULL),
(1791, '10320056', 'CGP', 'BD', 'CORP Whitex Garments (BD) Pvt. Ltd.', 'BDT', NULL, NULL),
(1792, '10321896', 'DAC', 'BD', 'Explore Wonders', 'BDT', NULL, NULL),
(1793, '10321904', 'DAC', 'BD', 'Sky Bird Travel Agents (Pvt) Ltd.', 'BDT', NULL, NULL),
(1794, '10322354', 'CXB', 'BD', 'CORP Mermaid Beach Resort', 'BDT', NULL, NULL),
(1795, '10322357', 'BZL', 'BD', 'Wisdom Travel Agency', 'BDT', NULL, NULL),
(1796, '10323043', 'DAC', 'BD', 'Everest Holidays', 'BDT', NULL, NULL),
(1797, '10323312', 'DAC', 'BD', 'Tourism Window (2)', 'BDT', NULL, NULL),
(1798, '10323331', 'DAC', 'BD', 'Ezzy Services & Resource Management Ltd.', 'BDT', NULL, NULL),
(1799, '10323996', 'DAC', 'BD', 'Red Sun Travels & Tours', 'BDT', NULL, NULL),
(1800, '10324186', 'KTM', 'NP', 'NP RASBITA INTERNATIONAL TRAVEL & TOURSP PVT LTD', 'NPR', NULL, NULL),
(1801, '10324193', 'KTM', 'NP', 'NP EXOTIC ADVENTURES TOURS & TRAVELS PVT LTD', 'NPR', NULL, NULL),
(1802, '10324195', 'KTM', 'NP', 'NP PRECIOUS TRAVELS & TOURS', 'NPR', NULL, NULL),
(1803, '10324208', 'DAC', 'BD', 'Span Travel and Logistics Ltd.', 'BDT', NULL, NULL),
(1804, '10324495', 'DAC', 'BD', 'I Con Tours and Travels', 'BDT', NULL, NULL),
(1805, '10325640', 'DAC', 'BD', 'Yes Travels', 'BDT', NULL, NULL),
(1806, '10325956', 'DAC', 'BD', 'RD Tours & Travels', 'BDT', NULL, NULL),
(1807, '10326245', 'DAC', 'BD', 'CORP Super Petrochemical (Pvt) Limited', 'BDT', NULL, NULL),
(1808, '10326257', 'CGP', 'BD', 'The Med Tour', 'BDT', NULL, NULL),
(1809, '10326262', 'SPD', 'BD', 'Sadia Aviation', 'BDT', NULL, NULL),
(1810, '10326272', 'DAC', 'BD', 'CORP Samuda Chemical Complex Limited', 'BDT', NULL, NULL),
(1811, '10327280', 'DAC', 'BD', 'B.M.S Travels', 'BDT', NULL, NULL),
(1812, '10327295', 'DAC', 'BD', 'K.S.P Travels', 'BDT', NULL, NULL),
(1813, '10327305', 'DAC', 'BD', 'Dolphin Tours & Travels', 'BDT', NULL, NULL),
(1814, '10327995', 'DAC', 'BD', 'Travel On', 'BDT', NULL, NULL),
(1815, '10328004', 'DAC', 'BD', 'Famous Aviation', 'BDT', NULL, NULL),
(1816, '10328011', 'DAC', 'BD', 'Skyland Travel & Tours', 'BDT', NULL, NULL),
(1817, '10328797', 'DAC', 'BD', 'CORP Aristopharma Ltd', 'BDT', NULL, NULL),
(1818, '10328802', 'SPD', 'BD', 'Source Tours & Travel', 'BDT', NULL, NULL),
(1819, '10329545', 'SPD', 'BD', 'R.K Tours & Travels', 'BDT', NULL, NULL),
(1820, '10329548', 'SPD', 'BD', 'Travel Express', 'BDT', NULL, NULL),
(1821, '10329554', 'SPD', 'BD', 'Madeena Tours and Travels', 'BDT', NULL, NULL),
(1822, '10331304', 'DAC', 'BD', 'CORP ABB Limited', 'BDT', NULL, NULL),
(1823, '10331320', 'DAC', 'BD', 'Dola Fakir Air Service', 'BDT', NULL, NULL),
(1824, '10331322', 'ZYL', 'BD', 'CORP Zakaria Enterprise', 'BDT', NULL, NULL),
(1825, '10331328', 'BZL', 'BD', 'Real Tours & Travels', 'BDT', NULL, NULL),
(1826, '10332667', 'DAC', 'BD', 'Butterfly Air Travels', 'BDT', NULL, NULL),
(1827, '10332848', 'BZL', 'BD', 'Lalon Tours & Travels', 'BDT', NULL, NULL),
(1828, '10332859', 'SPD', 'BD', 'Rafique Tours & Travels', 'BDT', NULL, NULL),
(1829, '10332866', 'ZYL', 'BD', 'Shahjalal Travels & Tours', 'BDT', NULL, NULL),
(1830, '10334553', 'DAC', 'BD', 'Ficus Travels International', 'BDT', NULL, NULL),
(1831, '10334852', 'CGP', 'BD', 'CORP SUNSHINE ACCESSORIES MFC. BD. LTD.', 'BDT', NULL, NULL),
(1832, '10336333', 'BZL', 'BD', 'Brothers Tour & Travels (BZL)', 'BDT', NULL, NULL),
(1833, '10336803', 'CGP', 'BD', 'CORP Mas Intimates Bangladesh Pvt. Ltd.', 'BDT', NULL, NULL),
(1834, '10336812', 'SPD', 'BD', 'Raihan Tours & Travels', 'BDT', NULL, NULL),
(1835, '10336816', 'SPD', 'BD', 'Jomuna Travel & Tours', 'BDT', NULL, NULL),
(1836, '10336831', 'CGP', 'BD', 'The Fly Zone Tours & Travels', 'BDT', NULL, NULL),
(1837, '10337064', 'KTM', 'NP', 'NP ALPINE TRVLS SERVC PVT  LTD', 'NPR', NULL, NULL),
(1838, '10337072', 'KTM', 'NP', 'NP ANNAPURNA VISION', 'NPR', NULL, NULL),
(1839, '10337078', 'KTM', 'NP', 'NP EAST & WEST INTERNATIONAL', 'NPR', NULL, NULL),
(1840, '10337079', 'KTM', 'NP', 'NP EXPERIENCE NEPAL', 'NPR', NULL, NULL),
(1841, '10337082', 'KTM', 'NP', 'NP ENTIRE TRAVELS & TOURS', 'NPR', NULL, NULL),
(1842, '10337084', 'KTM', 'NP', 'NP EXPLORE NEPAL RICHA', 'NPR', NULL, NULL),
(1843, '10337087', 'KTM', 'NP', 'NP GOCHALI TOURS & TRAVELS PVT LTD', 'NPR', NULL, NULL),
(1844, '10337089', 'KTM', 'NP', 'NP GREAT JOURNEYS', 'NPR', NULL, NULL),
(1845, '10337092', 'KTM', 'NP', 'NP GREAT WAY INT''L TRAVEL', 'NPR', NULL, NULL),
(1846, '10337094', 'KTM', 'NP', 'NP GULF TRAVEL & TOURS', 'NPR', NULL, NULL),
(1847, '10337096', 'KTM', 'NP', 'NP JOLLY GORKHA ADVENTURE', 'NPR', NULL, NULL),
(1848, '10337098', 'KTM', 'NP', 'NP ORBIT INTERNATIONAL TRAVELS', 'NPR', NULL, NULL),
(1849, '10337099', 'KTM', 'NP', 'NP PLAN HOLIDAYS TRVLS & TRS', 'NPR', NULL, NULL),
(1850, '10337122', 'KTM', 'NP', 'NP RICHA TOURS & TRAVELS', 'NPR', NULL, NULL),
(1851, '10337123', 'KTM', 'NP', 'NP SERENE TRAVLES', 'NPR', NULL, NULL),
(1852, '10337126', 'KTM', 'NP', 'NP SITARA TRAVELS PVT LTD', 'NPR', NULL, NULL),
(1853, '10337127', 'KTM', 'NP', 'NP SKYPASS TRAVEL', 'NPR', NULL, NULL),
(1854, '10337128', 'KTM', 'NP', 'NP TRIJYOTI TRAVEL AND TOURS', 'NPR', NULL, NULL),
(1855, '10337130', 'KTM', 'NP', 'NP VILLAGE TRAVEL', 'NPR', NULL, NULL),
(1856, '10337133', 'KTM', 'NP', 'NP ZENITH EXPERIENCES TRV', 'NPR', NULL, NULL),
(1857, '10337136', 'KTM', 'NP', 'NP ZEN NEPAL TOURS & TRAVELS', 'NPR', NULL, NULL),
(1858, '10338406', 'DAC', 'BD', 'Krishibid Tours & Tavels Ltd.', 'BDT', NULL, NULL),
(1859, '10338415', 'DAC', 'BD', 'NH Travels', 'BDT', NULL, NULL),
(1860, '10338428', 'DAC', 'BD', 'CORP Krishibid Bangladesh Ltd.', 'BDT', NULL, NULL),
(1861, '10339594', 'DAC', 'BD', 'CORP Best Electronics Limited', 'BDT', NULL, NULL),
(1862, '10339674', 'DAC', 'BD', 'Khan International Express', 'BDT', NULL, NULL),
(1863, '10339890', 'DAC', 'BD', 'Zamzam Travels', 'BDT', NULL, NULL),
(1864, '10340089', 'ZYL', 'BD', 'Air Guide International', 'BDT', NULL, NULL),
(1865, '10341073', 'DAC', 'BD', 'Primrose Tours & Travels', 'BDT', NULL, NULL),
(1866, '10341599', 'DAC', 'BD', 'Golden Tours & Travels', 'BDT', NULL, NULL),
(1867, '10342520', 'CGP', 'BD', 'Escape Bangladesh Ltd.', 'BDT', NULL, NULL),
(1868, '10343746', 'DAC', 'BD', 'CORP Transfast', 'BDT', NULL, NULL),
(1869, '10344149', 'DAC', 'BD', 'CORP Best Western Maple Leaf Hotel', 'BDT', NULL, NULL),
(1870, '10344456', 'ZYL', 'BD', 'S.S Enterprise', 'BDT', NULL, NULL),
(1871, '10344461', 'DAC', 'BD', 'Universe Tours & Tickets', 'BDT', NULL, NULL),
(1872, '10344474', 'DAC', 'BD', 'CORP ZXY International FZCO', 'BDT', NULL, NULL),
(1873, '10345127', 'DAC', 'BD', 'Regent Holiday Tours & Travels Ltd', 'BDT', NULL, NULL),
(1874, '10345129', 'DAC', 'BD', 'Hermain Travels & Tours', 'BDT', NULL, NULL),
(1875, '10345134', 'SPD', 'BD', 'Dinajpur Aviation', 'BDT', NULL, NULL),
(1876, '10345375', 'KTM', 'NP', 'NP Natraj Tours & Travels', 'NPR', NULL, NULL),
(1877, '10345604', 'DAC', 'BD', 'Simplyfly Solution and Services Ltd', 'BDT', NULL, NULL),
(1878, '10345956', 'KTM', 'NP', 'NP AEROLINA TRAVELS & TOURS', 'NPR', NULL, NULL),
(1879, '10345964', 'KTM', 'NP', 'NP LUMBINI PEACE TRAVELS TOURS', 'NPR', NULL, NULL),
(1880, '10345971', 'KTM', 'NP', 'NP GILT TRAVELS', 'NPR', NULL, NULL),
(1881, '10345976', 'KTM', 'NP', 'NP ROYAL MOUNTAIN', 'NPR', NULL, NULL),
(1882, '10345986', 'KTM', 'NP', 'NP NEPAL TRAVEL AGENCY PRIVATE LTD', 'NPR', NULL, NULL),
(1883, '10346030', 'DAC', 'BD', 'Jannat Tourism And Travels (Pvt.) Limited', 'BDT', NULL, NULL),
(1884, '10346031', 'SPD', 'BD', 'S.N Tours And Travels', 'BDT', NULL, NULL),
(1885, '10346039', 'SPD', 'BD', 'Esquire Travel Agency', 'BDT', NULL, NULL),
(1886, '10346399', 'DAC', 'BD', 'CORP Acron Infrastructure Services Ltd.', 'BDT', NULL, NULL),
(1887, '10347038', 'BZL', 'BD', 'Musa Ibrahim Travel Agency', 'BDT', NULL, NULL),
(1888, '10347046', 'SPD', 'BD', 'Comfort Air Travels', 'BDT', NULL, NULL),
(1889, '10347062', 'DAC', 'BD', 'CORP Clewiston Food & Accommodation Limited', 'BDT', NULL, NULL),
(1890, '10348155', 'KTM', 'NP', 'NP Hamlet Tours & Travels', 'NPR', NULL, NULL),
(1891, '10348712', 'ZYL', 'BD', 'Saraa Travels', 'BDT', NULL, NULL),
(1892, '10348720', 'DAC', 'BD', 'Flybird Travels', 'BDT', NULL, NULL),
(1893, '10348728', 'SPD', 'BD', 'Saidpur Tours And Travels', 'BDT', NULL, NULL),
(1894, '10348734', 'SPD', 'BD', 'I.A Tour & Travels', 'BDT', NULL, NULL),
(1895, '10348739', 'DAC', 'BD', 'Shah Tours & Travels', 'BDT', NULL, NULL),
(1896, '10348745', 'BZL', 'BD', 'Milon Air Travels', 'BDT', NULL, NULL),
(1897, '10349714', 'KTM', 'NP', 'NP City Travels & Tours', 'NPR', NULL, NULL),
(1898, '10349936', 'DAC', 'BD', 'Prantik Travels & Tourism Ltd.', 'BDT', NULL, NULL),
(1899, '10349939', 'DAC', 'BD', 'Winmet Tours & Travels', 'BDT', NULL, NULL),
(1900, '10350131', 'CGP', 'BD', 'CORP Sheng Tseng Enterprise Co. Ltd.', 'BDT', NULL, NULL),
(1901, '10350728', 'CGP', 'BD', 'Naf Trading & Travels', 'BDT', NULL, NULL),
(1902, '10353305', 'DAC', 'BD', 'Star Light Tours & Travels', 'BDT', NULL, NULL),
(1903, '10353317', 'CGP', 'BD', 'CORP Sungho Garment Accessories Limited', 'BDT', NULL, NULL),
(1904, '10353377', 'MCT', 'BD', 'Sun World Travel & Toursim LLC', 'BDT', NULL, NULL),
(1905, '10353420', 'DAC', 'BD', 'ABM Tours & Travels', 'BDT', NULL, NULL),
(1906, '10353868', 'CXB', 'BD', 'New Friends Tourism & Travels', 'BDT', NULL, NULL),
(1907, '10354839', 'DAC', 'BD', 'Baridhara Tours', 'BDT', NULL, NULL),
(1908, '10355999', 'BZL', 'BD', 'R. S. S. Travels', 'BDT', NULL, NULL),
(1909, '10356088', 'DAC', 'BD', 'CORP Social Isllmai Bank Limited', 'BDT', NULL, NULL),
(1910, '10356198', 'KWI', 'KW', 'ETERNITY INTERNATIONAL TRAVELS & TOURISM', 'KWD', NULL, NULL),
(1911, '10356204', 'RJH', 'BD', 'Anjum Air International', 'BDT', NULL, NULL),
(1912, '10356503', 'DAC', 'BD', 'Shuchona Travels', 'BDT', NULL, NULL),
(1913, '10356515', 'DAC', 'BD', 'CORP Sinha Power Generation Company Ltd.', 'BDT', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `depositinfo`
--

CREATE TABLE IF NOT EXISTS `depositinfo` (
  `DEPOSITID` int(11) NOT NULL,
  `MCDID` int(11) NOT NULL,
  `MCD_NO` varchar(100) NOT NULL,
  `DEPOSIT_TYPE` varchar(100) NOT NULL,
  `BANK_NAME` varchar(200) NOT NULL,
  `DEPOSIT_SLIP_NO` varchar(100) NOT NULL,
  `BANK_CHARGE` double NOT NULL,
  `DEPOSIT_RECEIVE_DATE` datetime NOT NULL,
  `DEPOSIT_RECEIVE_BY` varchar(500) NOT NULL,
  `DEPOSITOR_RECEIVER_PHONE` varchar(100) NOT NULL,
  `EMP_ID` varchar(50) NOT NULL,
  `DepositedAmount` double NOT NULL,
  `VoidStatus` int(11) NOT NULL,
  `IssuerID` int(11) NOT NULL,
  `IssuerIPAddress` varchar(50) NOT NULL,
  `IssueDate` datetime NOT NULL,
  `UpdatedByID` int(11) NOT NULL,
  `UpdatedByIPAddress` varchar(50) NOT NULL,
  `UpdateDate` datetime NOT NULL,
  `IssuerStationID` int(11) NOT NULL,
  `OutStanding` double NOT NULL,
  `Remarks` varchar(500) DEFAULT NULL,
  `TopUpStatus` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `depositinfo`
--

INSERT INTO `depositinfo` (`DEPOSITID`, `MCDID`, `MCD_NO`, `DEPOSIT_TYPE`, `BANK_NAME`, `DEPOSIT_SLIP_NO`, `BANK_CHARGE`, `DEPOSIT_RECEIVE_DATE`, `DEPOSIT_RECEIVE_BY`, `DEPOSITOR_RECEIVER_PHONE`, `EMP_ID`, `DepositedAmount`, `VoidStatus`, `IssuerID`, `IssuerIPAddress`, `IssueDate`, `UpdatedByID`, `UpdatedByIPAddress`, `UpdateDate`, `IssuerStationID`, `OutStanding`, `Remarks`, `TopUpStatus`) VALUES
(1, 628, 'MCD-00628', 'external', 'EBL', '123446', 23, '2016-09-01 00:00:00', 'Atik', '', '', 12900, 1, 7, '27.147.149.146', '2016-09-01 13:36:13', 7, '27.147.149.146', '2016-09-05 11:13:55', 13, 0, '', 1),
(2, 645, 'MCD-00645', 'external', 'hjkhkk', '21311213', 10, '2016-09-01 00:00:00', 'kjhkjhkj', '', '', 10000, 1, 8, '115.127.65.130', '2016-09-01 14:05:49', 0, '', '0001-01-01 00:00:00', 13, 0, '', 0),
(3, 649, 'MCD-00649', 'external', 'hkhkhk', 'fhfh', 34, '2016-09-03 00:00:00', 'gjhghj', '', '', 150000, 1, 8, '27.147.149.146', '2016-09-03 11:08:40', 0, '', '0001-01-01 00:00:00', 13, 0, '', 0),
(4, 650, 'MCD-00650', 'external', 'UCB', '1141021', 0, '2016-09-03 00:00:00', 'Uttara sales', '', '', 50000, 1, 8, '115.127.65.130', '2016-09-03 11:38:23', 0, '', '0001-01-01 00:00:00', 13, 0, '', 0),
(5, 651, 'MCD-00651', 'internal', '', '', 0, '2016-09-03 00:00:00', 'MR. Sumon', '017777777', 'USBA 0125', 200000, 0, 7, '27.147.149.146', '2016-09-03 14:50:26', 8, '27.147.149.146', '2016-09-05 13:08:02', 13, 0, 'Cash Receive from Head Office', 0),
(6, 642, 'MCD-00642', 'internal', '', '', 0, '0001-01-01 00:00:00', '', '', '', 3700, 1, 8, '27.147.149.146', '2016-09-03 15:57:34', 8, '27.147.149.146', '2016-09-05 13:03:27', 13, 0, '', 1),
(7, 639, 'MCD-00639', 'internal', '', '', 0, '2016-09-03 00:00:00', '', '', '', 20000, 1, 8, '115.127.65.130', '2016-09-03 16:15:10', 8, '27.147.149.146', '2016-09-05 12:50:15', 13, 0, '', 1),
(8, 653, 'MCD-00653', 'external', 'IBBL', '124589', 23, '2016-09-05 00:00:00', 'Agent', '', '', 100000, 1, 7, '115.127.65.130', '2016-09-05 17:51:45', 7, '115.127.65.130', '2016-09-05 17:53:22', 13, 0, '', 1),
(9, 655, 'MCD-00655', 'external', 'EBL', '12356', 0, '2016-09-07 00:00:00', 'Agrabad sales', '', '', 16500, 1, 8, '27.147.149.146', '2016-09-06 14:21:10', 8, '27.147.149.146', '2016-09-06 14:22:55', 13, 0, 'Recv 06 Sep''16', 1),
(10, 656, 'MCD-00656', 'external', 'sl21', '14789', 0, '2016-09-08 00:00:00', 'Agrabad sales', '', '', 81800, 1, 8, '27.147.149.146', '2016-09-06 14:25:01', 0, '', '0001-01-01 00:00:00', 13, 0, 'It recv on 05 Sep''16', 0),
(11, 657, 'MCD-00657', 'external', 'IBBL', '5589981', 0, '2016-08-22 00:00:00', 'NIMME', '', '', 10000, 1, 16, '115.127.24.162', '2016-09-06 17:37:46', 7, '27.147.149.146', '2016-09-06 17:46:29', 13, 0, '', 1),
(12, 659, 'mcd-00659', 'internal', '', '', 0, '2016-09-07 00:00:00', 'olive', '', '0339', 20000, 1, 16, '115.127.37.18', '2016-09-07 15:39:20', 7, '115.127.65.130', '2016-09-07 15:42:34', 13, 0, '', 1),
(13, 666, 'mcd-00666', 'external', 'IBBL', '53432', 0, '2016-09-08 00:00:00', 'Faisal', '', '', 50000, 1, 16, '115.127.6.226', '2016-09-08 17:17:07', 7, '115.127.65.130', '2016-09-08 17:20:12', 13, 0, '', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfo`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfo` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfobymcdno`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfobymcdno` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfobymcdnoanduser`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfobymcdnoanduser` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfodateanduserwise`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfodateanduserwise` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfodatewise`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfodatewise` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mcddepositinfouserwise`
--
CREATE TABLE IF NOT EXISTS `mcddepositinfouserwise` (
`McdDepositID` int(11)
,`MCD_NO` varchar(100)
,`MCDDate` datetime
,`StationOffice` varchar(150)
,`CorporateID` varchar(100)
,`CustomerName` varchar(200)
,`ModeOfPayment` varchar(70)
,`DEPOSIT_RECEIVE_DATE` datetime
,`DEPOSIT_TYPE` varchar(100)
,`DepositedAmount` double
,`BANK_NAME` varchar(200)
,`ChequeNo` varchar(150)
,`VoidStatus` int(11)
,`TopUpStatus` int(11)
,`IssuerID` int(11)
,`CollectionPurpose` varchar(150)
);

-- --------------------------------------------------------

--
-- Table structure for table `mcdinfo`
--

CREATE TABLE IF NOT EXISTS `mcdinfo` (
  `MCDID` int(11) NOT NULL,
  `AutoSerial` varchar(100) DEFAULT NULL,
  `ManualSerial` varchar(100) DEFAULT NULL,
  `MCDDate` datetime DEFAULT NULL,
  `StationOffice` varchar(150) DEFAULT NULL,
  `CustomerName` varchar(200) DEFAULT NULL,
  `CorporateID` varchar(100) DEFAULT NULL,
  `Mobile` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Address` varchar(500) DEFAULT NULL,
  `CollectionPurpose` varchar(150) DEFAULT NULL,
  `PNR` varchar(20) DEFAULT NULL,
  `Fees` double DEFAULT NULL,
  `FlightNo` varchar(150) DEFAULT NULL,
  `FlightDate` datetime DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Weight` double DEFAULT NULL,
  `TagNo` varchar(200) DEFAULT NULL,
  `ReferenceNo` varchar(200) DEFAULT NULL,
  `BusNo` varchar(100) DEFAULT NULL,
  `BusStartTime` varchar(100) DEFAULT NULL,
  `OtherRemarks` varchar(700) DEFAULT NULL,
  `RouteStart` varchar(20) DEFAULT NULL,
  `RouteEnd` varchar(20) DEFAULT NULL,
  `ModeOfPayment` varchar(70) DEFAULT NULL,
  `CardNo` varchar(50) DEFAULT NULL,
  `ChequeBank` varchar(100) DEFAULT NULL,
  `ChequeNo` varchar(150) DEFAULT NULL,
  `BcashMobile` varchar(20) DEFAULT NULL,
  `MBBankName` varchar(150) DEFAULT NULL,
  `MBMobile` varchar(20) DEFAULT NULL,
  `Currency` varchar(50) DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `Waiver` double DEFAULT NULL,
  `Tax` double DEFAULT NULL,
  `PaidAmount` double DEFAULT NULL,
  `AmountInWord` varchar(200) DEFAULT NULL,
  `Remarks` varchar(1500) DEFAULT NULL,
  `UserName` varchar(100) DEFAULT NULL,
  `IssuerID` int(11) DEFAULT NULL,
  `IPAddress` varchar(20) DEFAULT NULL,
  `CardType` varchar(70) DEFAULT NULL,
  `CargoReceiver` varchar(990) DEFAULT NULL,
  `TransactionID` varchar(50) NOT NULL,
  `UpdatedByID` int(11) DEFAULT NULL,
  `LastUpdate` datetime DEFAULT NULL,
  `UpdateByIP` varchar(50) DEFAULT NULL,
  `VoidStatus` int(11) DEFAULT NULL,
  `ChequeDate` datetime DEFAULT '0001-01-01 12:00:00'
) ENGINE=InnoDB AUTO_INCREMENT=668 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mcdinfo`
--

INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(1, 'MCD-00001', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'KAZI A HAMID', '', '01714122790', '', '', 'ebt', '00HBK4', 100, 'BS122', '2016-07-21 00:00:00', 0, 20, '', '', '', '', 'TEST PERPOSE', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', 'TEST PERPOSE', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 14, '2016-08-01 17:45:59', '123.200.23.98', 0, '0001-01-01 12:00:00'),
(2, 'MCD-00002', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/237/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'bs124', '2016-07-21 00:00:00', 0, 3, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', 'DAC\r\nADJT 9993404', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(3, 'MCD-00003', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'GE BIMAN', '', '01719118749', '', '', 'cargo', '', 100, 'BS124', '2016-07-21 00:00:00', 0, 3, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '01716201942', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(4, 'MCD-00004', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01748894629', '', '', 'mail_courier', '', 0, 'BS124', '2016-07-21 00:00:00', 1, 1, '08420', '01798674698 RRF JSR', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', 'RRF DAC\r\n01798674698', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(5, 'MCD-00005', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'm/s samad mashinary', '', '01711481820', '', '', 'mail_courier', '', 0, 'BS 124/109', '2016-07-21 00:00:00', 1, 1, '136060', '01711344762', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Shabbir Hossain', 12, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(6, 'MCD-00006', '', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'MD LUTFUR RAHMAN', '', '01786212225', '', '', 'mail_courier', '', 0, 'BS124', '2016-07-21 00:00:00', 1, 1, '31419', '01943123590', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Shabbir Hossain', 12, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(7, 'MCD-00007', '29383-98', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'kHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-21 00:00:00', 0, 0, '', '', 'BS121', '8:50am', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(8, 'MCD-00008', '29399-29415', '2016-07-21 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-21 00:00:00', 0, 0, '', '', 'BS123', '6:50pm', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4250, 0, 0, 4250, 'Four Thousand Two Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(9, 'MCD-00009', '29416-52', '2016-07-22 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-22 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '8:40am', '', 'JSR APT', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9250, 0, 0, 9250, 'Nine Thousand Two Hundred and Fifty', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(10, 'MCD-00010', '29453-85', '2016-07-23 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-23 00:00:00', 0, 0, '', '', 'BS 121/123', '6:55pm', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8250, 0, 0, 8250, 'Eight Thousand Two Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(11, 'MCD-00011', '', '2016-07-24 00:00:00', 'Jessore Airport (JSR)', 'saleha metaln jessore', '', '01913250753', '', '', 'mail_courier', '', 0, 'bs124/bs109', '2016-07-24 00:00:00', 1, 1, '050129', '01779605909', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(12, 'MCD-00012', '', '2016-07-24 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01718832643', '', '', 'mail_courier', '', 0, 'bs124', '2016-07-24 00:00:00', 1, 1, '289001', '01798674598', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(13, 'MCD-00013', '', '2016-07-24 00:00:00', 'Jessore Airport (JSR)', 'mr hiru jessore', '', '01711276677', '', '', 'mail_courier', '', 0, 'bs124', '2016-07-24 00:00:00', 1, 1, '24837', '01924644973', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(14, 'MCD-00014', '', '2016-07-24 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/238/16/HQ', '', '01735069150', '', '', 'cargo', '', 100, 'bs124', '2016-07-24 00:00:00', 0, 5, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', 'ADJT \r\nDAC', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(15, 'MCD-00015', '', '2016-07-25 00:00:00', 'Jessore Airport (JSR)', 'capt jia', '', '01769552226', '', '', 'mail_courier', '', 0, 'bs-124', '2016-07-25 00:00:00', 1, 1, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(16, 'MCD-00016', '', '2016-07-25 00:00:00', 'Jessore Airport (JSR)', 'abdullah', '', '01719974632', '', '', 'mail_courier', '', 0, 'bs-124', '2016-07-25 00:00:00', 1, 1, '08434', '01712601444', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(17, 'MCD-00017', '', '2016-07-25 00:00:00', 'Jessore Airport (JSR)', 'MTR /TS/242/16/HQ', '', '01823106360', '', '', 'mail_courier', '', 0, 'bs-124', '2016-07-25 00:00:00', 1, 1, '17715', '9993404', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(18, 'MCD-00018', '29520-561', '2016-07-26 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-26 00:00:00', 0, 0, '', '', 'BS 121/123', '7:00pm', '25 JULY''16 BUS TICKET AMOUNT', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10500, 0, 0, 10500, 'Ten Thousand Five Hundred ', '25 JULY''16 BUS TICKET AMOUNT', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(19, 'MCD-00019', '', '2016-07-26 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/242/16/HQ', '', '01735069150', '', '', 'cargo', '', 100, 'BS124', '2016-07-26 00:00:00', 0, 5, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '-Select Card Type-', 'ADJT AIR HQ DHAKA', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(20, 'MCD-00020', '', '2016-07-26 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01711182334', '', '', 'mail_courier', '', 0, 'BS124', '2016-07-26 00:00:00', 1, 1, '22722', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(21, 'MCD-00021', '22716', '2016-07-26 00:00:00', 'Jessore Airport (JSR)', 'GE BIMAN', '', '01911176903', '', '', 'cargo', '', 100, 'bs124', '2016-07-26 00:00:00', 0, 3, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '01738633817', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(22, 'MCD-00022', '', '2016-07-26 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-26 00:00:00', 0, 0, '', '', '29562-29600', '8:40am', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9500, 0, 0, 9500, 'Nine Thousand Five Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(23, 'MCD-00023', '', '2016-07-27 00:00:00', 'Jessore Airport (JSR)', 'EASHANUL HAQUE', '', '01921118450', '', '', 'mail_courier', '', 0, 'BS-122', '2016-07-27 00:00:00', 1, 1, '270614', '01948123490', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(24, 'MCD-00024', '', '2016-07-27 00:00:00', 'Jessore Airport (JSR)', 'NURUL AMIN', '', '01727071500', '', '', 'mail_courier', '', 0, 'BS-122', '2016-07-27 00:00:00', 1, 1, '267790', '01672525367', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(25, 'MCD-00025', '', '2016-07-27 00:00:00', 'Jessore Airport (JSR)', 'mtr/ts/243/16/hq', '', '01823106360', '', '', 'cargo', '', 100, 'bs124', '2016-07-27 00:00:00', 0, 4, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '-Select Card Type-', 'ADJT AIR HQ DAC\r\n029993404', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(26, 'MCD-00026', '', '2016-07-27 00:00:00', 'Revenue', 'Arifur RAHMAN', '', '01918171772', '', '', 'cargo', '', 100, 'BS142', '2016-07-27 00:00:00', 0, 10, '', '', '', '', '5x100=500\r\n5x80=400\r\ntest data entry from Cox''s Bazar on 27-7-16', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '5x100=500\r\n5x80=400\r\ntest data entry from Cox''s Bazar on 27-7-16', 'Software Developper', 16, '27.147.255.58', '-Select Card Type-', 'Mr. X', '', 14, '2016-08-01 16:34:25', '123.200.23.98', 0, '0001-01-01 12:00:00'),
(27, 'MCD-00027', '30101-28', '2016-07-27 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-27 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '6:50pm', '', 'JESSORE', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7000, 0, 0, 7000, 'Seven Thousand ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(28, 'MCD-00028', '', '2016-07-28 00:00:00', 'Jessore Airport (JSR)', 'r r f/ jessore', '', '01718832643', '', '', 'mail_courier', '', 0, 'bs 122', '2016-07-28 00:00:00', 1, 0.1, '265023', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(29, 'MCD-00029', '63765', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'MD SHOHEL', '', '01716220168', '', '', 'mail_courier', '', 0, 'bs152', '2016-07-28 00:00:00', 1, 1, '277933', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(30, 'MCD-00030', '', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', '', '9:00am', 'BUS TKT NO. 33853,4     ( 2*250=500)', 'DINAJPUR', 'SAIDPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', 'BUS TKT NO. 33853,4     ( 2*250=500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(31, 'MCD-00031', '', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', '', '11:00am', 'BUS TKT NO-33858 (1*250)', 'SAIDPUR', 'DINAJPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 250, 0, 0, 250, 'Two Hundred and Fifty', 'BUS TKT NO-33858 (1*250)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(32, 'MCD-00032', '', '2016-07-28 00:00:00', 'Cox''s Bazar Airport (CXB)', 'MR BILAL MULLA', '', '01829790306', '', '', 'ebt', '00HTLZ', 100, 'BS-142', '2016-07-28 00:00:00', 0, 10, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(33, 'MCD-00033', '', '2016-07-28 00:00:00', 'Cox''s Bazar Airport (CXB)', 'MD ISMAIL', '', '01816158886', '', '', 'cargo', '', 100, 'BS-142', '2016-07-28 00:00:00', 0, 80, '', '', '', '', '5*100=500/=\r\n75*80=6000/=', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8000, 1500, 0, 6500, 'Six Thousand Five Hundred ', '5*100=500/=\r\n75*80=6000/=', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '-Select Card Type-', 'MR SULTAN\r\n01763421011', '', 14, '2016-07-28 17:35:26', '27.147.255.58', 1, '0001-01-01 12:00:00'),
(34, 'MCD-00034', '', '2016-07-28 00:00:00', 'Jessore Airport (JSR)', 'SHAWKAT ALI', '', '01777703377', '', '', 'mail_courier', '', 0, 'bs124', '2016-07-28 00:00:00', 1, 1, '144416', '01777703306', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(35, 'MCD-00035', '', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', 'spd.aptsvc@us-banglaairlines.com', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', 'BS-152 & 154', '9:00pm', 'TKT NO: 33843-852(10x200=2000),33859-60(2x200=400)', 'RANGPUR', 'SAIDPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2400, 0, 0, 2400, 'Two Thousand Four Hundred ', 'TKT NO: 33843-852(10x200=2000),33859-60(2x200=400)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(36, 'MCD-00036', '', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', 'BS-152 & 154', '5:00pm', 'TKT NO: 33855-857(3x200=600),33864-872(9x200=1800)', 'SAIDPUR', 'RANGPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2400, 0, 0, 2400, 'Two Thousand Four Hundred ', 'TKT NO: 33855-857(3x200=600),33864-872(9x200=1800)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(37, 'MCD-00037', '', '2016-07-28 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', 'BS-152 & 154', '9:00am', 'TKT NO: 33861-863(250x3=750),33873-875(250x3=750)', 'SAIDPUR', 'DINAJPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', 'TKT NO: 33861-863(250x3=750),33873-875(250x3=750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(38, 'MCD-00038', '30129-48', '2016-07-28 00:00:00', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-28 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '8:40am', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(39, 'MCD-00039', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Sabina afza hq', '', '01715249460', '', '', 'cargo', '', 100, 'bs-152', '2016-07-29 00:00:00', 0, 4, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(40, 'MCD-00040', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Humayun kabir', '', '01788152559', '', '', 'mail_courier', '', 0, 'bs-152', '2016-07-29 00:00:00', 1, 0.5, '296870', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(41, 'MCD-00041', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-29 00:00:00', 0, 0, '', '', 'BS-151 & BS-152', '9:00am', 'TKT NO: 33876-880(200x5=1000), 33886-890(200x5=1000)', 'RANGPUR - SAIDPUR', 'SAIDPIR - RANGPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', 'TKT NO: 33876-880(200x5=1000), 33886-890(200x5=1000)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(42, 'MCD-00042', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-29 00:00:00', 0, 0, '', '', 'BS-151 & BS-152', '9:00am', 'TKT NO: 33881-33888(250x5=1250),33891(250x1=250)', 'DINAJPUR-SAIDPUR', 'SAIDPUR-DINAJPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', 'TKT NO: 33881-33888(250x5=1250),33891(250x1=250)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(43, 'MCD-00043', '', '2016-07-29 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/246/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'BS 124', '2016-07-29 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', 'ADJT/ AIR /HQ\r\n029993404', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(44, 'MCD-00044', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-29 00:00:00', 0, 0, '', '', 'BS-153 & BS-154', '3:00pm', 'TKT NO:33892-898(200x7=1400), 33906-909(200x4=800)', 'RANGPUR - SAIDPUR', 'SAIDPIR - RANGPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2200, 0, 0, 2200, 'Two Thousand Two Hundred ', 'TKT NO:33892-898(200x7=1400), 33906-909(200x4=800)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(45, 'MCD-00045', '', '2016-07-29 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-29 00:00:00', 0, 0, '', '', 'BS-153 & BS-154', '3:00pm', 'TKT NO: 33899-33905(250x7=1750),33910-33919(250x10=2500)', 'DINAJPUR-SAIDPUR', 'SAIDPUR-DINAJPUR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4250, 0, 0, 4250, 'Four Thousand Two Hundred and Fifty', 'TKT NO: 33899-33905(250x7=1750),33910-33919(250x10=2500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(46, 'MCD-00046', '30149-30178', '2016-07-29 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-29 00:00:00', 0, 0, '', '', 'BS 121/123', '6:50pm', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7500, 0, 0, 7500, 'Seven Thousand Five Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(47, 'MCD-00047', '', '2016-07-30 00:00:00', 'Saidpur Airport (SPD)', 'shibanee', '', '01719514657', '', '', 'ebt', '00hln4', 100, 'bs-154', '2016-07-30 00:00:00', 0, 7, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(48, 'MCD-00048', '', '2016-07-30 00:00:00', 'Saidpur Airport (SPD)', 'MD HUMAUN KABIR', '', '01788152559', '', '', 'mail_courier', '', 0, 'BS-154', '2016-07-30 00:00:00', 1, 0.15, '264935', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(49, 'MCD-00049', '', '2016-07-30 00:00:00', 'Jessore Airport (JSR)', 'TUSHAR /CAAB', '', '01923132694', '', '', 'mail_courier', '', 0, 'BS122', '2016-07-30 00:00:00', 1, 1, '266897', '266897', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(50, 'MCD-00050', '', '2016-07-30 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS TICKET', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-30 00:00:00', 0, 0, '', '', 'BS 121/123', '6:50pm', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9250, 0, 0, 9250, 'Nine Thousand Two Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(51, 'MCD-00051', '', '2016-07-30 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-30 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00pm', '', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8900, 0, 0, 8900, 'Eight Thousand Nine Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(52, 'MCD-00052', '', '2016-07-31 00:00:00', 'Saidpur Airport (SPD)', 'MOHAMMAD SUZAUDDIN', '', '01723508308', '', '', 'ebt', '00HUJ4', 1000, '152', '2016-07-31 00:00:00', 0, 10, '', '', '', '', 'wrongly issued details on mail raquib.aps@us-banglaairlines.com	\r\n7:15 PM 31/2016', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', 'wrongly issued details on mail raquib.aps@us-banglaairlines.com	\r\n7:15 PM 31/2016', 'MD MEHEDI HASAN', 24, '203.76.116.178', '-Select Card Type-', '', '', 7, '2016-07-31 19:19:46', '27.147.149.146', 0, '0001-01-01 12:00:00'),
(53, 'MCD-00053', '', '2016-07-31 00:00:00', 'Saidpur Airport (SPD)', 'MOHAMMAD SUZAUDDIN', '', '01723508308', '', '', 'ebt', '00HUJ4', 100, 'BS-152', '2016-07-31 00:00:00', 0, 10, '', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '-Select Card Type-', '', '', 14, '2016-07-31 13:09:14', '123.200.23.98', 1, '0001-01-01 12:00:00'),
(54, 'MCD-00054', '', '2016-07-31 00:00:00', 'Cox''s Bazar Airport (CXB)', 'md jakir hossain', '', '01777741301', '', '', 'cargo', '', 100, 'bs-142', '2016-07-31 00:00:00', 0, 5, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '-Select Card Type-', '', '', 14, '2016-07-31 13:07:46', '123.200.23.98', 1, '0001-01-01 12:00:00'),
(55, 'MCD-00055', '', '2016-07-31 00:00:00', 'Revenue', 'Rayhan Islam', '', '01719459787', '', '', 'cargo', '', 100, 'BS-172', '2016-08-02 00:00:00', 0, 10, '', '', '', '', 'Test data for Barisal Training purpose', 'sl5', 'sl6', 'card', '1766-XXXX-XXXX-7777', 'SCB', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', 'Test data for Barisal Training purpose', 'Software Developper', 16, '123.108.244.118', 'Visa Card', 'Mr Akbor', '', 7, '2016-08-01 16:06:43', '115.127.65.130', 0, '0001-01-01 12:00:00'),
(56, 'MCD-00056', '', '2016-07-31 00:00:00', 'Jessore Airport (JSR)', 'BISMILLAH', '', '01828161198', '', '', 'mail_courier', '', 0, 'BS-124', '2016-07-31 00:00:00', 1, 1, '248706', '01715647009', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(57, 'MCD-00057', '', '2016-07-31 00:00:00', 'Saidpur Airport (SPD)', 'Mr nepen', '', '01733134059', '', '', 'cargo', '', 100, 'BS-152', '2016-07-31 00:00:00', 0, 3, '', '', '', '', 'Tag No: 278790', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', 'Tag No: 278790', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(58, 'MCD-00058', '', '2016-07-31 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/247/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'BS124', '2016-07-31 00:00:00', 0, 6, '', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', 'ADJT DAC\r\nTAG 272298', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(59, 'MCD-00059', '', '2016-07-31 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-07-31 00:00:00', 0, 0, '', '', 'BS-151,152,153,154', '9:00am', 'TKT NO: 33961-33998', 'RANGPUR-SAIDPUR,DINJ', 'SAIDPUR-RANGPUR,SAID', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8400, 0, 0, 8400, 'Eight Thousand Four Hundred ', 'TKT NO: 33961-33998', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(60, 'MCD-00060', '30216-51', '2016-07-31 00:00:00', 'Jessore Airport (JSR)', 'khl bus', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-07-31 00:00:00', 0, 0, '', '', 'bs-122 , bs-124', '7:40am', '', 'jsr', 'khl', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9000, 0, 0, 9000, 'Nine Thousand ', '', 'Tamanna Mou', 10, '119.30.32.191', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(61, 'MCD-00061', '', '2016-08-01 00:00:00', 'Saidpur Airport (SPD)', 'Mr sumon', '', '01719167616', '', 'Uttara EPZ,\r\nNilphamari', 'mail_courier', '', 0, 'BS-152', '2016-08-01 00:00:00', 1, 0.3, '', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(62, 'MCD-00062', '', '2016-08-01 00:00:00', 'Saidpur Airport (SPD)', 'mr nihar', '', '01737268374', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-01 00:00:00', 1, 0.2, '278764', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(63, 'MCD-00063', '', '2016-08-01 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/248/16/HQ', '', '01714935109', '', '', 'cargo', '', 100, 'BS-124', '2016-08-01 00:00:00', 0, 3, '15595', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'ADJT\r\nDAC', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(64, 'MCD-00064', '', '2016-08-01 00:00:00', 'Saidpur Airport (SPD)', 'MR. HUMAUN', '', '01714784435', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-01 00:00:00', 1, 0.2, '278290', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(65, 'MCD-00065', '', '2016-08-01 00:00:00', 'Saidpur Airport (SPD)', 'MR. RAKIB', '', '01788152559', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-01 00:00:00', 1, 0.15, '268739', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(66, 'MCD-00066', '', '2016-08-01 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-01 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 33999-34017(200x19=3800)\r\n34201-34215(250x15=3750)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7550, 0, 0, 7550, 'Seven Thousand Five Hundred and Fifty', 'TKT NO: 33999-34017(200x19=3800)\r\n34201-34215(250x15=3750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(67, 'MCD-00067', '', '2016-08-01 00:00:00', 'Jessore Airport (JSR)', 'SALEHA METAL LTD', '', '017172204', '', '', 'mail_courier', '', 0, 'bs124', '2016-08-01 00:00:00', 1, 1, '23096', '01715647009', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(68, 'MCD-00068', '', '2016-08-01 00:00:00', 'Jessore Airport (JSR)', 'MOINZAMADDER', '', '01917667788', '', '', 'mail_courier', '', 0, 'bs124', '2016-08-01 00:00:00', 1, 1, '23129', '01934730237', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(69, 'MCD-00069', '', '2016-08-01 00:00:00', 'Jessore Airport (JSR)', 'TUSHER RAJ BONGSHI', '', '01923132694', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-01 00:00:00', 1, 1, '32310', 'CAAB/ENGR', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(70, 'MCD-00070', '', '2016-08-02 00:00:00', 'Saidpur Airport (SPD)', 'Mr Nihar', '', '01737268374', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-02 00:00:00', 1, 0.4, '279217', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(71, 'MCD-00071', '30252-86', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS TICKET', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-02 00:00:00', 0, 0, '', '', 'BS 121 & 123', '6:55pm', '01 AUG BUS TICKET AMOUNT 8750/-', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', '01 AUG BUS TICKET AMOUNT 8750/-', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(72, 'MCD-00072', '', '2016-08-02 00:00:00', 'Cox''s Bazar Airport (CXB)', 'ABU SIDDIQUE CHY', '', '01711315257', '', '', 'cargo', '', 100, 'BS-142', '2016-08-02 00:00:00', 0, 10, '', '', '', '', '5*100 = 500 tk\r\n5*80 = 400  tk', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '5*100 = 500 tk\r\n5*80 = 400  tk', 'JAMIR MD NAKIB US SATTAR', 17, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(73, 'MCD-00073', '', '2016-08-02 00:00:00', 'Cox''s Bazar Airport (CXB)', 'mr manik', '', '01814470014', '', '', 'cargo', '', 100, 'BS-142', '2016-08-02 00:00:00', 0, 12, '', '', '', '', '5*100 = 500 tk\r\n7*80  = 560 tk', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1200, 140, 0, 1060, 'One Thousand and Sixty', '5*100 = 500 tk\r\n7*80  = 560 tk', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '-Select Card Type-', '', '', 14, '2016-08-02 14:24:58', '123.200.23.98', 1, '0001-01-01 12:00:00'),
(74, 'MCD-00074', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'SALEHA METAL', '', '027114000', '', '', 'mail_courier', '', 0, 'BS 124', '2016-08-02 00:00:00', 1, 1, '050175', '01779605909', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(75, 'MCD-00075', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'SAMAD MECHINARY', '', '01711481820', '', '', 'mail_courier', '', 0, 'BS 124', '2016-08-02 00:00:00', 1, 1, '050124', 'HAQ ENTERPRISE', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(76, 'MCD-00076', '', '2016-08-02 00:00:00', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-02 00:00:00', 0, 0, '', '', '', '1:30pm', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1400, 0, 0, 1400, 'One Thousand Four Hundred ', '', 'SYED MOSTAIN HOSSAIN', 28, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(77, 'MCD-00077', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'LUTFOR RAHMAN', '', '01926475915', '', '', 'mail_courier', '', 0, 'bs-124', '2016-08-02 00:00:00', 1, 1, '265088', 'AKRAM HOSSAIN', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(78, 'MCD-00078', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'CAACB JSR', '', '01923132694', '', '', 'cargo', '', 100, 'bs-124', '2016-08-02 00:00:00', 0, 3, '248718', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'CAAB DAC', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(79, 'MCD-00079', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/249/HQ/16', '', '01823106360', '', '', 'cargo', '', 100, 'bs-124', '2016-08-02 00:00:00', 0, 4, '253526', '1', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'ADJT AIR HQ DAC', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(80, 'MCD-00080', '', '2016-08-02 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-02 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34018-34042(200x25=5000),342016-34226(250x11=2750)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7750, 0, 0, 7750, 'Seven Thousand Seven Hundred and Fifty', 'TKT NO: 34018-34042(200x25=5000),342016-34226(250x11=2750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(81, 'MCD-00081', '', '2016-08-02 00:00:00', 'Saidpur Airport (SPD)', 'Ms LIU FU HUA', '', '01918334656', '', '', 'ebt', '00HY0X', 100, 'BS-154', '2016-08-02 00:00:00', 0, 100, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(82, 'MCD-00082', '', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'SHAWKAT ALI', '', '01777703377', '', '', 'mail_courier', '', 0, 'bs-124', '2016-08-02 00:00:00', 1, 1, '144445', '01777703377', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(83, 'MCD-00083', '30287-30324', '2016-08-02 00:00:00', 'Jessore Airport (JSR)', 'KHL BUS', '', '017777836', '', '', 'bus_tkt', '', 0, '', '2016-08-02 00:00:00', 0, 0, '', '', 'BS-122/ BS-124', '7:40am', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9500, 0, 0, 9500, 'Nine Thousand Five Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(84, 'MCD-00084', '', '2016-08-03 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01718832643', '', '', 'cargo', '', 100, 'bs122', '2016-08-03 00:00:00', 0, 3, '16070', '01918869319', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'shaon biswas', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(85, 'MCD-00085', '', '2016-08-03 00:00:00', 'Jessore Airport (JSR)', 'SP JSR', '', '01922625213', '', '', 'cargo', '', 100, 'BS122', '2016-08-03 00:00:00', 0, 8, '41721', '01734290565', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'JOHIRUL ISLAM', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(86, 'MCD-00086', '', '2016-08-03 00:00:00', 'Saidpur Airport (SPD)', 'Mr zahedul', '', '01764895989', '', 'Uttara EPZ,\r\nNilphamari', 'mail_courier', '', 0, 'BS-152', '2016-08-03 00:00:00', 1, 0.4, '245046', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(87, 'MCD-00087', '', '2016-08-03 00:00:00', 'Saidpur Airport (SPD)', 'abdul AZIZ', '', '01741106940', '', '', 'ebt', '00HY2Y', 100, 'BS-152', '2016-08-03 00:00:00', 0, 8, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(88, 'MCD-00088', '', '2016-08-03 00:00:00', 'Revenue', 'MostafizUR Rahman', '', '01710535418', '', '', 'ebt', '00HUIP', 100, 'BS162', '2016-08-03 00:00:00', 0, 8, '91817635533', 'Day Flight', '', '', 'Int. pax. get the discount 100 taka\r\nTest purpose entry from Rajshahi', 'RJH', 'DAC', 'card', '4567-XXXX-XXXX-6789', 'SCB', '', '', '', '', 'Taka', 800, 100, 0, 700, 'Seven Hundred ', 'Int. pax. get the discount 100 taka\r\nTest purpose entry from Rajshahi', 'Software Developper', 16, '116.58.202.146', 'Visa Card', '', '', 14, '2016-08-03 12:53:10', '116.58.202.146', 0, '0001-01-01 12:00:00'),
(89, 'MCD-00089', '', '2016-08-03 00:00:00', 'Saidpur Airport (SPD)', 'arif hossain', '', '01753417442', '', 'UTTARA EPZ\r\nNILFHAMARI', 'mail_courier', '', 0, 'BS-154', '2016-08-03 00:00:00', 1, 0.2, '270306', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(90, 'MCD-00090', '', '2016-08-03 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/250/16/HQ', '', '01912872635', '', '', 'cargo', '', 100, 'BS-124', '2016-08-03 00:00:00', 0, 14, '23643', '1', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1400, 0, 0, 1400, 'One Thousand Four Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'ADJT AIR HQ DAC', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(91, 'MCD-00091', '', '2016-08-03 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-03 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00pm', 'TKT NO: 34043-34072(200x30=6000),\r\n34227-34237(250x11=2750)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', 'TKT NO: 34043-34072(200x30=6000),\r\n34227-34237(250x11=2750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(92, 'MCD-00092', '30325-65', '2016-08-03 00:00:00', 'Jessore Airport (JSR)', 'KHULNA BUS TICKET', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-03 00:00:00', 0, 0, '', '', 'BS 121/123', '6:50pm', '', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10250, 0, 0, 10250, 'Ten Thousand Two Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(93, 'MCD-00093', '', '2016-08-04 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01718832643', '', '', 'mail_courier', '', 0, 'BS122', '2016-08-04 00:00:00', 1, 1, '25196', '01924469319', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(94, 'MCD-00094', '', '2016-08-04 00:00:00', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', 'Uttara EPZ\r\nNilphamari', 'cargo', '', 100, 'BS-152', '2016-08-04 00:00:00', 0, 3, '239482', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(95, 'MCD-00095', '', '2016-08-04 00:00:00', 'Cox''s Bazar Airport (CXB)', 'RADIANT HACHERY', '', '01710819970', '', '', 'cargo', '', 100, 'BS-142', '2016-08-04 00:00:00', 0, 12, '48010', '', '', '', '5*100=500\r\n7*80=560', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1200, 140, 0, 1060, 'One Thousand and Sixty', '5*100=500\r\n7*80=560', 'JAMIR MD NAKIB US SATTAR', 17, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(96, 'MCD-00096', '', '2016-08-04 00:00:00', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', 'riyad.ms@us-banglaairlines.com', '', 'bus_tkt', '', 0, '', '2016-08-04 00:00:00', 0, 0, '', '', 'usb bzl', '1:50am', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2400, 0, 0, 2400, 'Two Thousand Four Hundred ', '', 'SYED MOSTAIN HOSSAIN', 28, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(97, 'MCD-00097', '', '2016-08-04 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/253/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'BS 124', '2016-08-04 00:00:00', 0, 3, '236925', '029993404', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(98, 'MCD-00098', '', '2016-08-04 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-04 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34073-34100(200x28=5600),\r\n34238-34253(250x16=4000)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9600, 0, 0, 9600, 'Nine Thousand Six Hundred ', 'TKT NO: 34073-34100(200x28=5600),\r\n34238-34253(250x16=4000)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(99, 'MCD-00099', '', '2016-08-04 00:00:00', 'Jessore Airport (JSR)', 'khulna bus ticket', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-04 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '6:50pm', '30366-92', 'JESSORE', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6750, 0, 0, 6750, 'Six Thousand Seven Hundred and Fifty', '30366-92', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(100, 'MCD-00100', '', '2016-08-05 00:00:00', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', 'Uttara EPZ,\r\nNilphamari', 'cargo', '', 100, 'BS-152', '2016-08-05 00:00:00', 0, 3, '268412', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(101, 'MCD-00101', '', '2016-08-05 00:00:00', 'Saidpur Airport (SPD)', 'Humayun kabir', '', '01788152559', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-05 00:00:00', 1, 0.2, '293230', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(102, 'MCD-00102', '', '2016-08-05 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', 'Saidpur Airport', 'bus_tkt', '', 0, '', '2016-08-05 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34301-34327(200x27=5400),\r\n34254-34267(250x14=3500)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8900, 0, 0, 8900, 'Eight Thousand Nine Hundred ', 'TKT NO: 34301-34327(200x27=5400),\r\n34254-34267(250x14=3500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(103, 'MCD-00103', '', '2016-08-05 00:00:00', 'Jessore Airport (JSR)', 'kHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-05 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '6:50pm', '30393-30431', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9750, 0, 0, 9750, 'Nine Thousand Seven Hundred and Fifty', '30393-30431', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(104, 'MCD-00104', '', '2016-08-06 00:00:00', 'Saidpur Airport (SPD)', 'sarwer shamim', '', '01878195970', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-06 00:00:00', 1, 0.02, '294294', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(105, 'MCD-00105', '', '2016-08-06 00:00:00', 'Cox''s Bazar Airport (CXB)', 'RADIANT HACHERY', '', '01710819970', '', '', 'cargo', '', 100, 'BS-142', '2016-08-06 00:00:00', 0, 50, '', '', '', '', '5*100=500 &\r\n45*80=3600', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 900, 0, 4100, 'Four Thousand One Hundred ', '5*100=500 &\r\n45*80=3600', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(106, 'MCD-00106', '', '2016-08-06 00:00:00', 'Rajshahi Airport (RJH)', 'kamal uddin', '', '01713700356', '', '', 'ebt', '00i2uv', 100, 'bs-162', '2016-08-06 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'ALI REDWONE DHIP', 32, '116.58.200.52', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00');
INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(107, 'MCD-00107', '', '2016-08-06 00:00:00', 'Saidpur Airport (SPD)', 'arif hossain', '', '01753417442', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-06 00:00:00', 1, 0.1, '279993', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(108, 'MCD-00108', '', '2016-08-06 00:00:00', 'Saidpur Airport (SPD)', 'SOHAN', '', '01787670309', '', '', 'cargo', '', 100, 'BS-154', '2016-08-06 00:00:00', 0, 8, '252972', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(109, 'MCD-00109', '', '2016-08-06 00:00:00', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01718832643', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-06 00:00:00', 1, 1, '268720', '01798674698', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(110, 'MCD-00110', '', '2016-08-06 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-06 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34328-34352(200x25=5000)\r\n34268-34293(250x26=6500)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 11500, 0, 0, 11500, 'Eleven Thousand Five Hundred ', 'TKT NO: 34328-34352(200x25=5000)\r\n34268-34293(250x26=6500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(111, 'MCD-00111', '', '2016-08-06 00:00:00', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-06 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '7:40am', '30432-67\r\n36 PCS', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9000, 0, 0, 9000, 'Nine Thousand ', '30432-67\r\n36 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(112, 'MCD-00112', '', '2016-08-07 00:00:00', 'Revenue', 'Mr. Hamed', '', '01712622251', '', 'Sylhet', 'ebt', '00HAIG', 100, 'BS132', '2016-08-07 00:00:00', 0, 12, '09876543', '01714122790', '', '', 'Test data entry for Sylhet', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1200, 140, 0, 1060, 'One Thousand and Sixty', 'Test data entry for Sylhet', 'Software Developper', 16, '202.51.179.250', '-Select Card Type-', '', '', 14, '2016-08-07 15:26:24', '27.147.149.146', 0, '0001-01-01 12:00:00'),
(113, 'MCD-00113', '', '2016-08-07 00:00:00', 'Saidpur Airport (SPD)', 'Mr Nihar', '', '01788152559', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-07 00:00:00', 1, 0.03, '230325', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(114, 'MCD-00114', '', '2016-08-07 00:00:00', 'Revenue', 'Mr. Limon', '', '01711395249', '', 'fghfhgf', 'ebt', '00ITER', 100, 'BS132', '2016-08-07 00:00:00', 0, 17, '98765453', '0987654312222', '', '', 'efgdfgdfgdfg\r\nTest Purpose', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1700, 150, 0, 1550, 'One Thousand Five Hundred and Fifty', 'efgdfgdfgdfg\r\nTest Purpose', 'Software Developper', 16, '163.47.32.234', '-Select Card Type-', '', '', 14, '2016-08-07 15:25:56', '27.147.149.146', 0, '0001-01-01 12:00:00'),
(115, 'MCD-00115', '', '2016-08-07 00:00:00', 'Cox''s Bazar Airport (CXB)', 'mr abu', '', '01819108029', '', '', 'mail_courier', '', 0, 'BS-142', '2016-08-07 00:00:00', 1, 1, '46640', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'JAMIR MD NAKIB US SATTAR', 17, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(116, 'MCD-00116', '', '2016-08-07 00:00:00', 'Jessore Airport (JSR)', 'N ISLAM ENTERPRISE (PVT) LTD', '', '01711899132', '', '', 'mail_courier', '', 0, 'BS 124', '2016-08-07 00:00:00', 1, 0.01, '275314', '01920725916', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(117, 'MCD-00117', '', '2016-08-07 00:00:00', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-07 00:00:00', 0, 0, '', '', 'usb bzl', '1:30pm', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2400, 0, 0, 2400, 'Two Thousand Four Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(118, 'MCD-00118', '', '2016-08-07 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/254/16/HQ', '', '01919479479', '', '', 'cargo', '', 100, 'BS 124', '2016-08-07 00:00:00', 0, 7, '238447', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(119, 'MCD-00119', '', '2016-08-07 00:00:00', 'Jessore Airport (JSR)', 'SP JSR', '', '01718500682', '', '', 'cargo', '', 100, 'BS-124', '2016-08-07 00:00:00', 0, 15, '280488 / 272279', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'Shabbir Hossain', 12, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(120, 'MCD-00120', '', '2016-08-07 00:00:00', 'Jessore Airport (JSR)', 'khulna bus ticket', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-07 00:00:00', 0, 0, '', '', 'bs 121 & 123', '7:00pm', '', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(121, 'MCD-00121', '', '2016-08-07 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-07 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34353-34374(200x22=4400),\r\n34294-34300,34401-34405(250x12=3000)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7400, 0, 0, 7400, 'Seven Thousand Four Hundred ', 'TKT NO: 34353-34374(200x22=4400),\r\n34294-34300,34401-34405(250x12=3000)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(122, 'MCD-00122', '', '2016-08-08 00:00:00', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', '', 'cargo', '', 100, 'BS-152', '2016-08-08 00:00:00', 0, 3, '256792', '01913890531', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(123, 'MCD-00123', '', '2016-08-08 00:00:00', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', '', 'cargo', '', 100, 'BS-152', '2016-08-08 00:00:00', 0, 3, '256792', '01913890531', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '-Select Card Type-', '', '', 15, '2016-08-11 13:16:20', '27.147.149.146', 0, '0001-01-01 12:00:00'),
(124, 'MCD-00124', '', '2016-08-08 00:00:00', 'Jessore Airport (JSR)', 'MR ANOK', '', '01718500682', '', '', 'mail_courier', '', 0, 'BS122', '2016-08-08 00:00:00', 1, 1, '254164', 'MASHIK HASAN', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', '01937510501', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(125, 'MCD-00125', '', '2016-08-08 00:00:00', 'Cox''s Bazar Airport (CXB)', 'MD HASEM', '', '01794218751', '', '', 'mail_courier', '', 0, 'BS-142', '2016-08-08 00:00:00', 1, 1, '46236', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'JAMIR MD NAKIB US SATTAR', 17, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(126, 'MCD-00126', '', '2016-08-08 00:00:00', 'Jessore Airport (JSR)', 'MTR/TS/255/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'BS-124', '2016-08-08 00:00:00', 0, 3, '237732', 'adjt', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(127, 'MCD-00127', '', '2016-08-08 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-08 00:00:00', 0, 0, '', '', 'BS-151,152 & BS-153,154', '9:00am', 'TKT NO: 34375-34398(200x24=4800),\r\n34406-34423(250x18=4500)', 'RANGPUR-SAIDPUR,DINJ', 'SAIDPUR-RANGPUR,SAID', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9300, 0, 0, 9300, 'Nine Thousand Three Hundred ', 'TKT NO: 34375-34398(200x24=4800),\r\n34406-34423(250x18=4500)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(128, 'MCD-00128', '', '2016-08-08 00:00:00', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-08 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '7:40am', '30503 - 31\r\n29 PCS', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7250, 0, 0, 7250, 'Seven Thousand Two Hundred and Fifty', '30503 - 31\r\n29 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(129, 'MCD-00129', '', '2016-08-08 00:00:00', 'Jessore Airport (JSR)', 'FRJUTE MILLS LTD', '', '018700011', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-08 00:00:00', 1, 1, '144469', '01715002400', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(130, 'MCD-00130', '', '2016-08-09 00:00:00', 'Revenue', 'Mr. Imran', '', '01816904090', '', '', 'cargo', '', 100, 'BS104', '2016-08-09 00:00:00', 0, 10, '345564566', '0987644332221', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '', 'Software Developper', 16, '119.30.47.146', '-Select Card Type-', 'Mr. Atiq\r\nDhaka', '', 7, '2016-08-09 13:26:43', '115.127.49.10', 0, '0001-01-01 12:00:00'),
(131, 'MCD-00131', '', '2016-08-09 00:00:00', 'Cox''s Bazar Airport (CXB)', 'selim morshed romel', '', '01712859275', '', '', 'cargo', '', 100, 'BS-142', '2016-08-09 00:00:00', 0, 5, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', 'MR IMRAN\r\n01611858584', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(132, 'MCD-00132', '', '2016-08-09 00:00:00', 'Cox''s Bazar Airport (CXB)', 'MR KAIRUL HAUQE', '', '01778393333', '', '', 'cargo', '', 100, 'BS-142', '2016-08-09 00:00:00', 0, 15, '19935', '', '', '', '5*100=500 &\r\n10*80=800', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 200, 0, 1300, 'One Thousand Three Hundred ', '5*100=500 &\r\n10*80=800', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(133, 'MCD-00133', '', '2016-08-09 00:00:00', 'Cox''s Bazar Airport (CXB)', 'mohammad ali khan', '', '01630606880', '', '', 'ebt', '00I3XX', 100, 'BS-142', '2016-08-09 00:00:00', 0, 6, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(134, 'MCD-00134', '72672', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'ms.farhana', '', '0222', '', '', 'ebt', '00i1vn', 100, 'bs104', '2016-08-09 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD OMAR MARUF', 40, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(135, 'MCD-00135', '72671', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'rony', '', '01811929829', '', '', 'mail_courier', '', 0, 'bs104', '2016-08-09 00:00:00', 1, 1, '12826', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD OMAR MARUF', 40, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(136, 'MCD-00136', '', '2016-08-09 00:00:00', 'Revenue', 'Mr. X', '', '01714122790', '', '', 'cargo', '', 100, 'BS121', '2016-08-10 00:00:00', 0, 10, '234567,  78906, 76544', '', '', '', '5 x 100=500\r\n5 x   80=400', 'CGP', 'JSR', 'card', '4535-XXXX-XXXX-5678', 'SCB', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '5 x 100=500\r\n5 x   80=400', 'Software Developper', 16, '119.30.47.146', 'Visa Card', 'Mr. Y\r\nDhaka', '678990045566', 7, '2016-08-10 12:38:46', '27.147.149.146', 0, '0001-01-01 12:00:00'),
(137, 'MCD-00137', '', '2016-08-09 00:00:00', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-09 00:00:00', 0, 0, '', '', 'usb bzl', '1:30pm', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1600, 0, 0, 1600, 'One Thousand Six Hundred ', '', 'SYED MOSTAIN HOSSAIN', 28, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(138, 'MCD-00138', '', '2016-08-09 00:00:00', 'Jessore Airport (JSR)', 'mtr/ts/256/16/hq', '', '01919479479', '', '', 'cargo', '', 100, 'bs-124', '2016-08-09 00:00:00', 0, 3, '289236', '9993404', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(139, 'MCD-00139', '', '2016-08-09 00:00:00', 'Jessore Airport (JSR)', 'rasu', '', '01712744817', '', '', 'mail_courier', '', 0, 'bs-124', '2016-08-09 00:00:00', 1, 1, '238715', '01753356112', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(140, 'MCD-00140', '', '2016-08-09 00:00:00', 'Jessore Airport (JSR)', 'lt col jahangir', '', '01769604110', '', '', 'cargo', '', 100, 'BS124', '2016-08-09 00:00:00', 0, 3, '272842', '01769012526', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'mjr srabontee dutta', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(141, 'MCD-00141', '', '2016-08-09 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-09 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '9:00am', 'TKT NO: 34399-34400,34501-34525(200x27=5400), 34424-34445(250x22=5500)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10900, 0, 0, 10900, 'Ten Thousand Nine Hundred ', 'TKT NO: 34399-34400,34501-34525(200x27=5400), 34424-34445(250x22=5500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(142, 'MCD-00142', '', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'MR.NAZMUL', '', '01820272723', '', '', 'cargo', '', 100, 'BS 108', '2016-08-09 00:00:00', 0, 3, '12509', '72673', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(143, 'MCD-00143', '', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'MR.NAZMUL', '', '01820272723', '', '', 'cargo', '', 100, 'BS 108', '2016-08-09 00:00:00', 0, 3, '12509', '72673', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(144, 'MCD-00144', '', '2016-08-09 00:00:00', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-09 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '7:40am', '30532-77\r\n46 PCS', 'JESSORE', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 11500, 0, 0, 11500, 'Eleven Thousand Five Hundred ', '30532-77\r\n46 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(145, 'MCD-00145', '', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'MR.BSF', '', '01727197104', '', '', 'cargo', '', 100, 'BS 108', '2016-08-09 00:00:00', 0, 4, '27973', '72674', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(146, 'MCD-00146', '', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'MR.SAJJAD', '', '01730787726', '', '', 'cargo', '', 100, 'BS 108', '2016-08-09 00:00:00', 0, 4, '05009', '72675', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(147, 'MCD-00147', '', '2016-08-09 00:00:00', 'Chittagong Airport (CGP)', 'MR.IQBAL', '', '01714168587', '', '', 'mail_courier', '', 0, 'BS 108', '2016-08-09 00:00:00', 1, 1, '01343', '72676', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(148, 'MCD-00148', '', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MR.AKBOR', '', '01826343543', '', '', 'mail_courier', '', 0, 'BS 104', '2016-08-10 00:00:00', 1, 1, '43547', '72677', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(149, 'MCD-00149', '', '2016-08-10 00:00:00', 'Cox''s Bazar Airport (CXB)', 'mr abu', '', '01819108029', '', '', 'mail_courier', '', 0, 'bs-142', '2016-08-10 00:00:00', 1, 1, '47736', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(150, 'MCD-00150', '72678', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'abdul mannan', '', '01715810107', '', '', 'cargo', '', 100, 'bs106', '2016-08-10 00:00:00', 0, 3, '21378', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(151, 'MCD-00151', '72679', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'mrs kaniz fatema', '', '01812110412', '', '', 'ebt', '00i5rc', 100, 'bs106', '2016-08-10 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(152, 'MCD-00152', '', '2016-08-10 00:00:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-10 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT 34526-34548(200x23=4600)\r\n34446-34470(250x25=6250)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10850, 0, 0, 10850, 'Ten Thousand Eight Hundred and Fifty', 'TKT 34526-34548(200x23=4600)\r\n34446-34470(250x25=6250)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(153, 'MCD-00153', '72680', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MR TAFAEL', '', '01731613781', '', '', 'ebt', '00I4P6', 100, 'BS108', '2016-08-10 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(154, 'MCD-00154', '72681', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MR SHOHAG', '', '01739637334', '', '', 'cargo', '', 100, 'BS108', '2016-08-10 00:00:00', 0, 3, '39860', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(155, 'MCD-00155', '73682', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MRS AMENA BEGUM NAZDIA', '', '01727719061', '', '', 'ebt', '00HTEH', 100, 'BS110', '2016-08-10 00:00:00', 0, 25, '', '', '', '', '', 'CGP', 'DAC', 'card', '5424-XXXX-XXXX-2417', 'CITI', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', 'Master Card', '', '000095435076', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(156, 'MCD-00156', '72683', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MR. MONIR', '', '01777707589', '', '', 'cargo', '', 100, 'BS 110', '2016-08-10 00:00:00', 0, 3, '29068', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '103.230.105.14', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(157, 'MCD-00157', '72684', '2016-08-10 00:00:00', 'Chittagong Airport (CGP)', 'MR. RASHED', '', '01811413280', '', '', 'ebt', '00I8XH', 100, 'BS 110', '2016-08-10 00:00:00', 0, 8, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '103.230.105.14', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(158, 'MCD-00158', '', '2016-08-10 00:00:00', 'Jessore Airport (JSR)', 'khulna bus ticket', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-10 00:00:00', 0, 0, '', '', 'bs 121 & 123', '', '30578-30600/ 23 Pcs', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5750, 0, 0, 5750, 'Five Thousand Seven Hundred and Fifty', '30578-30600/ 23 Pcs', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(159, 'MCD-00159', '', '2016-08-11 00:00:00', 'Chittagong Airport (CGP)', 'MR.IBRAHIM', '', '01838074417', '', '', 'mail_courier', '', 0, 'BS 102', '2016-08-11 00:00:00', 1, 1, '42903', '72685', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(160, 'MCD-00160', '', '2016-08-11 00:00:00', 'Saidpur Airport (SPD)', 'NIHAR RANJAN', '', '01737268374', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-11 00:00:00', 1, 0.1, '168983', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(161, 'MCD-00161', '', '2016-08-11 00:00:00', 'Cox''s Bazar Airport (CXB)', 'baf cxb / shohan', '', '01944582868', '', '', 'cargo', '', 100, 'BS-142', '2016-08-11 00:00:00', 0, 6, '47711', '', '', '', '5*100=500 & \r\n1*80 =80', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 20, 0, 580, 'Five Hundred and Eighty', '5*100=500 & \r\n1*80 =80', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(162, 'MCD-00162', '', '2016-08-11 00:00:00', 'Chittagong Airport (CGP)', 'MR.IBRAHIM', '', '01838074417', '', '', 'mail_courier', '', 0, 'BS102', '2016-08-11 00:00:00', 1, 1, '42903', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MOHIUDDIN', 52, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(163, 'MCD-00163', '', '2016-08-11 00:00:00', 'Chittagong Airport (CGP)', 'MR.AZAM KHAN', '', '01826666155', '', '', 'mail_courier', '', 0, 'BS104', '2016-08-11 00:00:00', 1, 1, '09381', '', '', '', 'Wrongly input 200 ISO 300,Ref: sumit.aps,to:atik & rev', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 200, 'Two Hundred ', 'Wrongly input 200 ISO 300,Ref: sumit.aps,to:atik & rev', 'MOHIUDDIN', 52, '27.147.250.42', '-Select Card Type-', '', '', 8, '2016-08-23 17:16:55', '115.127.65.130', 1, '2016-08-23 17:16:55'),
(164, 'MCD-00164', '', '2016-08-11 00:00:00', 'Chittagong Airport (CGP)', 'MR.RONY', '', '01811929829', '', '', 'cargo', '', 300, 'BS104', '2016-08-11 00:00:00', 0, 3, '36641', '', '', '', 'CARGO 03 KG=300', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 900, 600, 0, 300, 'Three Hundred ', 'CARGO 03 KG=300', 'MOHIUDDIN', 52, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(165, 'MCD-00165', '', '2016-08-11 00:00:00', 'Chittagong Airport (CGP)', 'MR.MOTALAB', '', '01867552389', '', '', 'mail_courier', '', 0, 'BS104', '2016-08-11 00:00:00', 1, 1, '36568', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MOHIUDDIN', 52, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 12:00:00'),
(166, 'MCD-00166', '', '2016-08-11 16:18:53', 'Jessore Airport (JSR)', 'saleha metal jessore', '', '01913250753', '', '', 'mail_courier', '', 0, 'bs124', '2016-08-11 00:00:00', 1, 1, 'cgp 050160', '01957939911', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(167, 'MCD-00167', '', '2016-08-11 16:25:33', 'Jessore Airport (JSR)', 'dr. surovi. jessore', '', '01758567356', '', '', 'cargo', '', 300, 'bs-124', '2016-08-11 00:00:00', 0, 1, '239844', '01712010176', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'maj. gazi', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(168, 'MCD-00168', '', '2016-08-11 16:27:34', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-11 00:00:00', 0, 0, '', '', 'usb bzl,bs-172', '', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3500, 0, 0, 3500, 'Three Thousand Five Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(169, 'MCD-00169', '72689', '2016-08-11 16:51:23', 'Chittagong Airport (CGP)', 'md zulfikar ali', '', '01819319153', '', '', 'ebt', '00i6pv', 100, 'bs106', '2016-08-11 00:00:00', 0, 14, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1400, 0, 0, 1400, 'One Thousand Four Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '103.230.106.9', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(170, 'MCD-00170', '72690', '2016-08-11 17:00:13', 'Chittagong Airport (CGP)', 'mr madusanka', '', '01730070160', '', '', 'ebt', '00i6d4', 100, 'bs106', '2016-08-11 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '103.230.104.9', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(171, 'MCD-00171', '72691', '2016-08-11 17:04:51', 'Chittagong Airport (CGP)', 'mr sujon', '', '01866977703', '', '', 'cargo', '', 100, 'bs106', '2016-08-11 00:00:00', 0, 3, '25959', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '103.230.106.9', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(172, 'MCD-00172', '', '2016-08-11 17:08:21', 'Jessore Airport (JSR)', 'mohaimin-ul-kabir JSR', '', '01782923983', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-11 00:00:00', 1, 1, '259898', '01789320530', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(173, 'MCD-00173', '', '2016-08-11 17:30:50', 'Jessore Airport (JSR)', 'MTR/TS/161/16/HQ', '', '01929764568', '', '', 'cargo', '', 100, 'BS-124', '2016-08-11 00:00:00', 0, 5, '259009', '029993404', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(174, 'MCD-00174', '', '2016-08-11 18:59:39', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-11 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 34549-34568(200x20=4000),\r\n34471-34488(250x18=4500)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8500, 0, 0, 8500, 'Eight Thousand Five Hundred ', 'TKT NO: 34549-34568(200x20=4000),\r\n34471-34488(250x18=4500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(175, 'MCD-00175', '72692', '2016-08-11 19:12:53', 'Chittagong Airport (CGP)', 'MR.HASAN', '', '01727197104', '', '', 'cargo', '', 100, 'BS 108', '2016-08-11 00:00:00', 0, 4, '26028', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(176, 'MCD-00176', '', '2016-08-11 19:29:50', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-11 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35101-43 / 43 pcs', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10750, 0, 0, 10750, 'Ten Thousand Seven Hundred and Fifty', '35101-43 / 43 pcs', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-11 00:00:00'),
(177, 'MCD-00177', '', '2016-08-12 09:13:26', 'Chittagong Airport (CGP)', 'MR.KAMRUL', '', '01911206891', '', '', 'mail_courier', '', 0, 'BS102', '2016-08-12 00:00:00', 1, 1, '40548', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MOHIUDDIN', 52, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(178, 'MCD-00178', '', '2016-08-12 11:50:09', 'Cox''s Bazar Airport (CXB)', 'RADIANT HACHERY/MOMTAZ UDDIN', '', '01710819970', '', '', 'cargo', '', 100, 'BS-142', '2016-08-12 00:00:00', 0, 22, '49120 & 49119', '', '', '', '5*100   = 500 tk \r\n17*100 = 1360 tk', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2200, 340, 0, 1860, 'One Thousand Eight Hundred and Sixty', '5*100   = 500 tk \r\n17*100 = 1360 tk', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(179, 'MCD-00179', '', '2016-08-12 13:11:02', 'Cox''s Bazar Airport (CXB)', 'dr shahela hossain', '', '01954504001', '', '', 'ebt', '00I5PB', 100, 'BS-142', '2016-08-12 00:00:00', 0, 8, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(180, 'MCD-00180', '', '2016-08-12 18:19:26', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-12 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 34569-34597(200x29=5800),\r\n34489-34500(250x12=3000)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8800, 0, 0, 8800, 'Eight Thousand Eight Hundred ', 'TKT NO: 34569-34597(200x29=5800),\r\n34489-34500(250x12=3000)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(181, 'MCD-00181', '', '2016-08-12 19:09:46', 'Jessore Airport (JSR)', 'ARAMEX KHL', '', '0412830611', '', '', 'cargo', '', 100, 'bs-124', '2016-08-12 00:00:00', 0, 3, '144492', '01942995522', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(182, 'MCD-00182', '', '2016-08-12 19:09:48', 'Jessore Airport (JSR)', 'ARAMEX KHL', '', '0412830611', '', '', 'cargo', '', 100, 'bs-124', '2016-08-12 00:00:00', 0, 3, '144492', '01942995522', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(183, 'MCD-00183', '', '2016-08-12 19:18:57', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-12 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '', '35144-35170.\r\n27 PCS', 'JESSORE', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6750, 0, 0, 6750, 'Six Thousand Seven Hundred and Fifty', '35144-35170.\r\n27 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-12 00:00:00'),
(184, 'MCD-00184', '72694', '2016-08-13 08:50:38', 'Chittagong Airport (CGP)', 'MR MONSUR', '', '01876693448', '', '', 'cargo', '', 100, 'BS102', '2016-08-13 00:00:00', 0, 3, '05372', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(185, 'MCD-00185', '72695', '2016-08-13 08:52:34', 'Chittagong Airport (CGP)', 'MR DEBU', '', '01747699233', '', '', 'mail_courier', '', 0, 'BS102', '2016-08-13 00:00:00', 1, 1, '45770', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(186, 'MCD-00186', '', '2016-08-13 10:05:17', 'Saidpur Airport (SPD)', 'MD SARIFUZZAMAN', '', '01922379419', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-13 00:00:00', 1, 0.35, '146405', '01911623046', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(187, 'MCD-00187', '72696', '2016-08-13 11:21:03', 'Chittagong Airport (CGP)', 'mr faisal', '', '01627979685', '', '', 'cargo', '', 100, 'bs104', '2016-08-13 00:00:00', 0, 3, '49249', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(188, 'MCD-00188', '', '2016-08-13 14:08:17', 'Rajshahi Airport (RJH)', 'MOHAMMAD KADIM ALI', '', '01712363060', '', '', 'ebt', '00hwkp', 100, 'bs-162', '2016-08-13 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'ALI REDWONE DHIP', 32, '123.108.244.228', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(189, 'MCD-00189', '', '2016-08-13 15:58:18', 'Jessore Airport (JSR)', 'GE BIMAN', '', '01911176903', '', '', 'cargo', '', 100, 'BS-124', '2016-08-13 00:00:00', 0, 4, '288569', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'CMES (AIR) KTL\r\n01718474586', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(190, 'MCD-00190', '', '2016-08-13 16:16:45', 'Saidpur Airport (SPD)', 'K.M. MASFIKUR RAHMAN', '', '01711144142', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-13 00:00:00', 1, 0.1, '146369', '01631157174', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(191, 'MCD-00191', '', '2016-08-13 16:38:08', 'Saidpur Airport (SPD)', 'NIHAR RANJAN', '', '01737268374', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-13 00:00:00', 1, 0.2, '146371', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(192, 'MCD-00192', '', '2016-08-13 18:12:27', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-13 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 34598-34600/36601-36627(200x30=6000), 36701-36711(250x11=2750)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', 'TKT NO: 34598-34600/36601-36627(200x30=6000), 36701-36711(250x11=2750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(193, 'MCD-00193', '', '2016-08-13 18:33:28', 'Chittagong Airport (CGP)', 'MR SAJID', '', '01681748844', '', '', 'cargo', '', 100, 'BS108', '2016-08-13 00:00:00', 0, 3, '11315', '72698', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(194, 'MCD-00194', '', '2016-08-13 19:07:16', 'Chittagong Airport (CGP)', 'mr sohag', '', '01739637134', '', '', 'cargo', '', 100, 'bs108', '2016-08-13 00:00:00', 0, 5, '00202', '72697', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(195, 'MCD-00195', '', '2016-08-13 19:21:46', 'Jessore Airport (JSR)', 'kHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-13 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35171-211/ 41 PCS', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10250, 0, 0, 10250, 'Ten Thousand Two Hundred and Fifty', '35171-211/ 41 PCS', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-13 00:00:00'),
(196, 'MCD-00196', '72701', '2016-08-14 14:25:31', 'Chittagong Airport (CGP)', 'FATEMA ZOHRA', '', '00000', '', '', 'ebt', '00I1N3', 100, 'bs104', '2016-08-14 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(197, 'MCD-00197', '72699', '2016-08-14 14:28:04', 'Chittagong Airport (CGP)', 'SAJEDUL HASAN', '', '01798511771', '', '', 'ebt', '00I712', 100, 'bs104', '2016-08-14 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(198, 'MCD-00198', '72700', '2016-08-14 14:29:21', 'Chittagong Airport (CGP)', 'SHURUV', '', '01730444511', '', '', 'mail_courier', '', 0, 'bs104', '2016-08-14 00:00:00', 1, 1, '36737', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(199, 'MCD-00199', '', '2016-08-14 15:11:26', 'Chittagong Airport (CGP)', 'MR.RUBEL', '', '01840737286', '', '', 'cargo', '', 100, 'BS 106', '2016-08-14 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(200, 'MCD-00200', '', '2016-08-14 15:25:33', 'Chittagong Airport (CGP)', 'mr.shoeb', '', '01777707645', '', '', 'ebt', '00i8mc', 100, 'bs 106', '2016-08-14 00:00:00', 0, 15, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(201, 'MCD-00201', '', '2016-08-14 15:29:43', 'Chittagong Airport (CGP)', 'MR.HANIF', '', '01923325267', '', '', 'mail_courier', '', 0, 'BS 106', '2016-08-14 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(202, 'MCD-00202', '', '2016-08-14 16:13:48', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-14 00:00:00', 0, 0, '', '', 'usb bzl,bs-172', '', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(203, 'MCD-00203', '', '2016-08-14 17:02:00', 'Jessore Airport (JSR)', 'MTR/TS/262/16/HQ', '', '01710695181', '', '', 'cargo', '', 100, 'BS-124', '2016-08-14 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(204, 'MCD-00204', '', '2016-08-14 18:39:16', 'Chittagong Airport (CGP)', 'MR KHALED', '', '01811409651', '', '', 'mail_courier', '', 0, 'BS 108', '2016-08-14 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(205, 'MCD-00205', '', '2016-08-14 18:49:39', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-14 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO; 36628-36656(200x29=5800),\r\n36712-36730 (250x19=4750)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10550, 0, 0, 10550, 'Ten Thousand Five Hundred and Fifty', 'TKT NO; 36628-36656(200x29=5800),\r\n36712-36730 (250x19=4750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(206, 'MCD-00206', '', '2016-08-14 19:06:35', 'Chittagong Airport (CGP)', 'MR MOHIUDDIN', '', '01865578020', '', '', 'mail_courier', '', 0, 'BS 108', '2016-08-14 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(207, 'MCD-00207', '', '2016-08-14 19:27:27', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-14 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35212-35244 / 33 PCS', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8250, 0, 0, 8250, 'Eight Thousand Two Hundred and Fifty', '35212-35244 / 33 PCS', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(208, 'MCD-00208', '', '2016-08-14 20:42:21', 'Chittagong Airport (CGP)', 'MR PINTU', '', '01618157450', '', '', 'mail_courier', '', 0, 'BS 110', '2016-08-14 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-14 00:00:00'),
(209, 'MCD-00209', '72708', '2016-08-15 08:37:15', 'Chittagong Airport (CGP)', 'MR SENAKE', '', '01713104566', '', '', 'ebt', '00ID99', 100, 'BS102', '2016-08-15 00:00:00', 0, 20, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(210, 'MCD-00210', '72709', '2016-08-15 08:38:27', 'Chittagong Airport (CGP)', 'MR SHELIO', '', '01817725405', '', '', 'ebt', '00IDHK', 100, 'BS102', '2016-08-15 00:00:00', 0, 18, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1800, 0, 0, 1800, 'One Thousand Eight Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(211, 'MCD-00211', '72710', '2016-08-15 11:24:29', 'Chittagong Airport (CGP)', 'MR. FAKHRUL ISLAM', '', '01843333167', '', '', 'cargo', '', 100, 'BS 104', '2016-08-15 00:00:00', 0, 3, '30624', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'md rizoan hossain', 41, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(212, 'MCD-00212', '72711', '2016-08-15 11:27:18', 'Chittagong Airport (CGP)', 'MRS. SHAMS RANIA', '', '01711720054', '', '', 'ebt', '00I167', 100, 'BS 104', '2016-08-15 00:00:00', 0, 30, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000, 0, 0, 3000, 'Three Thousand ', '', 'md rizoan hossain', 41, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(213, 'MCD-00213', '72712', '2016-08-15 11:33:49', 'Chittagong Airport (CGP)', 'MR.KAMRUL HASSAN', '', '01766680567', '', '', 'ebt', '00ICWN', 100, 'BS 104', '2016-08-15 00:00:00', 0, 15, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'md rizoan hossain', 41, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(214, 'MCD-00214', '', '2016-08-15 14:02:35', 'Rajshahi Airport (RJH)', 'masuma haque', '', '01718226609', '', '', 'ebt', '00i2w2', 100, 'bs-162', '2016-08-15 00:00:00', 0, 20, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'ALI REDWONE DHIP', 32, '116.58.203.34', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(215, 'MCD-00215', '', '2016-08-15 15:10:48', 'Chittagong Airport (CGP)', 'MR.MAINUDDIN', '', '01829446746', '', '', 'cargo', '', 100, 'BS 106', '2016-08-15 00:00:00', 0, 3, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(216, 'MCD-00216', '', '2016-08-15 15:30:46', 'Chittagong Airport (CGP)', 'MR.BADRUL KADER', '', '01878874512', '', '', 'ebt', 'I0QN', 100, 'BS 106', '2016-08-15 00:00:00', 0, 20, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00');
INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(217, 'MCD-00217', '', '2016-08-15 17:11:35', 'Jessore Airport (JSR)', 'MTR/TS/16/HQ', '', '9993404', '', '', 'cargo', '', 100, 'BS-124', '2016-08-15 00:00:00', 0, 3, '235796', 'adjt', '', '', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 7, '2016-08-15 17:48:06', '116.58.205.114', 1, '2016-08-15 17:48:06'),
(218, 'MCD-00218', '', '2016-08-15 17:12:24', 'Jessore Airport (JSR)', 'MTR/TS/16/HQ', '', '9993404', '', '', 'cargo', '', 100, 'BS-124', '2016-08-15 00:00:00', 0, 3, '235796', 'adjt', '', '', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 7, '2016-08-15 17:48:30', '116.58.205.114', 0, '2016-08-15 17:48:30'),
(219, 'MCD-00219', '', '2016-08-15 17:14:12', 'Jessore Airport (JSR)', 'MTR/TS/16/HQ', '', '9993404', '', '', 'cargo', '', 100, 'BS-124', '2016-08-15 00:00:00', 0, 3, '235796', 'adjt', '', '', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', 'Duplicate posting MCD 217,218,219 so last 2 voided', 'Humayun Kabir', 11, '203.76.120.226', '-Select Card Type-', '', '', 7, '2016-08-15 17:48:54', '116.58.205.114', 0, '2016-08-15 17:48:54'),
(220, 'MCD-00220', '', '2016-08-15 17:28:04', 'Jessore Airport (JSR)', 'RRF JESSORE', '', '01711182334', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-15 00:00:00', 1, 1, '258417', '017198674698', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(221, 'MCD-00221', '', '2016-08-15 18:21:40', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-15 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 36657-36688(200x32=6400)\r\n36731-36748(250x18=4500)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10900, 0, 0, 10900, 'Ten Thousand Nine Hundred ', 'TKT NO: 36657-36688(200x32=6400)\r\n36731-36748(250x18=4500)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(222, 'MCD-00222', '', '2016-08-15 19:16:18', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-15 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35245-84\r\n40 PCS', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '35245-84\r\n40 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-15 00:00:00'),
(223, 'MCD-00223', '', '2016-08-16 13:24:48', 'Cox''s Bazar Airport (CXB)', 'nazmul hossain', '', '01929993013', '', '', 'ebt', '00i79h', 100, 'BS-142', '2016-08-16 00:00:00', 0, 7, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(224, 'MCD-00224', '72715', '2016-08-16 16:49:25', 'Chittagong Airport (CGP)', 'mr sujon', '', '01866977703', '', '', 'cargo', '', 100, 'bs106', '2016-08-16 00:00:00', 0, 3, '40924', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(225, 'MCD-00225', '72716', '2016-08-16 16:51:21', 'Chittagong Airport (CGP)', 'mr nuru', '', '01819547453', '', '', 'mail_courier', '', 0, 'bs106', '2016-08-16 00:00:00', 1, 1, '23331', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(226, 'MCD-00226', '72717', '2016-08-16 16:53:42', 'Chittagong Airport (CGP)', 'mr abdul halim', '', '01920945087', '', '', 'mail_courier', '', 0, 'bs106', '2016-08-16 00:00:00', 1, 1, '44374', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(227, 'MCD-00227', '', '2016-08-16 17:02:09', 'Jessore Airport (JSR)', 'BASE ADJT BAF JSR', '', '9993404', '', '', 'cargo', '', 100, 'BS-124', '2016-08-16 00:00:00', 0, 6, '274877', 'AIR HQ DHAKA CANTT 9993404', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'AIR HQ DHAKA CANTT 9993404', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(228, 'MCD-00228', '', '2016-08-16 17:26:42', 'Revenue', 'Mr. X', '', '01714122790', '', '', 'ebt', '00IE45', 100, 'BS107', '2016-08-16 00:00:00', 0, 10, '56756756756', '0176534343434', '', '', '', 'DAC', 'CGP', 'card', '4562-XXXX-XXXX-7892', 'SCB', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '', 'Software Developper', 16, '123.200.23.138', 'Visa Card', '', '123123123123', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(229, 'MCD-00229', '', '2016-08-16 17:30:46', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-16 00:00:00', 0, 0, '', '', 'usb bzl', '', '', 'barisal to airport', 'airport to barisal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1100, 0, 0, 1100, 'One Thousand One Hundred ', '', 'SYED MOSTAIN HOSSAIN', 28, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(230, 'MCD-00230', '', '2016-08-16 18:36:07', 'Saidpur Airport (SPD)', 'SORIFUL ISLAM', '', '01918705767', '', '', 'bus_tkt', '', 0, '', '2016-08-16 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'TKT NO: 36689-36700 & 36801-36819 (200x32=6400),\r\n36749-36760(250x12=3000)', 'RANGPUR - SAIDPUR, D', 'SAIDPUR - RANGPUR, S', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9400, 0, 0, 9400, 'Nine Thousand Four Hundred ', 'TKT NO: 36689-36700 & 36801-36819 (200x32=6400),\r\n36749-36760(250x12=3000)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(231, 'MCD-00231', '', '2016-08-16 19:00:20', 'Revenue', 'Mr. Y', '', '01714122790', '', '', 'ebt', '00IFRT', 100, 'BS109', '2016-08-16 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'card', '4321-XXXX-XXXX-2342', 'SCB', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'Software Developper', 16, '123.200.23.138', 'Visa Card', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(232, 'MCD-00232', '', '2016-08-16 19:19:44', 'Chittagong Airport (CGP)', 'mr. oshana shankar', '', '01708134616', '', '', 'ebt', '00if4q', 100, 'BS108', '2016-08-16 00:00:00', 0, 50, '', '', '', '', '', 'sl5', 'sl6', 'card', '4325-XXXX-XXXX-0007', 'commercial bank', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', 'Visa Card', '', '000095872235', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(233, 'MCD-00233', '72718', '2016-08-16 19:28:29', 'Chittagong Airport (CGP)', 'mr. syem', '', '01726875323', '', '', 'cargo', '', 100, 'BS108', '2016-08-16 00:00:00', 0, 17, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1700, 240, 0, 1460, 'One Thousand Four Hundred and Sixty', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(234, 'MCD-00234', '72719', '2016-08-16 19:29:46', 'Chittagong Airport (CGP)', 'mr. nazmul', '', '01820272723', '', '', 'cargo', '', 100, 'BS108', '2016-08-16 00:00:00', 0, 4, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(235, 'MCD-00235', '72720', '2016-08-16 19:31:18', 'Chittagong Airport (CGP)', 'mr. moniruz zaman', '', '01819615394', '', '', 'ebt', '00ibdu', 100, 'BS108', '2016-08-16 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(236, 'MCD-00236', '72721', '2016-08-16 19:32:58', 'Chittagong Airport (CGP)', 'ms. shahima', '', '01715154710', '', '', 'ebt', '00icy4', 100, 'BS108', '2016-08-16 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(237, 'MCD-00237', '', '2016-08-16 19:35:37', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-16 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '', '39 PCS \r\n35285-323', 'JESSORE', 'KHULNA', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9750, 0, 0, 9750, 'Nine Thousand Seven Hundred and Fifty', '39 PCS \r\n35285-323', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(238, 'MCD-00238', '72722', '2016-08-16 20:37:27', 'Chittagong Airport (CGP)', 'mr.alom', '', '01689501624', '', '', 'cargo', '', 100, 'BS 110', '2016-08-16 00:00:00', 0, 8, '13468', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 60, 0, 740, 'Seven Hundred and Forty', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '-Select Card Type-', '', '', 7, '2016-08-18 17:18:32', '115.127.65.130', 1, '2016-08-18 17:18:32'),
(239, 'MCD-00239', '72722', '2016-08-16 20:41:15', 'Chittagong Airport (CGP)', 'mr.alom', '', '01689501624', '', '', 'cargo', '', 100, 'BS 108', '2016-08-16 00:00:00', 0, 8, '13468', '', '', '', 'MCD 00238,39 & 40 are same information wrongly issued and voided as per mail', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 60, 0, 740, 'Seven Hundred and Forty', 'MCD 00238,39 & 40 are same information wrongly issued and voided as per mail', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '-Select Card Type-', '', '', 7, '2016-08-18 17:26:12', '27.147.149.146', 0, '2016-08-18 17:26:12'),
(240, 'MCD-00240', '72722', '2016-08-16 20:41:41', 'Chittagong Airport (CGP)', 'mr.alom', '', '01689501624', '', '', 'cargo', '', 100, 'BS 108', '2016-08-16 00:00:00', 0, 8, '13468', '', '', '', 'MCD 00238,39 & 40 are same information wrongly issued and voided as per mail', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 60, 0, 740, 'Seven Hundred and Forty', 'MCD 00238,39 & 40 are same information wrongly issued and voided as per mail', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '-Select Card Type-', '', '', 7, '2016-08-18 17:26:58', '27.147.149.146', 0, '2016-08-18 17:26:58'),
(241, 'MCD-00241', '72723', '2016-08-16 21:00:28', 'Chittagong Airport (CGP)', 'mr. ashik', '', '01748820877', '', '', 'ebt', '00iei0', 100, 'bs110', '2016-08-16 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-16 00:00:00'),
(242, 'MCD-00242', '', '2016-08-17 09:52:02', 'Dhaka Airport (DAC)', 'SAHEH', '', '0125489', '', '', 'cargo', '', 100, 'BS101', '2016-08-17 00:00:00', 0, 5, '125466', '01745898989', '', '', 'WRONGLY ISSUED DURING TRAINING', 'JSR', 'CGP', 'card', '4587-XXXX-XXXX-4587', 'SCB', '', '', '', '', 'Taka', 500, 10, 0, 490, 'Four Hundred and Ninety', 'WRONGLY ISSUED DURING TRAINING', 'SALEH SERAJ', 67, '123.200.23.138', 'Visa Card', 'MR. X', '123', 7, '2016-08-17 09:57:49', '123.200.23.138', 0, '2016-08-17 09:57:49'),
(243, 'MCD-00243', '', '2016-08-17 10:15:28', 'Saidpur Airport (SPD)', 'Mr Nihar', '', '01737268374', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-17 00:00:00', 1, 0.25, '278167', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(244, 'MCD-00244', '', '2016-08-17 10:22:11', 'Revenue', 'Mr. ABC', '', '01714122790', '', '', 'ebt', '00TRIR', 100, 'BS109', '2016-08-17 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'Software Developper', 16, '123.200.23.138', '-Select Card Type-', '', '', 14, '2016-08-17 10:30:14', '123.200.23.138', 0, '2016-08-17 10:30:14'),
(245, 'MCD-00245', '', '2016-08-17 10:39:20', 'Chittagong Airport (CGP)', 'MD.MUBARAK', '', '01745198907', '', '', 'ebt', '00IFK0', 100, 'bs 104', '2016-08-17 00:00:00', 0, 30, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000, 0, 0, 3000, 'Three Thousand ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(246, 'MCD-00246', '', '2016-08-17 12:50:24', 'Cox''s Bazar Airport (CXB)', 'mr jahangir ahmed', '', '01558216000', '', '', 'ebt', '00IAMC', 100, 'bs-142', '2016-08-17 00:00:00', 0, 13, '', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1300, 0, 0, 1300, 'One Thousand Three Hundred ', '', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(247, 'MCD-00247', '', '2016-08-17 14:04:17', 'Rajshahi Airport (RJH)', 'SAILA AKHTER', '', '01774709356', '', 'RAJSHAHI', 'cargo', '', 100, 'BS-162', '2016-08-17 00:00:00', 0, 3, '29635', '01711090438', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ALI REDWONE DHIP', 32, '116.58.201.90', '', 'ATIKUR RAHMAN POLASH', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(248, 'MCD-00248', '', '2016-08-17 14:17:25', 'Rajshahi Airport (RJH)', 'MOHAMMED MANIRUZZAMAN', '', '01711157095', '', '', 'ebt', '00I47K', 100, 'BS-162', '2016-08-17 00:00:00', 0, 15, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'ALI REDWONE DHIP', 32, '116.58.201.90', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(249, 'MCD-00249', '', '2016-08-17 16:49:57', 'Saidpur Airport (SPD)', 'Mrs. BANU SYEDA TASNEEM', '', '01711538471', '', '', 'ebt', '00I6AI', 100, 'BS-154', '2016-08-17 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(250, 'MCD-00250', '', '2016-08-17 17:27:38', 'Jessore Airport (JSR)', 'RRF FOUNDATION JESSORE', '', '01718832643', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-17 00:00:00', 1, 1, '238262', '01798674698 RRF  DAC', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(251, 'MCD-00251', '72725', '2016-08-17 18:12:29', 'Chittagong Airport (CGP)', 'mr sujon', '', '01866977703', '', '', 'cargo', '', 100, 'BS 106', '2016-08-17 00:00:00', 0, 14, '11843', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1400, 180, 0, 1220, 'One Thousand Two Hundred and Twenty', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(252, 'MCD-00252', '', '2016-08-17 18:34:55', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-17 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 36820-36836(200x17=3400),\r\n36761-36784(250x24=6000)', 'RANGPUR - SAIDPUR, d', 'SAIDPIR - RANGPUR,sa', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9400, 0, 0, 9400, 'Nine Thousand Four Hundred ', 'TKT NO: 36820-36836(200x17=3400),\r\n36761-36784(250x24=6000)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(253, 'MCD-00253', '', '2016-08-17 18:44:54', 'Chittagong Airport (CGP)', 'mr shohag', '', '01739637334', '', '', 'cargo', '', 100, 'BS108', '2016-08-17 00:00:00', 0, 3, '01523', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(254, 'MCD-00254', '', '2016-08-17 19:17:18', 'Jessore Airport (JSR)', 'MTR/TS/   /16/HQ', '', '01735069150', '', '', 'cargo', '', 100, 'bs-124', '2016-08-17 00:00:00', 0, 6, '258226', 'ADJT,DAC', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(255, 'MCD-00255', '', '2016-08-17 19:48:28', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-17 00:00:00', 0, 0, '', '', 'BS-121 & BS 123', '', '35324-59\r\n36 PCS', 'JESSORE', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9000, 0, 0, 9000, 'Nine Thousand ', '35324-59\r\n36 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(256, 'MCD-00256', '72726', '2016-08-17 20:34:22', 'Chittagong Airport (CGP)', 'MR NOYON', '', '01793012260', '', '', 'mail_courier', '', 0, 'BS108', '2016-08-17 00:00:00', 1, 1, '25866', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-17 00:00:00'),
(257, 'MCD-00257', '', '2016-08-18 07:19:46', 'Jessore Airport (JSR)', 'al-amin', '', '01786627171', '', '', 'cargo', '', 100, 'BS122', '2016-08-18 00:00:00', 0, 6, '236233', '01721097494', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 0, 0, 600, 'Six Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'shahadat hossain', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(258, 'MCD-00258', '', '2016-08-18 07:27:28', 'Chittagong Airport (CGP)', 'MR.YACOOB', '', '01711275314', '', '', 'ebt', '00IBMQ', 100, 'BS 102', '2016-08-18 00:00:00', 0, 25, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(259, 'MCD-00259', '', '2016-08-18 08:20:09', 'Chittagong Airport (CGP)', 'mr.MALINDA', '', '01709637676', '', '', 'ebt', '00IG0Z', 100, 'BS 102', '2016-08-18 00:00:00', 0, 15, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(260, 'MCD-00260', '', '2016-08-18 10:15:37', 'Chittagong Airport (CGP)', 'MRS.PERVEEN FAHMIDA', '', '01815437939', '', '', 'ebt', '00IFKV', 100, 'BS 102', '2016-08-18 00:00:00', 0, 25, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(261, 'MCD-00261', '', '2016-08-18 11:10:26', 'Chittagong Airport (CGP)', 'mr.sarwar', '', '01730004267', '', '', 'ebt', '00iek8', 100, 'bs 104', '2016-08-18 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(262, 'MCD-00262', '', '2016-08-18 11:10:37', 'Chittagong Airport (CGP)', 'mr.sarwar', '', '01730004267', '', '', 'ebt', '00iek8', 100, 'bs 104', '2016-08-18 00:00:00', 0, 10, '', '', '', '', 'MCD 261 & 262 are same so 262 voided as per mail', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', 'MCD 261 & 262 are same so 262 voided as per mail', 'MONIR AHMED', 48, '115.127.49.10', '-Select Card Type-', '', '', 7, '2016-08-20 15:19:44', '115.127.65.130', 0, '2016-08-20 15:19:44'),
(263, 'MCD-00263', '', '2016-08-18 11:27:05', 'Saidpur Airport (SPD)', 'MR. SOHAN', '', '01787670309', '', '', 'cargo', '', 300, 'BS-152', '2016-08-18 00:00:00', 0, 1, '146410', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(264, 'MCD-00264', '', '2016-08-18 14:53:31', 'Dhaka Airport (DAC)', 'Mr. Baizid hossain', '', '01866977715', '', 'UNIQUE EXPRESS LTD', 'cargo', '', 80, 'bs-105', '2016-08-18 00:00:00', 0, 103, '104187,103527,106740', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8240, 0, 0, 8240, 'Eight Thousand Two Hundred and Forty', '', 'FERDOUS AHMAD', 57, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(265, 'MCD-00265', 'MR NO-70590', '2016-08-18 14:54:45', 'Dhaka Airport (DAC)', 'Mr. Baizid hossain', '', '01866977715', '', 'UNIQUE EXPRESS LTD', 'cargo', '', 80, 'bs-105', '2016-08-18 00:00:00', 0, 103, '104187,103527,106740', '', '', '', 'MCD00264 and 265 are same information so 265 voided as per mail.', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8240, 0, 0, 8240, 'Eight Thousand Two Hundred and Forty', 'MCD00264 and 265 are same information so 265 voided as per mail.', 'FERDOUS AHMAD', 57, '115.127.68.26', '-Select Card Type-', '', '', 7, '2016-08-18 16:59:40', '115.127.65.130', 0, '2016-08-18 16:59:40'),
(266, 'MCD-00266', 'MR NO-70590', '2016-08-18 15:19:01', 'Sylhet Airport (ZYL)', 'SUNDARBAN(IOM)', '', '01715202688', '', '', 'cargo', '', 100, 'BS132', '2016-08-18 00:00:00', 0, 3, '120595', 'MR NO-70590', '', '', '', 'ZYL', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(267, 'MCD-00267', '', '2016-08-18 15:51:12', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 0, '', '2016-08-18 00:00:00', 0, 0, '', '', 'usb bzl,bs-172', '', '', 'jhalokati-barisal-ai', 'airport-barisal-jhal', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2800, 0, 0, 2800, 'Two Thousand Eight Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(268, 'MCD-00268', '', '2016-08-18 16:36:54', 'Dhaka Airport (DAC)', 'ad mr ashraful alam', '', '01996617798', '', '', 'ebt', '00idif', 100, 'bs-123', '2016-08-18 00:00:00', 0, 10, '', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'NAHIDA SULTANA', 61, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(269, 'MCD-00269', '', '2016-08-18 16:39:44', 'Chittagong Airport (CGP)', 'mr rony', '', '01866977707', '', '', 'cargo', '', 100, 'bs 106', '2016-08-18 00:00:00', 0, 7, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 40, 0, 660, 'Six Hundred and Sixty', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(270, 'MCD-00270', '', '2016-08-18 16:42:10', 'Chittagong Airport (CGP)', 'mr rivu barua', '', '01777707528', '', '', 'ebt', '00i9sy', 100, 'bs 106', '2016-08-18 00:00:00', 0, 25, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(271, 'MCD-00271', '', '2016-08-18 17:04:40', 'Jessore Airport (JSR)', 'mtr/ts/270/16/hq', '', '01724169869', '', '', 'cargo', '', 100, 'BS124', '2016-08-18 00:00:00', 0, 4, '245126', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(272, 'MCD-00272', '', '2016-08-18 17:43:36', 'Jessore Airport (JSR)', 'RRF FOUNDATION JESSORE', '', '01720526259', '', '', 'cargo', '', 100, 'BS-124', '2016-08-18 00:00:00', 0, 3, '258614', '01798674698', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'SAWKAT AKABR', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(273, 'MCD-00273', '', '2016-08-18 17:43:58', 'Dhaka Airport (DAC)', 'MR SHAKIL', '', '01783265095', '', '', 'cargo', '', 80, 'BS107', '2016-08-18 00:00:00', 0, 166, '104138,103545,103790,103787,103525,106442,104036,103523,103514,103944,104136,104135,103611,103941,103789,104139,103548', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 13280, 0, 0, 13280, 'Thirteen Thousand Two Hundred and Eighty', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(274, 'MCD-00274', '', '2016-08-18 18:06:47', 'Jessore Airport (JSR)', 'mr monoj', '', '01920999888', '', '', 'mail_courier', '', 0, 'BS124', '2016-08-18 00:00:00', 1, 0.01, '275882', '01755501327', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(275, 'MCD-00275', '', '2016-08-18 18:07:30', 'Dhaka Airport (DAC)', 'FARID', '', '01911583161', '', '', 'mail_courier', '', 0, 'BS107', '2016-08-18 00:00:00', 1, 1, '103524', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(276, 'MCD-00276', '', '2016-08-18 18:11:51', 'Saidpur Airport (SPD)', 'SORIFUL ISLAM', '', '01918705787', '', '', 'bus_tkt', '', 0, '', '2016-08-18 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'TKT NO: 36837-36859(200x23=4600)\r\n36786-36800,\r\n36901-36904(250x20=5000)', 'RANGPUR - SAIDPUR, D', 'SAIDPUR - RANGPUR, S', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9600, 0, 0, 9600, 'Nine Thousand Six Hundred ', 'TKT NO: 36837-36859(200x23=4600)\r\n36786-36800,\r\n36901-36904(250x20=5000)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(277, 'MCD-00277', '', '2016-08-18 18:30:59', 'Chittagong Airport (CGP)', 'mr alam', '', '01689501624', '', '', 'cargo', '', 100, 'BS108', '2016-08-18 00:00:00', 0, 3, '21834', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(278, 'MCD-00278', '', '2016-08-18 19:17:16', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-18 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35360-81/ 22PCS', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5500, 0, 0, 5500, 'Five Thousand Five Hundred ', '35360-81/ 22PCS', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(279, 'MCD-00279', '', '2016-08-18 19:27:01', 'Dhaka Airport (DAC)', 'md forkan', '', '01623283664', '', '', 'cargo', '', 100, 'bs109', '2016-08-18 00:00:00', 0, 3, '105152', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(280, 'MCD-00280', '72733', '2016-08-18 19:46:07', 'Chittagong Airport (CGP)', 'mr. al mamun hasan', '', '01553321790', '', '', 'ebt', '00ibnf', 100, 'bs108', '2016-08-18 00:00:00', 0, 20, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(281, 'MCD-00281', '72734', '2016-08-18 19:47:51', 'Chittagong Airport (CGP)', 'mr. ahamed zeyadul', '', '01816674732', '', '', 'ebt', '00i397', 100, 'bs108', '2016-08-18 00:00:00', 0, 15, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(282, 'MCD-00282', '72735', '2016-08-18 20:37:54', 'Chittagong Airport (CGP)', 'mr. anup banerjee', '', '01777707528', '', '', 'ebt', '00hwep', 100, 'bs 110', '2016-08-18 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-18 00:00:00'),
(283, 'MCD-00283', '72736', '2016-08-19 11:27:36', 'Chittagong Airport (CGP)', 'mr ali', '', '01724385155', '', '', 'ebt', '00ibw5', 100, 'bs104', '2016-08-19 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(284, 'MCD-00284', '', '2016-08-19 14:19:16', 'Dhaka Airport (DAC)', 'TAPOSH KUMAR', '', '01728787251', '', '', 'cargo', '', 100, 'BS 105', '2016-08-19 00:00:00', 0, 3, '106204', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(285, 'MCD-00285', '72737', '2016-08-19 15:29:52', 'Chittagong Airport (CGP)', 'MR. SHAHADAT', '', '01970077514', '', '', 'cargo', '', 100, 'BS 106', '2016-08-19 00:00:00', 0, 3, '261639', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SHOVON CHOWDHURY', 47, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(286, 'MCD-00286', '', '2016-08-19 15:36:55', 'Dhaka Airport (DAC)', 'MOHAMMAD MONIR', '', '01710026478', '', '', 'cargo', '', 100, 'BS 123', '2016-08-19 00:00:00', 0, 3, '100196', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(287, 'MCD-00287', '', '2016-08-19 18:15:07', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-19 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'TKT NO: 36860-36881(200x22=4400)\r\n36905-36919(250x15=3750)', 'RANGPUR - SAIDPUR, D', 'SAIDPUR - RANGPUR, S', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8150, 0, 0, 8150, 'Eight Thousand One Hundred and Fifty', 'TKT NO: 36860-36881(200x22=4400)\r\n36905-36919(250x15=3750)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(288, 'MCD-00288', '73573', '2016-08-19 18:33:27', 'Dhaka Airport (DAC)', 'MR KUTUB', '', '01678619397', '', '', 'cargo', '', 100, 'BS 107', '2016-08-19 00:00:00', 0, 3, '106211', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ALVINA KHAN', 62, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(289, 'MCD-00289', '', '2016-08-19 19:29:17', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-19 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35382-35419\r\n38pcs', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9500, 0, 0, 9500, 'Nine Thousand Five Hundred ', '35382-35419\r\n38pcs', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-19 00:00:00'),
(290, 'MCD-00290', '', '2016-08-20 07:20:25', 'Jessore Airport (JSR)', 'FAKRUL ALAM', '', '01913079053', '', '', 'cargo', '', 100, 'BS122', '2016-08-20 00:00:00', 0, 3, '268573', '01716577505', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'MONIRUZZAMAN', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(291, 'MCD-00291', '72738', '2016-08-20 08:46:12', 'Chittagong Airport (CGP)', 'MR ALAM', '', '01911115835', '', '', 'ebt', '00ID39', 100, 'BS102', '2016-08-20 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(292, 'MCD-00292', '', '2016-08-20 08:50:05', 'Dhaka Airport (DAC)', 'MUCHOW CHARLITTE', '', '01762311780', '', '', 'ebt', '00IDAD', 100, 'BS-151', '2016-08-20 00:00:00', 0, 30, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000, 0, 0, 3000, 'Three Thousand ', '', 'NAHIDA SULTANA', 61, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(293, 'MCD-00293', '', '2016-08-20 11:02:46', 'Dhaka Airport (DAC)', 'MD MAFIJUL ISLAM', '', '01740988260', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-20 00:00:00', 1, 1, '104650', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(294, 'MCD-00294', '', '2016-08-20 11:54:09', 'Sylhet Airport (ZYL)', 'mr rahman syed mizanur', '', '01717389425', '', '', 'ebt', '00HGT4', 100, 'bs132', '2016-08-20 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Md ragib rahman', 33, '119.30.38.32', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(295, 'MCD-00295', '', '2016-08-20 12:09:19', 'Cox''s Bazar Airport (CXB)', 'MR SHAHAJAN', '', '01716895692', '', '', 'cargo', '', 100, 'bs-142', '2016-08-20 00:00:00', 0, 68, '165674,165770,165774', '', '', '', '5*100  =    500TK\r\n63*80  =  5040 TK', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6800, 1260, 0, 5540, 'Five Thousand Five Hundred and Forty', '5*100  =    500TK\r\n63*80  =  5040 TK', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', 'MR ARIF SARKAR\r\n01718436861', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(296, 'MCD-00296', '', '2016-08-20 13:15:09', 'Cox''s Bazar Airport (CXB)', 'Mr Hasmot', '', '01726286399', '', '', 'cargo', '', 100, 'bs-142', '2016-08-20 00:00:00', 0, 7, '169446', '', '', '', '5\r\n\r\n\r\n\r\n\r\n5*100=500tk\r\n2*80=160tk', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 40, 0, 660, 'Six Hundred and Sixty', '5\r\n\r\n\r\n\r\n\r\n5*100=500tk\r\n2*80=160tk', 'KAWSAR AHMED', 20, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(297, 'MCD-00297', '', '2016-08-20 13:19:22', 'Cox''s Bazar Airport (CXB)', 'Mr Hasmot', '', '01726286399', '', '', 'cargo', '', 100, 'bs-142', '2016-08-20 00:00:00', 0, 7, '169446', '', '', '', 'MCD 296 & 297 are same so voided as per mail.\r\n\r\n\r\n\r\n\r\n5*100=500tk\r\n2*80=160tk', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 40, 0, 660, 'Six Hundred and Sixty', 'MCD 296 & 297 are same so voided as per mail.\r\n\r\n\r\n\r\n\r\n5*100=500tk\r\n2*80=160tk', 'KAWSAR AHMED', 20, '27.147.255.50', '-Select Card Type-', '', '', 7, '2016-08-20 15:16:48', '115.127.65.130', 0, '2016-08-20 15:16:48'),
(298, 'MCD-00298', '', '2016-08-20 13:51:30', 'Dhaka Airport (DAC)', 'BABLU', '', '01726859413', '', '', 'cargo', '', 80, 'BS 105', '2016-08-20 00:00:00', 0, 10, '104855', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(299, 'MCD-00299', '', '2016-08-20 16:11:00', 'Saidpur Airport (SPD)', 'K.M. MASFIKUR RAHMAN', '', '01711144142', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-20 00:00:00', 1, 0.4, '255983', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(300, 'MCD-00300', '', '2016-08-20 16:56:55', 'Dhaka Airport (DAC)', 'sm moniruzzaman shahien', '', '01716577505', '', '', 'cargo', '', 300, '123', '2016-08-20 00:00:00', 0, 1, '103849', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(301, 'MCD-00301', '', '2016-08-20 17:52:55', 'Dhaka Airport (DAC)', 'MR ANIL', '', '01728420356', '', '', 'cargo', '', 300, '107', '2016-08-20 00:00:00', 0, 1, '105270', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(302, 'MCD-00302', '', '2016-08-20 18:09:01', 'Dhaka Airport (DAC)', 'AMDAD HOSSAIN', '', '0162476867', '', '', 'mail_courier', '', 0, '107', '2016-08-20 00:00:00', 1, 1, '103518', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(303, 'MCD-00303', '', '2016-08-20 18:10:40', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', 'raquib.ru@gmail.com', '', 'bus_tkt', '', 0, '', '2016-08-20 00:00:00', 0, 0, '', '', 'BS-151,152 & BS-153,154', '', 'TKT NO: 36882-36899 (200x18=3600),\r\n36920-36942 (250x23=5750)', 'RANGPUR-SAIDPUR,DINJ', 'SAIDPUR-RANGPUR,SAID', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 9350, 0, 0, 9350, 'Nine Thousand Three Hundred and Fifty', 'TKT NO: 36882-36899 (200x18=3600),\r\n36920-36942 (250x23=5750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(304, 'MCD-00304', '', '2016-08-20 18:15:53', 'Dhaka Airport (DAC)', 'MR MONIR', '', '01819858084', '', '', 'mail_courier', '', 0, '107', '2016-08-20 00:00:00', 1, 1, '', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(305, 'MCD-00305', '', '2016-08-20 19:01:48', 'Chittagong Airport (CGP)', 'ms fairuz samira', '', '01817705087', '', '', 'ebt', '00ij5l', 100, 'bs 108', '2016-08-20 00:00:00', 0, 25, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(306, 'MCD-00306', '', '2016-08-20 19:03:32', 'Chittagong Airport (CGP)', 'mr nazmul', '', '01820272723', '', '', 'cargo', '', 100, 'bs 108', '2016-08-20 00:00:00', 0, 5, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(307, 'MCD-00307', '', '2016-08-20 19:08:24', 'Chittagong Airport (CGP)', 'mr ponuel', '', '01818559044', '', '', 'cargo', '', 100, 'bs 108', '2016-08-20 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(308, 'MCD-00308', '', '2016-08-20 19:27:46', 'Jessore Airport (JSR)', 'abdul gaffar', '', '01716007205', '', '', 'cargo', '', 100, 'BS-124', '2016-08-20 00:00:00', 0, 60, '230923, 241631, 254751', '01749300844', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6000, 0, 0, 6000, 'Six Thousand ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'MR SHAHIN', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(309, 'MCD-00309', '', '2016-08-20 19:30:14', 'Jessore Airport (JSR)', 'MR HIRU', '', '01711276677', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-20 00:00:00', 1, 0.5, '277190', '01717284246', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(310, 'MCD-00310', '', '2016-08-20 19:33:54', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-20 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '', 'jessore', 'khulna', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10750, 0, 0, 10750, 'Ten Thousand Seven Hundred and Fifty', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-20 00:00:00'),
(311, 'MCD-00311', '', '2016-08-21 08:55:15', 'Jessore Airport (JSR)', 'DIG JSR', '', '01718500682', '', '', 'cargo', '', 100, 'BS122', '2016-08-21 00:00:00', 0, 25, '230943', '01711703978', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', 'SAKIL AHMED', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(312, 'MCD-00312', '', '2016-08-21 12:29:58', 'Sylhet Airport (ZYL)', 'DR LALPATH', '', '01711078279', '', '', 'cargo', '', 100, 'BS132', '2016-08-21 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(313, 'MCD-00313', '', '2016-08-21 12:45:34', 'Cox''s Bazar Airport (CXB)', 'mr nurul azim', '', '01610252525', '', '', 'cargo', '', 100, 'bs-142', '2016-08-21 00:00:00', 0, 3, '165761', '', '', '', '3*100  =  300 tk', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '3*100  =  300 tk', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(314, 'MCD-00314', '', '2016-08-21 12:53:27', 'Sylhet Airport (ZYL)', 'BRITISH COUNCIL,SYLHET', '', '01730098665', '', '', 'cargo', '', 80, 'BS132', '2016-08-21 00:00:00', 0, 17, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1360, 0, 0, 1360, 'One Thousand Three Hundred and Sixty', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(315, 'MCD-00315', '', '2016-08-21 13:05:18', 'Dhaka Airport (DAC)', 'MD HASMOT ALI', '', '01929577791', '', '', 'cargo', '', 100, 'BS105', '2016-08-21 00:00:00', 0, 3, '103784', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASIF SIDDIQUE', 65, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(316, 'MCD-00316', '', '2016-08-21 15:42:15', 'Chittagong Airport (CGP)', 'mr shamsul huda', '', '01713442206', '', '', 'mail_courier', '', 0, 'bs 106', '2016-08-21 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(317, 'MCD-00317', '', '2016-08-21 16:53:43', 'Jessore Airport (JSR)', 'MTR/TS/271/16/HQ', '', '01735069150', '', '', 'cargo', '', 100, 'BS-124', '2016-08-21 00:00:00', 0, 8, '256179', 'ADJT 999 3404', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'ADJT\r\nDAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(318, 'MCD-00318', '', '2016-08-21 17:38:18', 'Jessore Airport (JSR)', 'RRF FOUNDATION JESSORE', '', '01711182334', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-21 00:00:00', 1, 1, '256556', '01798674698 RRF  DAC', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(319, 'MCD-00319', '', '2016-08-21 18:33:34', 'Chittagong Airport (CGP)', 'mr ersadul haque', '', '01911607944', '', '', 'mail_courier', '', 0, 'bs 108', '2016-08-21 00:00:00', 1, 1, '', '', '', '', 'Edited..ref:monir.aps, Mail date:21-8-16, To: atiq,mahfuz..', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 100, 0, 200, 'Two Hundred ', 'Edited..ref:monir.aps, Mail date:21-8-16, To: atiq,mahfuz..', 'MITHUN GHOSH', 49, '27.147.250.42', '-Select Card Type-', '', '', 8, '2016-08-23 16:54:45', '115.127.65.130', 1, '2016-08-23 16:54:45'),
(320, 'MCD-00320', '', '2016-08-21 18:40:21', 'Chittagong Airport (CGP)', 'mr hasan', '', '017271971047', '', '', 'cargo', '', 100, 'bs 108', '2016-08-21 00:00:00', 0, 4, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(321, 'MCD-00321', '', '2016-08-21 18:59:59', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 0, '', '2016-08-21 00:00:00', 0, 0, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'TKT NO: 36900,37001-37021(200x22=4400),\r\n36943-36957(250x15=3750)', 'RANGPUR - SAIDPUR, D', 'SAIDPUR - RANGPUR, S', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8150, 0, 0, 8150, 'Eight Thousand One Hundred and Fifty', 'TKT NO: 36900,37001-37021(200x22=4400),\r\n36943-36957(250x15=3750)', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(322, 'MCD-00322', '', '2016-08-21 19:17:01', 'Chittagong Airport (CGP)', 'mr amal', '', '01716965444', '', '', 'cargo', '', 100, 'bs 108', '2016-08-21 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(323, 'MCD-00323', '', '2016-08-21 19:18:07', 'Chittagong Airport (CGP)', 'mr sohag', '', '01739637334', '', '', 'cargo', '', 100, 'bs 108', '2016-08-21 00:00:00', 0, 3, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(324, 'MCD-00324', '', '2016-08-21 20:31:18', 'Chittagong Airport (CGP)', 'mr saiful', '', '01980001265', '', '', 'mail_courier', '', 0, 'bs 110', '2016-08-21 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(325, 'MCD-00325', '', '2016-08-21 20:33:56', 'Chittagong Airport (CGP)', 'mr ersadul haque', '', '01911607944', '', '', 'mail_courier', '', 0, 'bs 108', '2016-08-21 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00');
INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(326, 'MCD-00326', '', '2016-08-21 21:20:29', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 0, '', '2016-08-21 00:00:00', 0, 0, '', '', 'BS-121 ,BS-123', '', '35463-92\r\n30 PCS', 'JSR', 'KHL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7500, 0, 0, 7500, 'Seven Thousand Five Hundred ', '35463-92\r\n30 PCS', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-21 00:00:00'),
(327, 'MCD-00327', '', '2016-08-22 06:44:10', 'Dhaka Airport (DAC)', 'MD MASUD', '', '01853281642', '', '', 'cargo', '', 100, 'BS101', '2016-08-22 00:00:00', 0, 3, '107331', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASIF SIDDIQUE', 65, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(328, 'MCD-00328', '', '2016-08-22 07:03:04', 'Dhaka Airport (DAC)', 'MD SUMON', '', '01924904855', '', '', 'cargo', '', 100, 'BS101', '2016-08-22 00:00:00', 0, 4, '103339', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'ASIF SIDDIQUE', 65, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(329, 'MCD-00329', '', '2016-08-22 07:15:13', 'Dhaka Airport (DAC)', 'MR MAHFUZ', '', '01775374786', '', '', 'cargo', '', 80, '101', '2016-08-22 00:00:00', 0, 33, '102950,103395,104883', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2640, 0, 0, 2640, 'Two Thousand Six Hundred and Forty', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(330, 'MCD-00330', '', '2016-08-22 07:21:24', 'Dhaka Airport (DAC)', 'MR MAHFUZUR RAHMAN', '', '01775374786', '', '', 'cargo', '', 80, '101', '2016-08-22 00:00:00', 0, 33, '102950,103395,104883', '', '', '', '', 'DAC', 'CGP', 'card', '5308-XXXX-XXXX-4573', 'DUTCH BANGLA BANK LTD', '', '', '', '', 'Taka', 2640, 0, 0, 2640, 'Two Thousand Six Hundred and Forty', '', 'SALEH SERAJ', 67, '115.127.68.26', 'Master Card', '', '744040', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(331, 'MCD-00331', '', '2016-08-22 08:38:43', 'Dhaka Airport (DAC)', 'MR RASEL', '', '01913890531', '', '', 'cargo', '', 100, 'BS 151', '2016-08-22 00:00:00', 0, 3, '05916', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(332, 'MCD-00332', '', '2016-08-22 09:39:16', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', '', 'cargo', '', 100, 'BS-152', '2016-08-22 00:00:00', 0, 3, '131873', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(333, 'MCD-00333', '', '2016-08-22 10:40:54', 'Chittagong Airport (CGP)', 'mr rony', '', '01811929829', '', '', 'mail_courier', '', 0, 'bs 104', '2016-08-22 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(334, 'MCD-00334', '', '2016-08-22 11:28:21', 'Sylhet Airport (ZYL)', 'mr haydar shahan abu', '', '01716428193', '', '', 'ebt', '00hi6u', 100, 'BS132', '2016-08-22 00:00:00', 0, 10, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(335, 'MCD-00335', '', '2016-08-22 11:49:06', 'Sylhet Airport (ZYL)', 'mr shyama proshad hoom', '', '01717420718', '', '', 'ebt', '00i9op', 100, 'BS132', '2016-08-22 00:00:00', 0, 20, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(336, 'MCD-00336', '', '2016-08-22 12:06:44', 'Sylhet Airport (ZYL)', 'mr deb ashimkanti', '', '01711700525', '', '', 'ebt', '00hlz0', 100, 'BS132', '2016-08-22 00:00:00', 0, 20, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(337, 'MCD-00337', '', '2016-08-22 12:17:10', 'Sylhet Airport (ZYL)', 'mr hira miah', '', '01777963737', '', '', 'ebt', '00hqwy', 100, 'BS132', '2016-08-22 00:00:00', 0, 45, '', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4500, 0, 0, 4500, 'Four Thousand Five Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(338, 'MCD-00338', '', '2016-08-22 13:11:09', 'Dhaka Airport (DAC)', 'Data magfur', '', '01711563452', '', '', 'cargo', '', 100, 'bs105', '2016-08-22 00:00:00', 0, 3, '107454', '', '', '', '', 'sl5', 'sl6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASIF SIDDIQUE', 65, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(339, 'MCD-00339', '', '2016-08-22 14:07:13', 'Dhaka Airport (DAC)', 'REZAUL KARIM', '', '01713442273', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-22 00:00:00', 1, 1, '108427', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(340, 'MCD-00340', '', '2016-08-22 14:16:20', 'Dhaka Airport (DAC)', 'FAZLE SHOHAN', '', '01713081846', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-22 00:00:00', 1, 1, '104583', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(341, 'MCD-00341', '', '2016-08-22 14:22:31', 'Dhaka Airport (DAC)', 'BABLU', '', '01726859413', '', '', 'cargo', '', 80, 'BS-105', '2016-08-22 00:00:00', 0, 25, '104578,106108,107456', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(342, 'MCD-00342', '', '2016-08-22 14:25:33', 'Rajshahi Airport (RJH)', 'Mr Bazlur Rahim', '', '01707805626', '', '', 'ebt', '00IJMN', 100, 'BS- 162', '2016-08-22 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'ALI REDWONE DHIP', 32, '116.58.204.159', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(343, 'MCD-00343', '', '2016-08-22 14:30:03', 'Dhaka Airport (DAC)', 'MR. MOHON', '', '01733436316', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-22 00:00:00', 1, 1, '104589', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(344, 'MCD-00344', '', '2016-08-22 14:46:24', 'Jessore Airport (JSR)', 'MR BADAL / G E BIMAN', '', '01716166385', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-22 00:00:00', 1, 0.6, '293515', '01718474586', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'MR HAFIZUR RAHMAN', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(345, 'MCD-00345', '', '2016-08-22 15:31:00', 'Dhaka Airport (DAC)', 'MR. SHAKIL AHMED', '', '01783265095', '', '', 'cargo', '', 80, 'BS107', '2016-08-22 00:00:00', 0, 153, '106105,106117,103024,103025,103020,103289,103027,102844,104688', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 12240, 0, 0, 12240, 'Twelve Thousand Two Hundred and Forty', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(346, 'MCD-00346', '', '2016-08-22 16:40:11', 'Jessore Airport (JSR)', 'MR HIRU', '', '01711276677', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-22 00:00:00', 1, 0.8, '256957', '01717284246', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'MR HAFIZUR RAHMAN', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(347, 'MCD-00347', '72749', '2016-08-22 16:42:29', 'Chittagong Airport (CGP)', 'MR SHEFIT', '', '01836680289', '', '', 'cargo', '', 100, 'BS 106', '2016-08-22 00:00:00', 0, 6, '211773', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 20, 0, 580, 'Five Hundred and Eighty', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(348, 'MCD-00348', '72750', '2016-08-22 16:43:44', 'Chittagong Airport (CGP)', 'MR SUJON', '', '01866977703', '', '', 'cargo', '', 100, 'BS106', '2016-08-22 00:00:00', 0, 3, '225411', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(349, 'MCD-00349', '72751', '2016-08-22 16:45:22', 'Chittagong Airport (CGP)', 'MR SANJAY', '', '01814314688', '', '', 'cargo', '', 100, 'BS106', '2016-08-22 00:00:00', 0, 3, '226519', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(350, 'MCD-00350', '', '2016-08-22 16:56:29', 'Jessore Airport (JSR)', 'aoc /baf base mtr', '', '01754297054', '', '', 'cargo', '', 100, 'BS-124', '2016-08-22 00:00:00', 0, 7, '255123', '029905470', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'OC /201 MU/BAF', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(351, 'MCD-00351', '', '2016-08-22 16:59:28', 'Jessore Airport (JSR)', 'MTR/TS/272/16/HQ', '', '01912872635', '', '', 'cargo', '', 100, 'BS-124', '2016-08-22 00:00:00', 0, 9, '267137', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 900, 0, 0, 900, 'Nine Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(352, 'MCD-00352', '', '2016-08-22 17:06:21', 'Jessore Airport (JSR)', 'BISMILLAH FISH FIRM', '', '01711988350', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-22 00:00:00', 1, 0.2, '140939', '01779605909', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(353, 'MCD-00353', '', '2016-08-22 17:36:40', 'Dhaka Airport (DAC)', 'MOHAMMAD JAMAL HAIDER', '', '01741181962', '', '', 'cargo', '', 80, 'BS107', '2016-08-22 00:00:00', 0, 10, '103010', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(354, 'MCD-00354', '', '2016-08-22 18:01:19', 'Dhaka Airport (DAC)', 'MR. RUBEL', '', '01866977719', '', '', 'cargo', '', 300, 'BS107', '2016-08-22 00:00:00', 0, 1, '104559', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(355, 'MCD-00355', '', '2016-08-22 18:07:08', 'Dhaka Airport (DAC)', 'SUSHMOY GHOSH', '', '01916103518', '', '', 'mail_courier', '', 0, 'BS107', '2016-08-22 00:00:00', 1, 1, '', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(356, 'MCD-00356', '', '2016-08-22 18:19:02', 'Dhaka Airport (DAC)', 'SABBIR', '', '01716609595', '', '', 'mail_courier', '', 0, 'BS109', '2016-08-22 00:00:00', 1, 1, '104558', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(357, 'MCD-00357', '', '2016-08-22 18:31:23', 'Saidpur Airport (SPD)', 'tofajjol', '', '01777777844', '', '', 'bus_tkt', '', 200, '', '2016-08-22 00:00:00', 0, 24, '', '', 'bs-151,152,153,154', '', 'Ranpur TKT NO: 37022-37045', 'SL7', 'SL8', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4800, 0, 0, 4800, 'Four Thousand Eight Hundred ', 'Ranpur TKT NO: 37022-37045', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(358, 'MCD-00358', '', '2016-08-22 18:34:23', 'Saidpur Airport (SPD)', 'tofazzol', '', '01777777844', '', '', 'bus_tkt', '', 250, '', '2016-08-22 00:00:00', 0, 9, '', '', 'bs-151,152,153,154', '', 'Dinajpur TKT NO: 36958-36966', 'SL7', 'SL8', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2250, 0, 0, 2250, 'Two Thousand Two Hundred and Fifty', 'Dinajpur TKT NO: 36958-36966', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(359, 'MCD-00359', '72752', '2016-08-22 19:55:32', 'Chittagong Airport (CGP)', 'MR KAJOL', '', '01755596626', '', '', 'mail_courier', '', 0, 'BS108', '2016-08-22 00:00:00', 1, 1, '207479', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(360, 'MCD-00360', '72753', '2016-08-22 19:56:40', 'Chittagong Airport (CGP)', 'MR MINHAZ', '', '01855306769', '', '', 'cargo', '', 100, 'BS108', '2016-08-22 00:00:00', 0, 3, '219249', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(361, 'MCD-00361', '72754', '2016-08-22 19:57:45', 'Chittagong Airport (CGP)', 'MR KAFIL UDDIN', '', '01819514888', '', '', 'cargo', '', 100, 'BS108', '2016-08-22 00:00:00', 0, 3, '206629', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(362, 'MCD-00362', '72755', '2016-08-22 19:58:48', 'Chittagong Airport (CGP)', 'MR NAZMUL', '', '01820272723', '', '', 'cargo', '', 100, 'BS108', '2016-08-22 00:00:00', 0, 3, '207508', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(363, 'MCD-00363', '72756', '2016-08-22 20:00:05', 'Chittagong Airport (CGP)', 'MR MANIK', '', '01675276002', '', '', 'cargo', '', 100, 'BS108', '2016-08-22 00:00:00', 0, 6, '209702', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 20, 0, 580, 'Five Hundred and Eighty', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-22 00:00:00'),
(364, 'MCD-00364', '', '2016-08-23 08:20:46', 'Dhaka Airport (DAC)', 'md.rasel', '', '01913890531', '', '', 'cargo', '', 100, 'bs-151', '2016-08-23 00:00:00', 0, 3, '12294', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD. KHALED BIN KHALIL', 59, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(365, 'MCD-00365', '', '2016-08-23 09:41:11', 'Dhaka Airport (DAC)', 'md habibur rahman', '', '01920101619', '', '', 'mail_courier', '', 0, 'bs 103', '2016-08-23 00:00:00', 1, 1, '06102', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(366, 'MCD-00366', '', '2016-08-23 09:48:01', 'Dhaka Airport (DAC)', 'MD SOHEL', '', '01718950845', '', '', 'cargo', '', 80, 'BS 103', '2016-08-23 00:00:00', 0, 6, '09920', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 480, 0, 0, 480, 'Four Hundred and Eighty', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(367, 'MCD-00367', '', '2016-08-23 10:21:45', 'Chittagong Airport (CGP)', 'MR.MAHBUBUR ALI', '', '01736480394', '', '', 'ebt', '00IJKC', 100, 'bs 104', '2016-08-23 00:00:00', 0, 40, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', '', 'MONIR AHMED', 48, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(368, 'MCD-00368', '', '2016-08-23 10:27:47', 'Revenue', 'test bus ticket', '', '01777777123', '', '', 'bus_tkt', '', 250, '', '2016-08-23 10:53:58', 0, 20, '', '', 'bs-123', '', 'Test purpose entry done by Software Developper', 'AIRPORT(JSR)', 'NOAPARA(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', 'Test purpose entry done by Software Developper', 'Software Developper', 16, '123.200.23.98', '-Select Card Type-', '', '', 14, '2016-08-23 10:53:58', '123.200.23.98', 0, '2016-08-23 10:53:58'),
(369, 'MCD-00369', '', '2016-08-23 10:30:49', 'Chittagong Airport (CGP)', 'MR.SARKAR DAS', '', '01713616848', '', '', 'ebt', '00IHQA', 100, 'BS 104', '2016-08-23 00:00:00', 0, 300, '', '', '', '', 'Voided due to wrong entry amount will be 3000. Corrected MCD 375. As per mail', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 30000, 0, 0, 30000, 'Thirty Thousand ', 'Voided due to wrong entry amount will be 3000. Corrected MCD 375. As per mail', 'MONIR AHMED', 48, '115.127.49.10', '-Select Card Type-', '', '', 7, '2016-08-25 14:32:04', '59.153.101.22', 0, '2016-08-25 14:32:04'),
(370, 'MCD-00370', '', '2016-08-23 11:33:04', 'Sylhet Airport (ZYL)', 'jakir tanvir', '', '01716826248', '', '', 'ebt', '00hns9', 100, 'BS132', '2016-08-23 00:00:00', 0, 50, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(371, 'MCD-00371', '', '2016-08-23 11:50:34', 'Sylhet Airport (ZYL)', 'mr shyam jibonmoy', '', '01715777808', '', '', 'ebt', '00ignm', 100, 'BS132', '2016-08-23 00:00:00', 0, 15, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(372, 'MCD-00372', '', '2016-08-23 11:50:39', 'Dhaka Airport (DAC)', 'ZILANI', '', '01726427766', '', '', 'mail_courier', '', 0, 'BS 131', '2016-08-23 00:00:00', 1, 1, '05003', '', '', '', '', 'DAC', 'ZYL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(373, 'MCD-00373', '', '2016-08-23 12:04:38', 'Sylhet Airport (ZYL)', 'mr ahad abdul', '', '01762987895', '', '', 'ebt', '00i98d', 100, 'BS132', '2016-08-23 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(374, 'MCD-00374', '', '2016-08-23 12:11:44', 'Sylhet Airport (ZYL)', 'iom, sylhet', '', '01715202688', '', '', 'cargo', '', 100, 'BS132', '2016-08-23 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(375, 'MCD-00375', '', '2016-08-23 13:04:08', 'Chittagong Airport (CGP)', 'MR.SARKAR DAS', '', '01713616848', '', '', 'ebt', '00IHQA', 100, 'BS 104', '2016-08-23 00:00:00', 0, 30, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000, 0, 0, 3000, 'Three Thousand ', '', 'MONIR AHMED', 48, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(376, 'MCD-00376', '', '2016-08-23 13:10:54', 'Dhaka Airport (DAC)', 'HABIBUR RAHMAN', '', '01712718011', '', '', 'cargo', '', 100, 'bs 105', '2016-08-23 00:00:00', 0, 3, '106066', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(377, 'MCD-00377', '', '2016-08-23 13:20:25', 'Dhaka Airport (DAC)', 'MD FARHAD HOSSAIN', '', '01712633551', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-23 00:00:00', 1, 1, '107435', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(378, 'MCD-00378', '', '2016-08-23 13:49:11', 'Dhaka Airport (DAC)', 'MD RIPON HOSSAIN', '', '01858318642', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-23 00:00:00', 1, 1, '155388', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(379, 'MCD-00379', '', '2016-08-23 14:36:12', 'Dhaka Airport (DAC)', 'MR MAHMUDUR RAHMAN', '', '01711511473', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-23 00:00:00', 1, 1, '155385', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(380, 'MCD-00380', '', '2016-08-23 14:40:44', 'Dhaka Airport (DAC)', 'MR MASUD PERVEZ', '', '01971300720', '', '', 'mail_courier', '', 0, 'BS-105', '2016-08-23 00:00:00', 1, 1, '107458', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(381, 'MCD-00381', '', '2016-08-23 16:33:15', 'Saidpur Airport (SPD)', 'Arif', '', '01753417442', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-23 00:00:00', 1, 0.2, '146415', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(382, 'MCD-00382', '72759', '2016-08-23 16:41:25', 'Chittagong Airport (CGP)', 'md atiqur rahman', '', '01755506024', '', '', 'ebt', '00ii52', 100, 'BS 106', '2016-08-23 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(383, 'MCD-00383', '', '2016-08-23 16:44:00', 'Jessore Airport (JSR)', 'MTR/TS/273/16/HQ', '', '01929764568', '', '', 'cargo', '', 100, 'BS-124', '2016-08-23 00:00:00', 0, 7, '256284', '01929764568', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', 'ADJT/DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(384, 'MCD-00384', '', '2016-08-23 16:48:11', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 100, '', '2016-08-23 00:00:00', 0, 24, '', '', 'usb bzl,bs-172', '', '', 'SADAR-ROAD(BZL)', 'AIRPORT(BZL)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2400, 0, 0, 2400, 'Two Thousand Four Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(385, 'MCD-00385', '72760', '2016-08-23 16:54:26', 'Chittagong Airport (CGP)', 'mr choton', '', '01856311740', '', '', 'cargo', '', 100, 'BS 106', '2016-08-23 00:00:00', 0, 10, '232516/264646', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(386, 'MCD-00386', '', '2016-08-23 17:25:07', 'Saidpur Airport (SPD)', 'NIHAR', '', '01737268374', '', '', 'cargo', '', 100, 'BS-154', '2016-08-23 00:00:00', 0, 3, '137547', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(387, 'MCD-00387', '', '2016-08-23 17:40:13', 'Jessore Airport (JSR)', 'MR HIRU', '', '01711276677', '', '', 'cargo', '', 100, 'BS-124', '2016-08-23 00:00:00', 0, 3, '286226', '01965838736', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ABBAS ALI', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(388, 'MCD-00388', '', '2016-08-23 18:40:53', 'Saidpur Airport (SPD)', 'Tofazzol Hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-23 00:00:00', 0, 26, '', '', 'BS-151,152,153,154', '', 'Rangpir TKT No: 37046-37071', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5200, 0, 0, 5200, 'Five Thousand Two Hundred ', 'Rangpir TKT No: 37046-37071', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(389, 'MCD-00389', '', '2016-08-23 18:43:04', 'Saidpur Airport (SPD)', 'Tofazzal Hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-23 00:00:00', 0, 17, '', '', 'bs-151,152,153,154', '', 'Dinajpur TKT No: 36967-36982', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4250, 0, 0, 4250, 'Four Thousand Two Hundred and Fifty', 'Dinajpur TKT No: 36967-36982', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(390, 'MCD-00390', '72761', '2016-08-23 20:00:57', 'Chittagong Airport (CGP)', 'mrs afroza', '', '01717539665', '', '', 'ebt', '00imgi', 100, 'BS108', '2016-08-23 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(391, 'MCD-00391', '72762', '2016-08-23 20:02:02', 'Chittagong Airport (CGP)', 'mr shohag', '', '01739637334', '', '', 'cargo', '', 100, 'BS108', '2016-08-23 00:00:00', 0, 3, '216760', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(392, 'MCD-00392', '72763', '2016-08-23 20:43:06', 'Chittagong Airport (CGP)', 'MR.SHAJAHAN', '', '01814497524', '', '', 'cargo', '', 100, '110', '2016-08-23 00:00:00', 0, 3, '212526', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(393, 'MCD-00393', '', '2016-08-23 21:33:02', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-23 00:00:00', 0, 28, '', '', 'BS-121 ,BS-123', '', '35493-35520 / 28 pax\r\nDate: 22 aug''16', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7000, 0, 0, 7000, 'Seven Thousand ', '35493-35520 / 28 pax\r\nDate: 22 aug''16', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(394, 'MCD-00394', '', '2016-08-23 21:35:46', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-23 00:00:00', 0, 57, '', '', 'BS-121 ,BS-123', '', 'Today''s Bus Ticket Amount', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 14250, 0, 0, 14250, 'Fourteen Thousand Two Hundred and Fifty', 'Today''s Bus Ticket Amount', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-23 00:00:00'),
(395, 'MCD-00395', '', '2016-08-24 06:29:57', 'Dhaka Airport (DAC)', 'MONIR', '', '01741317837', '', '', 'cargo', '', 300, 'BS 121', '2016-08-24 00:00:00', 0, 1, '100293', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(396, 'MCD-00396', '', '2016-08-24 06:56:30', 'Dhaka Airport (DAC)', 'SUMON', '', '01924904855', '', '', 'cargo', '', 300, 'BS 101', '2016-08-24 00:00:00', 0, 1, '142276', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(397, 'MCD-00397', '', '2016-08-24 07:26:34', 'Jessore Airport (JSR)', 'm/s khan auto jsr', '', '01711047501', '', '', 'mail_courier', '', 0, 'bs122', '2016-08-24 00:00:00', 1, 1, '256012', '01755540025', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(398, 'MCD-00398', '', '2016-08-24 08:41:07', 'Dhaka Airport (DAC)', 'RASEL', '', '01913890531', '', '', 'cargo', '', 100, 'BS 151', '2016-08-24 00:00:00', 0, 3, '09558', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(399, 'MCD-00399', '', '2016-08-24 09:44:47', 'Dhaka Airport (DAC)', 'MD ELIAS', '', '01814718864', '', '', 'cargo', '', 80, 'BS 103', '2016-08-24 00:00:00', 0, 10, '142216', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(400, 'MCD-00400', '', '2016-08-24 10:16:22', 'Dhaka Airport (DAC)', 'MR MD JASHIM UDDIN', '', '01990864961', '', '', 'mail_courier', '', 0, 'BS 131', '2016-08-24 00:00:00', 1, 0, '08498', '', '', '', '', 'DAC', 'ZYL', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'NAHIDA SULTANA', 61, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(401, 'MCD-00401', '', '2016-08-24 10:51:59', 'Chittagong Airport (CGP)', 'mrs farzana', '', '01713100002', '', '', 'ebt', '00ih8f', 100, 'bs 104', '2016-08-24 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(402, 'MCD-00402', '', '2016-08-24 10:53:29', 'Chittagong Airport (CGP)', 'mr sujon', '', '01866977703', '', '', 'cargo', '', 100, 'bs 104', '2016-08-24 00:00:00', 0, 5, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(403, 'MCD-00403', '', '2016-08-24 11:03:34', 'Dhaka Airport (DAC)', 'MR. SUJAN', '', '01940386521', '', '', 'cargo', '', 300, 'BS141', '2016-08-24 00:00:00', 0, 1, '109225', '', '', '', '', 'DAC', 'CXB', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(404, 'MCD-00404', '', '2016-08-24 11:15:01', 'Dhaka Airport (DAC)', 'MR. ATAUR RAHMAN', '', '01913750343', '', '', 'cargo', '', 100, 'BS141', '2016-08-24 00:00:00', 0, 3, '109246', '', '', '', '', 'DAC', 'CXB', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(405, 'MCD-00405', '', '2016-08-24 13:25:22', 'Cox''s Bazar Airport (CXB)', 'MD NURUL AZIZ', '', '01844016100', '', '', 'mail_courier', '', 0, 'bs-142', '2016-08-24 00:00:00', 1, 1, '169424', '', '', '', '', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'KAWSAR AHMED', 20, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(406, 'MCD-00406', '', '2016-08-24 14:18:31', 'Dhaka Airport (DAC)', 'ASIF CHOWDHURY', '', '01718920332', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-24 00:00:00', 1, 1, '154319', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(407, 'MCD-00407', '', '2016-08-24 14:21:11', 'Dhaka Airport (DAC)', 'mr sk sinha', '', '01965554433', '', '', 'mail_courier', '', 0, 'bs 105', '2016-08-24 00:00:00', 1, 1, '154317', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(408, 'MCD-00408', '', '2016-08-24 14:28:54', 'Dhaka Airport (DAC)', 'mr sk sinha', '', '01965554433', '', '', 'mail_courier', '', 0, 'bs 105', '2016-08-24 00:00:00', 1, 1, '154317', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(409, 'MCD-00409', '', '2016-08-24 14:30:13', 'Dhaka Airport (DAC)', 'mr parvez', '', '01712270146', '', '', 'mail_courier', '', 0, 'bs105', '2016-08-24 00:00:00', 1, 1, '154338', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(410, 'MCD-00410', '', '2016-08-24 14:32:05', 'Dhaka Airport (DAC)', 'BABLU', '', '01726859413', '', '', 'cargo', '', 80, 'BS105', '2016-08-24 00:00:00', 0, 10, '154386, 154389', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(411, 'MCD-00411', '', '2016-08-24 17:15:13', 'Jessore Airport (JSR)', 'MTR/TS/275/16/HQ', '', '01724169869', '', '', 'cargo', '', 100, 'BS-124', '2016-08-24 00:00:00', 0, 4, '248006', '029993402', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT / DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(412, 'MCD-00412', '', '2016-08-24 18:33:06', 'Saidpur Airport (SPD)', 'Tofazzol', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-24 00:00:00', 0, 23, '', '', 'bs-151,152,153,154', '', 'Rangpur TKT No: 37072-37094', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4600, 0, 0, 4600, 'Four Thousand Six Hundred ', 'Rangpur TKT No: 37072-37094', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(413, 'MCD-00413', '', '2016-08-24 18:36:12', 'Saidpur Airport (SPD)', 'Tofazzol', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-24 00:00:00', 0, 18, '', '', 'bs-151,152,153,154', '', 'Dinajpur TKT No: 36984-37000,29701', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4500, 0, 0, 4500, 'Four Thousand Five Hundred ', 'Dinajpur TKT No: 36984-37000,29701', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(414, 'MCD-00414', '72766', '2016-08-24 18:53:45', 'Chittagong Airport (CGP)', 'BISWAS SUKANNA', '', '01819395499', '', '', 'ebt', '00IZ3B', 100, 'BS 106', '2016-08-24 00:00:00', 0, 20, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(415, 'MCD-00415', '72767', '2016-08-24 18:56:12', 'Chittagong Airport (CGP)', 'MR RONY', '', '01866977707', '', '', 'cargo', '', 100, 'BS 106', '2016-08-24 00:00:00', 0, 3, '22253', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(416, 'MCD-00416', '72768', '2016-08-24 19:02:14', 'Chittagong Airport (CGP)', 'MR MANIK', '', '01675276002', '', '', 'cargo', '', 100, 'bs 108', '2016-08-24 00:00:00', 0, 6, '211968', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 600, 20, 0, 580, 'Five Hundred and Eighty', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(417, 'MCD-00417', '', '2016-08-24 19:19:51', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-24 00:00:00', 0, 27, '', '', 'BS-121 ,BS-123', '', '35578-35600, 27101-104 / 27 PAX', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6750, 0, 0, 6750, 'Six Thousand Seven Hundred and Fifty', '35578-35600, 27101-104 / 27 PAX', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(418, 'MCD-00418', '72769', '2016-08-24 20:35:51', 'Chittagong Airport (CGP)', 'mr.ismail', '', '01678641165', '', '', 'cargo', '', 100, 'bs-110', '2016-08-24 00:00:00', 0, 3, '218327', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.104.6', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-24 00:00:00'),
(419, 'MCD-00419', '', '2016-08-25 06:41:33', 'Dhaka Airport (DAC)', 'MR. SUMON', '', '01924904855', '', '', 'cargo', '', 300, 'BS101', '2016-08-25 00:00:00', 0, 1, '107373', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(420, 'MCD-00420', '', '2016-08-25 08:26:15', 'Dhaka Airport (DAC)', 'MR. RASEL', '', '01913890531', '', '', 'cargo', '', 300, 'BS151', '2016-08-25 00:00:00', 0, 1, '02603', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(421, 'MCD-00421', '', '2016-08-25 08:38:23', 'Dhaka Airport (DAC)', 'MR. ABUL HASNAT', '', '01915747500', '', '', 'cargo', '', 80, 'BS103', '2016-08-25 00:00:00', 0, 6, '106536', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 480, 0, 0, 480, 'Four Hundred and Eighty', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(422, 'MCD-00422', '72770', '2016-08-25 08:49:17', 'Chittagong Airport (CGP)', 'MR ALAM', '', '01854652772', '', '', 'cargo', '', 100, 'BS102', '2016-08-25 00:00:00', 0, 3, '219824', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(423, 'MCD-00423', '', '2016-08-25 09:25:36', 'Dhaka Airport (DAC)', 'National warehouse', '', '9845340', '', '', 'cargo', '', 80, 'bs103', '2016-08-25 00:00:00', 0, 10, '107137', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'ASIF SIDDIQUE', 65, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(424, 'MCD-00424', '', '2016-08-25 09:44:55', 'Saidpur Airport (SPD)', 'ABDUL HALIM', '', '01937368891', '', '', 'cargo', '', 100, 'BS-152', '2016-08-25 00:00:00', 0, 3, '146406', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(425, 'MCD-00425', '', '2016-08-25 10:04:12', 'Saidpur Airport (SPD)', 'Mr Nihar', '', '01737268374', '', '', 'cargo', '', 100, 'BS-152', '2016-08-25 00:00:00', 0, 3, '173571', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(426, 'MCD-00426', '', '2016-08-25 10:11:06', 'Saidpur Airport (SPD)', 'Mr.rana', '', '01738340502', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-25 00:00:00', 1, 0.2, '173572', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(427, 'MCD-00427', '', '2016-08-25 10:50:47', 'Dhaka Airport (DAC)', 'MR ABU BAKAR SIDDIQUE', '', '01741141626', '', '', 'cargo', '', 100, 'BS 141', '2016-08-25 00:00:00', 0, 3, '109209', '', '', '', '', 'DAC', 'CXB', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(428, 'MCD-00428', '', '2016-08-25 11:39:45', 'Sylhet Airport (ZYL)', 'SHABUL ISLAM', '', '01752733882', '', '', 'ebt', '00FPA3', 100, 'BS132', '2016-08-25 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(429, 'MCD-00429', '72771', '2016-08-25 12:03:32', 'Chittagong Airport (CGP)', 'mr mahfuzul hoque', '', '01914705459', '', '', 'ebt', '00igdx', 100, 'bs 104', '2016-08-25 00:00:00', 0, 20, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(430, 'MCD-00430', '72772', '2016-08-25 12:07:07', 'Chittagong Airport (CGP)', 'manu', '', '01843708910', '', '', 'cargo', '', 100, 'bs 104', '2016-08-25 00:00:00', 0, 12, '210079', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1200, 140, 0, 1060, 'One Thousand and Sixty', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(431, 'MCD-00431', '', '2016-08-25 12:29:14', 'Dhaka Airport (DAC)', 'MR. MD. MOHASIN', '', '01967261340', '', '', 'mail_courier', '', 0, 'BS105', '2016-08-25 00:00:00', 1, 1, '106792', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(432, 'MCD-00432', '', '2016-08-25 13:21:23', 'Cox''s Bazar Airport (CXB)', 'mr siddiqe', '', '01833089192', '', '', 'cargo', '', 100, 'bs-142', '2016-08-25 00:00:00', 0, 10, '', '', '', '', '100*5=500 &\r\n80 * 5=400', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '100*5=500 &\r\n80 * 5=400', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(433, 'MCD-00433', '', '2016-08-25 14:46:28', 'Dhaka Airport (DAC)', 'REZAUL KARIM', '', '01859543416', '', '', 'cargo', '', 80, 'BS105', '2016-08-25 00:00:00', 0, 13, '155627', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1040, 0, 0, 1040, 'One Thousand and Forty', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(434, 'MCD-00434', '', '2016-08-25 14:53:03', 'Dhaka Airport (DAC)', 'BAIZID HOSSAIN', '', '01866977715', '', '', 'cargo', '', 100, 'BS105', '2016-08-25 00:00:00', 0, 3, '155670', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(435, 'MCD-00435', '', '2016-08-25 14:57:33', 'Dhaka Airport (DAC)', 'BAHAR', '', '01785704591', '', '', 'mail_courier', '', 0, 'BS123', '2016-08-25 00:00:00', 1, 1, '02779', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(436, 'MCD-00436', '', '2016-08-25 16:31:47', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 100, '', '2016-08-25 00:00:00', 0, 26, '', '', 'usb bzl,bs-172', '', '', 'SADAR-ROAD(BZL)', 'AIRPORT(BZL)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2600, 0, 0, 2600, 'Two Thousand Six Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(437, 'MCD-00437', '', '2016-08-25 17:43:06', 'Jessore Airport (JSR)', 'mr julfikar ali', '', '01711336957', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-25 00:00:00', 1, 0.3, '144508', '0175557787', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'KAZAL KUMAR BARMON\r\nDAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(438, 'MCD-00438', '', '2016-08-25 17:57:05', 'Saidpur Airport (SPD)', 'Abdul Jalil', '', '01728215533', '', '', 'ebt', '00IPCI', 100, 'BS-154', '2016-08-25 00:00:00', 0, 5, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(439, 'MCD-00439', '', '2016-08-25 18:01:10', 'Jessore Airport (JSR)', 'KAMRUL HASAN', '', '01966623401', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-25 00:00:00', 1, 0.1, '277121', '01936684900', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(440, 'MCD-00440', '', '2016-08-25 18:07:21', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-25 00:00:00', 0, 26, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Rangpur TKT No: 37095-37100,29601-29620', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5200, 0, 0, 5200, 'Five Thousand Two Hundred ', 'Rangpur TKT No: 37095-37100,29601-29620', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00');
INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(441, 'MCD-00441', '', '2016-08-25 18:08:59', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-25 00:00:00', 0, 13, '', '', 'BS-151 & BS-152, bs-153 & bs-154', '', 'Dinajpur TKT No: 29702-29714', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3250, 0, 0, 3250, 'Three Thousand Two Hundred and Fifty', 'Dinajpur TKT No: 29702-29714', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(442, 'MCD-00442', '', '2016-08-25 18:14:43', 'Dhaka Airport (DAC)', 'SOHAG', '', '01712062659', '', '', 'cargo', '', 100, 'BS109', '2016-08-25 00:00:00', 0, 3, '155681', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(443, 'MCD-00443', '', '2016-08-25 18:16:38', 'Dhaka Airport (DAC)', 'SOHAG', '', '01712062659', '', '', 'cargo', '', 100, 'BS109', '2016-08-25 00:00:00', 0, 3, '155681', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(444, 'MCD-00444', '', '2016-08-25 18:49:42', 'Chittagong Airport (CGP)', 'MR.SANJEEV KUMAR', '', '01817707078', '', '', 'ebt', '00IJBQ', 100, 'BS 108', '2016-08-25 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(445, 'MCD-00445', '', '2016-08-25 19:16:37', 'Chittagong Airport (CGP)', 'MR.REJOWAN', '', '01709637679', '', '', 'cargo', '', 100, 'BS 108', '2016-08-25 00:00:00', 0, 11, '215724', '72774', '', '', '5KG#100=500\r\n06 KG#80=480', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1100, 120, 0, 980, 'Nine Hundred and Eighty', '5KG#100=500\r\n06 KG#80=480', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(446, 'MCD-00446', '', '2016-08-25 19:17:51', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-25 00:00:00', 0, 31, '', '', 'BS-121 ,BS-123', '', '27105-35 / 31 pax', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7750, 0, 0, 7750, 'Seven Thousand Seven Hundred and Fifty', '27105-35 / 31 pax', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-25 00:00:00'),
(447, 'MCD-00447', '', '2016-08-26 09:08:54', 'Dhaka Airport (DAC)', 'MR. RUBEL', '', '01680304892', '', '', 'cargo', '', 80, 'BS103', '2016-08-26 00:00:00', 0, 9, '156460', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 720, 0, 0, 720, 'Seven Hundred and Twenty', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(448, 'MCD-00448', '72775', '2016-08-26 11:40:18', 'Chittagong Airport (CGP)', 'mr aman', '', '01682978157', '', '', 'cargo', '', 100, 'bs 102', '2016-08-26 00:00:00', 0, 3, '223999', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(449, 'MCD-00449', '72776', '2016-08-26 11:45:26', 'Chittagong Airport (CGP)', 'kazi arif uddin ahmed', '', '01711357085', '', '', 'ebt', '00iny9', 100, 'bs 102', '2016-08-26 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(450, 'MCD-00450', '72777', '2016-08-26 11:49:27', 'Chittagong Airport (CGP)', 'mr khan', '', '01988800018', '', '', 'cargo', '', 100, 'bs 104', '2016-08-26 00:00:00', 0, 3, '222780', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(451, 'MCD-00451', '', '2016-08-26 13:36:03', 'Sylhet Airport (ZYL)', 'DR LALPATH', '', '01711078279', '', '', 'cargo', '', 100, 'BS132', '2016-08-26 00:00:00', 0, 3, '117249', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(452, 'MCD-00452', '', '2016-08-26 15:59:16', 'Saidpur Airport (SPD)', 'Mr. Hafizur Rahman', '', '01764803253', '', '', 'cargo', '', 100, 'BS-154', '2016-08-26 00:00:00', 0, 3, '131878', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(453, 'MCD-00453', '', '2016-08-26 16:05:21', 'Saidpur Airport (SPD)', 'Md. Sohel', '', '01716220168', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-26 00:00:00', 1, 0.2, '173559', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(454, 'MCD-00454', '', '2016-08-26 16:26:48', 'Chittagong Airport (CGP)', 'MR ABU HANIF', '', '01923325267', '', '', 'mail_courier', '', 0, 'BS 106', '2016-08-26 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(455, 'MCD-00455', '', '2016-08-26 16:28:23', 'Chittagong Airport (CGP)', 'MR PRADIPTA CHY', '', '01819317582', '', '', 'ebt', '00IM1P', 100, 'BS 106', '2016-08-26 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(456, 'MCD-00456', '', '2016-08-26 16:35:57', 'Dhaka Airport (DAC)', 'MR KAMAL', '', '01712928222', '', '', 'cargo', '', 80, '107', '2016-08-26 00:00:00', 0, 33, '107364,107375,107380.107381', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2640, 0, 0, 2640, 'Two Thousand Six Hundred and Forty', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(457, 'MCD-00457', '', '2016-08-26 16:40:48', 'Dhaka Airport (DAC)', 'MR MOSHARROUF', '', '01711402329', '', '', 'cargo', '', 300, 'BS 107', '2016-08-26 00:00:00', 80, 1, '108113', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(458, 'MCD-00458', '', '2016-08-26 17:43:01', 'Jessore Airport (JSR)', 'amin', '', '01961357753', '', '', 'mail_courier', '', 0, 'BS124', '2016-08-26 00:00:00', 1, 1, '298353', '01684262481', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'hasibul hasan', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(459, 'MCD-00459', '', '2016-08-26 18:04:41', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-26 00:00:00', 0, 27, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Rangpur TKT No: 29621-29647', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5400, 0, 0, 5400, 'Five Thousand Four Hundred ', 'Rangpur TKT No: 29621-29647', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(460, 'MCD-00460', '', '2016-08-26 18:07:18', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-26 00:00:00', 0, 19, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Dinajpur TKT No: 29715-29733', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4750, 0, 0, 4750, 'Four Thousand Seven Hundred and Fifty', 'Dinajpur TKT No: 29715-29733', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(461, 'MCD-00461', '', '2016-08-26 19:14:56', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-26 00:00:00', 0, 32, '', '', 'BS-121 ,BS-123', '', '27136-67 / 32 pax', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8000, 0, 0, 8000, 'Eight Thousand ', '27136-67 / 32 pax', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(462, 'MCD-00462', '', '2016-08-26 19:49:35', 'Chittagong Airport (CGP)', 'mr giyas uddin', '', '01818110417', '', '', 'mail_courier', '', 0, 'bs 108', '2016-08-26 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(463, 'MCD-00463', '', '2016-08-26 20:33:33', 'Chittagong Airport (CGP)', 'MR MASUD', '', '01830100745', '', '', 'mail_courier', '', 0, 'BS 110', '2016-08-26 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-26 00:00:00'),
(464, 'MCD-00464', '', '2016-08-27 08:47:52', 'Dhaka Airport (DAC)', 'MR  JASHIMUDDIN', '', '01787670343', '', '', 'cargo', '', 80, 'BS 151', '2016-08-27 00:00:00', 0, 11, '03640,03715', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 880, 0, 0, 880, 'Eight Hundred and Eighty', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(465, 'MCD-00465', '', '2016-08-27 11:29:59', 'Sylhet Airport (ZYL)', 'rosomala begum', '', '01778323114', '', '', 'ebt', '00fw5i', 100, 'BS132', '2016-08-27 00:00:00', 0, 15, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(466, 'MCD-00466', '', '2016-08-27 11:35:16', 'Cox''s Bazar Airport (CXB)', 'Mr Hasmot', '', '01726286399', '', '', 'cargo', '', 100, 'bs-142', '2016-08-27 00:00:00', 0, 10, '165371', '', '', '', '5*100 = 500 TK\r\n5*80   = 400 TK', 'CXB', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '5*100 = 500 TK\r\n5*80   = 400 TK', 'MOHAMMAD TANBIR HOSSAIN', 18, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(467, 'MCD-00467', '', '2016-08-27 11:47:21', 'Sylhet Airport (ZYL)', 'rahim rahman', '', '01717846459', '', '', 'ebt', '00gvch', 100, 'BS132', '2016-08-27 00:00:00', 0, 40, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(468, 'MCD-00468', '', '2016-08-27 13:50:40', 'Dhaka Airport (DAC)', 'MR BABUL', '', '01726859413', '', '', 'cargo', '', 80, 'BS 105', '2016-08-27 00:00:00', 0, 40, '106937,106938,106940,107037,107789', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3200, 0, 0, 3200, 'Three Thousand Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(469, 'MCD-00469', '', '2016-08-27 14:12:29', 'Dhaka Airport (DAC)', 'ANUP KUMAR BARUA', '', '01911483948', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-27 00:00:00', 1, 1, '105998', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(470, 'MCD-00470', '', '2016-08-27 14:25:55', 'Dhaka Airport (DAC)', 'SOHEL RANA', '', '0177789989', '', '', 'cargo', '', 300, 'BS 105', '2016-08-27 00:00:00', 0, 1, '04264', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(471, 'MCD-00471', '', '2016-08-27 14:53:07', 'Rajshahi Airport (RJH)', 'Sayfuzzaman', '', '01712566908', '', '', 'ebt', '00IQL3', 100, 'BS-162', '2016-08-27 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'ALI REDWONE DHIP', 32, '119.30.39.166', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(472, 'MCD-00472', '', '2016-08-27 15:19:30', 'Chittagong Airport (CGP)', 'MR.MAMUN', '', '01812478617', '', '', 'cargo', '', 100, 'BS 106', '2016-08-27 00:00:00', 0, 3, '213797', '72782', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(473, 'MCD-00473', '', '2016-08-27 17:23:09', 'Dhaka Airport (DAC)', 'MD IDRIS ALI', '', '01701757276', '', '', 'cargo', '', 300, 'BS 107', '2016-08-27 00:00:00', 0, 1, '07250', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(474, 'MCD-00474', '', '2016-08-27 17:28:34', 'Jessore Airport (JSR)', 'mr mostafa ali', '', '01678825011', '', '', 'cargo', '', 100, 'bs-124', '2016-08-27 00:00:00', 0, 3, '237524', '01911271117', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(475, 'MCD-00475', '', '2016-08-27 18:35:12', 'Chittagong Airport (CGP)', 'mr akbar', '', '01819882040', '', '', 'cargo', '', 100, 'bs 108', '2016-08-27 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(476, 'MCD-00476', '', '2016-08-27 18:36:22', 'Chittagong Airport (CGP)', 'mr nazmul', '', '01820272723', '', '', 'cargo', '', 100, 'bs 108', '2016-08-27 00:00:00', 0, 5, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(477, 'MCD-00477', '', '2016-08-27 18:41:38', 'Chittagong Airport (CGP)', 'mr ashiq imran', '', '01713104989', '', '', 'ebt', '00ikzd', 100, 'bs 108', '2016-08-27 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(478, 'MCD-00478', '', '2016-08-27 18:52:58', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-27 00:00:00', 0, 24, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Rangpur TKT No: 29648-29671', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4800, 0, 0, 4800, 'Four Thousand Eight Hundred ', 'Rangpur TKT No: 29648-29671', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(479, 'MCD-00479', '', '2016-08-27 18:54:12', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-27 00:00:00', 0, 12, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Dinajpur TKT No: 29734-29745', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000, 0, 0, 3000, 'Three Thousand ', 'Dinajpur TKT No: 29734-29745', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(480, 'MCD-00480', '', '2016-08-27 19:22:10', 'Chittagong Airport (CGP)', 'mr.raju', '', '01730787721', '', '', 'cargo', '', 100, 'bs 108', '2016-08-27 00:00:00', 0, 3, '205636', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(481, 'MCD-00481', '', '2016-08-27 19:25:03', 'Chittagong Airport (CGP)', 'MR.BELAL', '', '01823693245', '', '', 'mail_courier', '', 0, 'BS 108', '2016-08-27 00:00:00', 1, 1, '219947', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(482, 'MCD-00482', '', '2016-08-27 19:27:53', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-27 00:00:00', 0, 31, '', '', 'BS-121 ,BS-123', '', '27168-98', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7750, 0, 0, 7750, 'Seven Thousand Seven Hundred and Fifty', '27168-98', 'MD Billal Ahmed', 13, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(483, 'MCD-00483', '', '2016-08-27 19:28:25', 'Dhaka Airport (DAC)', 'BELAYET CHOWDHURY', '', '01726644423', '', '', 'mail_courier', '', 0, 'BS 109', '2016-08-27 00:00:00', 1, 1, '10115', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-27 00:00:00'),
(484, 'MCD-00484', '', '2016-08-28 11:14:43', 'Saidpur Airport (SPD)', 'MASFIKUR RAHMAN', '', '01711144142', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-28 00:00:00', 1, 0.2, '288727', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(485, 'MCD-00485', '', '2016-08-28 12:14:52', 'Sylhet Airport (ZYL)', 'iom, sylhet', '', '01715202688', '', '', 'cargo', '', 100, 'BS132', '2016-08-28 00:00:00', 0, 3, '282194', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(486, 'MCD-00486', '', '2016-08-28 12:50:38', 'Sylhet Airport (ZYL)', 'rohel miah', '', '01712595711', '', '', 'ebt', '00inqg', 100, 'BS132', '2016-08-28 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(487, 'MCD-00487', '', '2016-08-28 15:05:21', 'Dhaka Airport (DAC)', 'RAKIB', '', '01911308204', '', '', 'cargo', '', 80, 'BS 105', '2016-08-28 00:00:00', 0, 7, '156436', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 560, 0, 0, 560, 'Five Hundred and Sixty', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(488, 'MCD-00488', '', '2016-08-28 15:10:17', 'Dhaka Airport (DAC)', 'kashfia nahreen', '', '01757293862', '', '', 'cargo', '', 100, 'bs153', '2016-08-28 00:00:00', 0, 5, '02737', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'ASIF SIDDIQUE', 65, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(489, 'MCD-00489', '', '2016-08-28 15:34:42', 'Dhaka Airport (DAC)', 'MR. NAZMUL', '', '01913308451', '', '', 'cargo', '', 100, 'BS123', '2016-08-28 00:00:00', 0, 4, '04625', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(490, 'MCD-00490', '', '2016-08-28 15:53:13', 'Saidpur Airport (SPD)', 'MD JAHANGIR ALAM', '', '01735862880', '', '', 'cargo', '', 100, 'BS-154', '2016-08-28 00:00:00', 0, 3, '269060', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(491, 'MCD-00491', '', '2016-08-28 16:02:48', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 100, '', '2016-08-28 00:00:00', 0, 17, '', '', 'usba bzl,bs-172', '', '', 'SADAR-ROAD(BZL)', 'AIRPORT(BZL)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1700, 0, 0, 1700, 'One Thousand Seven Hundred ', '', 'POBITRA CHANDRA DAS', 38, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(492, 'MCD-00492', '', '2016-08-28 16:14:00', 'Jessore Airport (JSR)', 'm/s setu center', '', '01922311060', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-28 00:00:00', 1, 0.1, '140955', '01712652548', '', '', '', 'JSR', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'M/S GALLANT ENTERPRISE', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(493, 'MCD-00493', '72788', '2016-08-28 16:39:00', 'Chittagong Airport (CGP)', 'MR NASIR', '', '01819173776', '', '', 'mail_courier', '', 0, 'BS 106', '2016-08-28 00:00:00', 1, 1, '221473', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(494, 'MCD-00494', '72789', '2016-08-28 16:40:16', 'Chittagong Airport (CGP)', 'MR KADER', '', '01715741349', '', '', 'cargo', '', 100, 'BS 106', '2016-08-28 00:00:00', 0, 3, '216156', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(495, 'MCD-00495', '', '2016-08-28 16:51:32', 'Jessore Airport (JSR)', 'MTR/TS/276/16/HQ', '', '01823106360', '', '', 'cargo', '', 100, 'BS-124', '2016-08-28 00:00:00', 0, 3, '295860', '029993404', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(496, 'MCD-00496', '', '2016-08-28 17:05:35', 'Dhaka Airport (DAC)', 'MR. SHOHAGUE HASAN', '', '01924437857', '', '', 'cargo', '', 100, 'BS107', '2016-08-28 00:00:00', 0, 3, '153901', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(497, 'MCD-00497', '', '2016-08-28 17:17:03', 'Dhaka Airport (DAC)', 'MR. MINTU CHOWDHURY', '', '01935369958', '', '', 'cargo', '', 80, 'bs107', '2016-08-28 00:00:00', 0, 7, '153715', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 560, 0, 0, 560, 'Five Hundred and Sixty', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(498, 'MCD-00498', '', '2016-08-28 17:23:11', 'Jessore Airport (JSR)', 'mamun & Brothers', '', '01711116651', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-28 00:00:00', 1, 0.4, '267533', '', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(499, 'MCD-00499', '', '2016-08-28 17:32:06', 'Dhaka Airport (DAC)', 'MR. ASAD', '', '01611007270', '', '', 'mail_courier', '', 0, 'BS107', '2016-08-28 00:00:00', 1, 1, '158259', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(500, 'MCD-00500', '', '2016-08-28 17:36:31', 'Jessore Airport (JSR)', 'MONA FOOD INDUSTRIES', '', '042168088', '', '', 'cargo', '', 100, 'BS-124', '2016-08-28 00:00:00', 0, 3, '269022', '01711960657', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(501, 'MCD-00501', '', '2016-08-28 17:58:39', 'Dhaka Airport (DAC)', 'SHUMON', '', '01716134097', '', '', 'cargo', '', 100, 'BS-107', '2016-08-28 00:00:00', 0, 3, '', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD. IBNE ARAFAT MAZUMDER', 58, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(502, 'MCD-00502', '', '2016-08-28 18:05:54', 'Dhaka Airport (DAC)', 'NURUL AKTER', '', '01712120756', '', '', 'cargo', '', 100, 'BS-107', '2016-08-28 00:00:00', 0, 3, '158240', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD. IBNE ARAFAT MAZUMDER', 58, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(503, 'MCD-00503', '', '2016-08-28 18:25:59', 'Saidpur Airport (SPD)', 'MD JAKIR HOSSAIN', '', '01768839804', '', '', 'mail_courier', '', 0, 'BS-154', '2016-08-28 00:00:00', 1, 0.08, '250128', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(504, 'MCD-00504', '', '2016-08-28 18:38:52', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-28 00:00:00', 0, 20, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'TKT NO: 29672-29691\r\n(20x200=4000)', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', 'TKT NO: 29672-29691\r\n(20x200=4000)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(505, 'MCD-00505', '', '2016-08-28 18:42:16', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-28 00:00:00', 0, 17, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'TKT NO: 29746-29762\r\n(17x250=4250)', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4250, 0, 0, 4250, 'Four Thousand Two Hundred and Fifty', 'TKT NO: 29746-29762\r\n(17x250=4250)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(506, 'MCD-00506', '', '2016-08-28 19:27:24', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-28 00:00:00', 0, 35, '', '', 'BS-121 ,BS-123', '', '27199-233 / 35 PAX', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', '27199-233 / 35 PAX', 'Ahsan Kabir', 9, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(507, 'MCD-00507', '72790', '2016-08-28 19:30:04', 'Chittagong Airport (CGP)', 'mr.manik', '', '01675276002', '', '', 'cargo', '', 100, '108', '2016-08-28 00:00:00', 0, 4, '228905', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(508, 'MCD-00508', '72791', '2016-08-28 19:34:02', 'Chittagong Airport (CGP)', 'mr.shohag', '', '01739637334', '', '', 'cargo', '', 100, '108', '2016-08-28 00:00:00', 0, 3, '224773', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(509, 'MCD-00509', '72792', '2016-08-28 19:37:41', 'Chittagong Airport (CGP)', 'mr.amin', '', '01715163750', '', '', 'cargo', '', 100, '108', '2016-08-28 00:00:00', 0, 3, '204848', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-28 00:00:00'),
(510, 'MCD-00510', '', '2016-08-29 06:25:57', 'Dhaka Airport (DAC)', 'shohidul', '', '01937400858', '', '', 'cargo', '', 100, 'bs121', '2016-08-29 00:00:00', 0, 3, '114659', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(511, 'MCD-00511', '', '2016-08-29 06:46:34', 'Dhaka Airport (DAC)', 'nur hossain', '', '01620995412', '', '', 'mail_courier', '', 0, 'bs121', '2016-08-29 00:00:00', 1, 1, '114647', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(512, 'MCD-00512', '', '2016-08-29 06:57:53', 'Dhaka Airport (DAC)', 'shawkat', '', '01798674698', '', '', 'cargo', '', 100, 'bs121', '2016-08-29 00:00:00', 0, 3, '114649', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(513, 'MCD-00513', '', '2016-08-29 07:17:10', 'Jessore Airport (JSR)', 'kazi hamidul haque khulna', '', '01711820410', '', '', 'mail_courier', '', 0, 'BS122', '2016-08-29 00:00:00', 1, 1, '144505', 'shara 01711325100', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(514, 'MCD-00514', '', '2016-08-29 08:41:24', 'Dhaka Airport (DAC)', 'RASEL', '', '01913890531', '', '', 'cargo', '', 300, 'BS 151', '2016-08-29 00:00:00', 0, 1, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(515, 'MCD-00515', '', '2016-08-29 09:55:00', 'Dhaka Airport (DAC)', 'MD KAMRUL ISLAM', '', '01751712335', '', '', 'cargo', '', 300, 'BS 103', '2016-08-29 00:00:00', 0, 1, '105733', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(516, 'MCD-00516', '', '2016-08-29 10:52:16', 'Saidpur Airport (SPD)', 'md. Shamim', '', '01750700072', '', '', 'mail_courier', '', 0, 'BS-152', '2016-08-29 00:00:00', 1, 0.02, '146418', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(517, 'MCD-00517', '', '2016-08-29 11:27:13', 'Sylhet Airport (ZYL)', 'sami forhad miah', '', '01711123794', '', '', 'ebt', '00g2lm', 100, 'BS132', '2016-08-29 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(518, 'MCD-00518', '', '2016-08-29 11:38:25', 'Sylhet Airport (ZYL)', 'DR LALPATH', '', '01711078279', '', '', 'cargo', '', 100, 'BS132', '2016-08-29 00:00:00', 0, 3, '133292', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(519, 'MCD-00519', '', '2016-08-29 11:42:18', 'Dhaka Airport (DAC)', 'HABIB', '', '01920101619', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-29 00:00:00', 1, 1, '107469', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(520, 'MCD-00520', '', '2016-08-29 11:53:47', 'Dhaka Airport (DAC)', 'MR MANSURUL AMIN', '', '01678035948', '', '', 'cargo', '', 100, 'BS 105', '2016-08-29 00:00:00', 0, 3, '108171', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(521, 'MCD-00521', '', '2016-08-29 12:14:09', 'Sylhet Airport (ZYL)', 'koyes ali', '', '01736565255', '', '', 'ebt', '00isda', 100, 'BS132', '2016-08-29 00:00:00', 0, 15, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1500, 0, 0, 1500, 'One Thousand Five Hundred ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(522, 'MCD-00522', '', '2016-08-29 12:31:10', 'Sylhet Airport (ZYL)', 'mr choudhuury', '', '01749219710', '', '', 'ebt', '00is8l', 100, 'BS132', '2016-08-29 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(523, 'MCD-00523', '', '2016-08-29 12:40:50', 'Sylhet Airport (ZYL)', 'rashida kandoker', '', '01771302869', '', '', 'ebt', '00isiv', 100, 'BS132', '2016-08-29 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(524, 'MCD-00524', '', '2016-08-29 16:00:55', 'Dhaka Airport (DAC)', 'MR. SHAHIDUL', '', '01937400858', '', '', 'cargo', '', 300, 'BS123', '2016-08-29 00:00:00', 0, 1, '06830', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(525, 'MCD-00525', '', '2016-08-29 16:16:34', 'Dhaka Airport (DAC)', 'a s mallik', '', '07938877019', '', '', 'cargo', '', 80, 'bs123', '2016-08-29 00:00:00', 0, 65, '100866,103256,100854.103794,100663', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5200, 0, 0, 5200, 'Five Thousand Two Hundred ', '', 'ASIF SIDDIQUE', 65, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(526, 'MCD-00526', '', '2016-08-29 16:20:09', 'Dhaka Airport (DAC)', 'mr shakil', '', '01783265095', '', '', 'cargo', '', 80, 'bs107', '2016-08-29 00:00:00', 0, 15, '158247,158275', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1200, 0, 0, 1200, 'One Thousand Two Hundred ', '', 'ASIF SIDDIQUE', 65, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(527, 'MCD-00527', '', '2016-08-29 16:27:58', 'Dhaka Airport (DAC)', 'mr bablu', '', '01726859413', '', '', 'cargo', '', 80, 'bs107', '2016-08-29 00:00:00', 0, 54, '106055,107550,107548,107551,107547,107553,107519', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4320, 0, 0, 4320, 'Four Thousand Three Hundred and Twenty', '', 'ASIF SIDDIQUE', 65, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(528, 'MCD-00528', '72793', '2016-08-29 16:37:45', 'Chittagong Airport (CGP)', 'sadhaw kanti biswa', '', '01733037676', '', '', 'ebt', '00iep9', 100, 'BS 106', '2016-08-29 00:00:00', 0, 20, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(529, 'MCD-00529', '72794', '2016-08-29 16:41:25', 'Chittagong Airport (CGP)', 'mr biplab jawa', '', '9051679293', '', '', 'ebt', '00iu48', 100, 'BS 106', '2016-08-29 00:00:00', 0, 40, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(530, 'MCD-00530', '72795', '2016-08-29 16:43:50', 'Chittagong Airport (CGP)', 'mr iqbal hossain', '', '01714168587', '', '', 'cargo', '', 100, 'BS 106', '2016-08-29 00:00:00', 0, 3, '207580', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SAHEDUZZAMAN SAHED', 43, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(531, 'MCD-00531', '', '2016-08-29 16:45:06', 'Dhaka Airport (DAC)', 'mr md alaluddin', '', '01678819789', '', '', 'mail_courier', '', 0, 'bs 123', '2016-08-29 00:00:00', 1, 1, '114626', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(532, 'MCD-00532', '', '2016-08-29 16:55:03', 'Jessore Airport (JSR)', 'MTR/TS/279/16/HQ', '', '01966606470', '', '', 'cargo', '', 100, 'BS-124', '2016-08-29 00:00:00', 0, 3, '258194', 'ADJT', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(533, 'MCD-00533', '', '2016-08-29 17:00:17', 'Jessore Airport (JSR)', 'GE BIMAN', '', '01719118749', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-29 00:00:00', 1, 1, '283475', '01718474586', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Humayun Kabir', 11, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(534, 'MCD-00534', '', '2016-08-29 17:07:49', 'Dhaka Airport (DAC)', 'mr farid', '', '01911583161', '', '', 'cargo', '', 100, 'bs107', '2016-08-29 00:00:00', 0, 3, '158279', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASIF SIDDIQUE', 65, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(535, 'MCD-00535', '', '2016-08-29 17:12:54', 'Dhaka Airport (DAC)', 'MR JAMAL HAIDER', '', '01741181962', '', '', 'mail_courier', '', 0, 'BS 123', '2016-08-29 00:00:00', 1, 1, '05726', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(536, 'MCD-00536', '', '2016-08-29 18:22:56', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-29 00:00:00', 0, 20, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Rangpur TKT No: 29692-29700,34101-34111', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', 'Rangpur TKT No: 29692-29700,34101-34111', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(537, 'MCD-00537', '', '2016-08-29 18:28:00', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-29 00:00:00', 0, 10, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Dinajpur TKT No: 29763-29772', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2500, 0, 0, 2500, 'Two Thousand Five Hundred ', 'Dinajpur TKT No: 29763-29772', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(538, 'MCD-00538', '72796', '2016-08-29 19:08:32', 'Chittagong Airport (CGP)', 'mr.nurul alam', '', '01829629439', '', '', 'cargo', '', 100, '108', '2016-08-29 00:00:00', 0, 3, '215342', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(539, 'MCD-00539', '72797', '2016-08-29 19:11:29', 'Chittagong Airport (CGP)', 'mr.shahjahan', '', '01814437524', '', '', 'cargo', '', 100, '108', '2016-08-29 00:00:00', 0, 3, '210779', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.107.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(540, 'MCD-00540', '72798', '2016-08-29 19:15:12', 'Chittagong Airport (CGP)', 'mr.nazmul', '', '01820272723', '', '', 'mail_courier', '', 0, '108', '2016-08-29 00:00:00', 1, 1, '227972', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(541, 'MCD-00541', '72799', '2016-08-29 19:17:57', 'Chittagong Airport (CGP)', 'mr.nazmul', '', '01820272723', '', '', 'cargo', '', 100, '108', '2016-08-29 00:00:00', 0, 3, '200777', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(542, 'MCD-00542', '72800', '2016-08-29 19:21:53', 'Chittagong Airport (CGP)', 'mr.monir', '', '01777707523', '', '', 'cargo', '', 100, '108', '2016-08-29 00:00:00', 0, 3, '218818', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.107.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(543, 'MCD-00543', '72802', '2016-08-29 19:31:47', 'Chittagong Airport (CGP)', 'mr majed', '', '01817169426', '', '', 'cargo', '', 100, 'BS 108', '2016-08-29 00:00:00', 0, 3, '201294', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '103.230.107.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(544, 'MCD-00544', '', '2016-08-29 19:34:32', 'Dhaka Airport (DAC)', 'MR. MD RIPON UDDIN', '', '01771549348', '', '', 'cargo', '', 100, 'BS109', '2016-08-29 00:00:00', 0, 3, '105736', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(545, 'MCD-00545', '72803', '2016-08-29 19:38:10', 'Chittagong Airport (CGP)', 'MR SHOWMAN', '', '01879309830', '', '', 'mail_courier', '', 0, 'BS 108', '2016-08-29 00:00:00', 1, 1, '218026', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '103.230.105.19', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(546, 'MCD-00546', '', '2016-08-29 20:01:07', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-29 00:00:00', 0, 35, '', '', 'bs 121 & 123', '', '27234-68', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', '27234-68', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(547, 'MCD-00547', '', '2016-08-29 20:01:10', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-29 00:00:00', 0, 35, '', '', 'bs 121 & 123', '', '27234-68', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8750, 0, 0, 8750, 'Eight Thousand Seven Hundred and Fifty', '27234-68', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(548, 'MCD-00548', '72801', '2016-08-29 21:44:04', 'Chittagong Airport (CGP)', 'MR.BAF', '', '01727197104', '', '', 'cargo', '', 100, '108', '2016-08-29 00:00:00', 0, 5, '218420', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-29 00:00:00'),
(549, 'MCD-00549', '', '2016-08-30 06:26:29', 'Dhaka Airport (DAC)', 'MR. SUMON', '', '01924904855', '', '', 'cargo', '', 100, 'BS101', '2016-08-30 00:00:00', 0, 3, '106278', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(550, 'MCD-00550', '', '2016-08-30 06:30:55', 'Dhaka Airport (DAC)', 'MR. MD. TUHIN', '', '01686306057', '', '', 'mail_courier', '', 0, 'BS101', '2016-08-30 00:00:00', 1, 1, '150523', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(551, 'MCD-00551', '', '2016-08-30 06:57:25', 'Dhaka Airport (DAC)', 'MR. MASUD', '', '01830059106', '', '', 'mail_courier', '', 0, 'BS101', '2016-08-30 00:00:00', 1, 1, '150568', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(552, 'MCD-00552', '', '2016-08-30 07:11:48', 'Dhaka Airport (DAC)', 'MR. MASUM', '', '01716821847', '', '', 'mail_courier', '', 0, 'BS121', '2016-08-30 00:00:00', 1, 1, '08996', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(553, 'MCD-00553', '', '2016-08-30 07:21:24', 'Chittagong Airport (CGP)', 'mr johor', '', '01819317267', '', '', 'cargo', '', 100, 'bs 102', '2016-08-30 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(554, 'MCD-00554', '', '2016-08-30 07:36:29', 'Chittagong Airport (CGP)', 'mr ali', '', '01819648639', '', '', 'cargo', '', 100, 'bs 102', '2016-08-30 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(555, 'MCD-00555', '', '2016-08-30 08:41:50', 'Dhaka Airport (DAC)', 'MR. RASEL', '', '01913890531', '', '', 'cargo', '', 100, 'BS151', '2016-08-30 00:00:00', 0, 3, '023620', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00');
INSERT INTO `mcdinfo` (`MCDID`, `AutoSerial`, `ManualSerial`, `MCDDate`, `StationOffice`, `CustomerName`, `CorporateID`, `Mobile`, `Email`, `Address`, `CollectionPurpose`, `PNR`, `Fees`, `FlightNo`, `FlightDate`, `Quantity`, `Weight`, `TagNo`, `ReferenceNo`, `BusNo`, `BusStartTime`, `OtherRemarks`, `RouteStart`, `RouteEnd`, `ModeOfPayment`, `CardNo`, `ChequeBank`, `ChequeNo`, `BcashMobile`, `MBBankName`, `MBMobile`, `Currency`, `Amount`, `Waiver`, `Tax`, `PaidAmount`, `AmountInWord`, `Remarks`, `UserName`, `IssuerID`, `IPAddress`, `CardType`, `CargoReceiver`, `TransactionID`, `UpdatedByID`, `LastUpdate`, `UpdateByIP`, `VoidStatus`, `ChequeDate`) VALUES
(556, 'MCD-00556', '', '2016-08-30 09:37:32', 'Dhaka Airport (DAC)', 'MR. AZIZUL HAQUE', '', '01777709741', '', '', 'mail_courier', '', 0, 'BS103', '2016-08-30 00:00:00', 1, 1, '104694', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(557, 'MCD-00557', '', '2016-08-30 10:49:59', 'Chittagong Airport (CGP)', 'mr nazmul', '', '01813186182', '', '', 'mail_courier', '', 0, 'bs 104', '2016-08-30 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(558, 'MCD-00558', '', '2016-08-30 11:40:49', 'Sylhet Airport (ZYL)', 'iom, sylhet', '', '01715202688', '', '', 'cargo', '', 100, 'BS132', '2016-08-30 00:00:00', 0, 3, '128724', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(559, 'MCD-00559', '', '2016-08-30 11:50:26', 'Sylhet Airport (ZYL)', 'FORHAD AHMED', '', '01715417974', '', '', 'ebt', '00IN9S', 100, 'BS132', '2016-08-30 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(560, 'MCD-00560', '', '2016-08-30 12:27:22', 'Sylhet Airport (ZYL)', 'MD MIZANUR RAHMAN', '', '01762433857', '', '', 'ebt', '00HX13', 100, 'BS132', '2016-08-30 00:00:00', 0, 5, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Md ragib rahman', 33, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(561, 'MCD-00561', '', '2016-08-30 12:30:39', 'Cox''s Bazar Airport (CXB)', 'mr hasmat jahan', '', '01726286399', '', '', 'cargo', '', 100, 'bs-142', '2016-08-30 00:00:00', 0, 10, '150739', '', '', '', '100*5=500&\r\n80*5=400.', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '100*5=500&\r\n80*5=400.', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(562, 'MCD-00562', '', '2016-08-30 13:53:30', 'Dhaka Airport (DAC)', 'AHMAD ULLAH', '', '01743792196', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-30 00:00:00', 1, 1, '17552', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(563, 'MCD-00563', '', '2016-08-30 14:10:12', 'Dhaka Airport (DAC)', 'mr md kamrul islam', '', '01751712335', '', '', 'mail_courier', '', 0, 'bs 105', '2016-08-30 00:00:00', 1, 1, '104755', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(564, 'MCD-00564', '', '2016-08-30 14:17:49', 'Dhaka Airport (DAC)', 'mr abdhul halim', '', '01730648047', '', '', 'mail_courier', '', 0, 'bs 105', '2016-08-30 00:00:00', 1, 1, '103800', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(565, 'MCD-00565', '', '2016-08-30 14:45:16', 'Dhaka Airport (DAC)', 'MR MD HELAL UDDIN', '', '01911813594', '', '', 'cargo', '', 80, 'BS105', '2016-08-30 00:00:00', 0, 7, '104762', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 560, 0, 0, 560, 'Five Hundred and Sixty', '', 'SALEH SERAJ', 67, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(566, 'MCD-00566', '', '2016-08-30 16:26:14', 'Barisal Airport (BZL)', 'us bangla bzl', '', '01777777848', '', '', 'bus_tkt', '', 100, '', '2016-08-30 00:00:00', 0, 18, '', '', 'usb bzl,bs-172', '', '', 'SADAR-ROAD(BZL)', 'AIRPORT(BZL)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1800, 0, 0, 1800, 'One Thousand Eight Hundred ', '', 'SYED MOSTAIN HOSSAIN', 28, '203.76.100.2', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(567, 'MCD-00567', '', '2016-08-30 16:39:03', 'Jessore Airport (JSR)', 'MR PALASH', '', '01712808441', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-30 00:00:00', 1, 1, '297457', '01937873667', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'S K MONIRUZZAMAN, DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(568, 'MCD-00568', '72807', '2016-08-30 16:41:12', 'Chittagong Airport (CGP)', 'mr.rony', '', '01866977707', '', '', 'mail_courier', '', 0, '106', '2016-08-30 00:00:00', 1, 1, '202310', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.12', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(569, 'MCD-00569', '72808', '2016-08-30 16:44:01', 'Chittagong Airport (CGP)', 'mr.mohsin tanim', '', '01926322199', '', '', 'ebt', '00isa1', 100, '106', '2016-08-30 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.12', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(570, 'MCD-00570', '72809', '2016-08-30 16:47:09', 'Chittagong Airport (CGP)', 'mr.sujid', '', '01812260184', '', '', 'mail_courier', '', 0, '106', '2016-08-30 00:00:00', 1, 1, '227340', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.105.12', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(571, 'MCD-00571', '72810', '2016-08-30 16:50:16', 'Chittagong Airport (CGP)', 'mr.murad', '', '01817043367', '', '', 'cargo', '', 100, '106', '2016-08-30 00:00:00', 0, 3, '219657', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '103.230.107.12', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(572, 'MCD-00572', '', '2016-08-30 16:53:31', 'Dhaka Airport (DAC)', 'BABUL', '', '01726859413', '', '', 'cargo', '', 80, 'BS-107', '2016-08-30 00:00:00', 0, 50, '107509,106064,107780,107508,106062,106059', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4000, 0, 0, 4000, 'Four Thousand ', '', 'MD. IBNE ARAFAT MAZUMDER', 58, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(573, 'MCD-00573', '', '2016-08-30 16:54:37', 'Jessore Airport (JSR)', 'MTR/TS/280/16/HQ', '', '01724169869', '', '', 'cargo', '', 100, 'BS-124', '2016-08-30 00:00:00', 0, 5, '268210', '9993402', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD Billal Ahmed', 13, '203.76.120.226', '', 'ADJT AIR HQ, DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(574, 'MCD-00574', '', '2016-08-30 18:22:41', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-30 00:00:00', 0, 25, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Rangpur TKT No: 34112-34136', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', 'Rangpur TKT No: 34112-34136', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(575, 'MCD-00575', '', '2016-08-30 18:24:14', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-30 00:00:00', 0, 25, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'Dinajpur TKT No: 29773-29797', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6250, 0, 0, 6250, 'Six Thousand Two Hundred and Fifty', 'Dinajpur TKT No: 29773-29797', 'MD RAQUIB MOSTAQUIM', 23, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(576, 'MCD-00576', '72811', '2016-08-30 18:33:37', 'Chittagong Airport (CGP)', 'MR. DIDAR', '', '01730358869', '', '', 'cargo', '', 100, 'BS108', '2016-08-30 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(577, 'MCD-00577', '72812', '2016-08-30 18:35:38', 'Chittagong Airport (CGP)', 'MR. MANIK', '', '01675276002', '', '', 'cargo', '', 100, 'BS 108', '2016-08-30 00:00:00', 0, 4, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD AMRAN HOSSAIN', 39, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(578, 'MCD-00578', '', '2016-08-30 18:47:29', 'Jessore Airport (JSR)', 'SP JESSORE', '', '01777777835', '', '', 'cargo', '', 100, 'BS 124', '2016-08-30 00:00:00', 0, 5, '294827', '01944547708', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(579, 'MCD-00579', '', '2016-08-30 19:05:34', 'Jessore Airport (JSR)', 'KHL BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-30 00:00:00', 0, 31, '', '', 'bs 121 & 123', '', '27269-99', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7750, 0, 0, 7750, 'Seven Thousand Seven Hundred and Fifty', '27269-99', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(580, 'MCD-00580', '72813', '2016-08-30 19:58:55', 'Chittagong Airport (CGP)', 'mr shohag', '', '01729637334', '', '', 'cargo', '', 100, 'bs 108', '2016-08-30 00:00:00', 0, 3, '267712', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '103.230.107.9', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(581, 'MCD-00581', '72814', '2016-08-30 21:31:16', 'Chittagong Airport (CGP)', 'MR SAIFULLAH', '', '01631849329', '', '', 'ebt', '00IWFL', 100, 'BS 110', '2016-08-30 00:00:00', 0, 45, '', '', '', '', '', 'CGP', 'DAC', 'card', '4833-XXXX-XXXX-4501', '', '', '', '', '', 'Taka', 4500, 0, 0, 4500, 'Four Thousand Five Hundred ', '', 'MD ISMAIL HOSSAIN', 44, '115.127.49.10', 'Visa Card', '', '000096954770', 0, '0001-01-01 00:00:00', '', 1, '2016-08-30 00:00:00'),
(582, 'MCD-00582', '', '2016-08-31 06:47:25', 'Dhaka Airport (DAC)', 'SUMON', '', '01924904855', '', '', 'cargo', '', 100, 'BS 101', '2016-08-31 00:00:00', 0, 3, '104721', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(583, 'MCD-00583', '', '2016-08-31 07:03:00', 'Dhaka Airport (DAC)', 'mr md hafiz', '', '01765282392', '', '', 'cargo', '', 300, 'bs 121', '2016-08-31 00:00:00', 0, 1, '100825', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(584, 'MCD-00584', '', '2016-08-31 07:13:09', 'Dhaka Airport (DAC)', 'MR shahed', '', '01833155404', '', '', 'mail_courier', '', 0, 'BS 151', '2016-08-31 00:00:00', 1, 1, '113495', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(585, 'MCD-00585', '72815', '2016-08-31 08:13:44', 'Chittagong Airport (CGP)', 'MS.NASTASSIA YOUSEF', '', '01723808969', '', '', 'ebt', '00IKQC', 100, '102', '2016-08-31 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD TANJID ISLAM MAJUMDER', 42, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(586, 'MCD-00586', '72816', '2016-08-31 08:19:33', 'Chittagong Airport (CGP)', 'MR.AMAN', '', '01682978157', '', '', 'cargo', '', 100, '102', '2016-08-31 00:00:00', 0, 4, '223579', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(587, 'MCD-00587', '', '2016-08-31 08:22:15', 'Dhaka Airport (DAC)', 'RASEL', '', '01913890531', '', '', 'mail_courier', '', 0, 'BS 151', '2016-08-31 00:00:00', 1, 1, '113497', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(588, 'MCD-00588', '72817', '2016-08-31 08:24:10', 'Chittagong Airport (CGP)', 'MR.RAHIL AHMED', '', '01979310934', '', '', 'ebt', '00IVY2', 100, '102', '2016-08-31 00:00:00', 0, 5, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'MD TANJID ISLAM MAJUMDER', 42, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(589, 'MCD-00589', '', '2016-08-31 09:44:00', 'Saidpur Airport (SPD)', 'MR. ABDUL HALIM', '', '01774798917', '', '', 'cargo', '', 100, 'BS-152', '2016-08-31 00:00:00', 0, 3, '248300', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(590, 'MCD-00590', '', '2016-08-31 09:57:00', 'Saidpur Airport (SPD)', 'MR. RAKIB', '', '01714784435', '', '', 'cargo', '', 100, 'BS-152', '2016-08-31 00:00:00', 0, 8, '266495', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 800, 0, 0, 800, 'Eight Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(591, 'MCD-00591', '72818', '2016-08-31 11:22:19', 'Chittagong Airport (CGP)', 'mr. rakib', '', '01674823525', '', '', 'cargo', '', 100, 'bs104', '2016-08-31 00:00:00', 0, 4, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD AMRAN HOSSAIN', 39, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(592, 'MCD-00592', '', '2016-08-31 12:18:44', 'Cox''s Bazar Airport (CXB)', 'mr hasmat jahan', '', '01726286399', '', '', 'cargo', '', 100, 'bs-142', '2016-08-31 00:00:00', 0, 5, '138521', '', '', '', '100*5=500TK', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '100*5=500TK', 'KISHORE KUMAR DAS', 19, '27.147.255.50', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(593, 'MCD-00593', '', '2016-08-31 12:30:02', 'Sylhet Airport (ZYL)', 'abdul haque', '', '01776466172', '', '', 'ebt', '00hsh6', 100, 'BS132', '2016-08-31 00:00:00', 0, 50, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(594, 'MCD-00594', '', '2016-08-31 12:31:52', 'Sylhet Airport (ZYL)', 'abdul mumin', '', '01739946678', '', '', 'ebt', '00hsh6', 100, 'BS132', '2016-08-31 00:00:00', 0, 20, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2000, 0, 0, 2000, 'Two Thousand ', '', 'khalada yeasmin', 37, '163.47.32.234', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(595, 'MCD-00595', '', '2016-08-31 13:13:26', 'Dhaka Airport (DAC)', 'md jahidul islam', '', '01920646107', '', '', 'mail_courier', '', 0, 'BS 105', '2016-08-31 00:00:00', 1, 1, '107844', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(596, 'MCD-00596', '', '2016-08-31 13:25:04', 'Dhaka Airport (DAC)', 'SGT MONIR', '', '01672158143', '', '', 'cargo', '', 80, 'BS 105', '2016-08-31 00:00:00', 0, 33, '106325', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 2640, 0, 0, 2640, 'Two Thousand Six Hundred and Forty', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(597, 'MCD-00597', '', '2016-08-31 13:45:34', 'Dhaka Airport (DAC)', 'KAMAL HOSSAIN', '', '01712928222', '', '', 'cargo', '', 300, 'BS 105', '2016-08-31 00:00:00', 0, 1, '106369', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'SALEH SERAJ', 67, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(598, 'MCD-00598', '', '2016-08-31 14:34:07', 'Dhaka Airport (DAC)', 'MR. MD. BAIZID HOSSAIN', '', '01866977715', '', '', 'cargo', '', 80, 'BS105', '2016-08-31 00:00:00', 0, 12, '104159', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 960, 0, 0, 960, 'Nine Hundred and Sixty', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(599, 'MCD-00599', '', '2016-08-31 15:03:36', 'Dhaka Airport (DAC)', 'MR. MAHFUZ', '', '01775374786', '', '', 'cargo', '', 100, 'BS105', '2016-08-31 00:00:00', 0, 3, '105862', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(600, 'MCD-00600', '', '2016-08-31 15:43:12', 'Dhaka Airport (DAC)', 'MR. BABLU', '', '01726859413', '', '', 'cargo', '', 100, 'BS107', '2016-08-31 00:00:00', 0, 5, '105705', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(601, 'MCD-00601', '', '2016-08-31 15:47:34', 'Chittagong Airport (CGP)', 'mr md ashraf', '', '01976362304', '', '', 'mail_courier', '', 0, 'bs 106', '2016-08-31 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(602, 'MCD-00602', '', '2016-08-31 16:04:43', 'Dhaka Airport (DAC)', 'MR. LAC SUMON', '', '01910295529', '', '', 'cargo', '', 100, 'BS107', '2016-08-31 00:00:00', 0, 3, '103972', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(603, 'MCD-00603', '', '2016-08-31 16:30:48', 'Jessore Airport (JSR)', 'aoc /baf base mtr', '', '01913958338', '', '', 'cargo', '', 100, 'BS-124', '2016-08-31 00:00:00', 0, 3, '278360', '01678054673', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'AOC/ BASE BSR', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(604, 'MCD-00604', '', '2016-08-31 16:44:23', 'Jessore Airport (JSR)', 'MTR/TS/282/16/HQ', '', '01735069150', '', '', 'cargo', '', 100, 'BS-124', '2016-08-31 00:00:00', 0, 7, '258999', '029993404', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 700, 0, 0, 700, 'Seven Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'ADJT / DAC', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(605, 'MCD-00605', '', '2016-08-31 16:50:02', 'Dhaka Airport (DAC)', 'MR. KAMRUZZAMAN', '', '01711176863', '', '', 'cargo', '', 100, 'BS123', '2016-08-31 00:00:00', 0, 3, '07469', '', '', '', '', 'DAC', 'JSR', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(606, 'MCD-00606', '', '2016-08-31 16:52:14', 'Jessore Airport (JSR)', 'mr yasin arafat', '', '01795159527', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-31 00:00:00', 1, 0.1, '245140', '01712637320', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'MR ANIK', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(607, 'MCD-00607', '', '2016-08-31 17:19:37', 'Dhaka Airport (DAC)', 'MR. SAIFUL', '', '01965163971', '', '', 'cargo', '', 80, 'BS107', '2016-08-31 00:00:00', 0, 16, '142374', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1280, 0, 0, 1280, 'One Thousand Two Hundred and Eighty', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(608, 'MCD-00608', '', '2016-08-31 17:30:27', 'Jessore Airport (JSR)', 'MANIK', '', '01716952646', '', '', 'mail_courier', '', 0, 'bs-124', '2016-08-31 00:00:00', 1, 1, '287582', '01718009000', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(609, 'MCD-00609', '', '2016-08-31 17:30:59', 'Dhaka Airport (DAC)', 'MR. ABDUR RAZZAQUE', '', '01730051317', '', '', 'mail_courier', '', 0, 'BS107', '2016-08-31 00:00:00', 1, 1, '142375', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'sheak faisal ahmad', 66, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(610, 'MCD-00610', '', '2016-08-31 17:35:55', 'Jessore Airport (JSR)', 'MR HIRU', '', '01711276677', '', '', 'mail_courier', '', 0, 'BS-124', '2016-08-31 00:00:00', 1, 0.1, '297315', '01717284246', '', '', '', 'JSR', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'Ahsan Kabir', 9, '203.76.120.226', '', 'MR HAFIZUR RAHMAN', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(611, 'MCD-00611', '', '2016-08-31 17:55:04', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 200, '', '2016-08-31 00:00:00', 0, 25, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'RANGPUR\r\nTKT NO: 34137-34161(25x200=5000)', 'RANGPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5000, 0, 0, 5000, 'Five Thousand ', 'RANGPUR\r\nTKT NO: 34137-34161(25x200=5000)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(612, 'MCD-00612', '', '2016-08-31 18:00:43', 'Saidpur Airport (SPD)', 'Tofazzol hossain', '', '01716246304', '', '', 'bus_tkt', '', 250, '', '2016-08-31 00:00:00', 0, 21, '', '', 'BS-151 & BS-152, BS-153 & BS-154', '', 'DINAJPUR\r\nTKT NO:29798-29800 & 34101-34118\r\n(21x250=5250)', 'DINAJPUR(SPD)', 'AIRPORT(SPD)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 5250, 0, 0, 5250, 'Five Thousand Two Hundred and Fifty', 'DINAJPUR\r\nTKT NO:29798-29800 & 34101-34118\r\n(21x250=5250)', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(613, 'MCD-00613', '', '2016-08-31 18:26:21', 'Chittagong Airport (CGP)', 'ms amena akter', '', '01710936387', '', '', 'ebt', '00ip64', 100, 'bs 108', '2016-08-31 00:00:00', 0, 10, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MITHUN GHOSH', 49, '27.147.250.42', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(614, 'MCD-00614', '', '2016-08-31 18:37:02', 'Dhaka Airport (DAC)', 'MR. NAHID', '', '01678054673', '', '', 'cargo', '', 80, 'BS109', '2016-08-31 00:00:00', 0, 7, '154197', '', '', '', '', 'DAC', 'CGP', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 560, 0, 0, 560, 'Five Hundred and Sixty', '', 'sheak faisal ahmad', 66, '115.127.68.26', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(615, 'MCD-00615', '', '2016-08-31 18:46:13', 'Chittagong Airport (CGP)', 'mr rustom', '', '01795494283', '', '', 'cargo', '', 100, 'bs 108', '2016-08-31 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(616, 'MCD-00616', '', '2016-08-31 18:49:04', 'Chittagong Airport (CGP)', 'mr hasan', '', '01727197104', '', '', 'cargo', '', 100, 'bs 108', '2016-08-31 00:00:00', 0, 10, '', '', '', '', '5kg at 100 =500\r\n5kg at 80 =400', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 100, 0, 900, 'Nine Hundred ', '5kg at 100 =500\r\n5kg at 80 =400', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(617, 'MCD-00617', '', '2016-08-31 18:50:21', 'Chittagong Airport (CGP)', 'mr apu', '', '01682408465', '', '', 'mail_courier', '', 0, 'bs 108', '2016-08-31 00:00:00', 1, 1, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(618, 'MCD-00618', '', '2016-08-31 19:16:19', 'Chittagong Airport (CGP)', 'mr nazmul', '', '01820272723', '', '', 'cargo', '', 100, 'bs 108', '2016-08-31 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(619, 'MCD-00619', '', '2016-08-31 19:17:36', 'Chittagong Airport (CGP)', 'mr shamsul alam', '', '01719940446', '', '', 'cargo', '', 100, 'bs 108', '2016-08-31 00:00:00', 0, 3, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MITHUN GHOSH', 49, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(620, 'MCD-00620', '', '2016-08-31 19:28:50', 'Jessore Airport (JSR)', 'KHULNA BUS', '', '01777777836', '', '', 'bus_tkt', '', 250, '', '2016-08-31 00:00:00', 0, 29, '', '', 'BS-121 ,BS-123', '', '27300-28', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7250, 0, 0, 7250, 'Seven Thousand Two Hundred and Fifty', '27300-28', 'Tamanna Mou', 10, '203.76.120.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(621, 'MCD-00621', '', '2016-08-31 20:46:30', 'Chittagong Airport (CGP)', 'MR,MD NISHAD', '', '01730042902', '', '', 'ebt', '00IRUE', 100, 'BS110', '2016-08-31 00:00:00', 0, 10, '', '', '', '', '', 'CGP', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1000, 0, 0, 1000, 'One Thousand ', '', 'MD TAREK MAHMUD', 50, '115.127.49.10', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-08-31 00:00:00'),
(622, 'MCD-00622', '', '2016-09-01 08:16:24', 'Dhaka Airport (DAC)', 'MOHAMMAD IMRAN', '', '01726167770', '', '', 'cargo', '', 80, 'BS 151', '2016-09-01 00:00:00', 0, 24, '111684,111715,111713,111712', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 1920, 0, 0, 1920, 'One Thousand Nine Hundred and Twenty', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(623, 'MCD-00623', '', '2016-09-01 08:19:39', 'Dhaka Airport (DAC)', 'MOHAMMAD IMRAN', '', '01726167770', '', '', 'cargo', '', 80, 'BS 151', '2016-09-01 00:00:00', 0, 46, '111692,111691,111690,111689,111687,111686,111685', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3680, 0, 0, 3680, 'Three Thousand Six Hundred and Eighty', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(624, 'MCD-00624', '', '2016-09-01 08:30:11', 'Dhaka Airport (DAC)', 'RASEL', '', '01913890531', '', '', 'cargo', '', 300, 'BS 151', '2016-09-01 00:00:00', 0, 1, '111678', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'ASHIFUL ISLAM', 56, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(625, 'MCD-00625', '', '2016-09-01 08:30:48', 'Dhaka Airport (DAC)', 'reaz', '', '01718378109', '', '', 'mail_courier', '', 0, 'bs151', '2016-09-01 00:00:00', 1, 1, '111682', '', '', '', '', 'DAC', 'SPD', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200, 0, 0, 200, 'Two Hundred ', '', 'AHMED KHALED SHAMS', 68, '123.200.23.138', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(626, 'MCD-00626', '', '2016-09-01 09:49:35', 'Saidpur Airport (SPD)', 'MR. JAHANGIR ALOM', '', '01735862880', '', '', 'cargo', '', 100, 'BS-152', '2016-09-01 00:00:00', 0, 3, '277195', '01913890531', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(627, 'MCD-00627', '', '2016-09-01 10:34:19', 'Saidpur Airport (SPD)', 'MR. SHAMIM', '', '01750700072', '', '', 'mail_courier', '', 0, 'BS-152', '2016-09-01 00:00:00', 1, 0.1, '296635', '', '', '', '', 'SPD', 'DAC', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 400, 0, 0, 400, 'Four Hundred ', '', 'MD MEHEDI HASAN', 24, '203.76.116.178', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(628, 'MCD-00628', '', '2016-09-01 12:49:35', 'Revenue', '12 Event Travels & Tours', '10000752', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 12900, 0, 0, 12900, 'Twelve Thousand Nine Hundred ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 7, '2016-09-01 12:50:55', '115.127.65.130', 1, '0001-01-01 00:00:00'),
(629, 'MCD-00629', '', '2016-09-01 12:54:14', 'Revenue', 'Nexus Tours & Travels (DAC)', '10054262', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 190000, 0, 0, 190000, 'One Hundred and Ninety Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(630, 'MCD-00630', '', '2016-09-01 12:54:48', 'Revenue', 'Sky Navigator', '10005755', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(631, 'MCD-00631', '', '2016-09-01 12:55:24', 'Revenue', 'Nexus Tours & Travels (DAC)', '10054262', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 100000, 0, 0, 100000, 'One Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(632, 'MCD-00632', '', '2016-09-01 12:56:17', 'Revenue', 'Sky Navigator', '10005755', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 25000, 0, 0, 25000, 'Twenty-Five Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(633, 'MCD-00633', '', '2016-09-01 12:56:57', 'Revenue', 'Nexus Tours & Travels (DAC)', '10054262', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 100000, 0, 0, 100000, 'One Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(634, 'MCD-00634', '', '2016-09-01 12:58:57', 'Revenue', 'R2M World Wide', '10049963', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8500, 0, 0, 8500, 'Eight Thousand Five Hundred ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(635, 'MCD-00635', '', '2016-09-01 12:59:40', 'Revenue', 'CORP Green University', '10308952', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 6600, 0, 0, 6600, 'Six Thousand Six Hundred ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(636, 'MCD-00636', '', '2016-09-01 13:00:33', 'Revenue', 'Nexus Tours & Travels (DAC)', '10054262', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 100000, 0, 0, 100000, 'One Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(637, 'MCD-00637', '', '2016-09-01 13:01:01', 'Revenue', 'Bangla Air Service Tours & Travels', '10041266', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10500, 0, 0, 10500, 'Ten Thousand Five Hundred ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(638, 'MCD-00638', '', '2016-09-01 13:01:42', 'Revenue', '12 Event Travels & Tours', '10000752', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 12060, 0, 0, 12060, 'Twelve Thousand and Sixty', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(639, 'MCD-00639', '', '2016-09-01 13:02:58', 'Revenue', 'Escape Means Limited', '10019677', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 20000, 0, 0, 20000, 'Twenty Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(640, 'MCD-00640', '', '2016-09-01 13:04:24', 'Revenue', '12 Event Travels & Tours', '10000752', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 8300, 0, 0, 8300, 'Eight Thousand Three Hundred ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(641, 'MCD-00641', '', '2016-09-01 13:14:46', 'Revenue', 'Ziyarah Aviation', '10106824', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 7200, 0, 0, 7200, 'Seven Thousand Two Hundred ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(642, 'MCD-00642', '', '2016-09-01 13:16:21', 'Revenue', 'CORP Jamuna Spacetecg Hoint Venture Limited', '10077308', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3700, 0, 0, 3700, 'Three Thousand Seven Hundred ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(643, 'MCD-00643', '', '2016-09-01 13:16:56', 'Revenue', 'Ziyarah Aviation', '10106824', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 22500, 0, 0, 22500, 'Twenty-Two Thousand Five Hundred ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(644, 'MCD-00644', '', '2016-09-01 13:17:55', 'Revenue', 'Nexus Tours & Travels (DAC)', '10054262', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cheque', '-XXXX-XXXX-', 'SCB', '012589', '', '', '', 'Taka', 50000, 0, 0, 50000, 'Fifty Thousand ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-01 00:00:00'),
(645, 'MCD-00645', '', '2016-09-01 13:59:33', 'Revenue', 'TAKEOFF TRAVELS', '10000002', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '', 'Mahamudul Hasan', 8, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(646, 'MCD-00646', '', '2016-09-01 16:39:30', 'Revenue', 'DRAGON BOAT TOURS & TRAVELS', '10000003', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 100000, 0, 0, 100000, 'One Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(647, 'MCD-00647', '', '2016-09-01 16:53:57', 'Revenue', 'Lee Air Service', '10039595', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 50000, 0, 0, 50000, 'Fifty Thousand ', '', 'Software Developer', 14, '8.37.230.1', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(648, 'MCD-00648', '', '2016-09-03 11:03:13', 'Revenue', 'Shirina Air Travels', '10056418', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 16500, 0, 0, 16500, 'Sixteen Thousand Five Hundred ', '', 'Mahamudul Hasan', 8, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(649, 'MCD-00649', '', '2016-09-03 11:03:51', 'Revenue', 'Amazing Tours', '10030386', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 150000, 0, 0, 150000, 'One Hundred and Fifty Thousand ', '', 'Mahamudul Hasan', 8, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(650, 'MCD-00650', '', '2016-09-03 11:35:06', 'Revenue', 'Happy Air Tours Travels', '10000151', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cheque', '-XXXX-XXXX-', 'UCB', '1141021', '', '', '', 'Taka', 50000, 0, 0, 50000, 'Fifty Thousand ', '', 'Mahamudul Hasan', 8, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(651, 'MCD-00651', '', '2016-09-03 14:49:01', 'Revenue', 'Jaas Travel Corporation Ltd', '10000154', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 200000, 0, 0, 200000, 'Two Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(652, 'MCD-00652', '', '2016-09-05 16:34:26', 'Revenue', 'A K Azad Travel & Tours', '10140097', '123456789', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 4567, 0, 0, 4567, 'Four Thousand Five Hundred and Sixty-Seven', '', 'Software Developer', 14, '8.37.230.1', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(653, 'MCD-00653', '', '2016-09-05 17:50:54', 'Revenue', 'TAKEOFF TRAVELS', '10000002', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 100000, 0, 0, 100000, 'One Hundred  Thousand ', '', 'Muhammad Atikur Rashid', 7, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(654, 'MCD-00654', '', '2016-09-06 14:16:52', 'Revenue', 'Alif Travel', '10000677', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 30000, 0, 0, 30000, 'Thirty Thousand ', '', 'Mahamudul Hasan', 8, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(655, 'MCD-00655', '', '2016-09-06 14:17:37', 'Revenue', 'Prime Tours', '10161846', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 16500, 0, 0, 16500, 'Sixteen Thousand Five Hundred ', '', 'Mahamudul Hasan', 8, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(656, 'MCD-00656', '', '2016-09-06 14:23:43', 'Revenue', 'CORP Youngone (CEPZ) Ltd', '10050765', '', '', '', 'agentTopup', '', 0, '', '0001-01-01 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cheque', '-XXXX-XXXX-', 'AB', '8067377', '', '', '', 'Taka', 81800, 0, 0, 81800, 'Eighty-One Thousand Eight Hundred ', '', 'Mahamudul Hasan', 8, '27.147.149.146', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '0001-01-01 00:00:00'),
(657, 'MCD-00657', '', '2016-09-06 17:23:15', 'Revenue', 'International Travel Services (ITS)', '10120337', '', '', '', 'agentTopup', '', 0, '', '2016-09-06 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '', 'Software Developper', 16, '115.127.24.162', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-06 00:00:00'),
(658, 'MCD-00658', '', '2016-09-07 15:22:26', 'Revenue', 'olive', '', '01677803666', '', '', 'bus_tkt', '', 250, '', '2016-09-07 00:00:00', 0, 2, '', '', '121', '', '', 'AIRPORT(JSR)', 'NOAPARA(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Software Developper', 16, '115.127.37.18', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-07 00:00:00'),
(659, 'MCD-00659', '', '2016-09-07 15:26:08', 'Revenue', 'Happy Air Tours Travels', '10000151', '', '', '', 'agentTopup', '', 0, '', '2016-09-07 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 20000, 0, 0, 20000, 'Twenty Thousand ', '', 'Software Developper', 16, '115.127.37.18', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-07 00:00:00'),
(660, 'MCD-00660', '', '2016-09-07 17:58:14', 'Revenue', 'antik', '', '01368248769', '', '', 'bus_tkt', '', 250, '', '2016-09-07 00:00:00', 0, 2, '', '', 'bs121', '', '', 'AIRPORT(JSR)', 'SHIBBARI-MORE(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Software Developper', 16, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-07 00:00:00'),
(661, 'MCD-00661', '', '2016-09-07 18:00:41', 'Revenue', 'Crystal Way Travels', '10000140', '', '', '', 'agentTopup', '', 0, '', '2016-09-07 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 250000, 0, 0, 250000, 'Two Hundred and Fifty Thousand ', '', 'Software Developper', 16, '115.127.65.130', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-07 00:00:00'),
(662, 'MCD-00662', '', '2016-09-08 11:07:14', 'Revenue', 'A-One Air International', '10255005', '', '', '', 'agentTopup', '', 0, '', '2016-09-08 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 255000, 0, 0, 255000, 'Two Hundred and Fifty-Five Thousand ', '', 'Software Developper', 16, '123.200.23.98', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00'),
(663, 'MCD-00663', '', '2016-09-08 11:12:49', 'Revenue', 'A-One Air International', '10255005', '', '', '', 'agentTopup', '', 0, '', '2016-09-08 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 3000000, 0, 0, 3000000, 'Three Million ', '', 'Software Developper', 16, '123.200.23.98', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00'),
(664, 'MCD-00664', '', '2016-09-08 13:19:44', 'Revenue', '12 Event Travels & Tours', '10000752', '', '', '', 'agentTopup', '', 0, '', '2016-09-08 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 10000, 0, 0, 10000, 'Ten Thousand ', '', 'Software Developper', 16, '123.200.23.98', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00'),
(665, 'MCD-00665', '', '2016-09-08 13:24:07', 'Revenue', 'sakib', '', '01777777820', '', '', 'bus_tkt', '', 150, '', '2016-09-08 00:00:00', 0, 2, '', '', 'bs101', '', '', 'AIRPORT(CGP)', 'NASIRABAD(CGP)', 'card', '1202-XXXX-XXXX-3422', 'scb', '', '', '', '', 'Taka', 300, 0, 0, 300, 'Three Hundred ', '', 'Software Developper', 16, '123.200.23.98', 'Visa Card', '', '123', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00'),
(666, 'MCD-00666', '', '2016-09-08 17:04:33', 'Revenue', 'Shirina Air Travels', '10056418', '', '', '', 'agentTopup', '', 0, '', '2016-09-08 00:00:00', 0, 0, '', '', '', '', '', 'SL5', 'SL6', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 50000, 0, 0, 50000, 'Fifty Thousand ', '', 'Software Developper', 16, '115.127.6.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00'),
(667, 'MCD-00667', '', '2016-09-08 17:10:16', 'Revenue', 'Ahmed', '', '01777777812', '', '', 'bus_tkt', '', 250, '', '2016-09-08 00:00:00', 0, 2, '', '', 'bs121', '', '', 'AIRPORT(JSR)', 'NOAPARA(JSR)', 'cash', '-XXXX-XXXX-', '', '', '', '', '', 'Taka', 500, 0, 0, 500, 'Five Hundred ', '', 'Software Developper', 16, '115.127.6.226', '', '', '', 0, '0001-01-01 00:00:00', '', 1, '2016-09-08 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `officeinfo`
--

CREATE TABLE IF NOT EXISTS `officeinfo` (
  `OfficeID` int(11) NOT NULL,
  `Name` varchar(200) DEFAULT NULL,
  `Address` varchar(500) DEFAULT NULL,
  `Contact` varchar(500) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `officeinfo`
--

INSERT INTO `officeinfo` (`OfficeID`, `Name`, `Address`, `Contact`) VALUES
(5, 'Dhaka Airport (DAC)', 'Hazrat Shahjalal International Airport, Airport Road, Sector 1, Kurmitola, Dhaka 1229, Bangladesh', '01777777816-7'),
(6, 'Chittagong Airport (CGP)', 'Shah Amanat International Airport, Potenga Road,South Patenga,Chittagong 4206, Bangladesh', '01777777827-8'),
(7, 'Sylhet Airport (ZYL)', 'Osmani International Airport, Airport Road, Sylhet, 3102, Bangladesh.', '01777777832'),
(8, 'Rajshahi Airport (RJH)', 'Shah Makhdum Airport, \r\nRajshahi - Naogaon Highway, Nowhata, Rajshahi, 6210, Bangladesh.', '01777777853-4'),
(9, 'Barisal Airport (BZL)', 'Barisal Airport, Dhaka-Barisal Highway, Bangladesh', '01777777848-9'),
(10, 'Saidpur Airport (SPD)', 'Saidpur Airport,  Cantoment Rd, Saidpur, Saidpur 5310, Bangladesh.', '01777777844'),
(11, 'Cox''s Bazar Airport (CXB)', 'Cox''s Bazar Airport, Cox''s Bazar 4700, Bangladesh.', '01777777841-2'),
(12, 'Jessore Airport (JSR)', 'Airport Road, 7400', '01777777836-7'),
(13, 'Revenue', 'Arif tower, Kemal Ataturk Avenue, Banani - 1212, Dhaka.', '01777707500'),
(14, 'Audit', '77, Shrawardi Avenue, Baridhara Diplomatic Zone, Dhaka 1212', '+88028822608');

-- --------------------------------------------------------

--
-- Table structure for table `userinfo`
--

CREATE TABLE IF NOT EXISTS `userinfo` (
  `UserID` int(11) NOT NULL,
  `LoginID` varchar(100) DEFAULT NULL,
  `Password` varchar(200) DEFAULT NULL,
  `FullName` varchar(200) DEFAULT NULL,
  `Mobile` varchar(15) DEFAULT NULL,
  `AccessRight` varchar(50) NOT NULL,
  `StationID` int(11) NOT NULL,
  `ModifyDate` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userinfo`
--

INSERT INTO `userinfo` (`UserID`, `LoginID`, `Password`, `FullName`, `Mobile`, `AccessRight`, `StationID`, `ModifyDate`, `ModifiedBy`) VALUES
(7, 'Admin', 'atik@606241', 'Muhammad Atikur Rashid', '01777707500', 'admin', 13, '2016-07-23 10:01:56', 7),
(8, 'hasan0335', 'manhaz1985@', 'Mahamudul Hasan', '01714122790', 'admin', 13, '2016-08-23 16:46:29', 7),
(9, 'kabir0355', 'a99999', 'Ahsan Kabir', '01742252525', 'general', 12, '0001-01-01 00:00:00', 0),
(10, 'mou0326', '123', 'Tamanna Mou', '01915031041', 'general', 12, '0001-01-01 00:00:00', 0),
(11, 'humayun0149', '123', 'Humayun Kabir', '01777707506', 'general', 12, '0001-01-01 00:00:00', 0),
(12, 'shabbir0410', '123', 'Shabbir Hossain', '01777777851', 'general', 12, '0001-01-01 00:00:00', 0),
(13, 'rana0724', '123', 'MD Billal Ahmed', '01717961961', 'general', 12, '0001-01-01 00:00:00', 0),
(14, 'devadmin', 'USBA@321', 'Software Developer', '01913822747', 'admin', 13, '2016-07-27 11:48:22', 14),
(15, 'mahfuz0853', 'mamcd9787', 'Md. Mahfuzur Rahman', '01777707624', 'admin', 13, '0001-01-01 00:00:00', 0),
(16, 'devuser', 'dev@123', 'Software Developper', '01913822747', 'general', 13, '2016-08-16 17:17:05', 14),
(17, 'NAKIB0229', 'farhana', 'JAMIR MD NAKIB US SATTAR', '01777707545', 'general', 11, '0001-01-01 00:00:00', 0),
(18, 'TANBIR0552', 'tanbir0', 'MOHAMMAD TANBIR HOSSAIN', '01716548533', 'general', 11, '0001-01-01 00:00:00', 0),
(19, 'KISHORE0322', '208000', 'KISHORE KUMAR DAS', '01820108000', 'general', 11, '0001-01-01 00:00:00', 0),
(20, 'KAWSAR0823', '0823', 'KAWSAR AHMED', '01922637276', 'general', 11, '0001-01-01 00:00:00', 0),
(21, 'SARJIL0222', '1234', 'SARJIL HASAN', '01777777843', 'general', 11, '0001-01-01 00:00:00', 0),
(22, 'MOHSIN0323', 'a64885312', 'MOHSIN QADER ARIF', '01777777841', 'general', 11, '0001-01-01 00:00:00', 0),
(23, 'RAQUIB0540', '736286rms', 'MD RAQUIB MOSTAQUIM', '01777707623', 'general', 10, '0001-01-01 00:00:00', 0),
(24, 'MEHEDI0549', 'inaaya13122015', 'MD MEHEDI HASAN', '01719366726', 'general', 10, '0001-01-01 00:00:00', 0),
(25, 'RIYAD0698', '321', 'MD RIYAD HOSSAIN', '01721871017', 'general', 9, '0001-01-01 00:00:00', 0),
(26, 'SAIFUR0825', '100', 'MD SAIFUR RAHMAN', '01717655935', 'general', 9, '0001-01-01 00:00:00', 0),
(27, 'RAIHAN0824', '123', 'MD RAIHAN ISLAM', '01719459787', 'general', 9, '2016-08-01 15:57:03', 7),
(28, 'SYED0721', 'iloveu01.', 'SYED MOSTAIN HOSSAIN', '01675828110', 'general', 9, '0001-01-01 00:00:00', 0),
(29, 'sonnet0723', 'loveusonnet', 'KAWSAR ALAM', '01710215097', 'general', 8, '0001-01-01 00:00:00', 0),
(30, 'SOHEL0718', '535418', 'mOSTAFIZUR RAHMAN', '01710535418', 'general', 8, '0001-01-01 00:00:00', 0),
(31, 'MOSHARRAF0821', '222', 'MOSHARRAF HOSSAIN', '01913603024', 'general', 8, '0001-01-01 00:00:00', 0),
(32, 'DHIP0720', 'Ronon@1986', 'ALI REDWONE DHIP', '01977221971', 'general', 8, '0001-01-01 00:00:00', 0),
(33, 'ragib0163', '240382', 'Md ragib rahman', '01911660467', 'general', 7, '0001-01-01 00:00:00', 0),
(34, 'marzan0598', '111', 'marzan ahmed chowdhury', '01717229965', 'general', 7, '0001-01-01 00:00:00', 0),
(35, 'limon0143', '222', 'muhammed belayet ali limon', '01711395249', 'general', 7, '0001-01-01 00:00:00', 0),
(36, 'rezaul0194', '123456', 'syed rezaul karim', '01712566372', 'general', 7, '0001-01-01 00:00:00', 0),
(37, 'khalada0195', 'khan', 'khalada yeasmin', '01717468904', 'general', 7, '0001-01-01 00:00:00', 0),
(38, 'pobitra0722', 'simantojoy', 'POBITRA CHANDRA DAS', '01679201424', 'general', 9, '0001-01-01 00:00:00', 0),
(39, 'AMRAN0882', '01816904090', 'MD AMRAN HOSSAIN', '01816904090', 'general', 6, '0001-01-01 00:00:00', 0),
(40, 'OMAR0217', 'fom440501', 'MD OMAR MARUF', '01816440501', 'general', 6, '0001-01-01 00:00:00', 0),
(41, 'RIZOAN0212', '333', 'md rizoan hossain', '01753102226', 'general', 6, '0001-01-01 00:00:00', 0),
(42, 'TANJID0883', '280990SAMIT', 'MD TANJID ISLAM MAJUMDER', '01676064759', 'general', 6, '0001-01-01 00:00:00', 0),
(43, 'SAHED0213', 'cgp00045', 'SAHEDUZZAMAN SAHED', '01912267906', 'general', 6, '0001-01-01 00:00:00', 0),
(44, 'ISMAIL0602', '01911052146', 'MD ISMAIL HOSSAIN', '01911052146', 'general', 6, '0001-01-01 00:00:00', 0),
(45, 'MAINUL0393', '777', 'MD MAINUL ISLAM', '01677420459', 'general', 6, '0001-01-01 00:00:00', 0),
(46, 'SUMIT0230', '111', 'SUMIT BISWAS', '01816128714', 'general', 6, '0001-01-01 00:00:00', 0),
(47, 'SHOVON0601', 'svn4444#', 'SHOVON CHOWDHURY', '01912562153', 'general', 6, '0001-01-01 00:00:00', 0),
(48, 'MONIR0219', 'monir_3210#', 'MONIR AHMED', '01711205587', 'general', 6, '0001-01-01 00:00:00', 0),
(49, 'MITHUN1065', '01672605767', 'MITHUN GHOSH', '01818150578', 'general', 6, '0001-01-01 00:00:00', 0),
(50, 'TAREK0822', 'mifta@2015', 'MD TAREK MAHMUD', '01716085047', 'general', 6, '0001-01-01 00:00:00', 0),
(51, 'ALI0764', 'DIIIPU1414', 'MD EKRAM ALI DIPU', '01780000030', 'general', 6, '0001-01-01 00:00:00', 0),
(52, 'MOHIUDDIN0218', 'mohiuddin', 'MOHIUDDIN', '01855426240', 'general', 6, '0001-01-01 00:00:00', 0),
(53, 'MUNTASIR0489', '04muntasir89', 'MUNTASIR MAMUN', '01717963460', 'general', 6, '0001-01-01 00:00:00', 0),
(54, 'TARIK0549', 'lovebird7@f', 'TARIKUL ISLAM', '01713175773', 'viewer', 14, '0001-01-01 00:00:00', 0),
(55, 'swapon0539', 'swapnochura', 'saiful islam', '01916878185', 'viewer', 14, '0001-01-01 00:00:00', 0),
(56, 'ASIFUL0153', 'asnm23780.///', 'ASHIFUL ISLAM', '01675621077', 'general', 5, '0001-01-01 00:00:00', 0),
(57, 'FERDOUS0180', 'farkgW937779', 'FERDOUS AHMAD', '01615707777', 'general', 5, '0001-01-01 00:00:00', 0),
(58, 'ARAFAT0812', '111091138', 'MD. IBNE ARAFAT MAZUMDER', '01911662987', 'general', 5, '0001-01-01 00:00:00', 0),
(59, 'KHALED1012', '123', 'MD. KHALED BIN KHALIL', '01676028738', 'general', 5, '0001-01-01 00:00:00', 0),
(60, 'RONY0165', 'us@bangla#', 'SHEIK MD KAMRUZZAMAN RONY', '01777707511', 'general', 5, '0001-01-01 00:00:00', 0),
(61, 'NAHIDA0603', 'nahi616', 'NAHIDA SULTANA', '01686411047', 'general', 5, '0001-01-01 00:00:00', 0),
(62, 'ALVINA0365', '0001', 'ALVINA KHAN', '01717727545', 'general', 5, '0001-01-01 00:00:00', 0),
(63, 'MEHEDI0123', '123', 'MEHEDI HASAN', '01812875616', 'general', 5, '0001-01-01 00:00:00', 0),
(64, 'SALEH0191', 'ahmed', 'SALEH UDDIN', '01777707510', 'general', 5, '0001-01-01 00:00:00', 0),
(65, 'ASIF1024', 'asif13579', 'ASIF SIDDIQUE', '01711933807', 'general', 5, '0001-01-01 00:00:00', 0),
(66, 'FAisal0226', 'skk*.5656#', 'sheak faisal ahmad', '01676275576', 'general', 5, '0001-01-01 00:00:00', 0),
(67, 'SALEH0112', '351983', 'SALEH SERAJ', '01819130075', 'general', 5, '0001-01-01 00:00:00', 0),
(68, 'SHAMS0145', '123', 'AHMED KHALED SHAMS', '01741381424', 'general', 5, '0001-01-01 00:00:00', 0),
(69, 'ziad0397', '01710829788', 'ziad rahman', '01710829788', 'general', 5, '0001-01-01 00:00:00', 0),
(70, 'tanvir0997', '123', 'tanvir ahmed khan', '01711222717', 'general', 5, '0001-01-01 00:00:00', 0),
(71, 'lorence1020', '39839013loN', 'bodruddoza lorence', '01671413371', 'general', 5, '0001-01-01 00:00:00', 0),
(72, 'akib0832', 'palash1', 'md akibuzzaman', '01716339248', 'general', 5, '0001-01-01 00:00:00', 0),
(73, 'masum1068', '123', 'masum ahmed', '01722216250', 'general', 5, '0001-01-01 00:00:00', 0),
(74, 'ettahat0605', '123', 'ettahat hossaen', '01673020121', 'general', 5, '0001-01-01 00:00:00', 0),
(75, 'RIMON1069', '123', 'rIMON CHOWDHURY', '01676613734', 'general', 5, '0001-01-01 00:00:00', 0),
(76, 'SHAFI0833', '062863381', 'MD SHAFI ULLAH', '01670726640', 'general', 5, '0001-01-01 00:00:00', 0),
(77, 'MOWSUMI0816', '123', 'MOWSUMI AKTER', '01716121377', 'general', 5, '0001-01-01 00:00:00', 0),
(78, 'SADIA0127', '123', 'SADIA HASAN', '01682778455', 'general', 5, '0001-01-01 00:00:00', 0),
(79, 'MD', 'md@2016', 'Mohammed Abdullah Al Mamun', '01777707684', 'admin', 14, '0001-01-01 00:00:00', 0);

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfo`
--
DROP TABLE IF EXISTS `mcddepositinfo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfo` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`mcdinfo` `m` left join `depositinfo` `d` on((`d`.`MCDID` = `m`.`MCDID`))) order by `m`.`MCDDate` desc;

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfobymcdno`
--
DROP TABLE IF EXISTS `mcddepositinfobymcdno`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfobymcdno` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`depositinfo` `d` join `mcdinfo` `m` on((`d`.`MCDID` = `m`.`MCDID`))) where (`d`.`MCD_NO` like `m`.`AutoSerial`) order by `m`.`MCDDate` desc;

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfobymcdnoanduser`
--
DROP TABLE IF EXISTS `mcddepositinfobymcdnoanduser`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfobymcdnoanduser` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`depositinfo` `d` join `mcdinfo` `m` on((`d`.`MCDID` = `m`.`MCDID`))) order by `m`.`MCDDate` desc;

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfodateanduserwise`
--
DROP TABLE IF EXISTS `mcddepositinfodateanduserwise`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfodateanduserwise` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`depositinfo` `d` join `mcdinfo` `m` on((`d`.`MCDID` = `m`.`MCDID`))) order by `m`.`MCDDate` desc;

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfodatewise`
--
DROP TABLE IF EXISTS `mcddepositinfodatewise`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfodatewise` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`depositinfo` `d` join `mcdinfo` `m` on((`d`.`MCDID` = `m`.`MCDID`))) order by `m`.`MCDDate` desc;

-- --------------------------------------------------------

--
-- Structure for view `mcddepositinfouserwise`
--
DROP TABLE IF EXISTS `mcddepositinfouserwise`;

CREATE ALGORITHM=UNDEFINED DEFINER=`9fe69b_premcd`@`%` SQL SECURITY DEFINER VIEW `mcddepositinfouserwise` AS select `d`.`DEPOSITID` AS `McdDepositID`,`d`.`MCD_NO` AS `MCD_NO`,`m`.`MCDDate` AS `MCDDate`,`m`.`StationOffice` AS `StationOffice`,`m`.`CorporateID` AS `CorporateID`,`m`.`CustomerName` AS `CustomerName`,`m`.`ModeOfPayment` AS `ModeOfPayment`,`d`.`DEPOSIT_RECEIVE_DATE` AS `DEPOSIT_RECEIVE_DATE`,`d`.`DEPOSIT_TYPE` AS `DEPOSIT_TYPE`,`d`.`DepositedAmount` AS `DepositedAmount`,`d`.`BANK_NAME` AS `BANK_NAME`,`m`.`ChequeNo` AS `ChequeNo`,`d`.`VoidStatus` AS `VoidStatus`,`d`.`TopUpStatus` AS `TopUpStatus`,`m`.`IssuerID` AS `IssuerID`,`m`.`CollectionPurpose` AS `CollectionPurpose` from (`depositinfo` `d` join `mcdinfo` `m` on((`d`.`MCDID` = `m`.`MCDID`))) order by `m`.`MCDDate` desc;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agencies`
--
ALTER TABLE `agencies`
  ADD PRIMARY KEY (`AgencyID`);

--
-- Indexes for table `depositinfo`
--
ALTER TABLE `depositinfo`
  ADD PRIMARY KEY (`DEPOSITID`),
  ADD KEY `MCDID` (`MCDID`);

--
-- Indexes for table `mcdinfo`
--
ALTER TABLE `mcdinfo`
  ADD PRIMARY KEY (`MCDID`),
  ADD KEY `MCDDate` (`MCDDate`),
  ADD KEY `CollectionPurpose` (`CollectionPurpose`),
  ADD KEY `ModeOfPayment` (`ModeOfPayment`);

--
-- Indexes for table `officeinfo`
--
ALTER TABLE `officeinfo`
  ADD PRIMARY KEY (`OfficeID`),
  ADD KEY `OfficeID` (`OfficeID`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD PRIMARY KEY (`UserID`),
  ADD KEY `LoginID` (`LoginID`),
  ADD KEY `Password` (`Password`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `agencies`
--
ALTER TABLE `agencies`
  MODIFY `AgencyID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1914;
--
-- AUTO_INCREMENT for table `depositinfo`
--
ALTER TABLE `depositinfo`
  MODIFY `DEPOSITID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `mcdinfo`
--
ALTER TABLE `mcdinfo`
  MODIFY `MCDID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=668;
--
-- AUTO_INCREMENT for table `officeinfo`
--
ALTER TABLE `officeinfo`
  MODIFY `OfficeID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `userinfo`
--
ALTER TABLE `userinfo`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=80;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
