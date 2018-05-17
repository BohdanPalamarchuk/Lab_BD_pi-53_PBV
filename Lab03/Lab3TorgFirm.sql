--1)	Перелік замовлень до певної дати для товару молоко.

SELECT zakaz.date_naznach, tovar.Nazva
FROM zakaz_tovar join zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
JOIN tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE tovar.Nazva LIKE 'М%' AND zakaz.date_naznach BETWEEN '2017-07-02' AND '2017-07-20'

--2)	Перелік товарів ціна яких знаходиться в заданому діапазоні і кількість на складі не менше  за 15 одиниць.

SELECT zakaz_tovar.Kilkist, tovar.Price, tovar.Nazva	
FROM zakaz_tovar JOIN tovar ON zakaz_tovar.id_tovar=tovar.id_tovar
WHERE tovar.Price BETWEEN 18 AND 21 AND zakaz_tovar.Kilkist>15 

--3)	Перелік замовлень для яких не визначено дату виконання.

SELECT zakaz.date_rozm, tovar.Nazva
FROM zakaz_tovar JOIN zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
JOIN tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE zakaz.date_rozm is null

--4)	Перелік товарів певного постачальника наявних у визначеній кількості.

SELECT tovar.Nazva, postachalnik.Nazva, zakaz_tovar.Kilkist
FROM postachalnik JOIN tovar ON postachalnik.id_postach= tovar.id_postav
JOIN zakaz_tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE postachalnik.Nazva LIKE 'ТОВ "Арей"' AND zakaz_tovar.Kilkist=16

--5)	Визначити вартість всіх замовлених товарів за останні 30 днів, якщо постачальники є ТОВ

SELECT tovar.Price, zakaz.date_naznach, postachalnik.Nazva
FROM postachalnik JOIN tovar ON postachalnik.id_postach= tovar.id_postav
JOIN zakaz_tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
JOIN zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
WHERE postachalnik.Nazva LIKE 'ТОВ%' AND zakaz.date_naznach BETWEEN '2017-07-10' AND '2017-07-21'

--6)	Визначити коди співробітників та дати, коли вони  обслуговували замовлення від певного клієнту

SELECT sotrudnik.id_sotrud, zakaz.date_naznach, klient.Nazva
FROM sotrudnik JOIN zakaz ON sotrudnik.id_sotrud= zakaz.id_sotrud
JOIN klient ON zakaz.id_klient= klient.id_klient
WHERE klient.Nazva LIKE 'ПП Стоян С.В.'

--7)	Перелік постачальників що є ЗАТ і не постачали товарів

INSERT INTO dbo.postachalnik (id_postach,Nazva, Adress, City,Tel, Kontakt_osoba, Posada)
VALUES(4,'ЗАТ Полісся','вул Небесної сотні','Житомир','0971116754','Шуваєва К.А','менеджер')
SELECT * FROM postachalnik

--8)	Перелік клієнтів що є ПП і купували товари в попередньому місяці.

SELECT postachalnik.id_postach, postachalnik.Nazva, postachalnik.Adress, postachalnik.City, postachalnik.Kontakt_osoba, postachalnik.Posada, tovar.id_postav
FROM postachalnik LEFT JOIN tovar ON postachalnik.id_postach= tovar.id_postav
WHERE postachalnik.Nazva LIKE 'ЗАТ%' AND tovar.id_postav is null

--9)	Перелік співробітників, на ім‘я Андрій впорядкувати за абеткою


SELECT klient.id_klient, klient.Nazva, klient.Adress, klient.City, klient.Tel, zakaz.id_klient, zakaz.date_naznach
FROM klient JOIN zakaz ON klient.id_klient= zakaz.id_klient
WHERE klient.Nazva LIKE 'ПП%' AND  zakaz.date_naznach < '2017-07-20'

SELECT * FROM sotrudnik
INSERT INTO dbo.sotrudnik(id_sotrud, Fname, Name, Lname, Posada, Adress,City,Home_tel)
VALUES(4,'Шуваєв','Андрій','Васильович','Менеджер','вул. Київська 79 кв.26','Житомир','0971116754'),
(5,'Гришко','Андрій','Іванович','Менеджер+консультант','вул. Кочерги 120 кв.36','Житомир','0974566758'),
(6,'Андрушко','Андрій','Сергыйович','Консультант','вул. Селецька 10 кв.166','Житомир','0974563428')
SELECT * FROM sotrudnik WHERE sotrudnik.Name LIKE 'Андрій' ORDER BY sotrudnik.Fname

--10)	Перелік клієнтів що мають e-mail впорядкувати за id.

ALTER TABLE klient ADD Email varchar(100)
SELECT * FROM klient

DELETE FROM dbo.klient
WHERE klient.Nazva LIKE 'ПП Петров і товаріщі'

INSERT INTO dbo.klient(id_klient, Nazva,Adress, City)
VALUES(7,'ПП Петров і товаріщі','вул. Косачів 123','Житомир' )
ALTER TABLE dbo.klient DROP COLUMN Email

SELECT * FROM klient WHERE klient.Tel is not null ORDER BY klient.id_klient Desc