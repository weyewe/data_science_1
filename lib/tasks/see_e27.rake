

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'

task :extract_e27_headline => :environment do
 
    page_counter = 1 
    
    begin
    
        
        begin
            puts "current_page: #{page_counter}"
            url = "http://e27.co/page/#{page_counter}"
            page = Nokogiri::HTML(open(  url     ))  
            
            page.css(".mob-article-list .row").each do |result|
                Post.create(:excerpt_xml => result.to_xml, :source => "e27")
            end
            
            page_counter = page_counter  + 1 
            
            if page.css(".mob-article-list .row").length == 0 
                break
            end
        rescue OpenURI::HTTPError => e
            
            if e.message == '404 Not Found'
                # handle 404 error
                puts "Hohohohoh, 404. finished"
            else
                raise e
            end
            
            break
        end
        



    end while true
        
end