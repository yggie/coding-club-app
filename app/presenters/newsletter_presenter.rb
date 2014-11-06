class NewsletterPresenter
  RENDERER = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
                                       filter_html: true,
                                       no_styles: true),
                                     fenced_code_blocks: true,
                                     autolink: true)

  def self.markdown_to_html(raw_markdown)
    raw_markdown.present? ? RENDERER.render(raw_markdown) : ''
  end
end
