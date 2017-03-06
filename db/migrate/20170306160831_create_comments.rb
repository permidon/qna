class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id
      t.string  :commentable_type
      t.index [:commentable_id, :commentable_type]
      t.belongs_to :user, index: true
    end
  end
end
