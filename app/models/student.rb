class Student < ApplicationRecord
  normalizes :edu_program, with: ->(value) { value.presence }

  enum :study_form, { denna: "Денна", zaochna: "Заочна" }
  enum :degree, { jun_bachelor: "Молодший бакалавр",
                  bachelor: "Бакалавр",
                  master: "Магістр",
                  phd: "Доктор філософії"
  }

  validates :specialty, presence: {message: "Введіть спеціальність для студента!"}
  validates :edebo_study_card, presence: {message: "Введіть номер картки студента!"},
            uniqueness: {message: "Такий номер картки студента вже є."}
  # validates :academic_group, presence: {message: "Введіть академгрупу, у якій навчається студент!"}
  validates :admission_year, presence: { message: "Введіть рік вступу!" }
  validates :study_form, presence: { message: "Введіть форму навчання!" }
  validates :degree, presence: { message: "Ваедіть ступінь освіти!" }

  # Повне очищення таблиці перед імпортом нового списку студентів.
  # Скидає й autoincrement id, щоб нумерація починалась заново.
  def self.truncate
    transaction do
      connection.execute("DELETE FROM #{table_name}")
      connection.execute("DELETE FROM sqlite_sequence WHERE name = '#{table_name}'")
    end
  end

end
