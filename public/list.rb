#!/usr/bin/env ruby

begin
    require 'cgi'
    require 'kramdown'
    require_relative 'md_common'

    set_config()
    set_template_params()

    entries = Dir.entries(@page_dir)

    if get_sort() == "mtime"
        #sort by mtime
        entries = entries.sort_by do |entry|
            File.mtime(File.join(@page_dir,entry)).to_i * -1
        end
        subtitle="Modified Time"
    else
        # sort by name
        entries.sort!
        subtitle="Alphabetical"
    end

    markdown = ""
    for entry in entries
        if File.file?(File.join(@page_dir,entry))
            markdown += "1. [#{entry}](#{entry})\n"
        end
    end

    options = get_kramdown_options()
    doc = Kramdown::Document.new(markdown, options)

    @body = doc.to_html

    @page_title = "#{@site_title} - #{subtitle}"

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
