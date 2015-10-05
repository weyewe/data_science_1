require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi' 
 
require 'net/http'
require 'uri'
require 'mongo'

task :port_tia_to_mongo => :environment do
    
    # http://docs.mongodb.org/ecosystem/tutorial/ruby-driver-tutorial/#ruby-driver-tutorial
    
    # client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'experiment')
    # result = client[:artists].insert_one({ name: 'FKA Twigs' })
    
    # result = client[:artists].insert_many([
    #   { :name => 'Jimmy Sitorus' },
    #   { :name => 'Andy Moron' }
    # ])
    
    # client[:artists].find(:name => 'Flying Lotus').count
    
    # artists = client[:artists]

    # result = artists.find(:name => 'FKA Twigs').delete_one
    
    # client[:artists].find(:name => 'Jimmy Sitorus')
    
    # http://stackoverflow.com/questions/14435143/how-to-connect-mongodb-in-cloud9  << connect to mongodb in c9
    # 2015-10-03T02:55:07.232+0000 I CONTROL  [initandlisten] MongoDB starting : pid=790 port=27017 dbpath=/data/db 64-bit host=weyewe1-data-text-tia-1951208
    
    # mongo_url = "mongodb://" + process.env.IP + "/test";
    client = Mongo::Client.new([ '127.0.0.1:27017'], :database => 'scrap_gensim_play')
    
    Post.where(:source => "TiA").find_each do |post|
        client[:posts].insert_one({ excerpt_xml: post.excerpt_xml, page_xml: post.page_xml, source: "TiA" }) 
    end
    
    # Post.where{(source.eq "TiA") & (page_xml.eq "")}.count
    
     
   
end


task :mongod_parse_tia_excerpt_for_url => :environment do

    client = Mongo::Client.new([ '127.0.0.1:27017'], :database => 'scrap_gensim_play')
    
    posts  = client[:posts]
    
    counter = 1
    posts.find.each do |post|
        puts post["_id"] # ["excerpt_xml"]
        
        xml_string = post["excerpt_xml"]
        doc = Nokogiri::XML(xml_string)
        
        title  = doc.css("article h2.post-heading a").text
        url  = doc.css("article h2.post-heading a").attr('href').value 
        
        result = posts.find( :_id => post["_id"]).update_one("$set" => { :title => title, :url => url })
        
        # break if counter == 2
        
        # counter = counter + 1
    end
    # my_doc = posts.find()
    # my_doc.first 
    
    
   
end