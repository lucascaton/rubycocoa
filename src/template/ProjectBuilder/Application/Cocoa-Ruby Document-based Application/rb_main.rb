#
#  rb_main.rb
#  �PROJECTNAME�
#
#  Created by �FULLUSERNAME� on �DATE�.
#  Copyright (c) �YEAR� �ORGANIZATIONNAME�. All rights reserved.
#

require 'osx/cocoa'

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.to_s
  rbfiles = (Dir.entries(path) - [ __FILE__ ]).select {|x| /\.rb\z/ =~ x}
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
