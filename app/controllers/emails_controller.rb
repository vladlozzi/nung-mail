class EmailsController < ApplicationController
  def new_import
  end

  def import
    if params[:txt_file].present?
      email_count = 0
      Email.truncate
      import_errors = []
      File.foreach(params[:txt_file].path).with_index(1) do |line, index|
        if index > 1
          first_name, last_name, email =
            ::CSV.parse(line.delete("\r").delete("\n"), col_sep: ',', quote_char: '"').first
          email = Email.create(email: email)
          if email.valid?
            email_count += 1
          else
            import_errors << "Рядок #{index}: " + email.errors.map{ |e|
              "#{e.full_message} [#{email}]"
            }.join(" ")
          end
        end
      end
      notice = "З файлу #{params[:txt_file].original_filename} " + "імпортовано #{email_count} " + (
        email_count % 10 == 1 && email_count % 100 != 11 ? "email-адресу" : "email-адрес"
      ) + "." + (
        import_errors.empty? ? "" :
          "<br>Виправте помилки у рядках файлу і повторіть імпорт.<br>" + import_errors.join("<br>")
      )
      redirect_to new_import_emails_path, notice: notice[0..1015] + (notice[1016].nil? ? "" : "<br>. . .")
    end
  end

end
