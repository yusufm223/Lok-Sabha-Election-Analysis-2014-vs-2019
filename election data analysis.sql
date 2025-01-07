
select * from constituency_wise_results_2014;

-- Updating misspeled name
	update constituency_wise_results_2014
	set pc_name = REPLACE(pc_name ,'chelvella', 'chevella');

-- Creating view andhra_state
	create view andhra_state_view as
	  select 
			state,
			pc_name
	  from constituency_wise_results_2014
	  where state = 'Andhra Pradesh';

	select * from andhra_state_view;

-- updating state name andhra pardesh to telangana 
	update andhra_state_view
	set state = 'Telangana'
	where pc_name in ('adilabad','Bhongir ','chevella', 'Hyderabad','Karimnagar ', 'Khammam ', 'Mahabubabad ',
					  'Mahbubnagar', 'Malkajgiri', 'Medak', 'Nagarkurnool', 'Nalgonda', 'Nizamabad','peddapalle',
					  'Secundrabad','Warangal','Zahirabad');
 
 --converting all columns in lower case 
 
 UPDATE  constituency_wise_results_2014
 SET  state = LOWER (state);

 UPDATE  constituency_wise_results_2014
 SET  pc_name = lower (pc_name);

 UPDATE  constituency_wise_results_2014
 SET  candidate = lower(candidate);

 UPDATE  constituency_wise_results_2014
 SET  sex = lower (sex);

 UPDATE  constituency_wise_results_2014
 SET  category = lower (category);

  UPDATE  constituency_wise_results_2014
 SET  party = lower(party);

 UPDATE  constituency_wise_results_2014
 SET  party_symbol = lower(party_symbol);


-- changing  'Dadar And Nagar Haveli' to 'dadra and nagar haveli' 
update constituency_wise_results_2014
set pc_name = 'dadra and nagar haveli'
where pc_name = 'Dadar And Nagar Haveli';	

-- Trim some coloumn
		 
update constituency_wise_results_2014
set state = TRIM(state);
	
update constituency_wise_results_2014
set pc_name = TRIM(pc_name);
	   
update constituency_wise_results_2014
set candidate = TRIM(candidate);

------------------------------------------------------------------------------

select * from constituency_wise_results_2019;		



 --converting all columns in lower case 
 
 UPDATE  constituency_wise_results_2019
 SET  state = LOWER (state);

 UPDATE  constituency_wise_results_2019
 SET  pc_name = lower (pc_name);

 UPDATE  constituency_wise_results_2019
 SET  candidate = lower(candidate);

 UPDATE  constituency_wise_results_2019
 SET  sex = lower (sex);

 UPDATE  constituency_wise_results_2019
 SET  category = lower (category);

  UPDATE  constituency_wise_results_2019
 SET  party = lower(party);

 UPDATE  constituency_wise_results_2019
 SET  party_symbol = lower(party_symbol);

 -- updating male to 'm'
 
 update  constituency_wise_results_2019
 set sex = 'm'
 where  sex = 'male';

 -- updating female to 'f'

 update  constituency_wise_results_2019
 set sex = 'f'
 where  sex = 'female';

 update constituency_wise_results_2019
 set category = REPLACE(category, 'general', 'gen');
 




 --------------------------------------------------------------------------------------------

select * from dim_states_codes;

update dim_states_codes
set state_name = LOWER(state_name);

update dim_states_codes
set abbreviation = lower(abbreviation);


------------------------------------------------------------------------------------------------
select * from constituency_wise_results_2014;
select * from constituency_wise_results_2019;
select * from dim_states_codes;


select     
           state, pc_name,candidate, sum(total_votes) as total_cons_votes, 
           total_electors,
           round((100.0 * (sum(total_votes))/total_electors) ,2) as cons_voting_perc,
		   (total_electors - (sum(total_votes))) as diff
		   --round((100.0 * (total_electors - (sum(total_votes)))/total_electors),2)
from constituency_wise_results_2014
where state = 'andhra pradesh' and pc_name = 'aruku'
group by state, pc_name, total_electors, candidate 
 ;

with rnk_wise_result_2014 as (
		select    
				   state, 
				   pc_name,
				   candidate, 
				   total_votes, 
				   sum(total_votes) over(partition by state, pc_name) as total_voters_voting,
				   round((100.0 * (total_votes)/sum(total_votes) over(partition by state, pc_name)) ,2) as cons_voting_perc,
				   total_electors,
				   rank()over(partition by state, pc_name order by total_votes desc) as rnk
				   
		from constituency_wise_results_2014
		--where state = 'telangana' and pc_name = 'hyderabad'
		group by state, pc_name, total_votes,total_electors, candidate
		
)

