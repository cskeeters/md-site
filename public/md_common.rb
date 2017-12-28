require 'rouge'

def send_html(content)
    length=content.length
    response = "Content-type: text/html; charset=utf-8\nContent-Length: #{length}\n\n#{content}"
    puts response.force_encoding(Encoding::UTF_8)
end

def set_config()
    @site_prefix = ENV["SITE_PREFIX"]
    @page_dir = ENV["PAGE_DIR"]
    @kramdown_parser = ENV["KRAMDOWN_PARSER"]
    @site_title = ENV["SITE_TITLE"]
    @home_page = ENV["HOME_PAGE"]
end

def get_kramdown_options()
    options={:template => 'template.erb'}

    options[:input] = @kramdown_parser

    #rouge syntax_highlighter outputs pygments style html with a highlight
    options[:syntax_highlighter] = 'rouge'

    # While Rouge comes with many formatters, using them through kramdown limits the
    # availibity and the configurability of the formatters
    # https://kramdown.gettalong.org/syntax_highlighter/rouge.html

    sho = Hash.new
    # HTMLLegacy enables PRE and CODE tags after div
    sho[:formatter] = Rouge::Formatters::HTMLLegacy
    options[:syntax_highlighter_opts] = sho

    options[:hard_wrap] = true
    options[:smart_quotes] = ["apos", "apos", "quot", "quot"]

    return options
end

def set_template_params()
    # Set the class variables for Object
    # Since the ERB template is run from the Kramdown::Document,
    # This is an easy way to set simple to use variables
    @@site_prefix = @site_prefix
    @@site_title = @site_title

    @@base_tag = "<base href='#{@site_prefix}/'>"
    @@home_url = "/"
    @@alpha_url = "#{@site_prefix}/alpha"
    @@mtime_url = "#{@site_prefix}/mtime"
    @@search_url = "#{@site_prefix}/search"
    @@search = ""
end


def get_sort()
    cgi = CGI.new
    if cgi.has_key?("sort")
        return cgi["sort"]
    else
        return "alpha"
    end
end
