use torg_firm


-- 1)Створити представлення  для збереження алгоритму розрахунку загальної вартості замовлених товарів. Назва представлення – «QResult».
CREATE View qresult AS
	
	Select zakaz_tovar.id_zakaz, klient.Nazva, zakaz_tovar.id_tovar,
			zakaz_tovar.Kilkist, zakaz_tovar.Znigka, tovar.Price * zakaz_tovar.Kilkist * ( 1 - zakaz_tovar.Znigka) AS Zag_vartist

	   from (klient join zakaz on klient.id_klient = zakaz.id_klient)
			join ( Tovar join zakaz_tovar on tovar.id_tovar = zakaz_tovar.id_tovar) on
			zakaz.id_zakaz = zakaz_tovar.id_zakaz

--2)Розрахувати загальну вартість всіх замолень. Назва представлення – «Qresult2».
Create view qresult2 AS

	Select qresult.id_zakaz, klient.Nazva, zakaz.date_naznach,
		Sum(qresult.Zag_vartist) as Itog
	From (klient join zakaz on klient.id_klient = zakaz.id_klient)
	     join qresult on zakaz.id_zakaz = qresult.id_zakaz
	Group by qresult.id_zakaz, klient.Nazva, zakaz.date_naznach

--3)Вивести середню вартість замовлення по кожному співробітнику:
Select sotrudnik.Fname, sotrudnik.Name, sotrudnik.Posada,
	   AVG(qresult2.Itog) as [avg-itog]
from (sotrudnik join zakaz on sotrudnik.id_sotrud = zakaz.id_sotrud)
	  join qresult2 on zakaz.id_zakaz = qresult2.id_zakaz
group by sotrudnik.Fname, sotrudnik.Name, sotrudnik.Posada

--4)Вивести дані про 3 замовлення з найбільшою сумою:
SELECT TOP 3 sotrudnik.Fname, sotrudnik.[Name], sotrudnik.Posada,
 qresult.Zag_vartist as [vartist]

FROM (sotrudnik join zakaz on sotrudnik.id_sotrud = zakaz.id_sotrud)
 join qresult on zakaz.id_zakaz = qresult.id_zakaz
ORDER BY vartist desc;

--5)Вивести загальну вартість замовлень за клієнтами:
Select klient.Nazva, Sum(qresult.Zag_vartist) as [sum-zag_vartist]

from (klient join zakaz on klient.id_klient = zakaz.id_klient)
	join qresult on zakaz.id_zakaz = qresult.id_zakaz
group by klient.Nazva

--6)Вивести для кожного товару найбільшу суму, на яку він був придбаний.
Select tovar.Nazva, Max(tovar.Price * zakaz_tovar.Kilkist * ( 1 - zakaz_tovar.Znigka)) as Zag_vartist
from tovar join zakaz_tovar on 
	tovar.id_tovar = zakaz_tovar.id_tovar
group by tovar.Nazva

--7)Розрахувати загальну кількість замовлень за кожним співробітником.
Select sotrudnik.Fname, sotrudnik.Name, sotrudnik.Posada,
		count(zakaz.id_zakaz) as [count-id_zakaz]
from zakaz join sotrudnik on zakaz.id_sotrud = sotrudnik.id_sotrud
group by sotrudnik.Fname, sotrudnik.Name, sotrudnik.Posada

--1)Вивести список постачальників, які мешкають в одному місті з клієнтами. Переглянути, як зміниться запит, якщо умову «=« змінити на «<>«.
SELECT Klient.Nazva, Postachalnik.Nazva
FROM Klient, Postachalnik
WHERE Klient.City=Postachalnik.City;

--2)Вивести список товарів, ціна на які вища за середню.
SELECT Tovar.Nazva
FROM Tovar
WHERE (Tovar.Price>(SELECT AVG (Price)
FROM Tovar));

