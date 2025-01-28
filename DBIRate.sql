----------------------------------------------------------------------------------------------------
-- DBIrate.sql --
-- Count the number of rows in tblLoanData will be affected -- JAVATest 12585
select count(*) 
from DATAUPDT.MICDateFlagDBI UY 
inner join celink.tblloandata T1 
ON    UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND   (UY.new_DBI <> coalesce(T1.DebentureIntRate, 0.00))
with ur; 

-- update tblloandata
MERGE INTO celink.TBLLOANDATA AS T1 
USING      DATAUPDT.MICDateFlagDBI UY 
ON         UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND        (UY.new_DBI <> coalesce(T1.DebentureIntRate, 0.00))
WHEN MATCHED THEN UPDATE 
SET 
T1.DebentureIntRate  = UY.new_DBI 
;

-- Count the number of rows in tblLoanData have been affected (requested date = current date)  -- JAVATest 12585
select count(*) 
from DATAUPDT.MICDateFlagDBI UY 
inner join celink.tblloandata T1 
ON    UY.LoanNum = T1.INTSUBSERVICERLOANNUMBER 
AND   (UY.new_DBI = coalesce(T1.DebentureIntRate, 0.00))
with ur;


----------------------------------------------------------------------------------------------------
-- Note insertion  
-- Count the number of existing notes
select count(*) from celink.tblLoanNotes for read only with ur;  --JAVATest 151380282

Insert into celink.tblLoanNotes 
(INTSUBSERVICERLOANNUMBER, CHRLOANNOTES, DTMNOTEDATE, CHRUSERID, BLNPRIORITY, NoteStep)
select LOAN, LOANNOTES, CURRENT_TIMESTAMP, USERID, PRIORITY, 0 "NoteStep" from DATAUPDT.LOANNOTES_TKATO order by LOAN;  
		
-- Count the number of existing notes again    
select count(*) from celink.tblLoanNotes for read only with ur; --JAVATest 151392867 ... 151392867 = (select 151380282 + 12585 from sysibm.sysdummy1;)
		
		
