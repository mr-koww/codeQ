class AddUserToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, index: true
    add_foreign_key :answers, :users
  end
end