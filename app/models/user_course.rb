class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  scope :groups_formed, -> { where('group_number IS NOT NULL')}
end
