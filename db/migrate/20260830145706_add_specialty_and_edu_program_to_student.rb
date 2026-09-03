class AddSpecialtyAndEduProgramToStudent < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :specialty, :string, null: false
    add_column :students, :edu_program, :string

    add_index :students, [:specialty, :edu_program]
    add_index :students, :edu_program
  end
end
