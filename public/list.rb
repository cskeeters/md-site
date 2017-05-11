#!/usr/bin/env ruby

begin
    require 'cgi'
    require 'kramdown'
    require_relative 'md_common'

    config = get_config()

    entries = Dir.entries(config["PAGE_DIR"])

    if get_sort() == "mtime"
        #sort by mtime
        entries = entries.sort_by do |entry|
            File.mtime(File.join(config["PAGE_DIR"],entry)).to_i * -1
        end
    end

    markdown = ""
    for entry in entries
        if File.file?(File.join(config["PAGE_DIR"],entry))
            markdown += "1. [#{entry}](#{entry})\n"
        end
    end

    options = get_kramdown_options(config)
    doc = Kramdown::Document.new(markdown, options)

    # Translate filename (LinuxCommands) into default title (Linux Commands)
    if doc.root.metadata["title"] == nil
        doc.root.metadata["title"] = config["SITE_TITLE"]
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
