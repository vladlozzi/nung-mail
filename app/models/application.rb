class Application < ApplicationRecord
  validates :edebo_person_card, presence: {message: "Введіть ID персони в ЄДЕБО!"}
  validates :fullname_birthdate, presence: {message: "Введіть ПІБ вступника в ЄДЕБО!"}
  validates :phone_number, presence: {message: "Введіть контактний мобільний номер!"}
  validates_format_of :email,
                      with: /\A(|#{URI::MailTo::EMAIL_REGEXP})\z/,
                      message: "Введіть коректний або порожній email"

  def self.truncate
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0")
    ActiveRecord::Base.connection.execute("DELETE FROM #{self.table_name};")
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1")
  end
end
