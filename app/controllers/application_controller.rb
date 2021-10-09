class ApplicationController < ActionController::Base
    # ensoteam.usach@gmail.com http8080
    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token

	before_action :banned?

	def banned?
	  if current_user.present? && current_user.status == false
	    sign_out current_user
	    redirect_to(root_path, alert: "¡Cuenta suspendida!, para más información consulte con el administrador del sistema")
	  end
	end
end
