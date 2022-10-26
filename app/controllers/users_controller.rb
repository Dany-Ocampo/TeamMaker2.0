class UsersController < ApplicationController
  
  def index
		if user_signed_in? && current_user.rol == 0
			@user = User.new
			@courses = Course.all
			@programs = Program.all
			
		  per_page = 5
		  if params[:per_page]
		  	per_page = params[:per_page].to_i
			end
			if params[:search] && params[:search_course] != ""
				@users = User.joins(:courses).where(courses: { code: params[:search_course] }).where.not(rol: 0).search(params[:search],params[:search_rol],params[:search_status]).paginate(:page => params[:page], :per_page => per_page)
			elsif params[:search] && params[:search_course] == ""
				@users = User.where.not(rol: 0).search(params[:search],params[:search_rol],params[:search_status]).paginate(:page => params[:page], :per_page => per_page)
			else
				@users =  User.where.not(rol: 0).paginate(:page => params[:page], :per_page => per_page)
			end
		else
			redirect_to root_path
		end
	end

	def show
		redirect_to(root_path)
	end

	def edit
	  @user = User.find(params[:id])
	end

	def update
	  @user = User.find(params[:id])
	  @courses = params[:courses]
	  program_id = params["user"]["program_id"]
      program = Program.find(program_id)
      @user.programs = [program]
     
      if  @courses == nil
        redirect_back(fallback_location: users_path, alert: "Usuario sin curso")
    #elsif params[:user][:rol].to_i == 3 && @courses.count > 1
     #   redirect_back(fallback_location: users_path, alert: "Estudiantes solo pueden tener una sección")
    else
		  @userCourses = UserCourse.where(user_id: @user.id)
		  @userCourses.each do |userCourse|
		  	if !@courses.include? (userCourse.course_id.to_s)
		  		userCourse.destroy
		  	end
		  end

		  if !@courses.blank?
			  @courses.each do |sec|
			   userCourse = @user.user_courses.find_by(course_id: sec)
			   if !userCourse.present?
			   	UserCourse.create(course_id: sec,user_id: @user.id)
			   end
			  end
		  end

		  if @user.update(user_params)
		   	redirect_back(fallback_location: users_path, notice: "Usuario editado con éxito")
		  else
            redirect_back(fallback_location: users_path, alert: "No se ha podido procesar la solicitud")
		  end
		end
	end

	def destroy
	  @user = User.find(params[:id])
	  @userCourse = UserCourse.where(user_id: @user.id)
	  if @user.rol == 3 && Test.exists?(user_id: @user.id)
	  	@tests =  Test.where(user_id: @user.id)

	  	@tests.each do |test|
	  		@answers =  test.answers
	      @answers.each do |answer|	
	  			answer.destroy
	  		end
	      test.destroy
	    end
	  end

	  @userCourse.each do |userCourses|
	  	userCourses.destroy
	  end

	  enea = Eneatype.where(user_id: @user.id)
	  enea.each do |e|
	  	e.destroy
		end

	  if @user.destroy
	  	redirect_to(usuarios_path, notice: "Usuario eliminado con éxito")   		
      else
        redirect_back(fallback_location: users_path, alert: "No se ha podido procesar la solicitud")
	  end
	end


	# Importar archivo para poblar usuarios
	def import
		#if request.post?
		if params[:file]
		    archivo = params[:file]
		    nombre = archivo.original_filename
		    extension = nombre.slice(nombre.rindex("."), nombre.length).downcase
		    if extension == ".csv"		    	
		    	$problem = false
		    	@errors = User.check(params[:file])
		    	if $problem == false && $mark == 0
		    		@user = User.import(params[:file])
		    		if $mark_import == false
		    			redirect_to(usuarios_path, notice: "Usuarios importados")
                    else
                        redirect_back(fallback_location: users_path, alert: "En la fila número " + $mensaje_numero.to_s + " del archivo: 'Nombre: " +  $mensaje_nombre.to_s + ", Apellido: " + $mensaje_apeliido.to_s + ", Correo: " + $mensaje_correo.to_s + ", Curso: " +  $mensaje_course.to_s + " y Clave: " + $mensaje_clave.to_s + "', hay datos inválidos. Por favor, revise los datos.")
		    		end
		    	elsif $problem == true && $mark == 3
                    redirect_back(fallback_location: users_path, alert: "El archivo contiene estudiantes sin curso válido. Los estudiantes son: " + $persons)
		    	elsif $problem == true && $mark == 1
                    #flash[:danger] = "El archivo contiene usuarios que ya existen en el sistema. Los siguientes RUN contienen datos ya existentes: " + $count.to_s
                    redirect_back(fallback_location: users_path, alert: "El archivo contiene estudiantes que ya existen en el sistema. Los siguientes CORREOS contienen datos ya existentes: " + $persons)
                else
                    redirect_back(fallback_location: users_path, alert: "Los nombres de las columnas del archivo son incorrectas. Recuerde que deben llamarse: email,name,surname,password,course")
		    	end			    
            else
                redirect_back(fallback_location: users_path, alert: "No se ha podido cargar el archivo al sistema. Debe ser un archivo .csv")
		    end
        else
            redirect_back(fallback_location: users_path, alert: "No se ha seleccionado ningún archivo para importar")
		end

	end

	private
	def user_params
	  params.require(:user).permit(:email, :name, :surname, :age, :rol, :course, :status, :password, :password_confirmation, :accept_model, :study_group, :sex)
	end

end
