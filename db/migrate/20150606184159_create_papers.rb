class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :author
      t.string :filename

      t.timestamps null: false
    end
  end
end
