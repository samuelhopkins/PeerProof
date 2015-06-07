class AddFieldsToPapers < ActiveRecord::Migration
  def change
    add_column :papers, :content_type, :string
    add_column :papers, :file_contents, :binary
  end
end
