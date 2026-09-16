class HomeController < ApplicationController

  require 'zip'

  FACULTIES = {
    "\"Інститут архітектури та будівництва \"\"ІФНТУНГ-ДонНАБА\"\"\"" => "ІАБ",
    "Інститут гуманітарної підготовки та державного управління" => "ІГПДУ",
    "Інститут економіки та менеджменту" => "ІЕМ",
    "Інститут інженерної механіки та робототехніки" => "ІІМР",
    "Інститут нафтогазової інженерії" => "ІНГІ",
    "Інститут післядипломної освіти" => "ІПО",
    "Факультет природничих наук" => "ФПН",
    "Факультет інформаційних технологій" => "ФІТ",
    "Факультет автоматизації та енергетики" => "ФАЕ",
    "Центр міжнародної освіти" => "ЦМО",
    "Відділ аспірантури і докторатури" => "ВАД",
  }

  LIFECELL_CODE_PATTERN = /\A\+38(063|073|093)/
  OTHER_UKRAINIAN_MOBILE_CODE_PATTERN = /\A\+38(050|066|067|068|075|077|09[1-9])/

  def index
  end

  def emails_acadgr_table
    accounts_table = "First Name [Required],Last Name [Required],Email Address [Required],Password [Required],Org Unit Path [Required],Recovery Phone [MUST BE IN THE E.164 FORMAT],Mobile Phone,Employee ID,Department,Change Password at Next Sign-In\n"
    groups_table = "Group Email [Required],Member Email,Member Role,Member Type\n"
    accounts_table_to_deans_office = "Ім'я,Прізвище,Адреса електронної пошти,Телефон для відновлення пароля,Інститут/факультет # група,Примітки\n"
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
          phone_number = "'+"
        end

        account_row = student.first_name.gsub("`", "'").strip + "," +
          student.last_name.gsub("`", "'").strip + "," +
          email + ",1234567890," +
          "/#{unit_abbr}/Випуск #{student.graduate_at}," +
          phone_number.delete("'").strip + "," + phone_number.delete("'").strip + "," +
          "Студент групи #{student.academic_group} / ЄДЕБО ID #{student.edebo_study_card} / створено #{Time.now.strftime('%Y-%m-%d')}," +
          FACULTIES[student.faculty_name.strip] + " # " + student.academic_group.strip + "," +
          "TRUE\n"

        group_row = "students@nung.edu.ua,#{email},MEMBER,USER\n"

        account_to_deans_office_row = student.first_name.gsub("`", "'").strip + "," +
          student.last_name.gsub("`", "'").strip + "," +
          email + "," + phone_number.strip + "," +
          FACULTIES[student.faculty_name.strip] + " # " + student.academic_group.strip + "," +
          ( phone_number =~/\+38063|\+38073|\+38093/ ? "\"Ймовірно, оператор Lifeсell - можливі проблеми з відправленням коду для відновлення\"" : "") +
          "\n"

        accounts += 1
        accounts_table += account_row
        groups_table += group_row
        accounts_table_to_deans_office += account_to_deans_office_row
      else
        puts "Адресу " + email + " вже зареєстровано в Google Mail"
      end

    end

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry("#{accounts}EmailAccountsToRegister.csv")
      zip.write(accounts_table)

      zip.put_next_entry("#{accounts}EmailGroupsToRegister.csv")
      zip.write(groups_table)

      zip.put_next_entry("#{accounts}EmailAccountsToDeansOffice.csv")
      zip.write(accounts_table_to_deans_office)
    end

    zip_stream.rewind

    send_data zip_stream.read, filename: "#{accounts}EmailsToRegister.zip", type: 'application/zip'
  end

  def emails_epysf_table
    accounts_table = "First Name [Required],Last Name [Required],Email Address [Required],Password [Required],Org Unit Path [Required],Recovery Phone [MUST BE IN THE E.164 FORMAT],Mobile Phone,Employee ID,Department,Change Password at Next Sign-In\n"
    groups_table = "Group Email [Required],Member Email,Member Role,Member Type\n"
    accounts_table_to_deans_office = "Ім'я,Прізвище,Адреса електронної пошти,Телефон для відновлення пароля,Інститут/факультет # ОП,Примітки\n"
    accounts = 0
    Student.all.each do |student|
      edu_program = EducationalProgram.find_by(specialty: student.specialty, edu_program: student.edu_program)
      # p edu_program; p student
      ep = edu_program.edu_program_abbr
      ay = student.admission_year.to_s[-2..]
      sf = student.zaochna? ? "z" : ""
      dg = case true
           when student.jun_bachelor?
               "j"
           when student.bachelor?
             ""
           when student.master?
             "m"
           when student.phd?
             "phd"
           else
             "o"
           end
      epaydgsf = "#{ep}#{ay}#{dg}#{sf}" # ; puts "epaydgsf: #{epaydgsf}"

      domain = student.faculty_name == "Інститут післядипломної освіти" ? "ipo.nung.edu.ua" : "nung.edu.ua"
      unit_abbr =
        case student.faculty_name
        when "Відділ аспірантури і докторатури" then "Аспіранти"
        when "Інститут післядипломної освіти" then "Студенти ІПО"
        else "Студенти"
        end
      email = student.first_name_lat.strip.downcase + "." +
              student.last_name_lat.strip.downcase + "-" +
              epaydgsf + "@" + domain

      unless Email.find_by(email: email)
        application = Application.find_by(edebo_person_card: student.edebo_person_card)
        if application.present?
          phone_number = application.phone_number
        else
          phone_number = ""
        end
        phone_number_to_account =
          case phone_number
          when ""
            ""
          when /\A\+3800/
            ""
          when LIFECELL_CODE_PATTERN, OTHER_UKRAINIAN_MOBILE_CODE_PATTERN
            phone_number
          when /\A\+38/
            ""
          else
            phone_number
          end

        account_row = student.first_name.gsub("`", "'").strip + "," +
                      student.last_name.gsub("`", "'").strip + "," +
                      email + ",1234567890," +
                      "/#{unit_abbr}/Випуск #{student.graduate_at}," +
                      phone_number_to_account.strip + "," +
                      phone_number_to_account.strip + "," +
                      "Студент ОП #{ep.upcase} / ЄДЕБО ID #{student.edebo_study_card} / створено #{Time.now.strftime('%Y-%m-%d')}," +
                      FACULTIES[student.faculty_name.strip] + " # ОП " + ep.upcase + "," +
                      "TRUE\n"

        group_row = "students@nung.edu.ua,#{email},MEMBER,USER\n"

        phone_number_problem =
          case phone_number
          when ""
            "Відсутній номер мобільного телефону"
          when /\A\+3800/
            "Помилка в номері телефону: зайвий нуль у коді оператора та відсутня остання цифра"
          when LIFECELL_CODE_PATTERN
            "\"Ймовірно, оператор Lifecell - можливі проблеми з відправленням коду для відновлення\""
          when OTHER_UKRAINIAN_MOBILE_CODE_PATTERN
            ""
          when /\A\+38/
            "Помилка в номері телефону: невідомий код українського мобільного оператора"
          else
            ""
          end
        account_to_deans_office_row = student.first_name.gsub("`", "'").strip + "," +
                                      student.last_name.gsub("`", "'").strip + "," +
                                      email + ",'" + phone_number.strip + "," +
                                      FACULTIES[student.faculty_name.strip] + " # ОП " + ep.upcase + "," +
                                      phone_number_problem + "\n"

        accounts += 1
        accounts_table += account_row
        groups_table += group_row
        accounts_table_to_deans_office += account_to_deans_office_row
      else
        puts "Адресу " + email + " вже зареєстровано в Google Mail"
      end

    end

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry("#{accounts}EmailAccountsToRegister.csv")
      zip.write(accounts_table)

      zip.put_next_entry("#{accounts}EmailGroupsToRegister.csv")
      zip.write(groups_table)

      zip.put_next_entry("#{accounts}EmailAccountsToDeansOffice.csv")
      zip.write(accounts_table_to_deans_office)
    end

    zip_stream.rewind

    send_data zip_stream.read, filename: "#{accounts}EmailsToRegister.zip", type: 'application/zip'
  end
end