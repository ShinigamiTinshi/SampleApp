class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string  :bode
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type # Item, BlogPost
      t.timestamps
    end
  end
end
