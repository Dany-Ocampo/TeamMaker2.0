class PsychologicalController < ApplicationController
  
  def index
    if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
    else
      redirect_to root_path
    end
  end

  def test
    if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
    else
      redirect_to root_path
    end
  end

  def create
    if user_signed_in? && current_user.rol == 3 && current_user.accept_model == true
      if current_user.test_count == 1 || current_user.test_count == 3
        Answer.create(test_id: current_user.tests[0].id, element_kind: params[:answer], number: 1, answer: params[:answer])
        current_user.update(test_count: current_user.test_count + 1 )
        redirect_to test_eneagrama_test_path, notice: "¡Primer test listo!"
      elsif current_user.test_count == 2 || current_user.test_count == 4
        if current_user.tests[0].answers[0].answer.to_s == params[:answer].to_s
          current_user.create_eneatype(number: params[:answer])
          current_user.update(test_count: 6)
          current_user.tests[0].update(answered: true)
          redirect_to test_eneagrama_path, notice: "¡Tests completados con exito!"       
        else
          current_user.update(test_count: current_user.test_count + 1 )
          if current_user.tests[0].answers[0].destroy
            redirect_to test_eneagrama_path, alert: "Test no coincidentes, vuelva a intentarlo" 
          end   
        end
      elsif current_user.test_count == 5
        user_test = current_user.tests.find_by(kind: 1)
        if user_test.answered == false
          for i in 1..45
            if (1..5) === i
             enea = 1 
            elsif (6..10) === i
             enea = 2 
            elsif (11..15) === i
             enea = 3 
            elsif (16..20) === i
             enea = 4 
            elsif (21..25) === i
             enea = 5 
            elsif (26..30) === i
             enea = 6 
            elsif (31..35) === i
             enea = 7 
            elsif (36..40) === i
             enea = 8 
            elsif (41..45) === i
             enea = 9 
            end
            Answer.create(test_id: user_test.id, element_kind: enea, number: i, answer: params[:"answer#{i}"])
          end
          
          if user_test.update(:answered => true)
            answers = Answer.where(test_id: user_test.id)
            total = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            answers.each do |answer|
              for i in 1..9
                if answer.element_kind == i
                  total[i-1] = total[i-1] + answer.answer
                end
              end
            end
            for i in 1..9
              if total[i-1] != 0 && total[i-1] == total.max 
                current_user.create_eneatype(number: i,score: total[i-1])
              end
            end
            current_user.update(test_count: 6)
            redirect_to test_eneagrama_path, notice: "Test realizado con éxito"       
          else
            redirect_back(fallback_location: test_eneagrama_path, alert: "No se ha podido procesar la solicitud")
          end
        else
          redirect_to test_eneagrama_path, alert: "test ya respondido"        
        end
      end
    else
      redirect_to root_path
    end
  end

end
