LET $flag = 'OA';

UPDATE IN SCENARIO 'AAA' SET system_type = 'sanitary' WHERE diameter_flag = $flag;
UPDATE IN SCENARIO 'AAO' SET system_type = 'sanitary' WHERE diameter_flag = $flag;
UPDATE IN SCENARIO 'AAV' SET system_type = 'sanitary' WHERE diameter_flag = $flag;
UPDATE IN SCENARIO 'AAW' SET system_type = 'sanitary' WHERE diameter_flag = $flag;

UPDATE IN SCENARIO 'AAA' SET us_node.system_type = 'sanitary' WHERE system_type = 'sanitary';
UPDATE IN SCENARIO 'AAO' SET us_node.system_type = 'sanitary' WHERE system_type = 'sanitary';
UPDATE IN SCENARIO 'AAV' SET us_node.system_type = 'sanitary' WHERE system_type = 'sanitary';
UPDATE IN SCENARIO 'AAW' SET us_node.system_type = 'sanitary' WHERE system_type = 'sanitary';