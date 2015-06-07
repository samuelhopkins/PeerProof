class AddStatusToPapers < ActiveRecord::Migration
  def change
    add_column :papers, :status, :integer
  end
end
