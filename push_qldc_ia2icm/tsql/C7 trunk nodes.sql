/*  
object type: node
purpose: check on SQL required in config file to export useful pipe_types to the node
*/

CLEAR SELECTION;

/* citeria */
LET $search ='TRNK';

/* select statement for checking on outputs
SELECT node_id, system_type, status, 
(ANY(ds_links.pipe_type=$search) + ANY(us_links.pipe_type=$search)) AS trunk;

/* select nodes and pipes as a check */
SELECT ALL FROM [Node] WHERE ANY(ds_links.pipe_type=$search)+ANY(us_links.pipe_type=$search)>0;
SELECT ALL FROM [All Links] WHERE pipe_type = $search;