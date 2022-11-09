class Course < ApplicationRecord
  belongs_to :subject
  belongs_to :course_type 
  has_many :user_courses, dependent: :destroy
  has_many :users, :through => :user_courses
  accepts_nested_attributes_for :subject

def groups
  self.user_courses.groups_formed
end

end
