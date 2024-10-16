class Student < ApplicationRecord
  validates :edebo_study_card, presence: {message: "Введіть номер картки студента!"},
            uniqueness: {message: "ТакиЙ номер картки студента вже є."}
  validates :academic_group, presence: {message: "Введіть академгрупу, у якій навчається студент!"}

  def self.truncate
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0")
    ActiveRecord::Base.connection.execute("DELETE FROM #{self.table_name};")
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1")
  end

end
