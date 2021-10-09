class CreateProgramsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :programs_users do |t|
      t.belongs_to :program, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end
