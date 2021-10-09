class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.belongs_to :test, null: false, foreign_key: true
      t.integer :number
      t.integer :answer
      t.integer :element_kind

      t.timestamps
    end
  end
end
