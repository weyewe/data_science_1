

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi' 
 
require 'net/http'
require 'uri'


# Post.find_each {|x| x.update(:source => "TiA") } 
task :extract_tia_headline => :environment do
 
    page_counter = 1 
    
    begin
    
        
        begin
            puts "current_page: #{page_counter}"
            url = "https://www.techinasia.com/page/#{page_counter}"
            page = Nokogiri::HTML(open(  url     ))  
            
            page.css("article").each do |result|
                Post.create(:excerpt_xml => result.to_xml)
            end
            
            page_counter = page_counter  + 1 
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

task :parse_tia_excerpt_for_url => :environment do

  
  counter = 1 
  Post.where(:source => "TiA").find_each do |post| 
      
      puts "counter: #{counter}" if counter%100 == 0  
      
      xml_string = post.excerpt_xml
      doc = Nokogiri::XML(xml_string)
      
      title  = doc.css("article h2.post-heading a").text
      url  = doc.css("article h2.post-heading a").attr('href').value
      post.update(:title => title, :page_url => url)
      counter  = counter + 1 
  end
   
end
 

task :extract_tia_content => :environment do
 
    

    
    page_counter  = 1 
    Post.where{ (source.eq "TiA") & 
    (
        (page_xml.eq nil) | 
        (page_xml.eq "")
    )
     }.order("id DESC").find_each do |post|
        begin
            puts "current_page: #{page_counter}" if page_counter%10 == 0 
             
            # uri = ''
            # open( post.page_url) {|f|
            #   uri = f.read
            # }
            
            # content = eat( post.page_url)
            # page = Nokogiri::HTML( content )  
            
            # file = open( post.page_url )
            # contents = file.read
            
            # page = Nokogiri::HTML( contents )  
            # # puts contents
            
            # # page.css("article")
            # post = Post.where(:source => "TiA").first  
                
            uri = URI.parse(post.page_url)
            
            # Shortcut
            response = Net::HTTP.get_response(uri)
            
          
            
            page = Nokogiri::HTML( response.body )   
            page.css("article")
            
            # post.update( :page_xml => page.css("article").to_xml)
            
            post.page_xml = page.css("article").to_xml
            post.save 
            # if post.save
            #     puts "success.. id = #{post.id}"
            # end
            
            page_counter = page_counter  + 1 
            
        rescue OpenURI::HTTPError => e
            
            if e.message == '404 Not Found'
                # handle 404 error
                puts "Hohohohoh, 404. id = #{post.id}"
            else
                raise e
            end
            next 
        end
    end
      
        
end