select * from rnk_wise_result_2014
where rnk <=2
;

----------------------------------------------------------------------------------------------------


-- Total electors 2014
	select sum(distinct total_electors) as total_electors_2014
	from constituency_wise_results_2014
	

     -- Total electors 2019
	select sum(distinct total_electors) as total_electors_2019
	from constituency_wise_results_2019

----------------------------------------------------------------------------------------------------

-- Vote percentage 2014
    
   select 100.0 * sum(total_votes)/sum(distinct total_electors) as vote_perc_2014
   from constituency_wise_results_2014;

 -- Vote percentage 201
    
   select 100.0 * sum(total_votes)/sum(distinct total_electors) as vote_perc_2019
   from constituency_wise_results_2019;

----------------------------------------------------------------------------------------------------



--Questions 1 :- List top 5 constituency in 2014 in terms of voters turnout ratio?
--Voter Turnout Ratio = (Total Votes Cast / Total Electors)× 100%


select * from constituency_wise_results_2014;

select  top 5  pc_name, sum(total_votes) as total_votes_cast, total_electors,
       round(100.0 * (sum(total_votes))/total_electors ,2) as Voter_Turnout_Ratio
	   --row_number() over(order by 100.0 * (sum(total_votes))/total_electors desc) as rnk
from constituency_wise_results_2014
group by state, pc_name ,total_electors
order by round(100.0 * (sum(total_votes))/total_electors ,2) desc; 

--Questions 2 :- List bottom 5 constituency in 2014 in terms of voters turnout ratio?
--Voter Turnout Ratio = (Total Votes Cast / Total Electors)× 100%

select  top 5  state, pc_name, sum(total_votes)as total_votes_cast, total_electors,
       round(100.0 * (sum(total_votes))/total_electors ,2)as Voter_Turnout_Ratio,
	   row_number() over(order by 100.0 * (sum(total_votes))/total_electors ) as rnk
from constituency_wise_results_2014
group by state, pc_name, total_electors; 

--Questions 3 :- List top 5 constituency in 2019 in terms of voters turnout ration?
--Voter Turnout Ratio = (Total Votes Cast / Total Electors)× 100%


select  top 5  state, pc_name, sum(total_votes)as total_votes_cast, total_electors,
       100.0 * (sum(total_votes))/total_electors as Voter_Turnout_Ratio,
	   row_number() over(order by 100.0 * (sum(total_votes))/total_electors desc) as rnk
from constituency_wise_results_2019
group by state, pc_name, total_electors;


--Questions 4 :- List bottom 5 constituency in 2019 in terms of voters turnout ration?
--Voter Turnout Ratio = (Total Votes Cast / Total Electors)× 100%


select  top 5  state, pc_name, sum(total_votes)as total_votes_cast, total_electors,
       100.0 * (sum(total_votes))/total_electors as Voter_Turnout_Ratio,
	   row_number() over(order by 100.0 * (sum(total_votes))/total_electors ) as rnk
from constituency_wise_results_2019
group by state, pc_name, total_electors; 


--Questions 6 :- List top 5 states in 2014 in terms of voters turnout ration?


	select  top 5 
	        state, 
		    100.0 * sum(total_votes)/sum(distinct total_electors) as Voter_Turnout_Ratio
	from constituency_wise_results_2014
	group by state
	order by Voter_Turnout_Ratio desc; 

--Questions 7 :- List bottom 5 states in 2014 in terms of voters turnout ration?

	select  top 5 
	        state, 
		    round(100.0 * sum(total_votes)/sum(distinct total_electors),2) as Voter_Turnout_Ratio
	from constituency_wise_results_2014
	group by state
	order by Voter_Turnout_Ratio; 

--Questions 8 :- List top 5 states in 2019 in terms of voters turnout ration?
    
	select  top 5 
	        state, 
		    round(100.0 * sum(total_votes)/sum(distinct total_electors),2) as Voter_Turnout_Ratio
	from constituency_wise_results_2019
	group by state
	order by Voter_Turnout_Ratio desc; 

--Questions 9 :- List bottom 5 states in 2019 in terms of voters turnout ration?
    
		select  top 5 
	        state, 
		    round(100.0 * sum(total_votes)/sum(distinct total_electors),2) as Voter_Turnout_Ratio
	from constituency_wise_results_2019
	group by state
	order by Voter_Turnout_Ratio;

