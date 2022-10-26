class CoursesController < ApplicationController
  def index
    if user_signed_in? && current_user.rol == 0
      @courses = Course.includes(:course_type)
      @course = Course.new
      @course_types= CourseType.all
      @subjects= Subject.all
    else 
      redirect_to root_path
    end
  end
  
  def show 
    begin
        @curso = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound  
       redirect_to root_path
       return
    end

    if user_signed_in? && UserCourse.exists?(course_id: @curso.id, user_id: current_user.id)

      @courses = Course.all
      @programs = Program.all

      @user = User.new

        per_page = 5
        if params[:per_page]
          per_page = params[:per_page].to_i
        end
        if params[:search]
          @users = @curso.users.where(rol: 3).where.not(rol: 0).search(params[:search],params[:search_rol],params[:search_status]).paginate(:page => params[:page], :per_page => per_page)
        else
          @users = @curso.users.where(rol: 3).where.not(rol: 0).paginate(:page => params[:page], :per_page => per_page)
        end
      else
        redirect_to root_path
      end
  end

	def new
		if user_signed_in? && current_user.rol == 0	
    @course = Course.new
  	else
  		redirect_to root_path
  	end
  end

  def create
    @courses = Course.all
    @course_types= CourseType.all
    if current_user.rol == 0
  		@course = Course.new(course_params)
      subject = Subject.find_or_create_by(name: params[:course][:subject])
      @course.subject= subject
  		if @course.save
  			redirect_to(courses_path, notice: "¡Curso " + @course.code + " creado con exito!")
  	  else
  	  
        if@course.errors.any?
           errors = @course.errors.first
          @course.errors.full_messages.each do |msg|
            if errors != msg
              if msg == "Curso ya está en uso"
                flash[:alert] = "Curso ya existe"
              end
              errors = errors.to_s + ", " + msg.to_s
            end
          end
          render 'index'
      error = []
      if @course.errors.any?
        @course.errors.full_messages.each do |msg|
          error << msg
        end
      end
        
        end
  	  end
  	else
  	 	redirect_to root_path
  	end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course_types= CourseType.all
    @course.save
    if @course.update(course_params)
      redirect_to(courses_path, notice: "Curso actualizado con éxito")
    else
      
        if@course.errors.any?
           errors = @course.errors.first
          @course.errors.full_messages.each do |msg|
            if errors != msg
              if msg == "Curso ya está en uso"
                flash[:alert] = "Curso ya existe"
              end
              errors = errors.to_s + ", " + msg.to_s
            end
          end
         error = []
        error << @course.id
        if @course.errors.any?
          @course.errors.full_messages.each do |msg|
            error << msg
          end
        end

        redirect_back(fallback_location: courses_path, alert: error)
        
        end
    end
  end

  def destroy
    @course = Course.find(params[:id])
      
    if !UserCourse.exists?(course_id: @course.id)
      if @course.destroy
        redirect_to(courses_path, notice: "Curso eliminado con éxito")
      else
        redirect_to(courses_path, notice: "No se ha podido procesar la solicitud")
      end
    else
      redirect_to(courses_path, alert: "Imposible eliminar curso, no esta vacío")
    end

  end

    def my_courses_list

    end

    def home
        @curso = Course.find(params[:id])
        @psycho_test_answered = current_user.tests.find_by(kind: 1).answered
        @social_test_answered = current_user.tests.find_by(kind: 2).answered && current_user.tests.find_by(kind: 2)
    end

  private

	def course_params
    params.require(:course).permit(:course_type_id, :code , :year, :semester)
	  #params.require(:course).permit(:subject_id, :course_type_id, :code , :year, :semester)
	end
end
