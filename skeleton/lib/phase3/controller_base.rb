require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      raise "Already visited" if already_built_response?

      template = ERB.new(File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")).result(binding)

      render_content(template, 'text/html')
    end
  end
end
