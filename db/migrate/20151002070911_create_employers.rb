class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      
 
    t.text :name 
    t.text :excerpt_xml
    t.string :source
    
    
    

      t.timestamps null: false
    end
  end
end
