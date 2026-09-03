class CreateEducationalPrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :educational_programs do |t|
      t.string :specialty, null: false
      t.string :edu_program
      t.string :edu_program_abbr, null: false, limit: 4 # абревіатура коротка

      t.timestamps
    end

    add_index :educational_programs, :edu_program, unique: true
    add_index :educational_programs, :edu_program_abbr, unique: true

    add_check_constraint :educational_programs,
                          "LENGTH(edu_program_abbr) <= 4",
                          name: "edu_program_abbr_length_check"
  end
end
