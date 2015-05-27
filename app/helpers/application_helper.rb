module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Siwapp").join(" - ")
      end
    end
  end

  # To put class=active into the menu links
  def active_link(link)
    (link == params[:controller]) ? "active" : ""
  end

  # Transform the current controller name into a type name
  def current_type
    controller_name.classify
  end

  # Returns a "humanized" version of the current type name
  def current_type_name
    current_type.constantize.model_name.human
  end

  # Check if there's a _searchform__filters.erb partial for this controller
  def searchform__filters?
    lookup_context.template_exists?("searchform__filters", controller_name, true)
  end

  # Render the advanced filters template for this controller
  def searchform__filters(f)
    render(partial: "#{controller_name}/searchform__filters", locals: {f: f})
  end

  # Render the advanced filters toggle
  def searchform__filters__toggle(f)
    render(partial: "shared/searchform__filters__toggle", locals: {f: f})
  end
end