--3)Вивести список товарів, які було продано зі знижкою більше 5%.
SELECT *
FROM Tovar
WHERE id_tovar IN (SELECT id_tovar FROM Zakaz_tovar 
WHERE Znigka >=0.05);

--4)Вставити в таблицю «Tovar» (див. рис. 1.19) відомості про новий товар.
INSERT INTO Tovar ( Nazva, Price, id_postav )
VALUES ('кефір', 12.5, 1);

--5)!!!Вставити в таблицю «Klient» всіх постачальників, що мешкають у Житомирі.
INSERT INTO Klient ( nazva )
SELECT Nazva
FROM Postachalnik
WHERE Postachalnik.city='Житомир';

--6)Підвищити ціну на товари від постачальника з кодом  1 на 13%.
UPDATE Tovar SET Price = (1.13*Price)
WHERE id_postav=1;

--7)Знищити з таблиці «Tovar» (див. рис. 1.19) запис зі значенням поля K_tovar=25.
DELETE 
FROM Tovar
WHERE id_tovar=25;

--8)Знищити з таблиці «Zakaz» (див. рис. 1.20) всі замовлення від клієнта із зазначеною назвою.
DELETE 
FROM Zakaz
WHERE id_klient=(SELECT id_klient FROM Klient 
WHERE Nazva like 'Введіть назву клієнта' )

--9)Вивести одночасно відомості про всіх партнерів фірми
SELECT Postachalnik.Nazva, Postachalnik.City, Postachalnik.Adress
FROM Postachalnik
UNION 
SELECT Klient.Nazva, Klient.City, Klient.Adress
FROM Klient;

--10)Побудувати запит з параметрами,  який виводить відомості про товари, замовлені після вказаної дати та з ціною, що перевищує задану.
Declare @min decimal(10,4) = 0.5, @date_begin DateTime = '01.01.2018'
SELECT zakaz_tovar.id_zakaz, zakaz.date_rozm, tovar.price, zakaz_tovar.kilkist
FROM zakaz INNER JOIN (Tovar INNER JOIN zakaz_tovar 
ON Tovar.id_tovar=zakaz_tovar.id_tovar) 
ON zakaz.id_zakaz=zakaz_tovar.id_zakaz
WHERE tovar.price>@min And zakaz.date_rozm>=@date_begin;


-------------------------ТОРГОВА ФІРМА ----------------------------------
use torg_firm

--1)Вивести загальну кількість товарів на підприємстві.
Select sum(tovar.NaSklade) AS [VesTovar]
from tovar 

--2)Вивести загальну кількість співробітників підприємства.
Select count(*) as countsSotrutdik
from sotrudnik

--3)Вивести загальну кількість постачальників підприємства.
Select distinct count(*) as countsPostachalnik
from sotrudnik

--4)Вивести кількість за кожним товаром, що придбані у поточному місяці.
Select tovar.Nazva, zakaz.date_naznach, sum(zakaz_tovar.Kilkist)
	from tovar
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
		join zakaz on
			zakaz_tovar.id_zakaz = zakaz.id_zakaz and zakaz.date_naznach LIKE '2017-06%'
	group by tovar.Nazva, zakaz.date_naznach

--5)Вивести суму, на яку були придбані товари у поточному місяці.
Select zakaz.date_naznach, SUM(tovar.Price * zakaz_tovar.Kilkist) as summa
	from tovar
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
		join zakaz on
			zakaz_tovar.id_zakaz = zakaz.id_zakaz
		group by zakaz.date_naznach 

--6)Вивести суму продажу товарів за кожним постачальником.
Select postachalnik.Nazva, sum(tovar.Price *(zakaz_tovar.Kilkist)) AS [TOVAR]
	from tovar
		join postachalnik on
			tovar.id_postav = postachalnik.id_postach
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
		group by postachalnik.Nazva
			
