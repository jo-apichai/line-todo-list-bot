class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :user_id, null: false, index: true
      t.string :description, null: false
      t.datetime :datetime, null: false, index: true
      t.boolean :finished, null: false, default: false, index: true
      t.boolean :important, null: false, default: false, index: true

      t.timestamps null: false
    end
  end
end
