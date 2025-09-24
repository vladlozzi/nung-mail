class StudentsController < ApplicationController
  def new_import
  end

  def import
    if params[:txt_file].present?
      student_count = 0
      Student.truncate
      import_errors = []
      File.foreach(params[:txt_file].path).with_index(1) do |line, index|
        if index > 1
          download_at, edebo_study_card, status_from, study_status, edebo_person_card,
            full_name, birth_date, person_doc_type, person_doc_series, person_doc_number, person_doc_date,
            person_doc_valid_until, gender, citizenship, full_name_en, tax_number, valid_tax_number,
            license_year, study_start, study_finish, receive_date, unit, dual_study,
            degree, base_degree, study_form,
            study_payer, contract_based_study_funded_by_legal_entities,
            did_obtain_degree_in_another_specialty,
            is_study_period_shortened, specialty, specialization, edu_program_id, edu_program,
            profession, academic_year, academic_group =
            line.delete("\r").delete("\n").split(";")
          # p full_name
          last_name, first_name = full_name.split(" ")
          full_name_en = full_name.gsub("`", "").gsub('зг', 'zgh').gsub('Зг', 'Zgh').
            to_slug.transliterate(:ukrainian).to_s if full_name_en.nil? || full_name_en.empty?
          last_name_lat, first_name_lat = full_name_en.split(" ")
          student = Student.create(
            first_name: first_name, last_name: last_name,
            first_name_lat: first_name_lat, last_name_lat: last_name_lat,
            graduate_at: license_year, mobile_number: "+",
            academic_group: academic_group, faculty_name: unit,
            edebo_study_card: edebo_study_card, edebo_person_card: edebo_person_card
          )
          if student.valid?
            student_count += 1
          else
            import_errors << "Рядок #{index}: " + student.errors.map{ |e|
              "#{e.full_message} [#{student}]"
            }.join(" ")
          end
        end
      end
      notice = "З файлу #{params[:txt_file].original_filename} " + "імпортовано #{student_count} " + (
        student_count % 10 == 1 && student_count % 100 != 11 ? "здобувача освіти" : "здобувачів освіти"
      ) + "." + (
        import_errors.empty? ? "" :
          "<br>Виправте помилки у рядках файлу і повторіть імпорт.<br>" + import_errors.join("<br>")
      )
      redirect_to new_import_students_path, notice: notice[0..1015] + (notice[1016].nil? ? "" : "<br>. . .")
    end
  end
end
