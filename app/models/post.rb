
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'


class Post < ActiveRecord::Base
    
    def extract_tia_content
        begin 
             
            uri = ''
            open( post.page_url) {|f|
              uri = f.read
            }
            
            page = Nokogiri::HTML( uri )  
            
            
            post.update( :page_xml => page.css("article").to_xml)
            
            page_counter = page_counter  + 1 
            
        rescue OpenURI::HTTPError => e
            
            if e.message == '404 Not Found'
                # handle 404 error
                puts "Hohohohoh, 404. id = #{post.id}"
            else
                raise e
            end 
        end
    end
    
    
    def extract_content
        if source == "TiA"
            extract_tia_content
        end
    end
end
