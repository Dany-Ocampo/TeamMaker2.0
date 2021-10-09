class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.belongs_to :subject, null: false, foreign_key: true
      t.belongs_to :section_type, null: false, foreign_key: true
      t.string :code
      t.integer :year
      t.integer :semester

      t.timestamps
    end
  end
end
