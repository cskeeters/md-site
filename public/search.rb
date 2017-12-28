#!/usr/bin/env ruby

begin
    require 'cgi'
    require 'kramdown'
    require 'yaml'
    require 'set'
    require_relative 'md_common'

    config = get_config()

    cgi = CGI.new

    if cgi.has_key?("q") && cgi["q"] != nil

        markdown = "# File names matching *#{cgi["q"]}*\n\n"

        matches = Set.new

        #for match in `ls -1 #{config["PAGE_DIR"]}/*'#{cgi["q"]}'*`.split
        for match in Dir.glob(File.join(config["PAGE_DIR"], "*#{cgi["q"]}*"), File::FNM_CASEFOLD)
            markdown += "1. [#{File.basename(match)}](#{File.basename(match)})\n"
            matches.add(match)
        end

        markdown += "\n# File contents with *#{cgi["q"]}*\n\n"

        for match in `fgrep -il '#{cgi["q"]}' #{config["PAGE_DIR"]}/*`.split
            if not matches.include?(match)
                markdown += "1. [#{File.basename(match)}](#{File.basename(match)})\n"
                matches.add(match)
            end
        end

    else
        mardown += "Error: Did not specify search term"
    end

    options = get_kramdown_options(config)
    options[:search] = cgi["q"]
    doc = Kramdown::Document.new(markdown, options)

    # Translate filename (LinuxCommands) into default title (Linux Commands)
    if doc.root.metadata["title"] == nil
        doc.root.metadata["title"] = config["SITE_TITLE"]+" - Search"
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
