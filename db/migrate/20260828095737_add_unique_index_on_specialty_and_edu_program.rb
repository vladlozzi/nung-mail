class AddUniqueIndexOnSpecialtyAndEduProgram < ActiveRecord::Migration[8.1]
  def change
    remove_index :educational_programs, :edu_program
    remove_index :educational_programs, :edu_program_abbr

    add_index :educational_programs, :edu_program_abbr

    add_index :educational_programs, [:specialty, :edu_program], unique: true
  end
end