#companies
select 
concat( c.company_code, ' ',  c.founder, ' ', count(distinct l.lead_manager_code) , ' ', count(distinct s.senior_manager_code), ' ', count(distinct m.manger_code), ' ' ,count(distinct e.employee_code)) as output
from company c
join lead_manager l
on c.company_code = l.company_code
join senior_manager s
on s.company_code = c.company_code
join manager m
on m.company_code = c.company_code
join employee e
on e.company_code = c.company_code
group by c.company_code, c.founder
;

#the blunder
select  Ceiling(avg(salary) - avg(replace(salary, '0', '')))
from
employees
;

#Triangles
select 
case 
		when not (a+b >c and b+c > a and  c+a > b)  then  'Not A Triangle'
		when a = b and b = c then 'Equilateral'
        when a = b or b=c or c= a  then 'Isosceles'
        else 'Scalene'
end
from triangles
;

#occupations
select  concat(name, ' ' , '(', left(occupation, 1) , ')') 
from occupations
order by name asc
;
Select concat('There are a total of ' , count(*), ' ',  occupation, 's') 
from occupations
group by occupation
order by count(*), occupation
;

#occupation 2
select od.name, op.name
from occupations o
join occupations od
on o.name = od.name
and od.occupation = 'Doctor'
left join occupations op
on o.name = op.name
and op.occupation = 'Professor'
;

#occupation 3 self join
SELECT MAX(C1), MAX(C2), MAX(C3), MAX(C4) 
FROM
(SELECT
COUNT(*) Rank,
IF (STRCMP(T1.Occupation, 'Doctor') = 0, T1.Name, NULL) AS C1,
IF (STRCMP(T1.Occupation, 'Professor') = 0, T1.Name, NULL) AS C2,
IF (STRCMP(T1.Occupation, 'Singer') = 0, T1.Name, NULL) AS C3,
IF (STRCMP(T1.Occupation, 'Actor ') = 0, T1.Name, NULL) AS C4
FROM Occupations T1 LEFT JOIN Occupations T2 ON T1.Occupation = T2.Occupation 
AND STRCMP(T1.Name, T2.Name) >= 0 GROUP BY T1.Name, T1.Occupation ORDER BY Rank, T1.Name) AS MyOccupations GROUP BY Rank;

#Grades
use cta;
drop table if exists grades;
create table grades
(grade int, 
min_mark int,
max_mark int)
;

insert into grades(grade, min_mark, max_mark) values (1, 0, 9);
insert into grades(grade, min_mark, max_mark) values (2, 10, 19);
insert into grades(grade, min_mark, max_mark) values (3, 20, 29);
insert into grades(grade, min_mark, max_mark) values (4, 30, 39);
insert into grades(grade, min_mark, max_mark) values (5, 40, 49);
insert into grades(grade, min_mark, max_mark) values (6, 50, 59);
insert into grades(grade, min_mark, max_mark) values (7, 60, 69);
insert into grades(grade, min_mark, max_mark) values (8, 70, 79);
insert into grades(grade, min_mark, max_mark) values (9, 80, 89);
insert into grades(grade, min_mark, max_mark) values (10, 90, 100);

create table students
(id int, 
name varchar(30),
marks int)
;

insert into students(id, name, marks) values(1, 'Julia', 88);
insert into students(id, name, marks) values(2, 'Smantha', 68);
insert into students(id, name, marks) values(3, 'Maria', 99);
insert into students(id, name, marks) values(4, 'Scarlet', 78);
insert into students(id, name, marks) values(5, 'Ashley', 63);
insert into students(id, name, marks) values(6, 'Jane', 81);

select * from grades;
select * from students;

select 
case when a.grade >= 8 then concat(a.name, ' ' , a.grade, ' ',  a.marks)
else  concat( 'NULL' , ' ' , a.grade, ' ',  a.marks)
end
from
(select 
s.id, s.name, s.marks, g.grade
from grades g, students s
where s.marks between g.min_mark and g.max_mark
order by 1) as a
order by a.grade desc, a.name, a.marks 
;

#top hacker
use Cta;
create table hackers
(hacker_id int, 
name varchar(30)
)
;

