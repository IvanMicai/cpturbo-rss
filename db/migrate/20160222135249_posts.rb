class Posts < ActiveRecord::Migration
   def change
    create_table :posts do |t|
      t.string :title
      t.integer :post_id
      t.date :published_at
      t.string :author_name
      t.integer :author_id
      t.text :description
      t.string :topic_category_0
      t.string :topic_category_1
      t.string :topic_category_2
      t.string :topic_category_3
      t.string :topic_category_4
      t.string :topic_category_5

      t.timestamps
    end
  end
end