--7) Вивести загальну кількість замовлень за кожним постачальником, що продає молоко.
Select postachalnik.Nazva, COUNT(zakaz_tovar.id_zakaz) AS [AllKilk]
	from tovar 
		join postachalnik on
			tovar.id_postav = postachalnik.id_postach and tovar.Nazva  like 'молоко'
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
		group by postachalnik.Nazva

--8) Вивести середню суму, на яку замовлявся товар.
Select tovar.Nazva, AVG(zakaz_tovar.Kilkist * tovar.Price) AS [AVGPrice]
	from tovar
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
	group by tovar.Nazva

--9) Вивести вартість замовлень усіх клієнтів, що мешкають у Житомирі.
Select klient.Nazva, sum ( tovar.Price * zakaz_tovar.Kilkist) AS [Price]
	from tovar
		join zakaz_tovar on
			tovar.id_tovar = zakaz_tovar.id_tovar
		join zakaz on
			zakaz_tovar.id_zakaz = zakaz.id_zakaz
		join klient on
			zakaz.id_klient = klient.id_klient and klient.City like 'Житомир'
	group by klient.Nazva

-- 10) Вивести середню ціну на товари по кожному постачальнику.
Select tovar.Nazva, AVG (tovar.Price) as AvgPrice
	from tovar
	group by tovar.Nazva 

----------------------------БАЗА ДАНИХ РЕЙТИНГ --------------------------------------------------------
use reiting

-- 1) Сумарний рейтинг студента з кожної дисципліни.
Select dbo_student.Name_ini,predmet.Nazva, sum(Reiting.Reiting) / COUNT(Reiting.Reiting) as ball 
	from dbo_student
		join Reiting on
			dbo_student.Kod_stud = Reiting.Kod_student
		join Rozklad_pids on
			Reiting.K_zapis = Rozklad_pids.K_zapis
		join Predmet_plan on
			Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
		join predmet on
			Predmet_plan.K_predmet = predmet.K_predmet
	group by dbo_student.Name_ini,predmet.Nazva

--2) Розрахувати кількість студентів у кожній групі.
Select dbo_groups.Kod_group, count (dbo_student.Kod_stud) as kilkist
	from dbo_groups
		join dbo_student on
			dbo_groups.Kod_group = dbo_student.Kod_group
	group by dbo_groups.Kod_group

--3)Розрахувати кількість дисциплін за групою.
Select dbo_groups.Kod_group, count(predmet.Nazva) as kilkistDusziplin
	from dbo_groups
		join Predmet_plan on
			dbo_groups.K_navch_plan = Predmet_plan.K_navch_plan
		join predmet on
			Predmet_plan.K_predmet = predmet.K_predmet
	group by dbo_groups.Kod_group


--4)Розрахувати кількість проведених занять у кожній групі.
select dbo_groups.Kod_group , sum(Predmet_plan.Chas_all)/2 
 from dbo_groups
	join Predmet_plan on
	    Predmet_plan.K_navch_plan = dbo_groups.K_navch_plan 
 group by dbo_groups.Kod_group

--5)Розрахувати середній бал за групою.
Select dbo_groups.Kod_group, sum(Reiting.Reiting) / COUNT(Reiting.Reiting) as ball 
		from dbo_student
			join dbo_groups on
			dbo_student.Kod_group = dbo_groups.Kod_group
			join Reiting on
				dbo_student.Kod_stud = Reiting.Kod_student
			join Rozklad_pids on
				Reiting.K_zapis = Rozklad_pids.K_zapis
			join Predmet_plan on
				Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
			join predmet on
				Predmet_plan.K_predmet = predmet.K_predmet
		group by dbo_groups.Kod_group

--6)Розрахувати середній бал з дисципліни.
Select predmet.Nazva, sum(reiting.Reiting)/ count(reiting.Reiting) AS [AVG Ball]
from  predmet
join Predmet_plan on Predmet_plan.K_predmet = predmet.K_predmet
join Rozklad_pids on Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
join Reiting on reiting.K_zapis = Rozklad_pids.K_zapis
group by predmet.Nazva

