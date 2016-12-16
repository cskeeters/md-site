#!/usr/local/bin/ruby

begin

    require 'cgi'
    require 'kramdown'
    require_relative 'md_common'

    def get_markdown(param, config)
        file = ""

        cgi = CGI.new
        if cgi.has_key?(param)

            file = cgi[param]
            filepath = File.join(config["PAGE_DIR"], file)
            if file.index("..")
                markdown = "Error: Can not specify '..' in page name"
            elsif file.index("/")
                markdown = "Error: Can not specify '/' in page name"
            elsif not File.file?(filepath)
                markdown = "Error: File '#{file}' does not exist"
            else
                markdown = File.read(filepath, :encoding => 'utf-8')
            end
            #markdown = "File is '#{file}'"
        else
            markdown = "Must specify file to render"
        end
        return file, markdown
    end

    ## main ##

    config = get_config()

    file,markdown = get_markdown('file', config)

    options = get_kramdown_options(config)
    doc = Kramdown::Document.new(markdown, options)

    # Translate filename (LinuxCommands) into default title (Linux Commands)
    if doc.root.metadata["title"] == nil
        # Strip .md if it exists
        title = file.gsub(/.md$/, '')

        title = title.gsub(/-/, ' ')
        title = title.gsub(/([A-Z][a-z])/, ' \1').strip
        title = title.split.map { |word| word[0].upcase+word[1..99999] }.join(' ')

        doc.root.metadata["title"] = title
    end

    # Convert Markdown to HTML
    send_html(doc.to_html)
rescue ScriptError, StandardError => e
    if ENV["SHOW_DEBUG"] == "True"
        print "Content-Type: text/plain\r\n\r\n"
        puts $!.inspect, $!.backtrace
    else
        raise e
    end
end
