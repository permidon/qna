class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :votable_id
      t.string  :votable_type
      t.index [:votable_id, :votable_type]
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
