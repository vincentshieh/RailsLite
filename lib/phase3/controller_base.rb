require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      file_content = File.read("views/#{self.class.name.underscore}/#{template_name.to_s}.html.erb")
      erb_template_content = ERB.new(file_content).result(binding)
      render_content(erb_template_content, "text/html")
    end
  end
end
