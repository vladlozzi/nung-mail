class AddAdmissionYearAndStudyFormToStudents < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :admission_year, :integer, null: false
    add_column :students, :study_form, :string, null: false

    add_index :students, :admission_year
    add_index :students, :study_form
  end
end