class CreateJobOpenings < ActiveRecord::Migration
  def change
    create_table :job_openings do |t|
      
          t.text :name 
    t.text :excerpt_xml
    t.string :source

      t.timestamps null: false
    end
  end
end