insert into hackers(hacker_id, name) 
values 
(5580, 'Rose' ),
(8439, 'Angela'),
(27205, 'Frank'),
(52243, 'Patrick'),
(52348, 'Lisa'),
(57645, 'Kimberly'),
(77726, 'Bonnie'),
(83082, 'Michael'),
(86870, 'Tod'),
(90411, 'Joe')
;

create table difficulty
(difficulty_level int, 
score int
)
;
insert into difficulty(difficulty_level, score)
values
(1, 20),
(2, 30),
(3, 40),
(4, 60),
(5, 80),
(6, 100),
(7, 120)
;

create table hack_challenges
(challenge_id int,
hacker_id int, 
difficulty_level int
)
;

insert into hack_challenges(challenge_id, hacker_id, difficulty_level)
values
(4810, 77726, 4),
(21089, 27205, 1),
(36566, 5580, 7),
(66730, 52243, 6),
(71055, 52243, 2)
;

create table submissions
(submission_id int,
hacker_id int,
challenge_id int,
score int)
;

insert into submissions(submission_id, hacker_id, challenge_id, score) values
(68628, 77726, 36566, 30),
(65300, 77726, 21089, 10),
(40326, 52243, 36566, 77),
(8941, 27205, 4810, 4),
(83554, 77726, 66730, 30),
(43353, 52243, 66730, 0),
(55385, 52348, 71055, 20),
(39784, 27205, 71055, 23),
(94613, 86870, 71055, 30),
(45788, 52348, 36566, 0 ),
(93058, 86870, 36566, 30),
(7344, 8439, 66730, 92),
(2721, 8439, 4810, 36),
(523, 5580, 71055, 4),
(49105, 52348, 66730, 0),
(55877, 57645, 66730, 80),
(38355, 27205, 66730, 35),
(3924 , 8439, 36566, 80),
(97397, 90411, 66730, 100),
(84162, 83082, 4810, 40),
(97431, 90411, 71055, 30)
;

select s.hacker_id, h.name
from submissions s 
join hack_challenges c
on s.challenge_id = c.challenge_id
join difficulty d
on d.difficulty_level = c.difficulty_level
join hackers h
on h.hacker_id = s.hacker_id
where s.score = d.score
and c.difficulty_level = d.difficulty_level
group by s.hacker_id, h.name
having count(s.hacker_id) > 1
order by count(s.hacker_id) desc, s.hacker_id asc
;

#Harry potter
create table wands
(id int,
code int,
coins_needed int,
power int
)
;

insert into wands(id, code, coins_needed, power)
values
(1, 4, 3688, 8),
(2, 3, 9365, 3),
(3, 3, 7187, 10),
(4, 3, 734, 8),
(5, 1, 6020, 2),
(6, 2, 6773, 7),
(7, 3, 9873, 9),
(8, 3, 7721, 7),
(9, 1, 1647, 10), 
(10, 4, 504, 5),
(11, 2, 7587, 5),
(12, 5, 9897, 10),
(13, 3, 4651, 8),
(14, 2, 5408, 1), 
(15, 2, 6018, 7),
(16, 4, 7710, 5),
(17, 2, 8798, 7),
(18, 2, 	3312, 3),
(19, 4, 7651, 6),
(20, 5, 5689, 3)
;

create table wands_property
(code int,
age int, 
is_evil int
);

insert into wands_property(code, age, is_evil)
values
(1, 45, 0),
(2, 40, 0),
(3, 4, 1),
(4, 20, 0),
(5, 17, 0)
;

select wands.id, min_prices.age, wands.coins_needed, wands.power
from wands
inner join (select wands.code, wands.power, min(wands_property.age) as age, min(wands.coins_needed) as min_price
            from wands
            inner join wands_property
            on wands.code = wands_property.code
            where wands_property.is_evil = 0
            group by wands.code, wands.power) min_prices
on wands.code = min_prices.code
   and wands.power = min_prices.power
   and wands.coins_needed = min_prices.min_price
order by wands.power desc, min_prices.age desc;

#contest leaderboard
select h.hacker_id, name, sum(score) as total_score
from
hackers as h inner join
/* find max_score*/
(select hacker_id,  max(score) as score from submissions group by challenge_id, hacker_id) max_score

on h.hacker_id=max_score.hacker_id
group by h.hacker_id, name

/* don't accept hackers with total_score=0 */
having total_score > 0

/* finally order as required */
order by total_score desc, h.hacker_id
;


#placements



