class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.integer :edebo_person_card, null: false
      t.string :fullname_birthdate, null: false
      t.string :phone_number, null: false
      t.string :email

      t.timestamps
    end
  end
end
