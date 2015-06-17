class AddFlagToUser < ActiveRecord::Migration
  def change
  	add_column :users, :credit_flag, :boolean, :default => false
  end
end
