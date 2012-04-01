# -*- encoding : utf-8 -*-
module ApplicationHelper

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def print_error_messages resource
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = "你需要解决以下#{resource.errors.count}个问题："

    html = <<-HTML
    <div class="alert alert-error">
      <a class="close" data-dismiss="alert">x</a>
      <strong>#{sentence}</strong>
      <ul>
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end

  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type == :notice
      text = content_tag(:div, link_to("x", "#", :class => "close", "data-dismiss" => "alert") + message, :class => "alert fade in alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end

  def safe(html)
    sanitize(html, :tags => %w(table thead tbody tr td th ol ul li div span font img sup sub br hr a pre p h1 h2 h3 h4 h5 h6), :attributes => %w(id class style src href size color))
  end

  def render_page_title
    title = @page_title ? "#{SITE_NAME} | #{@page_title}" : SITE_NAME rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end

end
