#!/usr/bin/env ruby

begin

    require 'cgi'
    require 'kramdown'
    require_relative 'md_common'

    # Translate filename (LinuxCommands) into default title (Linux Commands)
    def to_title(file)
        # Strip .md if it exists
        title = file.gsub(/.md$/, '')

        title = title.gsub(/-/, ' ')
        title = title.gsub(/([A-Z][a-z])/, ' \1').strip
        title = title.split.map { |word| word[0].upcase+word[1..99999] }.join(' ')
        return title
    end

    def get_markdown(param)
        file = ""

        cgi = CGI.new
        if cgi.has_key?(param)

            file = cgi[param]
            filepath = File.join(@page_dir, file)
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
            file = @home_page
            filepath = File.join(@page_dir, file)
            markdown = File.read(filepath, :encoding => 'utf-8')
            #markdown = "Must specify file to render"
        end
        return file, markdown
    end

    ## main ##

    set_config()

    set_template_params()

    # page name to translate is passed in 'file' parameter of url
    file, markdown = get_markdown('file')

    options = get_kramdown_options()
    doc = Kramdown::Document.new(markdown, options)

    @body = doc.to_html

    @page_title = doc.root.metadata["title"]
    if @page_title == nil
        @page_title = to_title(file)
    end

    renderer = ERB.new(File.read('template.erb'))
    html = renderer.result()
    send_html(html)

rescue ScriptError, StandardError => e
    if ENV["SHOW_DEBUG"] == "True"
        print "Content-Type: text/plain\r\n\r\n"
        puts $!.inspect, $!.backtrace
    else
        raise e
    end
end
