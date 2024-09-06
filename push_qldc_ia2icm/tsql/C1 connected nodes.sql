/*  
object type: all nodes and links
purpose: select the network thats important for the wastewater hydraulic model
*/

DESELECT ALL;

list $system = 'WWCO', 'WWPR';
list $status = 'INUS', 'REPU', 'STOK', 'END', 'VIRT';

SELECT ALL FROM [Node] IN Base SCENARIO
WHERE MEMBER(status,$status)=TRUE 
AND MEMBER(system_type,$system)=TRUE; 

SELECT ALL FROM [All Links] IN Base SCENARIO 
WHERE MEMBER(status,$status)=TRUE 
AND MEMBER(system_type,$system)=TRUE;

DESELECT ALL FROM [All Nodes] 
WHERE count(ds_links.*)=0 AND count(us_links.*)=0;