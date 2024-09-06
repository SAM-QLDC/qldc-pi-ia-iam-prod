/*  
object type: manhole survey
purpose: creates GPS survey points where
there is a cover level
*/

INSERT INTO [GPS Survey]
(id, x, y, elevation, survey_date, schedule_number, asset_id)
SELECT node_id, x, y, cover_level, year_laid, 0, node_id
WHERE cover_level>0;