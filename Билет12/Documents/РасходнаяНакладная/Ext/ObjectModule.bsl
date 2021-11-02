﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаПроведенияОперУчет(Отказ, Режим);

	Движения.Управленческий.Записывать = Истина;
	Движения.Управленческий.Записать();
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.Материалы);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = СписокНоменклатуры;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура, "Номенклатура");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Управленческий");
	ЭлементБлокировки.УстановитьЗначение("Счет", ПланыСчетов.Управленческий.Товары);
	ЭлементБлокировки.УстановитьЗначение(ПланыВидовХарактеристик.ВидыСубконто.Склады, Склад);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = СписокНоменклатуры;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура, "Номенклатура");
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура.ЭтоКомпьютер КАК НоменклатураЭтоКомпьютер,
		|	СУММА(РасходнаяНакладнаяСписокНоменклатуры.Количество) КАК Количество,
		|	СУММА(РасходнаяНакладнаяСписокНоменклатуры.Сумма) КАК Сумма
		|ПОМЕСТИТЬ ВТ_ДанныеДок
		|ИЗ
		|	Документ.РасходнаяНакладная.СписокНоменклатуры КАК РасходнаяНакладнаяСписокНоменклатуры
		|ГДЕ
		|	РасходнаяНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура,
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура.ЭтоКомпьютер
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеДок.Номенклатура КАК Номенклатура,
		|	ВТ_ДанныеДок.НоменклатураЭтоКомпьютер КАК ЭтоКомпьютер,
		|	ВТ_ДанныеДок.Номенклатура.Представление КАК НоменклатураПредставление,
		|	ВТ_ДанныеДок.Количество КАК Количество,
		|	ВТ_ДанныеДок.Сумма КАК Сумма,
		|	ЕСТЬNULL(УправленческийОстаткиМатериалы.КоличествоОстаток, 0) + ЕСТЬNULL(УправленческийОстаткиКомпьютеры.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(УправленческийОстаткиМатериалы.СуммаОстаток, 0) + ЕСТЬNULL(УправленческийОстаткиКомпьютеры.СуммаОстаток, 0) КАК СуммаОстаток
		|ИЗ
		|	ВТ_ДанныеДок КАК ВТ_ДанныеДок
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
		|				&МоментВремени,
		|				Счет = &Материалы,
		|				&СубконтоНоменклатура,
		|				Субконто1 В
		|					(ВЫБРАТЬ
		|						ВТ_ДанныеДок.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТ_ДанныеДок КАК ВТ_ДанныеДок
		|					ГДЕ
		|						НЕ ВТ_ДанныеДок.НоменклатураЭтоКомпьютер)) КАК УправленческийОстаткиМатериалы
		|		ПО ВТ_ДанныеДок.Номенклатура = УправленческийОстаткиМатериалы.Субконто1
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Управленческий.Остатки(
		|				&МоментВремени,
		|				Счет = &Товары,
		|				&СубконтоСкладНоменклатура,
		|				Субконто1 = &Склад
		|					И Субконто2 В
		|						(ВЫБРАТЬ
		|							ВТ_ДанныеДок.Номенклатура КАК Номенклатура
		|						ИЗ
		|							ВТ_ДанныеДок КАК ВТ_ДанныеДок
		|						ГДЕ
		|							ВТ_ДанныеДок.НоменклатураЭтоКомпьютер)) КАК УправленческийОстаткиКомпьютеры
		|		ПО ВТ_ДанныеДок.Номенклатура = УправленческийОстаткиКомпьютеры.Субконто2";
	
	Запрос.УстановитьПараметр("Материалы", ПланыСчетов.Управленческий.Материалы);
	Запрос.УстановитьПараметр("Товары", ПланыСчетов.Управленческий.Товары);
	
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	СубконтоНоменклатура = Новый Массив;
	СубконтоНоменклатура.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	Запрос.УстановитьПараметр("СубконтоНоменклатура", СубконтоНоменклатура);
	
	СубконтоСкладНоменклатура = Новый Массив;
	СубконтоСкладНоменклатура.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Склады);
	СубконтоСкладНоменклатура.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Номенклатура);
	Запрос.УстановитьПараметр("СубконтоСкладНоменклатура", СубконтоСкладНоменклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НеХватает = Выборка.Количество - Выборка.КоличествоОстаток;
		Если НеХватает > 0 Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Не хватает товара %1 в количестве %2", Выборка.НоменклатураПредставление, НеХватает);
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		Если Отказ Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		Себестоимость = Выборка.Количество / Выборка.КоличествоОстаток * Выборка.СуммаОстаток; 
		Если Выборка.ЭтоКомпьютер Тогда
			
			Движение = Движения.Управленческий.Добавить();
			Движение.СчетДт = ПланыСчетов.Управленческий.ПрибылиУбытки;
			Движение.СчетКт = ПланыСчетов.Управленческий.Товары;
			Движение.Период = Дата;
			Движение.Сумма = Себестоимость;
			Движение.КоличествоКт = Выборка.Количество;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = Склад;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			
		Иначе
			
			Движение = Движения.Управленческий.Добавить();
			Движение.СчетДт = ПланыСчетов.Управленческий.ПрибылиУбытки;
			Движение.СчетКт = ПланыСчетов.Управленческий.Материалы;
			Движение.Период = Дата;
			Движение.Сумма = Себестоимость;
			Движение.КоличествоКт = Выборка.Количество;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
			
		КонецЕсли;
		
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Управленческий.Покупатели;
		Движение.СчетКт = ПланыСчетов.Управленческий.ПрибылиУбытки;
		Движение.Период = Дата;
		Движение.Сумма = Выборка.Сумма;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = Выборка.Номенклатура;
		
	КонецЦикла;
	
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры

Процедура ОбработкаПроведенияОперУчет(Отказ, Режим)
	
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Движения.ОстаткиНоменклатуры.Записать();
	
	Движения.ПотребностиЗаказаПокупателя.Записывать = Истина;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	СУММА(РасходнаяНакладнаяСписокНоменклатуры.Количество) КАК Количество
		|ПОМЕСТИТЬ ВТ_ДанныеДок
		|ИЗ
		|	Документ.РасходнаяНакладная.СписокНоменклатуры КАК РасходнаяНакладнаяСписокНоменклатуры
		|ГДЕ
		|	РасходнаяНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходнаяНакладнаяСписокНоменклатуры.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеДок.Номенклатура КАК Номенклатура,
		|	ВТ_ДанныеДок.Номенклатура.Представление КАК НоменклатураПредставление,
		|	ВТ_ДанныеДок.Количество КАК Количество,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(ОстаткиНоменклатурыОстатки.СуммаОстаток, 0) КАК СуммаОстаток
		|ИЗ
		|	ВТ_ДанныеДок КАК ВТ_ДанныеДок
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиНоменклатуры.Остатки(
		|				&МоментВремени,
		|				ЗаказПокупателя = &ЗаказПокупателя
		|					И Номенклатура В
		|						(ВЫБРАТЬ
		|							ВТ_ДанныеДок.Номенклатура КАК Номенклатура
		|						ИЗ
		|							ВТ_ДанныеДок КАК ВТ_ДанныеДок)) КАК ОстаткиНоменклатурыОстатки
		|		ПО ВТ_ДанныеДок.Номенклатура = ОстаткиНоменклатурыОстатки.Номенклатура";
	
	Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НеХватает = ВыборкаДетальныеЗаписи.Количество - ВыборкаДетальныеЗаписи.КоличествоОстаток;
		Если НеХватает > 0 Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Не хватает товара %1 в количестве %2", ВыборкаДетальныеЗаписи.НоменклатураПредставление, НеХватает);
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		Если Отказ Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		Движение = Движения.ПотребностиЗаказаПокупателя.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.ЗаказПокупателя = ЗаказПокупателя;
		Движение.КоличествоОтгрузить = ВыборкаДетальныеЗаписи.Количество;
		
	
		Движение = Движения.ОстаткиНоменклатуры.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.ЗаказПокупателя = ЗаказПокупателя;
		Движение.Количество = ВыборкаДетальныеЗаписи.Количество;
		Движение.Сумма = ВыборкаДетальныеЗаписи.Количество / ВыборкаДетальныеЗаписи.КоличествоОстаток * ВыборкаДетальныеЗаписи.СуммаОстаток;
		
	КонецЦикла;
	Движения.ПотребностиЗаказаПокупателя.БлокироватьДляИзменения = Истина;
	Движения.Записать();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиНоменклатурыОстатки.Номенклатура КАК Номенклатура,
	|	ОстаткиНоменклатурыОстатки.Номенклатура.Представление КАК НоменклатураПредставление,
	|	-ОстаткиНоменклатурыОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиНоменклатуры.Остатки(
	|			&граница,
	|			ЗаказПокупателя = &ЗаказПокупателя
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТ_ДанныеДок.Номенклатура КАК Номенклатура
	|					ИЗ
	|						ВТ_ДанныеДок КАК ВТ_ДанныеДок)) КАК ОстаткиНоменклатурыОстатки
	|ГДЕ
	|	ОстаткиНоменклатурыОстатки.КоличествоОстаток < 0";
	
	Запрос.УстановитьПараметр("Граница", Новый Граница(МоментВремени(), ВидГраницы.Включая));
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("Превышено допустимое количество для отгрузки по товару %1 в количестве %2",
			ВыборкаДетальныеЗаписи.НоменклатураПредставление, ВыборкаДетальныеЗаписи.КоличествоОстаток);
		Сообщение.Сообщить();
		
	КонецЦикла;

	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры
