module ApplicationHelper

mappings = Devise.mappings.values.map(&:used_helpers).flatten.uniq
[:session, :password, :registration, :unlock, :authy, :passwords_with_policy, :invitation]

routes = Devise::URL_HELPERS.slice(*mappings)
{:session=>[nil, :new, :destroy],
 :password=>[nil, :new, :edit],
 :registration=>[nil, :new, :edit, :cancel],
 :unlock=>[nil, :new],
 :authy=>[],
 :passwords_with_policy=>[],
 :invitation=>[nil, :new, :accept]} 

 routes.each do |module_name, actions|
   [:path, :url].each do |path_or_url|
      actions.each do |action|
      action = action ? "#{action}_" : ""
       puts "#{action}#{module_name}_#{path_or_url}"
     end
   end
 end

end
