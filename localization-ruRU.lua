if(GetLocale() == "ruRU") then

-- ===================== Part for TradeLog ==================
TRADE_LOG_MONEY_NAME = {
	gold = "г",
	silver = "с",
	copper = "б",
}

CANCEL_REASON_TEXT = {
	self = "Я отменил это",
	other = "цель отменила это",
	toofar = "мы слишком далеко",
	selfrunaway = "Я отошел в сторону",
	selfhideui = "Я спрятал интерфейс",
	unknown = "неизвестно почему",
}

TRADE_LOG_SUCCESS_NO_EXCHANGE = "Торговля с [%t] была завершена, но обмен не производился.";
TRADE_LOG_SUCCESS = "Торговля с [%t] была завершена.";
TRADE_LOG_DETAIL = "Подробности";
TRADE_LOG_CANCELLED = "Торговля с [%t] была отменена: %r.";
TRADE_LOG_FAILED = "Торговля с [%t] не удалась: %r.";
TRADE_LOG_FAILED_NO_TARGET = "Торговля не удалась: %r.";
TRADE_LOG_HANDOUT = "дано";
TRADE_LOG_RECEIVE = "получили";
TRADE_LOG_ENCHANT = "наложение чар";
TRADE_LOG_ITEM_NUMBER = "%d предметы";
TRADE_LOG_CHANNELS = {
	whisper = "шептать",
	raid = "Рейд",
	party = "Группа",
	say = "Сказать",
	yell = "Кричать",
}
TRADE_LOG_ANNOUNCE = "УВЕДОМЛЯТЬ";
TRADE_LOG_ANNOUNCE_TIP = "Отметьте это, чтобы автоматически объявить после торговли."

TRADE_LOG_RESULT_TEXT_SHORT = { 
	cancelled = "Отмена", 
	complete = "ok", 
	error = "Неудача", 
}

TRADE_LOG_RESULT_TEXT = {
	cancelled = "Торговля отменена", 
	complete = "Торговля завершена", 
	error = "Торговля не удалась", 
}

TRADE_LOG_MONTH_SUFFIX = "-"
TRADE_LOG_DAY_SUFFIX = ""

TRADE_LOG_COMPLETE_TOOLTIP = "Нажмите, чтобы показать детали";


RECENT_TRADE_TIME = "%d %s тому назад"
RECENT_TRADE_TITLE = "Недавняя Торговля"

-- ===================== Part for TradeList ==================
TRADE_LIST_CLEAR_HISTORY = "Очистить"
TRADE_LIST_SCALE = "Масштаб детализации"
TRADE_LIST_FILTER = "Завершено только"

TRADE_LIST_HEADER_WHEN = "Время"
TRADE_LIST_HEADER_WHO = "Получатель"
TRADE_LIST_HEADER_WHERE = "Расположение"
TRADE_LIST_HEADER_SEND = "Потерянный"
TRADE_LIST_HEADER_RECEIVE = "Получил"
TRADE_LIST_HEADER_RESULT = "Результат"

TRADE_LIST_CLEAR_CONFIRM = "Записи до сегодняшнего дня будут полностью очищены!";

TRADE_LIST_TITLE = "Торговый журнал неограничен"
TRADE_LIST_DESC = "Показать последние журналы торговли или причины неудачных сделок."

end
