class AddSecondTitleToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :progress, :string, null: false, default: '未着手' 
  end
end
