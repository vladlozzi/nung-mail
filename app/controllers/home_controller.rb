class HomeController < ApplicationController
  FACULTIES = {
    "Інститут архітектури, будівництва та енергетики" => "ІАБЕ",
    "\"Інститут архітектури та будівництва \"\"ІФНТУНГ-ДонНАБА\"\"\"" => "ІАБ",
    "Інститут гуманітарної підготовки та державного управління" => "ІГПДУ",
    "Інститут економіки та менеджменту" => "ІЕМ",
    "Інститут інженерної механіки та робототехніки" => "ІІМР",
    "Інститут інформаційних технологій" => "ІІТ",
    "Інститут нафтогазової інженерії" => "ІНГІ",
    "Інститут післядипломної освіти" => "ІПО",
    "Факультет природничих наук" => "ФПН",
    "Факультет інформаційних технологій" => "ФІТ",
    "Факультет автоматизації та енергетики" => "ФАЕ",
    "Центр міжнародної освіти" => "ЦМО",
    "Відділ аспірантури і докторатури" => "ВАД",
  }

  def index
  end

  def emails_table
    table = ""
    accounts = 0
    Student.all.each do |student|
      academic_group_lat = student.academic_group.strip.downcase.gsub('зг', 'zgh').
        to_slug.transliterate(:ukrainian).to_s.delete("-")
      domain = student.faculty_name == "Інститут післядипломної освіти" ? "ipo.nung.edu.ua" : "nung.edu.ua"
      unit_abbr =
        case student.faculty_name
        when "Відділ аспірантури і докторатури" then "Аспіранти"
        when "Інститут післядипломної освіти" then "Студенти ІПО"
        else "Студенти"
        end
      email = student.first_name_lat.strip.downcase + "." +
        student.last_name_lat.strip.downcase + "-" +
        academic_group_lat + "@" + domain
      unless Email.find_by(email: email)
        application = Application.find_by(edebo_person_card: student.edebo_person_card)
        if application.present?
          phone_number = application.phone_number
        else
          phone_number = "'"
        end
        row = student.first_name.gsub("`", "'").strip + ";" +
          student.last_name.gsub("`", "'").strip + ";" +
          email + ";1234567890;" +
          "/#{unit_abbr}/Випуск #{student.graduate_at};" +
          phone_number.strip + ";" + phone_number.strip + ";" +
          "Студент групи #{student.academic_group} / ЄДЕБО ID #{student.edebo_study_card};" +
          FACULTIES[student.faculty_name.strip] + " # " +
          student.academic_group.strip + ";" +
          "TRUE\n"
        accounts += 1
        table += row
      end
    end

    send_data table, filename: "#{accounts}EmailAccountsToRegister.csv"
  end
end