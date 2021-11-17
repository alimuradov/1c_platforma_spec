﻿
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	
	Если ТребуемыеПараметры = Неопределено Тогда
		
		ТекПользователь = Справочники.ФизическиеЛица.НайтиПоНаименованию(ИмяПользователя());
		Если ТекПользователь = Неопределено Тогда
			ПараметрыСеанса.ТекущаяДолжность = Неопределено;
		Иначе
			Отбор = новый Структура("Исполнитель", ТекПользователь);
			Запись = РегистрыСведений.РегистрАдресации.Получить(Отбор);
			ПараметрыСеанса.ТекущаяДолжность = Запись.Должность;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
