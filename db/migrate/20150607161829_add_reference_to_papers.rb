class AddReferenceToPapers < ActiveRecord::Migration
  def change
  add_belongs_to(:papers, :user)
  end
end
