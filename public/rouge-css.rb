#!/usr/bin/env ruby

# Some pygment names might be missing from colorization.  For example 'cd' in
# bash was being span'ed with 'nb', but the Base16 render method was not
# outputing anything for nb.
#
# To resolve this, you can edit the installed gem
# GEM_PATH/gems/rouge-2.X.X/lib/rouge/themes/base16.rb
#
# Your'll notice there is no `style Name` or `style Name::Builtin` to match the
# Name.Builtin from pygments.  To correct for this you can modify the Name
# blocks with this:
#
#      style Name::Builtin, :fg => :base0D
#      style Name::Variable, :fg => :base08
#      style Name::Namespace,
#            Name::Class,
#            Name::Constant, :fg => :base0A
#
#      style Name::Attribute, :fg => :base0D
#
# Color Reference to tokens: http://chriskempson.com/projects/base16/
# Pygment tokens: http://pygments.org/docs/tokens/


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
