class AddTitleToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, { default: -> { 'NOW()' }, null: false } 
  end
end
