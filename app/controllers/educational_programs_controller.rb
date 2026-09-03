class EducationalProgramsController < ApplicationController
  before_action :set_educational_program, only: %i[ show edit update destroy ]

  # GET /educational_programs or /educational_programs.json
  def index
    @educational_programs = EducationalProgram.all
  end

  # GET /educational_programs/1 or /educational_programs/1.json
  def show
  end

  # GET /educational_programs/new
  def new
    @educational_program = EducationalProgram.new
  end

  # GET /educational_programs/1/edit
  def edit
  end

  # POST /educational_programs or /educational_programs.json
  def create
    @educational_program = EducationalProgram.new(educational_program_params)

    respond_to do |format|
      if @educational_program.save
        format.html { redirect_to @educational_program, notice: "Educational program was successfully created." }
        format.json { render :show, status: :created, location: @educational_program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @educational_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /educational_programs/1 or /educational_programs/1.json
  def update
    respond_to do |format|
      if @educational_program.update(educational_program_params)
        format.html { redirect_to @educational_program, notice: "Educational program was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @educational_program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @educational_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /educational_programs/1 or /educational_programs/1.json
  def destroy
    @educational_program.destroy!

    respond_to do |format|
      format.html { redirect_to educational_programs_path, notice: "Educational program was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def new_import
  end

  def import
    if params[:txt_file].present?
      edu_program_count = 0
      EducationalProgram.truncate
      import_errors = []
      File.foreach(params[:txt_file].path, external_encoding: 'UTF-8').with_index(1) do |line, index|
        if index > 1
          specialty, edu_program, abbr = line.delete("\r").delete("\n").delete('"').split(";")
          educational_program = EducationalProgram.create(
            specialty: specialty, edu_program: edu_program, edu_program_abbr: abbr
          )
          if educational_program.valid?
            edu_program_count += 1
          else
            import_errors << "Рядок #{index}: " + educational_program.errors.map{ |e|
              "#{e.full_message} [#{educational_program}]"
            }.join(" ")
          end
        end
      end
      notice = "З файлу #{params[:txt_file].original_filename} " + "імпортовано #{edu_program_count} " + (
        edu_program_count % 10 == 1 && edu_program_count % 100 != 11 ? "освітню програму" : "освітніх програм"
      ) + "." + (
                 import_errors.empty? ? "" :
                   "<br>Виправте помилки у рядках файлу і повторіть імпорт.<br>" + import_errors.join("<br>")
               )
      redirect_to new_import_edu_programs_path, notice: notice[0..1015] + (notice[1016].nil? ? "" : "<br>. . .")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_educational_program
      @educational_program = EducationalProgram.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def educational_program_params
      params.expect(educational_program: [ :specialty, :edu_program, :edu_program_abbr ])
    end
end
