/*  
object type: all_links
purpose: 
*/

DESELECT ALL;
CLEAR SELECTION;

LIST $pipes = 'PN','SN','CL';

//SELECT ALL FROM [All Links] WHERE MEMBER(left(pipe_class,2),$pipes)=TRUE;
//SELECT ALL FROM [All Links] WHERE user_text_24 = 'PRES'

SELECT ALL FROM [All Links] WHERE system_type='WWPR';
SELECT ALL FROM [All Nodes] WHERE system_type='WWPR';