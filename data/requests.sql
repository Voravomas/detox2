--Запити:

--1. для алкоголіка А знайти всіх іспекторів, 
--які ловили його щонайменше N разів з дати F по  дату Т

SELECT r.inspector_id_brought, count(*)
FROM registry as r
WHERE r.from_bed_id IS NULL
AND r.alcoholic_id = alcoholic_A
AND r.date_entered BETWEEN date_F AND date_T
GROUP BY r.inspector_id_brought
having count(*) >= N;

--2. для алкаша А знайти усі ліжка 
--на яких він побував з дати F по дату T

SELECT to_bed_id 
FROM registry
WHERE alcoholic_id = alcoholic_A
AND to_bed_id IS NOT NULL
AND date_entered BETWEEN date_F AND date_T
GROUP BY to_bed_id;

--3. для інспектора І знайти всіх алкашів, 
--яких він забирав хоча б N разів з дати F по дату T

SELECT alcoholic_id, count(*)
FROM registry
WHERE inspector_id_brought = I
AND from_bed_id IS NULL
AND date_entered BETWEEN date_F AND date_T
GROUP BY alcoholic_id 
HAVING count(*) >= N;

--4. для алкаша А знайти усі ліжка у витверезнику, 
--з яких він тікав  з дати F по дату T

SELECT from_bed_id
FROM registry
WHERE alcoholic_id = alcoholic_A
AND inspector_id_freed IS NULL
AND from_bed_id IS NOT NULL
AND to_bed_id IS NULL
AND date_left BETWEEN date_F and date_T
GROUP BY from_bed_id;


--5. для алк А знайти усіх інспекторів, 
--які лапали його меншу к-сть разів ніж випускали
SELECT concat(a.inspector_id_brought, a.inspector_id_freed) as insp_id, a.times_brought, a.times_freed FROM
( (SELECT inspector_id_brought, count(*) as times_brought
FROM registry
WHERE from_bed_id IS NULL
AND alcoholic_id = alc_A
GROUP BY inspector_id_brought) r1
FULL JOIN
(SELECT inspector_id_freed,  count(*) as times_freed
FROM registry
WHERE alcoholic_id = alc_A
AND inspector_id_freed IS NOT NULL
GROUP BY inspector_id_freed) r2
ON r1.inspector_id_brought = r2.inspector_id_freed) a
WHERE a.times_brought < a.times_freed;



--6. знайти всіх іспекторів, 
--які забирали щонайменше N різних алків з дати F по дату T

SELECT inspector_id_brought
FROM registry
WHERE from_bed_id IS NULL
AND date_entered BETWEEN date_F and date_T
GROUP BY inspector_id_brought
HAVING count(distinct alcoholic_id) >= N;


--7. знайти усіх алкоголіків, 
--яких забирали хоча б N разів з дати F по дату T

SELECT alcoholic_id, count(*)
FROM registry
WHERE from_bed_id IS NULL
AND date_entered BETWEEN date_F and date_t
GROUP BY alcoholic_id
HAVING count(*) >= N;

--8. знайти усі спільні події 
--для алкоголіка А та інспектора І з дати F по дату T

SELECT * 
FROM registry
WHERE alcoholic_id = alcoholic_A
AND ( (inspector_id_brought = I AND date_entered BETWEEN date_F AND date_T)
OR (inspector_id_freed = I AND date_left BETWEEN date_F AND date_T) );

--9. для алк А та кожного спиртного напою, 
--що він пив, знайти скільки разів з дати F по дату T
--він пив цей напій у групі з щонайменше N алкоголіків

SELECT a.drink_id, count(*)
FROM ( SELECT pa.party_id, count(*) as members
	FROM party_id_alcoholic_id as pa
	WHERE pa.alcoholic_id = alcoholic_A
	GROUP BY pa.party_id 
		INNER JOIN (SELECT party_id, drink_id, date_happened
			FROM party) p ON p.party_id = pa.party_id ) a
WHERE a.members >= N
AND a.date_happened BETWEEN date_F and date_T
GROUP BY a.drink_id;


--10. знайти сумарну к-сть втеч з витверезника по місяцях

