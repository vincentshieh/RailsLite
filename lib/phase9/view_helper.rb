module ViewHelper
  def link_to(body, url = nil)
    html = <<-HTML
      <a href="#{url}">#{body}</a>
    HTML
    html.html_safe
  end

  def button_to(body, url = nil, html_options = { method: :post })
    html = <<-HTML
      <form class="button_to" action="#{url}" method="#{html_options[:method]}">
        <div><input type="submit" value="#{body}"></div>
      </form>
    HTML
    html.html_safe
  end
end
