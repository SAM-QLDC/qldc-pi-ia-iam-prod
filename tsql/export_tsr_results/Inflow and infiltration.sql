//SET $timesteps = MAX(tsr.timesteps);
SET $timesteps = 1;
SET $factor = 365*24*60*60;
SET $pop = population;

SET $qfoul = ($timesteps*AVG(tsr.qfoul))*$factor;
SET $qpop = (AVG(tsr.qfoul)*(1000*24*60*60))/$pop;
SET $qsurf01 = ($timesteps*AVG(tsr.qsurf01))*$factor;
SET $qsurf02 = ($timesteps*AVG(tsr.qsurf02))*$factor;
SET $qsurf03 = ($timesteps*AVG(tsr.qsurf03))*$factor;
SET $qsoil = ($timesteps*AVG(tsr.qsoil))*$factor;
SET $qtrade = ($timesteps*AVG(tsr.qtrade))*$factor;
SET $total = ($timesteps*AVG(tsr.qcatch))*$factor;
SET $base = ($timesteps*AVG(tsr.qbase))*$factor;
SET $qhard = ($qsurf01 + $qsurf02);

SELECT network.id AS network_id, oid, subcatchment_id
	, $qpop AS l_person_day 
	, $qfoul AS qfoul
	, $qtrade AS qtrade
	, $qhard AS qhard
	, $qsurf03 AS qpermeable
	, $qsoil AS qsoil
	, $total AS total
	, $base AS base
INTO FILE 'C:\Users\HLewis\Downloads\ww_sewer_overflows\icm_inflow_infiltration\exports\ii.csv'
WHERE system_type = 'foul';