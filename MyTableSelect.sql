--`
SELECT * FROM dbo.Sub WHERE idRate =3;

SELECT Sub.SubName, Rate.RateName FROM Sub
Join Rate ON Sub.idSub = Rate.idRate;

SELECT Sub.SubName, Rate.RateName, Payment.Summ FROM Sub
Join Rate ON Sub.idSub = Rate.idRate
Join Payment ON Payment.idSub = Sub.idSub;

SELECT Sub.SubName,Sub.SubAdress,Rate.RateName, Payment.Summ FROM Sub
JOIN Rate ON Rate.idRate = Sub.idRate
JOIN Payment ON Payment.idSub = Sub.idSub
WHERE Summ BETWEEN 300 AND 700 
AND RateName LIKE 'По україні';


SELECT Sub.SubName, Rate.RateName, InfoATC.DateOfCall, Payment.Summ FROM Sub
Join Rate ON Sub.idSub = Rate.idRate
Join Payment ON Payment.idSub = Sub.idSub
Join InfoATC ON Sub.idSub  = InfoATC.idSub
WHERE DateOfCall LIKE '11.05.2018';

SELECT  Sub.SubName, 
		Rate.RateName, 
		Payment.PeriodOfPay, 
		Payment.Summ 
	FROM Sub
JOIN Rate ON Rate.idRate = Sub.idSub
JOIN Payment ON Sub.idSub = Payment.idSub
WHERE PeriodOfPay LIKE '01.02%' 
AND Summ BETWEEN 100 AND 300;


SELECT Sub.SubName, 
       Rate.RateName, 
	   Report.DateOfReport, 
	   Payment.Summ 
	FROM Sub
JOIN Rate ON Rate.idRate = Sub.idSub
JOIN Report ON Sub.idRate = Report.idReport   
JOIN Payment ON Sub.idSub = Payment.idSub
WHERE SubName LIKE 'Діма' AND Summ BETWEEN 300 AND 600;
 

SELECT Sub.SubName,
		Sub.SubAdress,
		Rate.RateName,
		Rate.RatePrise,
		Payment.PeriodOfPay,
		Payment.Summ
FROM Sub
JOIN Rate ON Rate.idRate = Sub.idRate
JOIN Payment ON Sub.idSub = Payment.idSub
WHERE PeriodOfPay LIKE '01.02%' AND RatePrise BETWEEN 40 AND 60;

SELECT Sub.SubName,
		Sub.SubAdress,
		Rate.RateName,
		Rate.RatePrise,
		Payment.PeriodOfPay,
		Payment.Summ
FROM Sub
JOIN Rate ON Rate.idRate = Sub.idRate
JOIN Payment ON Sub.idSub = Payment.idSub
WHERE PeriodOfPay LIKE '01.01%' AND RatePrise BETWEEN 20 AND 40
ORDER BY RatePrise DESC;

