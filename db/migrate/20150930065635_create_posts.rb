class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :excerpt_xml
      t.text :page_xml
      
      t.text :page_url 

      t.timestamps null: false
    end
  end
end
