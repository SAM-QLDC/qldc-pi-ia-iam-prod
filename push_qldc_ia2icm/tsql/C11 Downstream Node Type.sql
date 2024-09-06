/*  
object type: node
purpose: find what type of headloss needs to be applied to each pipe
*/

CLEAR SELECTION;

/* citeria */
LIST $none ='TRNK';

/* select nodes and pipes as a check */
SELECT ALL FROM [Pipe] 
WHERE ANY(ds_links.node_type=$none)