-- 10 :- Which consituency have elected the same party for two consecutive elections, rank them by % of votes 
--       to that winning party in 2019.
   

 with winning_2014 as (
    select 
          state,
		  pc_name,
		  party as winning_party_2014,
		  rank() over(partition by pc_name order by total_votes desc)as rnk
   from
   constituency_wise_results_2014
  ),

  top_winning_2014 as (
  select 
        *
  from
  where rnk =1
  ),

  winning_2019 as(
  select 
          state,
		  pc_name,
		  party as winning_party_2019,
		  rank() over(partition by pc_name order by total_votes desc)as rnk
   from
   constituency_wise_results_2019
   ),

      top_winning_2019 as (
   
	   select state,
		  pc_name,
		  party as winning_party_2019 ,
	           total_votes * 100.0 / SUM(total_votes) OVER (PARTITION BY pc_name) AS vote_percentage_2019
    FROM 
        winning_2019
	   where rnk =1
	)
-----------------------------------------------------------------------------------------------------

-- Top 5 candidates based on margin diffrence with runners in 2014.
CREATE VIEW winner_runner_2014 as 
		 select pc_name,
				candidate,
				total_votes,
				rank()over(partition by pc_name order by total_votes desc) as ranking
				from (
				 select 
						pc_name,
						candidate,
						total_votes,
						rank() over(partition by pc_name order by total_votes desc) as rnk
				 from constituency_wise_results_2014	
 
		 ) as x
		 where rnk <=2;


select * from winner_runner_2014; 

with margin_diff_2014 as (
 select 
            pc_name,
			candidate,
			total_votes,
           
		   lag(total_votes) over(partition by pc_name order by total_votes) as runner_votes,
		   total_votes - lag(total_votes) over(partition by pc_name order by total_votes) as margin_diff
 from winner_runner_2014
 )
		 
select top 5 * from margin_diff_2014 where 
runner_votes is not null and 
margin_diff is not null
order by margin_diff desc;



-- Top 5 candidates based on margin diffrence with runners in 2019.

CREATE VIEW winner_runner_2019 as 
		 select pc_name,
				candidate,
				total_votes,
				rank()over(partition by pc_name order by total_votes desc) as ranking
				from (
				 select 
						pc_name,
						candidate,
						total_votes,
						rank() over(partition by pc_name order by total_votes desc) as rnk
				 from constituency_wise_results_2019	
 
		 ) as x
		 where rnk <=2;

  with margin_diff_2019 as (
		 select 
					pc_name,
					candidate,
					total_votes,
           
				   lag(total_votes) over(partition by pc_name order by total_votes) as runner_votes,
				   total_votes - lag(total_votes) over(partition by pc_name order by total_votes) as margin_diff
		 from winner_runner_2019
 )
		 
select top 5 * from margin_diff_2019 where 
runner_votes is not null and 
margin_diff is not null
order by margin_diff desc;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
   -- % splits of votes of parties between 2014 and 2019 at national level

	-- Calculate the party-wise votes and percentage in 2014
WITH votes_2014 AS (
    SELECT 
        party,
        SUM(total_votes) AS total_party_vote_2014
    FROM 
        constituency_wise_results_2014
    GROUP BY 
        party
),
total_votes_2014 AS (
    SELECT 
        SUM(total_party_vote_2014) AS total_vote_cast_2014
    FROM 
        votes_2014
),
party_percentage_2014 AS (
    SELECT
        v.party,
        v.total_party_vote_2014,
        (v.total_party_vote_2014 * 100.0 / t.total_vote_cast_2014) AS percentage_votes_2014
    FROM 
        votes_2014 v
    CROSS JOIN 
        total_votes_2014 t
),

-- Calculate the party-wise votes and percentage in 2019
votes_2019 AS (
    SELECT 
        party,
        SUM(total_votes) AS total_party_vote_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        party
),
total_votes_2019 AS (
    SELECT 
        SUM(total_party_vote_2019) AS total_vote_cast_2019
    FROM 
        votes_2019
),
party_percentage_2019 AS (
    SELECT
        v.party,
        v.total_party_vote_2019,
        (v.total_party_vote_2019 * 100.0 / t.total_vote_cast_2019) AS percentage_votes_2019
    FROM 
        votes_2019 v
    CROSS JOIN 
        total_votes_2019 t
)

