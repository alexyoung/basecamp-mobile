class Basecamp
  attr_reader :url, :user_name, :password
  
  def test_connection
    projects
  end
  
  def feed_items
    response = post('/feed/recent_items_rss', {}, "Content-Type" => 'xml')
    
    if response.code.to_i / 100 == 2
      result = XmlSimple.xml_in(response.body)
      result['channel'][0]['item']
    elsif response.code == "302" && !second_try
      connect!(@url, !@use_ssl)
      request(path, {}, true)
    else
      raise "#{response.message} (#{response.code})"
    end
  end
  
  def late_milestones(project_id)
    self.milestones(project_id).find_all {|milestone| milestone.deadline < Date.today and !milestone.completed }
  end
end