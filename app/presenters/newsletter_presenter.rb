class NewsletterPresenter
  # check out the documentation here: https://github.com/vmg/redcarpet#and-you-can-even-cook-your-own
  class InlineStyledHTML < Redcarpet::Render::HTML
    include ActionView::Helpers::TagHelper

    def header(text, header_level)
      content_tag "h#{header_level}", text.html_safe, style: 'font-weight:100'
    end
  end

  RENDERER = Redcarpet::Markdown.new(InlineStyledHTML.new(
                                       filter_html: true,
                                       link_attributes: {
                                         target: '_blank',
                                         style: 'color: #990000',
                                       },
                                       no_styles: true),
                                     fenced_code_blocks: true,
                                     autolink: true)

  def self.markdown_to_html(raw_markdown)
    raw_markdown.present? ? RENDERER.render(raw_markdown) : ''
  end
end