-- Combine the results to compare the percentage splits between 2014 and 2019
SELECT
    COALESCE(p2014.party, p2019.party) AS party, -- Uses COALESCE to handle cases where a party might have participated in one election but not the other
    COALESCE(p2014.percentage_votes_2014, 0) AS percentage_votes_2014,
    COALESCE(p2019.percentage_votes_2019, 0) AS percentage_votes_2019
FROM
    party_percentage_2014 p2014
FULL OUTER JOIN ---using a FULL OUTER JOIN to ensure all parties from both years(2014, 2019) are included.
    party_percentage_2019 p2019 ON p2014.party = p2019.party
ORDER BY percentage_votes_2014 desc, percentage_votes_2019 desc;


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
   -- % splits of votes of parties between 2014 and 2019 at state level

-- Calculate the party-wise votes and percentage at state level in 2014
WITH votes_2014 AS (
    SELECT 
        party,
        state,
        SUM(total_votes) AS total_party_vote_2014
    FROM 
        constituency_wise_results_2014
    GROUP BY 
        party, state
),
total_votes_2014 AS (
    SELECT 
        state,
        SUM(total_party_vote_2014) AS total_vote_cast_2014
    FROM 
        votes_2014
    GROUP BY 
        state
),
party_percentage_2014 AS (
    SELECT
        v.party,
        v.state,
        v.total_party_vote_2014,
        (v.total_party_vote_2014 * 100.0 / t.total_vote_cast_2014) AS percentage_votes_2014
    FROM 
        votes_2014 v
    JOIN 
        total_votes_2014 t ON v.state = t.state
),

-- Calculate the party-wise votes and percentage at state level in 2019
votes_2019 AS (
    SELECT 
        party,
        state,
        SUM(total_votes) AS total_party_vote_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        party, state
),
total_votes_2019 AS (
    SELECT 
        state,
        SUM(total_party_vote_2019) AS total_vote_cast_2019
    FROM 
        votes_2019
    GROUP BY 
        state
),
party_percentage_2019 AS (
    SELECT
        v.party,
        v.state,
        v.total_party_vote_2019,
        (v.total_party_vote_2019 * 100.0 / t.total_vote_cast_2019) AS percentage_votes_2019
    FROM 
        votes_2019 v
    JOIN 
        total_votes_2019 t ON v.state = t.state
)

-- Combine the results to compare the percentage splits between 2014 and 2019
SELECT
    COALESCE(p2014.state, p2019.state) AS state,
    COALESCE(p2014.party, p2019.party) AS party,
    COALESCE(p2014.percentage_votes_2014, 0) AS percentage_votes_2014,
    COALESCE(p2019.percentage_votes_2019, 0) AS percentage_votes_2019
FROM
    party_percentage_2014 p2014
FULL OUTER JOIN
    party_percentage_2019 p2019 ON p2014.party = p2019.party AND p2014.state = p2019.state
--WHERE p2014.state = 'west bengal' and p2019.state = 'west bengal'
ORDER BY
    party,percentage_votes_2014 desc, percentage_votes_2019 desc	;

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--Q9 List top 5 constituency for two major national parties where they have gained vote share in 2019 as 
--   compared to 2014



-- Step 1: Calculate vote share for 2014
WITH vote_share_2014 AS (
    SELECT 
        pc_name,
        party,
        SUM(total_votes) AS total_votes_2014,
        (SUM(total_votes) * 100.0 / SUM(SUM(total_votes)) OVER (PARTITION BY pc_name)) AS vote_share_2014
    FROM 
        constituency_wise_results_2014
    GROUP BY 
        pc_name, party
),

-- Step 2: Calculate vote share for 2019
vote_share_2019 AS (
    SELECT 
        pc_name,
        party,
        SUM(total_votes) AS total_votes_2019,
        (SUM(total_votes) * 100.0 / SUM(SUM(total_votes)) OVER (PARTITION BY pc_name)) AS vote_share_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        pc_name, party
),

-- Step 3: Calculate the gain in vote share
vote_share_gain AS (
    SELECT
        v19.pc_name,
        v19.party,
        v19.vote_share_2019 - COALESCE(v14.vote_share_2014, 0) AS vote_share_gain
    FROM
        vote_share_2019 v19
    LEFT JOIN
        vote_share_2014 v14 ON v19.pc_name = v14.pc_name AND v19.party = v14.party
),

