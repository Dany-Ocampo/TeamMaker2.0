class HomeController < ApplicationController
  
  def index
  	if user_signed_in?
	  	user = current_user
			if params[:accept_model]
			 	user.accept_model = params[:accept_model]
			 	if user.save
			 		if user.accept_model == true
				 		for i in(1..3)
							current_user.tests.create(kind: i, status: true, answered: false)
							current_user.update(test_count: 1)
						end
					end
					redirect_to root_path
				else
					redirect_to(root_path, alert: "No se a podido procesar la solicitud")
				end
			end
	  end
	end

end
