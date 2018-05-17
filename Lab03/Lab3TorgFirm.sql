--1)	������ ��������� �� ����� ���� ��� ������ ������.

SELECT zakaz.date_naznach, tovar.Nazva
FROM zakaz_tovar join zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
JOIN tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE tovar.Nazva LIKE '�%' AND zakaz.date_naznach BETWEEN '2017-07-02' AND '2017-07-20'

--2)	������ ������ ���� ���� ����������� � �������� ������� � ������� �� ����� �� �����  �� 15 �������.

SELECT zakaz_tovar.Kilkist, tovar.Price, tovar.Nazva	
FROM zakaz_tovar JOIN tovar ON zakaz_tovar.id_tovar=tovar.id_tovar
WHERE tovar.Price BETWEEN 18 AND 21 AND zakaz_tovar.Kilkist>15 

--3)	������ ��������� ��� ���� �� ��������� ���� ���������.

SELECT zakaz.date_rozm, tovar.Nazva
FROM zakaz_tovar JOIN zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
JOIN tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE zakaz.date_rozm is null

--4)	������ ������ ������� ������������� ������� � ��������� �������.

SELECT tovar.Nazva, postachalnik.Nazva, zakaz_tovar.Kilkist
FROM postachalnik JOIN tovar ON postachalnik.id_postach= tovar.id_postav
JOIN zakaz_tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
WHERE postachalnik.Nazva LIKE '��� "����"' AND zakaz_tovar.Kilkist=16

--5)	��������� ������� ��� ���������� ������ �� ������ 30 ���, ���� ������������� � ���

SELECT tovar.Price, zakaz.date_naznach, postachalnik.Nazva
FROM postachalnik JOIN tovar ON postachalnik.id_postach= tovar.id_postav
JOIN zakaz_tovar ON tovar.id_tovar= zakaz_tovar.id_tovar
JOIN zakaz ON zakaz_tovar.id_zakaz=zakaz.id_zakaz
WHERE postachalnik.Nazva LIKE '���%' AND zakaz.date_naznach BETWEEN '2017-07-10' AND '2017-07-21'

--6)	��������� ���� ����������� �� ����, ���� ����  ������������� ���������� �� ������� �볺���

SELECT sotrudnik.id_sotrud, zakaz.date_naznach, klient.Nazva
FROM sotrudnik JOIN zakaz ON sotrudnik.id_sotrud= zakaz.id_sotrud
JOIN klient ON zakaz.id_klient= klient.id_klient
WHERE klient.Nazva LIKE '�� ����� �.�.'

--7)	������ ������������� �� � ��� � �� ��������� ������

INSERT INTO dbo.postachalnik (id_postach,Nazva, Adress, City,Tel, Kontakt_osoba, Posada)
VALUES(4,'��� ������','��� ������� ����','�������','0971116754','������ �.�','��������')
SELECT * FROM postachalnik

--8)	������ �볺��� �� � �� � �������� ������ � ������������ �����.

SELECT postachalnik.id_postach, postachalnik.Nazva, postachalnik.Adress, postachalnik.City, postachalnik.Kontakt_osoba, postachalnik.Posada, tovar.id_postav
FROM postachalnik LEFT JOIN tovar ON postachalnik.id_postach= tovar.id_postav
WHERE postachalnik.Nazva LIKE '���%' AND tovar.id_postav is null

--9)	������ �����������, �� ��� ����� ������������ �� �������


SELECT klient.id_klient, klient.Nazva, klient.Adress, klient.City, klient.Tel, zakaz.id_klient, zakaz.date_naznach
FROM klient JOIN zakaz ON klient.id_klient= zakaz.id_klient
WHERE klient.Nazva LIKE '��%' AND  zakaz.date_naznach < '2017-07-20'

SELECT * FROM sotrudnik
INSERT INTO dbo.sotrudnik(id_sotrud, Fname, Name, Lname, Posada, Adress,City,Home_tel)
VALUES(4,'�����','�����','����������','��������','���. ������� 79 ��.26','�������','0971116754'),
(5,'������','�����','��������','��������+�����������','���. ������� 120 ��.36','�������','0974566758'),
(6,'��������','�����','����������','�����������','���. �������� 10 ��.166','�������','0974563428')
SELECT * FROM sotrudnik WHERE sotrudnik.Name LIKE '�����' ORDER BY sotrudnik.Fname

--10)	������ �볺��� �� ����� e-mail ������������ �� id.

ALTER TABLE klient ADD Email varchar(100)
SELECT * FROM klient

DELETE FROM dbo.klient
WHERE klient.Nazva LIKE '�� ������ � �������'

INSERT INTO dbo.klient(id_klient, Nazva,Adress, City)
VALUES(7,'�� ������ � �������','���. ������� 123','�������' )
ALTER TABLE dbo.klient DROP COLUMN Email

SELECT * FROM klient WHERE klient.Tel is not null ORDER BY klient.id_klient Desc