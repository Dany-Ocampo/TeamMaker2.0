class UserSection < ApplicationRecord
  belongs_to :user
  belongs_to :section

  scope :groups_formed, -> { where('group_number IS NOT NULL')}
end
