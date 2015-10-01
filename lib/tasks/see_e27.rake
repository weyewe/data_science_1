

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


task :parse_e27_excerpt_for_url => :environment do

  
  counter = 1 
  Post.where(:source => "e27").find_each do |post| 
      
      puts "counter: #{counter}" if counter%100 == 0  
      
      xml_string = post.excerpt_xml
      doc = Nokogiri::XML(xml_string)
      
      title  = doc.css(".artcle-seprtr h2.list-article-title").text
      url  = doc.css(".artcle-seprtr a").attr('href').value
      post.update(:title => title, :page_url => url)
      counter  = counter + 1 
  end
   
end

task :extract_e27_content => :environment do
 
    

    
    page_counter  = 1 
    Post.where{ (source.eq "e27") & (page_xml.eq nil)}.order("id DESC").find_each do |post|
        begin
            puts "current_page: #{page_counter}" if page_counter%10 == 0 
            
            puts "The url : #{post.page_url}"
                
            # uri = URI.parse(post.page_url)
            
            # Shortcut
            # response = Net::HTTP.get_response(uri)
            
            
            
            file = open( post.page_url )
            contents = file.read
            puts "done reading the content"
            
            
            page = Nokogiri::HTML( contents )  
            # puts contents
            
            puts "parsing nokogiri"
          
            
            # page = Nokogiri::HTML( response.body ) 
            # post.update( :page_xml => page.css("article").to_xml)
            
            if page.css("div.blog-page").length != 1
                puts "it is zero length" if page.css("div.blog-page").length == 0
                puts "it is more than 1 length" if page.css("div.blog-page").length > 1
                
                puts "url : #{post.page_url}"
                page_counter = page_counter + 1 
                next
                
            end
            post.page_xml = page.css("div.blog-page").to_xml
            post.save 
            # if post.save
            #     puts "success.. id = #{post.id}"
            # end
            
            page_counter = page_counter  + 1 
            
        rescue Net::ReadTimeout
            puts "timeout!!!"
            
            puts post.page_url
             
            next 
        end
    end
      
        
end