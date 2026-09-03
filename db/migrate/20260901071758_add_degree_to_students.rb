class AddDegreeToStudents < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :degree, :string, null: false
  end
end
