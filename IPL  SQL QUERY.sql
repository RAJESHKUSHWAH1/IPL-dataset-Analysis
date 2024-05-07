create database ipl
use ipl

create table matches
(id varchar(max),season varchar(max),city varchar(max),	date varchar(max),
team1 varchar(max),	team2 varchar(max),	toss_winner varchar(max),	toss_decision varchar(max),
result varchar(max),	dl_applied varchar(max),	winner varchar(max),
win_by_runs varchar(max),	win_by_wickets varchar(max),	player_of_match varchar(max),
venue varchar(max),	umpire1 varchar(max),	umpire2 varchar(max),umpire3 varchar(max))


bulk insert   matches 
from 'C:\Users\RAJESH KUSHWAH\Downloads\matches.csv'
with(fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=50)
select * from matches

create table delivery
(match_id varchar(max),	inning varchar(max),batting_team varchar(max),
bowling_team varchar(max),overs varchar(max),
ball varchar(max),	
batsman varchar(max),non_striker varchar(max),bowler varchar(max),is_super_over varchar(max),
wide_runs varchar(max),	bye_runs varchar(max),	legbye_runs varchar(max),	
noball_runs varchar(max),penalty_runs varchar(max),	batsman_runs varchar(max),extra_runs varchar(max),
total_runs varchar(max),player_dismissed varchar(max),dismissal_kind varchar(max)	,
fielder varchar(max))

bulk insert   delivery 
from 'C:\Users\RAJESH KUSHWAH\Downloads\deliveries.csv'
with(fieldterminator=',',rowterminator='\n',firstrow=2,maxerrors=50)

select * from delivery
select * from matches

select column_name,data_type from INFORMATION_SCHEMA.columns
where table_name = 'delivery'

alter table delivery
alter column total_runs int

select column_name,data_type from INFORMATION_SCHEMA.columns
where table_name='matches'

select try_convert(date,date)  from matches


update matches set date =TRY_CONVERT(date,date)

select * from matches

alter table matches
alter column  dl_applied int

alter table matches
alter column  date date 


select * from delivery
select * from matches

alter table matches
alter column  win_by_wickets int


----What are the top 5 player with most player of the match Awards.

select * from matches
select top 5 player_of_match, count(*) as counts from matches
group by player_of_match
order by counts desc

--- how many matches were won by each team in each season.

select season,winner,count(*) as won_match from matches
group by season,winner
order by  season desc,won_match 


---what is th average strike rate of bastman in the datebase

select top 5 batsman ,(sum(total_runs)/count(ball))*100 as strike_rate
from delivery
group by batsman
order by strike_rate  desc

select * from matches


---what is the number of matches won by each team batting first vesur batting second
select batting_first,count(*)as win_by_run from (select case 
when  win_by_runs > 0 then team1 else team2 end batting_first
 from matches 
 where winner!='tie')as batting_first_team
 group by batting_first
 order by win_by_run desc

----which batsman has the highest stike rate

select * from delivery

select top 1 batsman,(sum(batsman_runs)*100/count(ball)) as max_strike_rate 
from delivery
group by batsman
having sum(batsman_runs)>= 200
order by max_strike_rate  desc

----how many time has each batsman been dismissed by the bowler malinga.

select * from delivery

select batsman,count(*) as Dismised_by_malinga from delivery
where bowler = 'sl malinga' 
group by batsman
order by Dismised_by_malinga desc


---Q what is the average percentage of boundary four and six hit by each batsman
select batsman, avg( case when batsman_runs=4 or batsman_runs=6 
then 1 else 0 end )* 100 as avg_boundary
from delivery 
group by batsman 
order by avg_boundary desc

-----how many extra (widl and no_ball) were bowled by each team in each match
select * from matches
select * from delivery

select m.match_id as match_no,bowling_team,sum(d.extra_runs) as extra_run
from matches m
join delivery d
on m.match_id=d.match_id
Where extra_runs>0
group by m.match_id,bowling_team
order by m.match_id desc

----which bowler is the best bowling  figure in the single matches
select * from matches
select * from delivery



select top 1 m.match_id,d.bowler,count(*) as bowling_count from matches m
join delivery d
on m.match_id=d.match_id
---where d.player_dismissed is not null
group by m.match_id,d.bowler
order by bowling_count desc

----how many time did the each team win the toss in each season

select distinct season,toss_winner, count(*) as toss_win from matches
group by season,toss_winner
order by toss_win desc


----how many match did each player win the player of the match  award

select * from matches
select player_of_match,count(*)as no_of_time_player_of_match from matches 
where player_of_match is not null
group by player_of_match  
order by no_of_time_player_of_match desc

---@ -what is the no. of runs score in each over of the innings in each match


select m.match_id, d.inning,overs,avg(d.total_runs) as avg_runs from delivery d
join matches m
on d.match_id=d.match_id
group by m.match_id, d.inning,overs

----which team has the highest total score in single match

 
select top 1 m.season , d.batting_team, d.overs,sum(d.total_runs) as total_runs from matches m
join delivery d
on m.match_id=d.match_id
group by m.season , d.batting_team, d.overs
order by total_runs desc

--- which best man score the most run in single match


select top 1 m.season , d.batsman, d.overs,sum(d.total_runs) as total_runs from matches m
join delivery d
on m.match_id=d.match_id
group by m.season , d.batsman, d.overs
order by total_runs desc