-- Step 4: Filter for two major national parties (e.g., 'BJP' and 'INC') and rank the constituencies based on the gain in vote share
ranked_vote_share_gain AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY party ORDER BY vote_share_gain DESC) AS rank
    FROM
        vote_share_gain
    WHERE
        party IN ('BJP', 'INC') -- Replace with actual party names as needed
)

-- Final Step: Select the top 5 constituencies for each party
SELECT
    pc_name,
    party,
    vote_share_gain
FROM
    ranked_vote_share_gain
WHERE
    rank <= 5
ORDER BY
    party, rank;


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

--Q9 List top 5 constituency for two major national parties where they have lost vote share in 2019 as 
--   compared to 2014




-- Step 1: Calculate vote share for 2014
WITH vote_share_2014 AS (
    SELECT 
        pc_name,
        party,
        SUM(total_votes) AS total_votes_2014,
        (SUM(total_votes) * 100.0 / SUM(SUM(total_votes)) OVER (PARTITION BY pc_name)) AS vote_share_2014
    FROM 
        constituency_wise_results_2014
    GROUP BY 
        pc_name, party
),

-- Step 2: Calculate vote share for 2019
vote_share_2019 AS (
    SELECT 
        pc_name,
        party,
        SUM(total_votes) AS total_votes_2019,
        (SUM(total_votes) * 100.0 / SUM(SUM(total_votes)) OVER (PARTITION BY pc_name)) AS vote_share_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        pc_name, party
),

-- Step 3: Calculate the gain in vote share
vote_share_gain AS (
    SELECT
        v19.pc_name,
        v19.party,
        v19.vote_share_2019 - COALESCE(v14.vote_share_2014, 0) AS vote_share_gain
    FROM
        vote_share_2019 v19
    LEFT JOIN
        vote_share_2014 v14 ON v19.pc_name = v14.pc_name AND v19.party = v14.party
),

-- Step 4: Filter for two major national parties (e.g., 'BJP' and 'INC') and rank the constituencies based on the gain in vote share
ranked_vote_share_gain AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY party ORDER BY vote_share_gain) AS rank
    FROM
        vote_share_gain
    WHERE
        party IN ('BJP', 'INC') -- Replace with actual party names as needed
)

-- Final Step: Select the top 5 constituencies for each party
SELECT
    pc_name,
    party,
    vote_share_gain
FROM
    ranked_vote_share_gain
WHERE
    rank <= 5
ORDER BY
    party, rank;

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- Q10 Which constituency has voted the most for NOTA ?

 
 -- the constituency who voted the most nota 2014
 select top 5
        pc_name,
        total_votes
 from constituency_wise_results_2014
 where party_symbol = 'nota'
 order by total_votes desc;

 -- the constituency who voted the most nota 2019
 select top 5
        pc_name,
        total_votes
 from   constituency_wise_results_2019
 where  party = 'nota'
 order  by total_votes desc;



 --------------------------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------------------------
 --Q10 : Which constituency have elected candidates whose party	has less than 10% vote share 
 --      at state level in 2019	
   
   with votes_share_2019 AS (
    SELECT 
        state,
        party,
        SUM(total_votes) AS total_votes_2019,
        (SUM(total_votes) * 100.0 / SUM(SUM(total_votes)) OVER (PARTITION BY state)) AS vote_share_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state, party),

    candiadtes_2019 as (
	    select state,
		       party,
			   candidate
        from constituency_wise_results_2019
	)


select  top 20 
       vs_19.state,
       vs_19.party,
	   c_19.candidate,
	   total_votes_2019,
	   vote_share_2019
from votes_share_2019 vs_19
,candiadtes_2019 c_19
where vote_share_2019 < 10
order by total_votes_2019 desc,
	   vote_share_2019 desc


	   ------------------------
	   -------------------------


	   WITH state_party_votes_2019 AS (
    SELECT 
        state,
        party,
        SUM(total_votes) AS total_votes_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state, party
),

state_total_votes_2019 AS (
    SELECT 
        state,
        SUM(total_votes_2019) AS total_votes_cast_2019
    FROM 
        state_party_votes_2019
    GROUP BY 
        state
),

state_party_vote_share_2019 AS (
    SELECT 
        spv.state,
        spv.party,
        spv.total_votes_2019,
        (spv.total_votes_2019 * 100.0 / stv.total_votes_cast_2019) AS vote_share_2019
    FROM 
        state_party_votes_2019 spv
    JOIN 
        state_total_votes_2019 stv ON spv.state = stv.state
),

