class AddMoreDetailsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :author, :string
    add_column :posts, :comment_count, :integer
    add_column :posts, :title, :string 
    add_column :posts, :body_content, :text 
    add_column :posts, :post_date, :datetime
  end
end
