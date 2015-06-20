class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.references :user, index: true
      t.references :question, index: true

      t.timestamps null: false
    end

    add_foreign_key :subscribers, :users
    add_foreign_key :subscribers, :questions

    add_index :subscribers, [:question_id, :user_id]
  end
end