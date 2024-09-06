//work out upstream pops and areas for each link 

LIST $cur = 'Foul', 'foul', 'Combined', 'combined';

//cur population
UPDATE [Subcatchment] SET $cur_sub_pop = IIF(MEMBER(system_type, $cur) = 1, population, 0);
UPDATE [Node] SET $cur_pop = SUM(subcatchments.$cur_sub_pop); 
SET $cur_pipe_pop = NVL(us_node.$cur_pop, 0);
SET $cur_us_pop = NVL(SUM(all_us_links.$cur_pipe_pop), 0);
SET $cur_pop_calc = IIF(($cur_pipe_pop + $cur_us_pop) = 0, 0, $cur_pipe_pop + $cur_us_pop);

//cur catchment areas
UPDATE [Subcatchment] SET $cur_sub_area = IIF(MEMBER(system_type, $cur) = 1, total_area, 0);
UPDATE [Node] SET $cur_area = SUM(subcatchments.$cur_sub_area); 
SET $cur_pipe_area = NVL(us_node.$cur_area, 0);
SET $cur_us_area = NVL(SUM(all_us_links.$cur_pipe_area), 0);
SET $cur_area_calc = IIF(($cur_pipe_area + $cur_us_area) = 0, 0, $cur_pipe_area + $cur_us_area);

//cur additional foul flow
UPDATE [Subcatchment] SET $cur_addff = additional_foul_flow*1000;
UPDATE [Node] SET $cur_add_ff = SUM(subcatchments.$cur_addff);
SET $cur_pipe_add_ff = NVL(us_node.$cur_add_ff, 0);
SET $cur_us_add_ff = NVL(SUM(all_us_links.$cur_pipe_add_ff), 0);
SET $cur_add_ff_calc = IIF(($cur_pipe_add_ff + $cur_us_add_ff) = 0, 0, $cur_pipe_add_ff + $cur_us_add_ff);

//cur baseflow
UPDATE [Subcatchment] SET $cur_baseflow = base_flow*1000;
UPDATE [Node] SET $cur_base = SUM(subcatchments.$cur_baseflow);
SET $cur_pipe_base = NVL(us_node.$cur_base, 0);
SET $cur_us_base = NVL(SUM(all_us_links.$cur_pipe_base), 0);
SET $cur_base_calc = IIF(($cur_pipe_base + $cur_us_base) = 0, 0, $cur_pipe_base + $cur_us_base);

//cur tradeflow
//usually used as seasonal baseflow for WWL models
UPDATE [Subcatchment] SET $cur_tradeflow = trade_flow*1000;
UPDATE [Node] SET $cur_trade = SUM(subcatchments.$cur_tradeflow);
SET $cur_pipe_trade = NVL(us_node.$cur_trade, 0);
SET $cur_us_trade = NVL(SUM(all_us_links.$cur_pipe_trade), 0);
SET $cur_trade_calc = IIF(($cur_pipe_trade + $cur_us_trade) = 0, 0, $cur_pipe_trade + $cur_us_trade);

//export results to CSV files
SELECT network.id AS network_id
	, oid
	, asset_uid
	, asset_id
	, $cur_pop_calc AS cur_cum_population
	, $cur_area_calc AS cur_cum_area
	, $cur_add_ff_calc AS cur_cum_additional_foul_flow
	, $cur_base_calc AS cur_cum_baseflow
	, $cur_trade_calc AS cur_cum_tradeflow
INTO FILE 'C:\Users\HLewis\Downloads\ww_sewer_overflows\icm_cumulative_totals\exports\ua.csv'