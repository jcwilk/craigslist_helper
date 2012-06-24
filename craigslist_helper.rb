class CraigslistHelper < Sinatra::Base
  PAGES = [
    'http://sfbay.craigslist.org/eby/zip/3098595706.html',
    'http://sfbay.craigslist.org/eby/ele/3098633336.html'
  ]

  DALLI_TTL = 20 #seconds

  get '/' do
    "MOVING SALE<br/>
Near Dwight and Sacramento in Berkeley<br/>
All items must go ASAP!!!<br/>
Email me at <a href='mailto:jcwilk@gmail.com'>jcwilk@gmail.com</a> and I will get back to you right away<br/>
<br/>"+
    PAGES.map{|p| get_link(p) }.compact.join("<br/><br/>")
  end

  def get_link(url)
    html = Dalli::Client.new.fetch(url,DALLI_TTL){RestClient.get(url)}
    doc=Nokogiri::HTML(html)
    title = doc.title
    imgs = doc.css('div#ci img')
    img = imgs.first[:src] if !imgs.empty?
    "<a href='#{url}' target='_blank'>#{"<img src='#{img}'><br/>" if img}#{title}</a>"
  rescue
    nil
  end
end
