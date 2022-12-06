class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
  before_destroy :check_user
  scope :groups_formed, -> { where('group_number IS NOT NULL')}

def check_user
  if self.user.user_courses.count <= 1
    self.user.destroy
  end
end

end
