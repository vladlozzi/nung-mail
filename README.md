# README

Вебзастосунок для створення акаунтів електронної пошти закладу вищої освіти в Google Mail

Вихідні дані:
1. Файл у форматі TSV Users.tsv. Отримати його можна в адміністратора електронної пошти.
2. Файл у форматі CSV ЕкспортЗдобувачів.csv. Отримати його можна з ЄДЕБО: "Здобувачі освіти"->"Бакалавр|Магістр|Доктор філософії"->"Активні дії"->"Експортувати в CSV".
3. Файл у форматі CSV ЕкспортЗаяв.csv. Отримати його можна з ЄДЕБО: "Вступна кампанія"->"Заяви вступників"->"Активні дії"->"Експортувати в CSV".

Важливо! ЄДЕБО експортує CSV-файли в кодуванні Windows 1251. Тому перед використанням цього застосунка файли ЕкспортЗдобувачів.csv та ЕкспортЗаяв.csv необхідно відкрити в текстовому редакторі і зберегти в кодуванні UTF-8.

Результат: файл у форматі CSV з акаунтами пошти для імпорту в Google Mail.

Вебзастосунок працює в середовищі фреймворка Ruby on Rails.

Рекомендовані версії:
- Ruby 3.0.2
- Rails 7.0.x
