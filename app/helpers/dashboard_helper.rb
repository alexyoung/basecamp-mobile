module DashboardHelper
  def basecamp_rss
    html = ''
    last_date = nil

    Feed.find_all.each do |item|
      item_date = d(item['pubDate'][0].to_date)
      html << content_tag('h3', item_date) if item_date != last_date
      html << item['title'][0]
      html << tag('br')
      last_date = item_date
    end
    
    return html
  rescue Exception
    content_tag 'p', 'No activity'
  end
end
