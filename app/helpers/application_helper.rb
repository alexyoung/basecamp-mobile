# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Display the standard feedback messages
  def standard_messages
    html = ''
    [:notice, :error].each do |flash_type|
      if flash[flash_type] != nil
        html <<=<<EOD
<strong>#{flash[flash_type]}</strong><br/>

EOD
        flash[flash_type] = nil
      end
    end
    
    if html.size > 0
      return html + tag('hr')
    else
      return ''
    end
  end

  def navigation
    projects = Project.find_active
    
    return '' if projects.nil?
    
    if @project
      project_id = @project.id
    else
      project_id = nil
    end
    
    html =  link_to_if !current_page?(:controller => 'dashboard', :action => 'index'), 'Dashboard', dashboard_url
    html << ' | ' + link_to('Logout', logout_url) 
    html << tag('br')
    html << project_select_form(project_id)
    html << tag('hr')
  end
  
  def project_select_form(project_id)
    html = form_tag(project_select_url, :method => 'post')
    html << content_tag('select', project_select_optgroup(project_id), :name => 'id') + submit_tag('go')
    html << '</form>'
  end
  
  def project_select_optgroup(project_id)
    projects = Project.find_active
    html = content_tag('option', 'Your projects')
    
    companies = projects.collect { |project| [project.company.id, project.company.name] }.uniq
    companies.each do |company|
      html << content_tag('optgroup',
      projects.collect do |project|
        if project.company.id == company[0]
          if project_id == project.id
            content_tag('option', project.name, :value => project.id, :selected => 'selected')
          else
            content_tag('option', project.name, :value => project.id)
          end
        end
      end.join("\n"), :label => company[1])
    end
    html
  end
    
  def d(date)
    date.strftime('%A %B %d, %Y')
  end
  
  # Add http://www.google.com/gwt/n?u= to URLs, and make them into links
  def mobile_links(text, mobile_web_viewer = 'http://www.google.com/gwt/n?u=')
    text.gsub(MOBILE_LINK_REGEX) do
      all, a, b, c, d = $&, $1, $2, $3, $5
      if a =~ /<a\s/i # don't replace URL's that are already linked
        all
      else
        text = b + c
        text = yield(text) if block_given?
        %(#{a}<a href="#{mobile_web_viewer}#{b=="www."?"http://www.":b}#{c}">#{text}</a>#{d})
      end
    end
  end
  
  private
  
  MOBILE_LINK_REGEX = /
    (                       # leading text
      <\w+.*?>|             #   leading HTML tag, or
      [^=!:'"\/]|           #   leading punctuation, or 
      ^                     #   beginning of line
    )
    (
      (?:http[s]?:\/\/)|    # protocol spec, or
      (?:www\.)             # www.*
    ) 
    (
      ([\w]+:?[=?&\/.-]?)*    # url segment
      \w+[\/]?              # url tail
      (?:\#\w*)?            # trailing anchor
    )
    ([[:punct:]]|\s|<|$)    # trailing text
   /x unless const_defined?(:MOBILE_LINK_REGEX)
end
