class Institution < ApplicationRecord
    has_many :users, :through => :user_institutions
end
