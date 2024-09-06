LET $flag = 'OA';

UPDATE IN SCENARIO 'AAA' 
SET system_type = 'sanitary' 
WHERE chamber_area_flag = $flag;

UPDATE IN SCENARIO 'AAO' 
SET system_type = 'sanitary' 
WHERE chamber_area_flag = $flag;

UPDATE IN SCENARIO 'AAV' 
SET system_type = 'sanitary' 
WHERE chamber_area_flag = $flag;

UPDATE IN SCENARIO 'AAW' 
SET system_type = 'sanitary' 
WHERE chamber_area_flag = $flag;