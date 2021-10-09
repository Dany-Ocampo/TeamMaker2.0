class SectionsController < ApplicationController
  def index
    if user_signed_in? && current_user.rol == 0
      @sections = Section.all
      @section = Section.new
    else 
      redirect_to root_path
    end
  end
  
  def show 
    begin
        @seccion = Section.find(params[:id])
    rescue ActiveRecord::RecordNotFound  
       redirect_to root_path
       return
    end

    if user_signed_in? && UserSection.exists?(section_id: @seccion.id, user_id: current_user.id)

      @sections = Section.all
      @programs = Program.all

      @user = User.new

        per_page = 5
        if params[:per_page]
          per_page = params[:per_page].to_i
        end
        if params[:search]
          @users = @seccion.users.where(rol: 3).where.not(rol: 0).search(params[:search],params[:search_rol],params[:search_status]).paginate(:page => params[:page], :per_page => per_page)
        else
          @users = @seccion.users.where(rol: 3).where.not(rol: 0).paginate(:page => params[:page], :per_page => per_page)
        end
      else
        redirect_to root_path
      end
   # if User.joins(:sections).where(sections: { section: @seccion.section }).where(id: current_user.id).exists?

   # else
   #   redirect_to root_path
   # end

  end

	def new
		if user_signed_in? && current_user.rol == 0	
    @section = Section.new
  	else
  		redirect_to root_path
  	end
  end

  def create
    @sections = Section.all
    if current_user.rol == 0
  		@section = Section.new(section_params)
  		if @section.save
  			redirect_to(sections_path, notice: "¡Sección " + @section.code + " creada con exito!")
  	  else
  	  
        if@section.errors.any?
           errors = @section.errors.first
          @section.errors.full_messages.each do |msg|
            if errors != msg
              if msg == "Section ya está en uso"
                flash[:alert] = "Sección ya existe"
              end
              errors = errors.to_s + ", " + msg.to_s
            end
          end
          render 'index'
      error = []
      if @section.errors.any?
        @section.errors.full_messages.each do |msg|
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
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])

    if @section.update(section_params)
      redirect_to(sections_path, notice: "Sección actualizado con éxito")
    else
      
        if@section.errors.any?
           errors = @section.errors.first
          @section.errors.full_messages.each do |msg|
            if errors != msg
              if msg == "Section ya está en uso"
                flash[:alert] = "Sección ya existe"
              end
              errors = errors.to_s + ", " + msg.to_s
            end
          end
         error = []
        error << @section.id
        if @section.errors.any?
          @section.errors.full_messages.each do |msg|
            error << msg
          end
        end

        redirect_back(fallback_location: sections_path, alert: error)
        
        end
    end
  end

  def destroy
    @section = Section.find(params[:id])
      
    if !UserSection.exists?(section_id: @section.id)
      if @section.destroy
        redirect_to(sections_path, notice: "Sección eliminada con éxito")
      else
        redirect_to(sections_path, notice: "No se a podido procesar la solicitud")
      end
    else
      redirect_to(sections_path, alert: "Imposible eliminar sección, no esta vacía")
    end

  end

    def my_sections

    end

    def home
        @seccion = Section.find(params[:id])
        @psycho_test_answered = current_user.tests.find_by(kind: 1).answered
        @social_test_answered = current_user.tests.find_by(kind: 2).answered && current_user.tests.find_by(kind: 2)
    end

  private

	def section_params
	  params.require(:section).permit(:subject, :section_type, :code , :year, :semester)
	end
end
