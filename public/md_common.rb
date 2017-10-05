require 'rouge'

def send_html(content)
    length=content.length
    response = "Content-type: text/html; charset=utf-8\nContent-Length: #{length}\n\n#{content}"
    puts response.force_encoding(Encoding::UTF_8)
end

def get_config()
    config = {}
    config["SITE_PREFIX"] = ENV["SITE_PREFIX"]
    config["PAGE_DIR"] = ENV["PAGE_DIR"]
    config["KRAMDOWN_PARSER"] = ENV["KRAMDOWN_PARSER"]
    config["SITE_TITLE"] = ENV["SITE_TITLE"]
    config["HOME_PAGE"] = ENV["HOME_PAGE"]
    return config
end

def get_kramdown_options(config)
    options={:template => 'template.erb'}

    options[:input] = config["KRAMDOWN_PARSER"]

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

    options[:SITE_PREFIX] = config["SITE_PREFIX"]
    options[:SITE_TITLE] = config["SITE_TITLE"]
    return options
end

def get_sort()
    cgi = CGI.new
    if cgi.has_key?("sort")
        return cgi["sort"]
    else
        return "alpha"
    end
end