--7) Розрахувати поточний рейтинг студента з кожної дисципліни.
Select dbo_student.Name_ini,predmet.Nazva, sum(Reiting.Reiting) / COUNT(Reiting.Reiting) as ball 
	from dbo_student
		join Reiting on
			dbo_student.Kod_stud = Reiting.Kod_student
		join Rozklad_pids on
			Reiting.K_zapis = Rozklad_pids.K_zapis
		join Predmet_plan on
			Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
		join predmet on
			Predmet_plan.K_predmet = predmet.K_predmet
	group by dbo_student.Name_ini,predmet.Nazva

Select *
from Reiting
--8)Відобразити найменший рейтинг студентів з дисципліни
Select dbo_student.Name_ini,predmet.Nazva, (sum(Reiting.Reiting) / COUNT(Reiting.Reiting)) as ball 
	from dbo_student
		join Reiting on
			dbo_student.Kod_stud = Reiting.Kod_student
		join Rozklad_pids on
			Reiting.K_zapis = Rozklad_pids.K_zapis
		join Predmet_plan on
			Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
		join predmet on
			Predmet_plan.K_predmet = predmet.K_predmet
	group by dbo_student.Name_ini,predmet.Nazva
	Having (sum(Reiting.Reiting) / COUNT(Reiting.Reiting)) < 60

--9)Відобразити найбільший студентський рейтинг з дисципліни.
Select dbo_student.Name_ini,predmet.Nazva, (sum(Reiting.Reiting) / COUNT(Reiting.Reiting)) as ball 
	from dbo_student
		join Reiting on
			dbo_student.Kod_stud = Reiting.Kod_student
		join Rozklad_pids on
			Reiting.K_zapis = Rozklad_pids.K_zapis
		join Predmet_plan on
			Rozklad_pids.K_predm_pl = Predmet_plan.K_predm_pl
		join predmet on
			Predmet_plan.K_predmet = predmet.K_predmet
	group by dbo_student.Name_ini,predmet.Nazva
	Having (sum(Reiting.Reiting) / COUNT(Reiting.Reiting)) > 60

--10)Розрахувати кількість проведених занять за видами для кожної дисципліни.
select predmet.Nazva, sum(Predmet_plan.Cahs_sam)/2 as samCahs , sum(Predmet_plan.Chas_Labor)/2 as laborCahs, sum(Predmet_plan.Chas_Lek)/2 as lekCahs
 from dbo_groups
	join Predmet_plan on
	    Predmet_plan.K_navch_plan = dbo_groups.K_navch_plan 
	join predmet on
		Predmet_plan.K_predmet = predmet.K_predmet
 group by predmet.Nazva

 --11)Розрахувати кількість груп за кожною спеціальністю.
 Select Spetsialnost.Nazva, count (dbo_groups.Kod_group) as countGroups
	from Spetsialnost
		join Navch_plan on
			Navch_plan.K_spets = Spetsialnost.K_spets
		join dbo_groups on
			dbo_groups.K_navch_plan = Navch_plan.K_navch_plan
	group by Spetsialnost.Nazva

--12)Запит на знищення даних з таблиці «Reiting» за визначеним кодом студента (в поле параметра вводиться прізвище студента).
Delete from Reiting
where Reiting.Kod_student = 84

--13)Запит на знищення даних з таблиці «Para» за визначеним кодом дисципліни (у поле параметра вводиться назва дисципліни).
Declare @Parametr varchar(100) = 'Код дисципліни'
Delete from predmet where predmet.K_predmet = (Select predmet.K_predmet from predmet where predmet.Nazva = @Parametr);

--14)Запит на оновлення даних у таблиці «Reiting» – передбачити збільшення балів за модульні контролі на 15%.

