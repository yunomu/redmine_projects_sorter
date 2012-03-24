class ProjectsSorter < Redmine::Hook::ViewListener
  def view_projects_form(context)
    project = context[:project]
    f = context[:form]

    html = "<p>"
    html << f.text_field(:ord, :value => project.ord, :type => :number)
    html << "</p>"
    html
  end
end
