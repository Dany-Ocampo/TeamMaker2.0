class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.belongs_to :subject, null: false, foreign_key: true
      t.belongs_to :course_type, null: false, foreign_key: true
      t.string :code
      t.integer :year
      t.integer :semester

      t.timestamps
    end
  end
end
