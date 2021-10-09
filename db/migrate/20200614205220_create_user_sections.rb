class CreateUserSections < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sections do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :section, null: false, foreign_key: true
      t.integer :group_number

      t.timestamps
    end
  end
end
