#!/usr/local/bin/ruby

require_relative 'md_common'

begin
    require 'rouge'

    print "Content-type: text/css\r\n\r\n"
    print Rouge::Themes::Base16.mode(:dark).render(scope: 'div.highlighter-rouge')

rescue => e
    if env["SHOW_DEBUG"]
        print "Content-Type: text/plain\r\n\r\n"
        puts $!.inspect, $!.backtrace
    else
        raise e
    end
end
