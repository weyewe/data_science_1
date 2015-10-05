


require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi' 
 
require 'net/http'
require 'uri'


task :extract_q_headline => :environment do
 
    page_counter = 1 
    
    (1.upto 1654).each do |page_number|
        begin
        
            puts "current_page: #{page_counter}" if page_counter%100 == 0 
            
            url = "http://www.qerja.com/perusahaan/?page=#{page_number}"
            page = Nokogiri::HTML(open(  url     ))  
            
      
            
            page.css("table tbody tr").each do |result|
                Employer.create(:excerpt_xml => result.to_xml, :source => "qerja")
            end
            
            page_counter = page_counter  + 1 
       
        rescue OpenURI::HTTPError => e
            
            if e.message == '404 Not Found'
                # handle 404 error
                puts "Hohohohoh, 404. finished"
            else
                raise e
            end
            
            next
        end
    end 
end


task :parse_qerja_company_name => :environment do

  
  counter = 1 
  Employer.where(:source => "qerja").find_each do |employer| 
      
      puts "counter: #{counter}" if counter%100 == 0  
      
      xml_string = employer.excerpt_xml
      doc = Nokogiri::XML(xml_string)
      
      name  = doc.css("div.media-body h4.bold").text
       
      employer.update(:name => name )
      counter  = counter + 1 
  end
   
end