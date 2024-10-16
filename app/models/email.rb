class Email < ApplicationRecord
  validates :email, presence: {message: "Введіть email!"},
            uniqueness: {message: "ТакиЙ email вже є."}
  validates_format_of :email,
                      with: URI::MailTo::EMAIL_REGEXP,
                      message: "Некоректний email"

  def self.truncate
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0")
    ActiveRecord::Base.connection.execute("DELETE FROM #{self.table_name};")
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1")
  end
end