module NavHelper
  def nav_link(link_text, link_path, override=nil)
    current = false
    current ||= controller.controller_name == override
    current ||= current_page?(link_path)

    if current
      html_class_name = 'nav-link nav-link--current'
    else
      html_class_name = 'nav-link'
    end

    content_tag(:li, :class => html_class_name) do
      link_to link_text, link_path
    end
  end
end
