class CreateTests < ActiveRecord::Migration[6.0]
  def change
    create_table :tests do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :kind
      t.boolean :status
      t.boolean :answered

      t.timestamps
    end
  end
end
