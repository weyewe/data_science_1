casper = require('casper').create()  
url = "http://e27.co/good-to-see-more-focus-on-tech-than-fin-in-fin-tech-citrus-founder-20150513/"  
casper.start url, ->  
  #The regex is used to remove whitespace
  #firstName = @.getHTML('span.given-name').replace /^\s+|\s+$/g, ""
  docs = @.getHTML("div.blog-page").replace /^\s+|\s+$/g, "" 
  console.log "the docs: #{docs}"
casper.run()  