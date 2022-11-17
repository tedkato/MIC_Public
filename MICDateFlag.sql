--MICDateFlag.sql--
-- tblLoanData
-- Count the number of rows in tblLoanData will be affected (requested date <> current date)
select count(*) 
from DATAUPDT.MICDateFlag UY 
inner join celink.tblloandata T1 
ON    UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND   date(UY.new_MICDate) <> date(coalesce(T1.MICENDORSEDDATE, '1900-01-01'))
with ur; 

-- update tblloandata
MERGE INTO celink.TBLLOANDATA AS T1 
USING DATAUPDT.MICDateFlag UY 
ON    UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND   date(UY.new_MICDate) <> date(coalesce(T1.MICENDORSEDDATE, '1900-01-01'))
WHEN MATCHED THEN UPDATE 
SET 
	T1.MICENDORSEDDATE  = UY.new_MICDate 
;

-- Count the number of rows in tblLoanData have been affected (requested date = current date) 
select count(*) 
from DATAUPDT.MICDateFlag UY 
inner join celink.tblloandata T1 
ON    UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND   date(UY.new_MICDate) = date(T1.MICENDORSEDDATE)
with ur;


-- tblPropertyDescription
-- Count the number of rows in tblPropertyDescription will be affected (requested date <> current date) 
select 	count(*) 
from 	DATAUPDT.MICDateFlag UY 
inner 	join celink.tblPropertyDescription T2
ON    	UY.LoanNum = T2.INTSUBSERVICERLOANNUMBER 
and     date(UY.new_MICDate) <> date(coalesce(T2.DTMMICENDORSEDATE, '1900-01-01'))
with ur;

-- update tblPropertyDescription
MERGE INTO celink.tblPropertyDescription AS T2 
USING DATAUPDT.MICDateFlag UY
on    UY.LoanNum = T2.INTSUBSERVICERLOANNUMBER
and   date(UY.new_MICDate) <> date(coalesce(T2.DTMMICENDORSEDATE, '1900-01-01'))
WHEN MATCHED THEN UPDATE 
SET 
	T2.DTMMICENDORSEDATE     = UY.new_MICDate,
	T2.BTNMICENDORSERECEIVED = -1 
 ;

-- Count the number of rows in tblPropertyDescription where (requested date = current date) 
select 	count(*) 
from 	DATAUPDT.MICDateFlag UY 
inner 	join celink.tblPropertyDescription T2
ON    	UY.LoanNum = T2.INTSUBSERVICERLOANNUMBER 
and  	date(UY.new_MICDate) = date(T2.DTMMICENDORSEDATE)
with ur;


-- Note insertion  
-- Count the number of existing notes
select count(*) from celink.tblLoanNotes for read only with ur; 

Insert into celink.tblLoanNotes 
	(INTSUBSERVICERLOANNUMBER, CHRLOANNOTES, DTMNOTEDATE, CHRUSERID, BLNPRIORITY)
select LOAN, LOANNOTES, CURRENT_TIMESTAMP, USERID, PRIORITY from DATAUPDT.LOANNOTES_TKATO order by LOAN ;

-- Count the number of existing notes again    
select count(*) from celink.tblLoanNotes for read only with ur; 