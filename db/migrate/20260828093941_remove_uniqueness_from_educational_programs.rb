class RemoveUniquenessFromEducationalPrograms < ActiveRecord::Migration[8.1]
  def change
    remove_index :educational_programs, :edu_program
    remove_index :educational_programs, :edu_program_abbr

    add_index :educational_programs, :edu_program
    add_index :educational_programs, :edu_program_abbr
  end
end