﻿Функция ПолучитьТекущуюУчетнуюПолитику(ДатаДокумента) Экспорт

	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетнаяПолитикаСрезПоследних.МетодСписания КАК МетодСписания
		|ИЗ
		|	РегистрСведений.УчетнаяПолитика.СрезПоследних(&ДатаДокумента, ) КАК УчетнаяПолитикаСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий(); 
	
	Возврат ВыборкаДетальныеЗаписи.МетодСписания;

КонецФункции
