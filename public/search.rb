#!/usr/bin/env ruby

begin
    require 'cgi'
    require 'kramdown'
    require 'yaml'
    require 'set'
    require_relative 'md_common'

    set_config()
    set_template_params()

    cgi = CGI.new

    if cgi.has_key?("q") && cgi["q"] != nil

        markdown = "# File names matching *#{cgi["q"]}*\n\n"

        matches = Set.new

        #for match in `ls -1 #{@page_dir}/*'#{cgi["q"]}'*`.split
        for match in Dir.glob(File.join(@page_dir, "*#{cgi["q"]}*"), File::FNM_CASEFOLD)
            markdown += "1. [#{File.basename(match)}](#{File.basename(match)})\n"
            matches.add(match)
        end

        markdown += "\n# File contents with *#{cgi["q"]}*\n\n"

        for match in `fgrep -il '#{cgi["q"]}' #{@page_dir}/*`.split
            if not matches.include?(match)
                markdown += "1. [#{File.basename(match)}](#{File.basename(match)})\n"
                matches.add(match)
            end
        end

    else
        mardown += "Error: Did not specify search term"
    end

    options = get_kramdown_options()
    options[:search] = cgi["q"]
    doc = Kramdown::Document.new(markdown, options)

    @body = doc.to_html

    @page_title = "#{@site_title} - Search"

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