SELECT YEAR(date_left), MONTH(date_left), count(*)
FROM registry
WHERE inspector_id_freed IS NULL
AND to_bed_id IS NULL
GROUP BY YEAR(date_left), MONTH(date_left);


--11. вивести ліжка витверезника у порядку спадання
--середньої к-сті втрат свідомості для усіх алкоголіків, 
--що були приведені на ліжко інсектором І з дати F по дату T

SELECT a.to_bed_id as bed_id, count(a.alcoholic_id) / count(DISTINCT a.alcoholic_id) as avg_faints
FROM ( SELECT to_bed_id, alcoholic_id 
	FROM registry as r
	INNER JOIN faints ON r.alcoholic_id = faints.alcoholic_id AND r.to_bed_id = faints.bed_id
	WHERE r.inspector_id_brought = I
	AND r.date_entered BETWEEN date_F AND date_T) a
GROUP BY bed_id
ORDER BY avg_faints DESC;


--12. вивести алк напої у порядку спадання сумарної к-сті алкоголіків,
--що його пили разом з алк А з дати F по дату T

SELECT a.drink_id, sum(a.members - 1) as sum_alc
FROM ( SELECT pa.party_id, count(*) as members
	FROM party_id_alcoholic_id as pa
	WHERE pa.alcoholic_id = alcoholic_A
	GROUP BY pa.party_id 
		INNER JOIN (SELECT party_id, drink_id, date_happened
			FROM party) p ON p.party_id = pa.party_id ) a
WHERE a.date_happened BETWEEN date_F and date_T
GROUP BY a.drink_id
ORDER BY sum_alc DESC;


/*
TESTS
*/

SELECT to_bed_id 
FROM registry
WHERE alcoholic_id = 3
AND to_bed_id IS NOT NULL
AND date_entered BETWEEN '2020-06-02' AND '2020-07-23'/*він був на ліжку 2 в першу дату*/
GROUP BY to_bed_id;

/*FIXING*/ 
SELECT from_bed_id as bed_id
FROM registry
WHERE alcoholic_id = 3
AND to_bed_id IS NOT NULL
AND date_entered BETWEEN '2020-06-02' AND '2020-07-23'/*він був на ліжку 2 в першу дату*/
GROUP BY bed_id
UNION
SELECT to_bed_id as bed_id
FROM registry
WHERE alcoholic_id = 3
AND to_bed_id IS NOT NULL
AND date_entered BETWEEN '2020-06-02' AND '2020-07-23'/*він був на ліжку 2 в першу дату*/
GROUP BY bed_id;


/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/



/*Syntax error*/
SELECT a.inspector_id
FROM ( SELECT r.inspector_id_brought as inspector_id, count(*) as times_brought
	FROM registry as r
	WHERE r.alcoholic_id = 3
	AND r.from_bed_id IS NULL
	GROUP BY r.inspector_id_brought
	INNER JOIN ( SELECT inspector_id_freed as inspector_id, count(*) as times_freed
		FROM registry
		WHERE alcoholic_id = 3
		AND to_bed_id IS NULL
		GROUP BY inspector_id_freed ) reg ON reg.inspector_id = r.inspector_id ) a
WHERE a.times_brought < a.times_freed;


/*FIXING*/
SELECT concat(a.inspector_id_brought, a.inspector_id_freed) as insp_id, a.times_brought, a.times_freed FROM
( (SELECT inspector_id_brought, count(*) as times_brought
FROM registry
WHERE from_bed_id IS NULL
AND alcoholic_id = 3
GROUP BY inspector_id_brought) r1
FULL JOIN
(SELECT inspector_id_freed,  count(*) as times_freed
FROM registry
WHERE alcoholic_id = 3
AND inspector_id_freed IS NOT NULL
GROUP BY inspector_id_freed) r2
ON r1.inspector_id_brought = r2.inspector_id_freed) a
WHERE a.times_brought < a.times_freed;

/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/



/*DIDN't FIND id 3*/
SELECT inspector_id_brought
FROM registry
WHERE from_bed_id IS NULL
AND date_entered BETWEEN '2020-05-19' and '2020-06-22'
GROUP BY inspector_id_brought
HAVING count(distinct alcoholic_id) >= 2;

