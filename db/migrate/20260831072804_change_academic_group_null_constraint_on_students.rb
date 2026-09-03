class ChangeAcademicGroupNullConstraintOnStudents < ActiveRecord::Migration[8.1]
  def change
    change_column_null :students, :academic_group, true
  end
end