--16)Запит на вставку даних до таблиці «Reiting» – передбачити вставку даних студентів визначеної групи (код пари та
-- початковий бал задається динамічно).

DECLARE @Counter int
DECLARE @Mark int
SET @Mark = 50
SET @Counter = 1

WHILE @Counter<10 BEGIN
     INSERT INTO Reiting ( Reiting.Kod_student,Reiting.K_zapis,Reiting.Reiting, Reiting.Prisutn) VALUES (94, 10, @Mark, @Counter)
     SET @Counter = @Counter + 1
END


Select *
from dbo_groups
	join dbo_student on dbo_student.Kod_group = dbo_groups.Kod_group

Select *
	from Rozklad_pids


-------------------------------------- ІНДИВІДУАЛЬНІ ЗАВДАННЯ ----------------------------------------------------------
use Lab_02

INSERT INTO InfoATC (DateOfCall,TypeOfCall,StartEndCall,idSub) values
('2018.03.01','За кордон','65','1'),
('2018.06.06','По місту','41','2'),
('2018.06.03','На другий оператор','122','4'),
('2018.06.04','По місту','23','2'),
('2018.06.03','По місту','12','2'),
('2018.06.04','На другий оператор','98','3'),
('2018.05.30','За кордон','44','4')

-- Загально наговорені хвилини Богданом по тарифу "За кордон"

SELECT Sub.SubName, InfoATC.TypeOfCall, SUM (InfoATC.StartEndCall) AS [AllMins] FROM Sub
JOIN InfoATC ON InfoATC.idSub = Sub.idSub
WHERE Sub.SubName LIKE 'Богдан' AND InfoATC.TypeOfCall LIKE 'За кордон'


SELECT InfoATC.TypeOfCall, COUNT (InfoATC.StartEndCall) AS [AllMins] FROM InfoATC

-- Добавимо більше даних до таблиці Payment

INSERT INTO Payment (PeriodOfPay,Summ,idSub) VALUES 
('01.01.2017-01.02.2018','123','1'),
('01.01.2017-01.02.2018','164','2'),
('01.01.2017-01.02.2018','186','1'),
('01.01.2017-01.02.2018','2423','1'),
('01.01.2017-01.02.2018','231','2'),
('01.01.2017-01.02.2018','2332','1'),
('01.01.2017-01.02.2018','2231','2'),
('01.01.2017-01.02.2018','2334','1'),
('01.01.2017-01.02.2018','3654','2'),
('01.01.2017-01.02.2018','4457','1'),
('01.01.2017-01.02.2018','345','2'),
('01.01.2017-01.02.2018','435','1'),
('01.01.2017-01.02.2018','5333','3')


-- Вивести суму грошей яку винен Богдан за період 01.01.2017-01.02.2018

SELECT Sub.SubName, Payment.PeriodOfPay, SUM(Payment.Summ) AS [SUM] FROM Sub
JOIN Payment ON Payment.idSub = Sub.idSub
WHERE Sub.SubName LIKE 'Богдан' AND Payment.PeriodOfPay LIKE '01.01.2017-01.02.2018'
GROUP BY Sub.SubName, Payment.PeriodOfPay


-- Вивести загальну кількість абонентів, та загальну суму наговорених грошей по всім тарифам


SELECT COUNT(Sub.SubName) AS [Abonents], SUM(Payment.Summ) AS [AllMoney]  FROM Sub
JOIN Payment ON Payment.idSub = Sub.idSub


-- Вивести свіх користувачів, які взяли квитанцію 2018-05-15.

SELECT Sub.SubName, Report.DateOfReport, SUM(Payment.Summ) AS [Сумма наговорених коштів] FROM Sub
JOIN Report ON Report.idReport =  Sub.idSub
JOIN Payment ON Payment.idSub = Sub.idSub
WHERE DateOfReport LIKE '2018-05-15'
GROUP BY Sub.SubName, Report.DateOfReport



		