class RegistrationsController < Devise::RegistrationsController
    skip_before_action :require_no_authentication, raise: false
  
    def new
      if user_signed_in? && current_user.rol == 0 
      @user = User.new
      else
        redirect_to root_path
      end
    end
  
    def create
        puts "hey"
        puts params
      if current_user.rol == 0 || current_user.rol == 1
        errors = ''
        program_id = params["user"]["program_id"]
        program = Program.find(program_id)
        @user = User.new(user_params)
        @user.programs << program
        @sections = params[:sections]
        if @sections == nil
        redirect_back(fallback_location: users_path)
          flash[:alert] = "Usuario sin sección"
        else    
          if @user.rol == 3 && @sections.count > 1
            redirect_back(fallback_location: users_path)
            errors = "Estudiantes solo pueden tener 1 sección"
            flash[:alert] = errors
          else
            if @user.save
              @sections.each do |section_id|
                UserSection.create(section_id: section_id,user_id: @user.id)
              end
            #  elsif current_user.rol == 1
            #    UserSection.create(section_id: @sections.to_i,user_id: @user.id)
            #  UserMailer.registration_confirmation(@user).deliver_now
                redirect_back(fallback_location: users_path, notice: "¡Usuario " + @user.email + " registrado con exito!")
            else
               redirect_back(fallback_location: users_path)
              if @user.errors.any?
                @user.errors.full_messages.each do |msg|
                  errors = msg + '. ' + errors
                end
                flash[:alert] = errors
              end
            end
          end
        end
      else
        redirect_to root_path
      end
    end
    
    private
    def user_params
      params.require(:user).permit(:email, :name, :surname, :rol, :section, :status, :password, :password_confirmation, :accept_model, :study_group)
    end
  
  end