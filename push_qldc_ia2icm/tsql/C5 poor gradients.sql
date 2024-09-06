CLEAR SELECTION; 

SELECT ALL WHERE system_type='WWCO'
AND (gradient <= 0 OR gradient is null)
AND system_type ='WWCO'
AND status = 'INUS';