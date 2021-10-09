class Section < ApplicationRecord
  belongs_to :subject
  belongs_to :section_type
  has_many :user_sections
  has_many :users, :through => :user_sections

def groups
  self.user_sections.groups_formed
end

end
