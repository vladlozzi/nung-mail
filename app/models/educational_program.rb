class EducationalProgram < ApplicationRecord
  normalizes :edu_program, with: ->(value) { value.presence }

  validates :specialty, presence: true
  validates :edu_program_abbr, presence: true, length: { maximum: 4 }
  validates :edu_program, uniqueness: { scope: :specialty }, allow_nil: true

  def self.truncate
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0")
    ActiveRecord::Base.connection.execute("DELETE FROM #{self.table_name};")
    # ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1")
  end

end
