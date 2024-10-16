class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :first_name_lat, null: false
      t.string :last_name_lat, null: false
      t.integer :graduate_at, null: false
      t.string :mobile_number, null: false
      t.string :academic_group, null: false
      t.string :faculty_name, null: false
      t.integer :edebo_study_card, null: false
      t.integer :edebo_person_card, null: false

      t.timestamps
    end
    add_index :students, :edebo_study_card, unique: true
  end
end
