module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Siwapp").join(" - ")
      end
    end
  end
end