/* there is no mistake here */
/*---------------------------------------------------------------------------------------*/


/*column reference "alcoholic_id" is ambiguous*/
SELECT a.to_bed_id as bed_id, count(a.alcoholic_id) / count(DISTINCT a.alcoholic_id) as avg_faints
FROM ( SELECT to_bed_id, alcoholic_id 
	FROM registry as r
	INNER JOIN faints ON r.alcoholic_id = faints.alcoholic_id AND r.to_bed_id = faints.bed_id
	WHERE r.inspector_id_brought = I
	AND r.date_entered BETWEEN '2020-04-22' AND '2020-04-25') a
GROUP BY bed_id
ORDER BY avg_faints DESC;


/*FIXING*/
SELECT a.to_bed_id as bed_id, count(a.alcoholic_id) / count(DISTINCT a.alcoholic_id) as avg_faints
FROM ( SELECT to_bed_id, r.alcoholic_id 
	FROM registry as r
	INNER JOIN faints ON r.alcoholic_id = faints.alcoholic_id AND r.to_bed_id = faints.bed_id
	WHERE r.inspector_id_brought = 4
	AND r.date_entered BETWEEN '2020-04-22' AND '2020-04-25') a
GROUP BY bed_id
ORDER BY avg_faints DESC;

/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/



/*syntax error at or near "INNER" */
SELECT a.drink_id, count(*)
FROM ( SELECT pa.party_id, count(*) as members
	FROM party_id_alcoholic_id as pa
	WHERE pa.alcoholic_id = alcoholic_A
	GROUP BY pa.party_id 
		INNER JOIN (SELECT party_id, drink_id, date_happened
			FROM party) p ON p.party_id = pa.party_id ) a
WHERE a.members >= 1
AND a.date_happened BETWEEN '2020-03-13' and '2020-05-13'
GROUP BY a.drink_id;


/*FIXING*/
SELECT a.drink_id, count(*)
FROM ( (SELECT party_id, count(*) as members
	FROM party_id_alcoholic_id
	WHERE alcoholic_id = 1
	GROUP BY party_id ) pa
	INNER JOIN
	(SELECT party_id, drink_id, date_happened
	FROM party) p 
	ON p.party_id = pa.party_id) a
WHERE a.members >= 1
AND a.date_happened BETWEEN '2020-03-13' and '2020-05-13'
GROUP BY a.drink_id;

/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/




/*function year(date) does not exist*/
SELECT YEAR(date_left), MONTH(date_left), count(*)
FROM registry
WHERE inspector_id_freed IS NULL
AND to_bed_id IS NULL
GROUP BY YEAR(date_left), MONTH(date_left);


/*FIXING*/
SELECT EXTRACT(YEAR FROM date_left) as year, EXTRACT(MONTH FROM date_left) as month, count(*)
FROM registry
WHERE inspector_id_freed IS NULL
AND to_bed_id IS NULL
AND date_left IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_left), EXTRACT(MONTH FROM date_left);

/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/




/* syntax error at or near "INNER"*/
SELECT a.drink_id, sum(a.members - 1) as sum_alc
FROM ( SELECT pa.party_id, count(*) as members
	FROM party_id_alcoholic_id as pa
	WHERE pa.alcoholic_id = alcoholic_A
	GROUP BY pa.party_id 
		INNER JOIN (SELECT party_id, drink_id, date_happened
			FROM party) p ON p.party_id = pa.party_id ) a
WHERE a.date_happened BETWEEN '2020-04-21' and '2020-06-23'
GROUP BY a.drink_id
ORDER BY sum_alc DESC;


/*FIXING*/
SELECT a.drink_id, sum(a.members - 1) as sum_alc
FROM ( (SELECT party_id, count(*) as members
	FROM party_id_alcoholic_id
	WHERE alcoholic_id = 1
	GROUP BY party_id) pa
	INNER JOIN 
	(SELECT party_id, drink_id, date_happened
	FROM party) p 
	ON p.party_id = pa.party_id ) a
WHERE a.date_happened BETWEEN '2020-04-21' and '2020-06-23'
GROUP BY a.drink_id
ORDER BY sum_alc DESC;

/*looks like its fixed*/
/*---------------------------------------------------------------------------------------*/




