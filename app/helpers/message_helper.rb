module MessageHelper
  def options_for_categories(categories)
    categories.collect {|category| content_tag('option', category.name, :value => category.id) }.join("\n")
  end

  # Caches categories per-project
  # TODO: Make this use cache
  def categories(project_id)
    Message.message_categories(project_id)
  end
  
  # Caches people
  # TODO: Make this use cache
  def message_author(id)
    user = User.find(id)
    user.first_name
  end
end
