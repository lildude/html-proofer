class IframeCheck < ::HTMLProofer::Check
  def missing_src?
    blank?(@iframe.url)
  end

  def run
    @html.css('iframe').each do |node|
      @iframe = create_element(node)
      line = node.line
      content = node.content

      next if @iframe.ignore?

      if missing_src?
        add_issue('iframe has no src attribute', line: line, content: content)
      elsif @iframe.remote?
        add_to_external_urls(@iframe.url)
      elsif !@iframe.exists?
        add_issue("internal iframe #{@iframe.url} does not exist", line: line, content: content)
      end

      if @iframe.check_iframe_http? && @iframe.scheme == 'http'
        add_issue("iframe #{@iframe.url} uses the http scheme", line: line, content: content)
      end
    end

    external_urls
  end
end