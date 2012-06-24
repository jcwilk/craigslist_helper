configure :production do
end

PAGES = [
  'http://sfbay.craigslist.org/sby/fuo/3098332994.html'	
]

# Quick test
get '/' do
  "MOVING SALE<br/>
Near Dwight and Sacramento in Berkeley<br/>
All items must go ASAP!!!<br/>
Email me at jcwilk@gmail.com and I will get back to you right away<br/>
<br/>"
  PAGES.map{|p| get_link(p) }.compact.join("<br/>")
end

def get_link(url)
  doc=Nokogiri::HTML(RestClient.get(url))
  title = doc.title
  imgs = doc.css('div#ci img')
  img = imgs.first[:src] if !imgs.empty?
  "<a href='#{url}' target='_blank'>#{"<img src='#{img}'><br/>" if img}#{title}</a>"
rescue
  nil
end