elected_candidates_2019 AS (
    SELECT 
        state,
        pc_name,
        party,
        total_votes,
        RANK() OVER (PARTITION BY pc_name ORDER BY total_votes DESC) AS rank
    FROM 
        constituency_wise_results_2019
)

SELECT top 10
    ec.state,
    ec.pc_name,
    ec.party,
    spvs.vote_share_2019
FROM 
    elected_candidates_2019 ec
JOIN 
    state_party_vote_share_2019 spvs ON ec.state = spvs.state AND ec.party = spvs.party
WHERE 
    ec.rank = 1
    AND spvs.vote_share_2019 < 10
ORDER BY 
    ec.state, ec.pc_name;



	-------------------------------
	-------------------------------
  -- OPTIMIZE QUERY
 

 -- Step 1: Calculate total votes for each party at the state level in 2019
CREATE INDEX idx_state_party_2019 ON constituency_wise_results_2019 (state, party);

WITH state_party_votes_2019 AS (
    SELECT 
        state,
        party,
        SUM(total_votes) AS total_votes_2019
    FROM 
        constituency_wise_results_2019
    GROUP BY 
        state, party
)

-- Step 2: Calculate the total votes cast at the state level in 2019
SELECT 
    state,
    SUM(total_votes_2019) AS total_votes_cast_2019
INTO #state_total_votes_2019
FROM 
    state_party_votes_2019
GROUP BY 
    state

-- Step 3: Calculate the vote share for each party at the state level in 2019
SELECT 
    spv.state,
    spv.party,
    spv.total_votes_2019,
    (spv.total_votes_2019 * 100.0 / stv.total_votes_cast_2019) AS vote_share_2019
INTO #state_party_vote_share_2019
FROM 
    state_party_votes_2019 spv
JOIN 
    #state_total_votes_2019 stv ON spv.state = stv.state;

-- Step 4: Identify elected candidates and their party vote share at the state level
CREATE INDEX idx_state_pc_2019 ON constituency_wise_results_2019 (state, pc_name);

SELECT 
    state,
    pc_name,
    party,
    total_votes,
    RANK() OVER (PARTITION BY pc_name ORDER BY total_votes DESC) AS rank
INTO #elected_candidates_2019
FROM 
    constituency_wise_results_2019;

-- Step 5: Combine the results to find the required constituencies
SELECT 
    ec.state,
    ec.pc_name,
    ec.party,
    spvs.vote_share_2019
FROM 
    #elected_candidates_2019 ec
JOIN 
    #state_party_vote_share_2019 spvs ON ec.state = spvs.state AND ec.party = spvs.party
WHERE 
    ec.rank = 1
    AND spvs.vote_share_2019 < 10
ORDER BY 
    ec.state, ec.pc_name;


	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------

	-- which party has won more seats in 2014 

	-- Bjp party win 2014 count
	with ranking as ( 
	  select 
	        pc_name,
	        party,
			total_votes
			,rank()over(partition by pc_name order by total_votes desc) as rnk
	  from
	  constituency_wise_results_2014
	  )

     select 
	         count(case when rnk = 1 and party = 'bjp' then 1 else null end )as Total_seats_won_by_bjp_2014
	  from ranking;
    
	  
	  


	  -- which party has won more seats in 2019
	  
    with ranking as ( 
	  select 
	        pc_name,
	        party,
			total_votes
			,rank()over(partition by pc_name order by total_votes desc) as rnk
	  from
	  constituency_wise_results_2019
	  )


	  -- Bjp party win 2014 count
	  select
	         count(case when rnk = 1 and party = 'bjp' then 1 else null end )as Total_seats_won_by_bjp_2019
	  from ranking;

------------------------------------------------------------------

	  -- congress party win 2014 count
	with ranking as ( 
	  select 
	        pc_name,
	        party,
			total_votes
			,rank()over(partition by pc_name order by total_votes desc) as rnk
	  from
	  constituency_wise_results_2014
	  )

     select 
	         count(case when rnk = 1 and party = 'inc' then 1 else null end )as Total_seat_won_by_Congress_2014
	  from ranking;
	

	 -- congress party win 2019 count
	with ranking as ( 
	  select 
	        pc_name,
	        party,
			total_votes
			,rank()over(partition by pc_name order by total_votes desc) as rnk
	  from
	  constituency_wise_results_2019
	  )

     select 
	         count(case when rnk = 1 and party = 'inc' then 1 else null end ) as Total_seat_won_by_Congress_2019
	  from ranking;

---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- Total male voter 2014

select count(*)
from constituency_wise_results_2014
where sex = 'm';






