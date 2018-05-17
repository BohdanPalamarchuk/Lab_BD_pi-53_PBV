CREATE DATABASE Lab_02

create table Sub(
idSub int IDENTITY(1,1) not null primary key ,
SubName varchar(40) not null,
SubAdress varchar(50) not null,
idRate int not null foreign key (idRate) references dbo.Rate(idRate)
on delete cascade on update no action)

create table Rate(
idRate int IDENTITY(1,1) not null primary key,
RateName varchar(30),
RatePrise int not null)

create table Payment(
idPayment int IDENTITY(1,1) not null primary key,
PeriodOfPay varchar(100) not null,
Summ money not null,
idSub int not null foreign key (idSub) references dbo.Sub(idSub)
on delete cascade on update no action) 

create table InfoATC(
idInfoATC int not null IDENTITY(1,1) primary key,
DateOfCall varchar(50) not null,
TypeOfCall varchar(30) not null,
StartEndCall varchar(100) not null,
idSub int not null foreign key (idSub) references dbo.Sub(idSub)
on delete cascade on update no action)

create table Report(
idReport int IDENTITY(1,1) primary key,
DateOfReport date not null,
idInfoATC int not null foreign key (idInfoATC) references dbo.InfoATC(idInfoATC)
on delete cascade on update no action)