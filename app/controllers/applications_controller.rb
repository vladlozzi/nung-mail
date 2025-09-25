class ApplicationsController < ApplicationController
  def new_import
  end

  def import
    if params[:txt_file].present?
      application_count = 0
      Application.truncate
      import_errors = []
      File.foreach(params[:txt_file].path, external_encoding: 'Windows-1251').with_index(1) do |line, index|
        app_id, edebo_person_card,
          offer_type, offer_name, degree, base_degree, specialty, specialization, study_form, academic_year,
          unit, is_study_period_shortened, is_application_electronic,
          fullname_birthdate, phone_numbers, email,
          gender, is_ukr_citizen, application_status,
          confirm_by_sign, confirm_by_sign_date,
          confirm_by_scan, confirm_by_scan_date,
          personal_account_number =
          ::CSV.parse(line.delete("\r").delete("\n"), col_sep: ';').first
        if application_status == "До наказу"
          phone_numbers = "';" if phone_numbers.nil? || phone_numbers.empty?
          phone_number = phone_numbers.split(";").first.gsub(/[\s()-]/, "")
          application = Application.create(
            edebo_person_card: edebo_person_card,
            fullname_birthdate: fullname_birthdate,
            phone_number: phone_number == "'" ? "'" : "'" + phone_number,
            email: email
          )
          if application.valid?
            application_count += 1
          else
            import_errors << "Рядок #{index}: " + application.errors.map{ |e|
              "#{e.full_message} [#{application}]"
            }.join(" ")
          end
        end
      end
      notice = "З файлу #{params[:txt_file].original_filename} " + "імпортовано #{application_count} " + (
        application_count % 10 == 1 && application_count % 100 != 11 ? "заяву" : "заяв"
      ) + " на вступ зі статусом \"До наказу\"." + (
        import_errors.empty? ? "" :
          "<br>Виправте помилки у рядках файлу і повторіть імпорт.<br>" + import_errors.join("<br>")
      )
      redirect_to new_import_applications_path, notice: notice[0..1015] + (notice[1016].nil? ? "" : "<br>. . .")
    end
  end
end
